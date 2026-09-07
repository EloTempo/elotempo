//! Cálculo de Parentesco e Ancestral Comum (Cruzamento de Linhagens).
//!
//! Permite cruzar duas pessoas quaisquer do acervo (inclusive entre árvores
//! diferentes ou entre registros pessoais e figuras públicas) para determinar:
//! 1. Se há parentesco consanguíneo e quem é o Ancestral Comum Mais Próximo (LCA);
//! 2. A classificação canônica da relação em língua portuguesa (Pai, Filho, Irmãos,
//!    Tio, Sobrinho, Primos de 1º, 2º e 3º grau, etc.);
//! 3. Caso não haja consanguinidade, se há vínculo por afinidade (cônjuges, sogros, cunhados);
//! 4. O caminho passo a passo ilustrando visualmente a conexão genealógica.

use std::collections::{HashMap, HashSet, VecDeque};
use serde::{Deserialize, Serialize};
use sqlx::SqlitePool;
use tauri::State;

use super::erros::{ErroDominio, Resultado};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PassoParentesco {
    pub pessoa_id: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub foto_url: Option<String>,
    pub papel: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ParentescoResultado {
    pub pessoa_a_id: String,
    pub pessoa_b_id: String,
    pub pessoa_a_nome: String,
    pub pessoa_b_nome: String,
    pub tem_parentesco: bool,
    /// "consanguineo" | "afim" | "mesma_pessoa" | "nenhum"
    pub tipo_relacao: String,
    pub descricao_parentesco: String,
    pub grau_consanguinidade: Option<u32>,
    pub distancia_geracoes_a: Option<u32>,
    pub distancia_geracoes_b: Option<u32>,
    pub ancestral_comum: Option<PassoParentesco>,
    pub caminho: Vec<PassoParentesco>,
}

#[derive(Debug, Clone)]
struct PessoaBasica {
    id: String,
    nome: String,
    sobrenome: Option<String>,
    sexo: String,
    foto_url: Option<String>,
}

#[tauri::command]
pub async fn calcular_parentesco(
    pessoa_a_id: String,
    pessoa_b_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<ParentescoResultado> {
    calcular(&db, &pessoa_a_id, &pessoa_b_id).await
}

pub async fn calcular(
    pool: &SqlitePool,
    id_a: &str,
    id_b: &str,
) -> Resultado<ParentescoResultado> {
    let a = obter_pessoa_basica(pool, id_a).await?;
    let b = obter_pessoa_basica(pool, id_b).await?;

    let nome_completo_a = format!("{} {}", a.nome, a.sobrenome.as_deref().unwrap_or("")).trim().to_string();
    let nome_completo_b = format!("{} {}", b.nome, b.sobrenome.as_deref().unwrap_or("")).trim().to_string();

    // 1. Caso trivial: mesma pessoa
    if id_a == id_b {
        return Ok(ParentescoResultado {
            pessoa_a_id: id_a.to_string(),
            pessoa_b_id: id_b.to_string(),
            pessoa_a_nome: nome_completo_a.clone(),
            pessoa_b_nome: nome_completo_b,
            tem_parentesco: true,
            tipo_relacao: "mesma_pessoa".into(),
            descricao_parentesco: "Mesma pessoa".into(),
            grau_consanguinidade: Some(0),
            distancia_geracoes_a: Some(0),
            distancia_geracoes_b: Some(0),
            ancestral_comum: Some(PassoParentesco {
                pessoa_id: a.id.clone(),
                nome: a.nome,
                sobrenome: a.sobrenome,
                sexo: a.sexo,
                foto_url: a.foto_url,
                papel: "Mesma pessoa".into(),
            }),
            caminho: vec![],
        });
    }

    // 2. Busca de ancestrais de A e B (árvore ascendente biológica)
    let ancestrais_a = mapear_ancestrais(pool, &a).await?;
    let ancestrais_b = mapear_ancestrais(pool, &b).await?;

    // 3. Verifica se há ancestrais comuns (LCA)
    let mut candidatos_lca: Vec<(String, u32, u32)> = Vec::new();
    for (anc_id, (dist_a, _)) in &ancestrais_a {
        if let Some((dist_b, _)) = ancestrais_b.get(anc_id) {
            candidatos_lca.push((anc_id.clone(), *dist_a, *dist_b));
        }
    }

    if !candidatos_lca.is_empty() {
        // Ordena para escolher o LCA mais próximo (menor soma de distâncias, ou menor máxima)
        candidatos_lca.sort_by_key(|(_, da, db)| (da + db, std::cmp::max(*da, *db)));
        let (lca_id, dist_a, dist_b) = candidatos_lca[0].clone();

        let lca_info = obter_pessoa_basica(pool, &lca_id).await?;
        let caminho_a = &ancestrais_a[&lca_id].1;
        let caminho_b = &ancestrais_b[&lca_id].1;

        // Constrói caminho visual completo: A -> ... -> LCA -> ... -> B
        let mut caminho_completo = Vec::new();
        for p in caminho_a {
            caminho_completo.push(p.clone());
        }
        // Volta descendo pelo ramo de B (invertendo o caminho que subiu de B até LCA)
        if caminho_b.len() > 1 {
            for p in caminho_b.iter().rev().skip(1) {
                let mut descendo = p.clone();
                descendo.papel = if p.pessoa_id == id_b {
                    "Pessoa B".into()
                } else if p.sexo == "M" {
                    "Filho".into()
                } else {
                    "Filha".into()
                };
                caminho_completo.push(descendo);
            }
        }

        let lca_passo = PassoParentesco {
            pessoa_id: lca_info.id.clone(),
            nome: lca_info.nome,
            sobrenome: lca_info.sobrenome,
            sexo: lca_info.sexo,
            foto_url: lca_info.foto_url,
            papel: "Ancestral Comum Mais Próximo".into(),
        };

        let descricao = descrever_parentesco_consanguineo(dist_a, dist_b, &a.sexo, &b.sexo);

        return Ok(ParentescoResultado {
            pessoa_a_id: id_a.to_string(),
            pessoa_b_id: id_b.to_string(),
            pessoa_a_nome: nome_completo_a,
            pessoa_b_nome: nome_completo_b,
            tem_parentesco: true,
            tipo_relacao: "consanguineo".into(),
            descricao_parentesco: descricao,
            grau_consanguinidade: Some(dist_a + dist_b),
            distancia_geracoes_a: Some(dist_a),
            distancia_geracoes_b: Some(dist_b),
            ancestral_comum: Some(lca_passo),
            caminho: caminho_completo,
        });
    }

    // 4. Sem consanguinidade direta: tenta encontrar vínculo por afinidade (grafo geral: pais, filhos, cônjuges)
    if let Some((descricao, caminho)) = buscar_vinculo_afinidade(pool, &a, &b).await? {
        return Ok(ParentescoResultado {
            pessoa_a_id: id_a.to_string(),
            pessoa_b_id: id_b.to_string(),
            pessoa_a_nome: nome_completo_a,
            pessoa_b_nome: nome_completo_b,
            tem_parentesco: true,
            tipo_relacao: "afim".into(),
            descricao_parentesco: descricao,
            grau_consanguinidade: None,
            distancia_geracoes_a: None,
            distancia_geracoes_b: None,
            ancestral_comum: None,
            caminho,
        });
    }

    // 5. Nenhum vínculo encontrado
    Ok(ParentescoResultado {
        pessoa_a_id: id_a.to_string(),
        pessoa_b_id: id_b.to_string(),
        pessoa_a_nome: nome_completo_a,
        pessoa_b_nome: nome_completo_b,
        tem_parentesco: false,
        tipo_relacao: "nenhum".into(),
        descricao_parentesco: "Nenhum parentesco ou vínculo encontrado no acervo".into(),
        grau_consanguinidade: None,
        distancia_geracoes_a: None,
        distancia_geracoes_b: None,
        ancestral_comum: None,
        caminho: vec![],
    })
}

async fn obter_pessoa_basica(pool: &SqlitePool, id: &str) -> Resultado<PessoaBasica> {
    let row = sqlx::query(
        "SELECT id, nome, sobrenome, sexo, foto_url FROM pessoas WHERE id = ?",
    )
    .bind(id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| ErroDominio::PessoaNaoEncontrada(id.to_string()))?;

    use sqlx::Row;
    Ok(PessoaBasica {
        id: row.try_get("id")?,
        nome: row.try_get("nome")?,
        sobrenome: row.try_get("sobrenome")?,
        sexo: row.try_get("sexo")?,
        foto_url: row.try_get("foto_url")?,
    })
}

/// Mapeia todos os ancestrais de uma pessoa subindo pelas uniões biológicas.
async fn mapear_ancestrais(
    pool: &SqlitePool,
    origem: &PessoaBasica,
) -> Resultado<HashMap<String, (u32, Vec<PassoParentesco>)>> {
    let mut resultado = HashMap::new();
    let mut fila = VecDeque::new();

    let primeiro_passo = PassoParentesco {
        pessoa_id: origem.id.clone(),
        nome: origem.nome.clone(),
        sobrenome: origem.sobrenome.clone(),
        sexo: origem.sexo.clone(),
        foto_url: origem.foto_url.clone(),
        papel: "Origem".into(),
    };

    resultado.insert(origem.id.clone(), (0, vec![primeiro_passo.clone()]));
    fila.push_back((origem.id.clone(), 0, vec![primeiro_passo]));

    while let Some((pessoa_id, dist, caminho_atual)) = fila.pop_front() {
        if dist >= 15 {
            continue; // Limite de profundidade para árvores profundas
        }

        // Busca pai e mãe desta pessoa através de unioes
        let pais = sqlx::query(
            r#"
            SELECT p.id, p.nome, p.sobrenome, p.sexo, p.foto_url,
                   CASE WHEN u.slot_masculino_id = p.id THEN 'Pai' ELSE 'Mãe' END AS papel
            FROM uniao_filhos uf
            JOIN unioes u ON u.id = uf.uniao_id
            JOIN pessoas p ON (p.id = u.slot_masculino_id OR p.id = u.slot_feminino_id)
            WHERE uf.pessoa_id = ? AND p.is_placeholder = 0
            "#,
        )
        .bind(&pessoa_id)
        .fetch_all(pool)
        .await?;

        for row in pais {
            use sqlx::Row;
            let pai_id: String = row.try_get("id")?;
            let nome: String = row.try_get("nome")?;
            let sobrenome: Option<String> = row.try_get("sobrenome")?;
            let sexo: String = row.try_get("sexo")?;
            let foto_url: Option<String> = row.try_get("foto_url")?;
            let papel: String = row.try_get("papel")?;

            let novo_dist = dist + 1;
            let ja_existe = resultado.get(&pai_id).map(|(d, _)| *d <= novo_dist).unwrap_or(false);

            if !ja_existe {
                let mut novo_caminho = caminho_atual.clone();
                novo_caminho.push(PassoParentesco {
                    pessoa_id: pai_id.clone(),
                    nome,
                    sobrenome,
                    sexo,
                    foto_url,
                    papel,
                });

                resultado.insert(pai_id.clone(), (novo_dist, novo_caminho.clone()));
                fila.push_back((pai_id, novo_dist, novo_caminho));
            }
        }
    }

    Ok(resultado)
}

/// Tradução canônica para a língua portuguesa das relações de consanguinidade.
fn descrever_parentesco_consanguineo(
    da: u32,
    db: u32,
    sexo_a: &str,
    sexo_b: &str,
) -> String {
    match (da, db) {
        (0, 1) => if sexo_a == "M" { "Pai de B" } else { "Mãe de B" }.into(),
        (1, 0) => if sexo_a == "M" { "Filho de B" } else { "Filha de B" }.into(),
        (0, 2) => if sexo_a == "M" { "Avô de B" } else { "Avó de B" }.into(),
        (2, 0) => if sexo_a == "M" { "Neto de B" } else { "Neta de B" }.into(),
        (0, 3) => if sexo_a == "M" { "Bisavô de B" } else { "Bisavó de B" }.into(),
        (3, 0) => if sexo_a == "M" { "Bisneto de B" } else { "Bisneta de B" }.into(),
        (0, 4) => if sexo_a == "M" { "Trisavô de B" } else { "Trisavó de B" }.into(),
        (4, 0) => if sexo_a == "M" { "Trineto de B" } else { "Trineta de B" }.into(),
        (0, n) => format!("Ancestral de {}ª geração", n),
        (n, 0) => format!("Descendente de {}ª geração", n),
        (1, 1) => if sexo_a == "M" && sexo_b == "M" {
            "Irmãos"
        } else if sexo_a == "F" && sexo_b == "F" {
            "Irmãs"
        } else {
            "Irmãos (Irmão e Irmã)"
        }.into(),
        (1, 2) => if sexo_a == "M" { "Tio de B" } else { "Tia de B" }.into(),
        (2, 1) => if sexo_a == "M" { "Sobrinho de B" } else { "Sobrinha de B" }.into(),
        (1, 3) => if sexo_a == "M" { "Tio-avô de B" } else { "Tia-avó de B" }.into(),
        (3, 1) => if sexo_a == "M" { "Sobrinho-neto de B" } else { "Sobrinha-neta de B" }.into(),
        (1, 4) => if sexo_a == "M" { "Tio-bisavô de B" } else { "Tia-bisavó de B" }.into(),
        (4, 1) => if sexo_a == "M" { "Sobrinho-bisneto de B" } else { "Sobrinha-bisneta de B" }.into(),
        (2, 2) => "Primos de 1º grau (Primos-irmãos)".into(),
        (2, 3) => if sexo_a == "M" {
            "Primo de 1º grau afastado (Primo-tio de B)"
        } else {
            "Prima de 1º grau afastada (Prima-tia de B)"
        }.into(),
        (3, 2) => if sexo_a == "M" {
            "Primo de 1º grau afastado (Primo-sobrinho de B)"
        } else {
            "Prima de 1º grau afastada (Prima-sobrinha de B)"
        }.into(),
        (3, 3) => "Primos de 2º grau".into(),
        (3, 4) | (4, 3) => "Primos de 2º grau afastados".into(),
        (4, 4) => "Primos de 3º grau".into(),
        (a, b) => format!("Parentes consanguíneos colaterais (grau {})", a + b),
    }
}

/// Busca de conexões por afinidade e casamento na rede familiar.
async fn buscar_vinculo_afinidade(
    pool: &SqlitePool,
    origem: &PessoaBasica,
    destino: &PessoaBasica,
) -> Resultado<Option<(String, Vec<PassoParentesco>)>> {
    let mut visitados = HashSet::new();
    let mut fila = VecDeque::new();

    let primeiro = PassoParentesco {
        pessoa_id: origem.id.clone(),
        nome: origem.nome.clone(),
        sobrenome: origem.sobrenome.clone(),
        sexo: origem.sexo.clone(),
        foto_url: origem.foto_url.clone(),
        papel: "Origem".into(),
    };

    visitados.insert(origem.id.clone());
    fila.push_back((origem.id.clone(), vec![primeiro]));

    while let Some((atual_id, caminho)) = fila.pop_front() {
        if caminho.len() > 7 {
            continue; // Máximo de 6 graus de separação por afinidade
        }

        // Vizinhos diretos no grafo familiar: cônjuges, pais e filhos
        let vizinhos = sqlx::query(
            r#"
            -- Cônjuges
            SELECT p.id, p.nome, p.sobrenome, p.sexo, p.foto_url,
                   CASE WHEN p.sexo = 'M' THEN 'Marido' ELSE 'Esposa' END AS papel
            FROM unioes u
            JOIN pessoas p ON (
                (u.slot_masculino_id = ? AND u.slot_feminino_id = p.id) OR
                (u.slot_feminino_id = ? AND u.slot_masculino_id = p.id)
            )
            WHERE p.is_placeholder = 0

            UNION

            -- Pais
            SELECT p.id, p.nome, p.sobrenome, p.sexo, p.foto_url,
                   CASE WHEN p.sexo = 'M' THEN 'Pai' ELSE 'Mãe' END AS papel
            FROM uniao_filhos uf
            JOIN unioes u ON u.id = uf.uniao_id
            JOIN pessoas p ON (p.id = u.slot_masculino_id OR p.id = u.slot_feminino_id)
            WHERE uf.pessoa_id = ? AND p.is_placeholder = 0

            UNION

            -- Filhos
            SELECT p.id, p.nome, p.sobrenome, p.sexo, p.foto_url,
                   CASE WHEN p.sexo = 'M' THEN 'Filho' ELSE 'Filha' END AS papel
            FROM unioes u
            JOIN uniao_filhos uf ON uf.uniao_id = u.id
            JOIN pessoas p ON p.id = uf.pessoa_id
            WHERE (u.slot_masculino_id = ? OR u.slot_feminino_id = ?) AND p.is_placeholder = 0
            "#,
        )
        .bind(&atual_id)
        .bind(&atual_id)
        .bind(&atual_id)
        .bind(&atual_id)
        .bind(&atual_id)
        .fetch_all(pool)
        .await?;

        for row in vizinhos {
            use sqlx::Row;
            let viz_id: String = row.try_get("id")?;
            let nome: String = row.try_get("nome")?;
            let sobrenome: Option<String> = row.try_get("sobrenome")?;
            let sexo: String = row.try_get("sexo")?;
            let foto_url: Option<String> = row.try_get("foto_url")?;
            let papel: String = row.try_get("papel")?;

            let mut novo_caminho = caminho.clone();
            novo_caminho.push(PassoParentesco {
                pessoa_id: viz_id.clone(),
                nome,
                sobrenome,
                sexo,
                foto_url,
                papel,
            });

            if viz_id == destino.id {
                let descricao = descrever_caminho_afinidade(&novo_caminho);
                return Ok(Some((descricao, novo_caminho)));
            }

            if !visitados.contains(&viz_id) {
                visitados.insert(viz_id.clone());
                fila.push_back((viz_id, novo_caminho));
            }
        }
    }

    Ok(None)
}

fn descrever_caminho_afinidade(caminho: &[PassoParentesco]) -> String {
    let passos = caminho.len() - 1;
    if passos == 1 {
        let papel = &caminho[1].papel;
        if papel == "Marido" || papel == "Esposa" {
            return format!("Cônjuges ({} de A)", papel);
        }
    } else if passos == 2 {
        let p1 = &caminho[1].papel;
        let p2 = &caminho[2].papel;
        if (p1 == "Marido" || p1 == "Esposa") && (p2 == "Pai" || p2 == "Mãe") {
            return "Sogro(a) de A".into();
        }
        if (p1 == "Filho" || p1 == "Filha") && (p2 == "Marido" || p2 == "Esposa") {
            return "Genro / Nora de A".into();
        }
        if (p1 == "Pai" || p1 == "Mãe") && (p2 == "Marido" || p2 == "Esposa") {
            return "Cunhado(a) de A".into();
        }
    }

    format!("Vínculo familiar por afinidade/casamento ({} passos de conexão)", passos)
}

#[cfg(test)]
mod testes {
    use super::*;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePool::connect("sqlite::memory:").await.unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        pool
    }

    async fn criar_pessoa(pool: &SqlitePool, nome: &str, sobrenome: &str, sexo: &str) -> String {
        let id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, ?, ?, ?, 1, 0)",
        )
        .bind(&id)
        .bind(nome)
        .bind(sobrenome)
        .bind(sexo)
        .execute(pool)
        .await
        .unwrap();
        id
    }

    async fn ligar_uniao_e_filho(
        pool: &SqlitePool,
        pai_id: &str,
        mae_id: &str,
        filho_id: &str,
    ) {
        let uniao_id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id) VALUES (?, ?, ?)",
        )
        .bind(&uniao_id)
        .bind(pai_id)
        .bind(mae_id)
        .execute(pool)
        .await
        .unwrap();

        sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES (?, ?, 1)",
        )
        .bind(&uniao_id)
        .bind(filho_id)
        .execute(pool)
        .await
        .unwrap();
    }

    #[tokio::test]
    async fn calcula_parentesco_pai_e_filho() {
        let pool = pool_de_teste().await;
        let pai = criar_pessoa(&pool, "Pedro", "Bragança", "M").await;
        let mae = criar_pessoa(&pool, "Leopoldina", "Habsburgo", "F").await;
        let filho = criar_pessoa(&pool, "Pedro II", "Bragança", "M").await;

        ligar_uniao_e_filho(&pool, &pai, &mae, &filho).await;

        let res = calcular(&pool, &pai, &filho).await.unwrap();
        assert!(res.tem_parentesco);
        assert_eq!(res.tipo_relacao, "consanguineo");
        assert_eq!(res.descricao_parentesco, "Pai de B");
        assert_eq!(res.distancia_geracoes_a, Some(0));
        assert_eq!(res.distancia_geracoes_b, Some(1));
        assert_eq!(res.ancestral_comum.unwrap().pessoa_id, pai);

        let res_inv = calcular(&pool, &filho, &pai).await.unwrap();
        assert_eq!(res_inv.descricao_parentesco, "Filho de B");
    }

    #[tokio::test]
    async fn calcula_parentesco_irmaos() {
        let pool = pool_de_teste().await;
        let pai = criar_pessoa(&pool, "Pai", "Silva", "M").await;
        let mae = criar_pessoa(&pool, "Mãe", "Silva", "F").await;
        let filho1 = criar_pessoa(&pool, "Filho Um", "Silva", "M").await;
        let filho2 = criar_pessoa(&pool, "Filha Dois", "Silva", "F").await;

        ligar_uniao_e_filho(&pool, &pai, &mae, &filho1).await;

        let uniao_id: String = sqlx::query_scalar("SELECT id FROM unioes LIMIT 1")
            .fetch_one(&pool)
            .await
            .unwrap();

        sqlx::query("INSERT INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES (?, ?, 2)")
            .bind(&uniao_id)
            .bind(&filho2)
            .execute(&pool)
            .await
            .unwrap();

        let res = calcular(&pool, &filho1, &filho2).await.unwrap();
        assert!(res.tem_parentesco);
        assert_eq!(res.tipo_relacao, "consanguineo");
        assert!(res.descricao_parentesco.contains("Irmão"));
        assert_eq!(res.distancia_geracoes_a, Some(1));
        assert_eq!(res.distancia_geracoes_b, Some(1));
    }

    #[tokio::test]
    async fn calcula_parentesco_primos() {
        let pool = pool_de_teste().await;
        // Avós
        let avo_m = criar_pessoa(&pool, "Avô", "Oliveira", "M").await;
        let avo_f = criar_pessoa(&pool, "Avó", "Oliveira", "F").await;

        // Filhos dos avós (Irmãos)
        let pai1 = criar_pessoa(&pool, "Pai Um", "Oliveira", "M").await;
        let pai2 = criar_pessoa(&pool, "Pai Dois", "Oliveira", "M").await;

        let u_avos = uuid::Uuid::new_v4().to_string();
        sqlx::query("INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id) VALUES (?, ?, ?)")
            .bind(&u_avos).bind(&avo_m).bind(&avo_f).execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES (?, ?, 1)")
            .bind(&u_avos).bind(&pai1).execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO uniao_filhos (uniao_id, pessoa_id, ordem) VALUES (?, ?, 2)")
            .bind(&u_avos).bind(&pai2).execute(&pool).await.unwrap();

        // Esposas e Primos
        let mae1 = criar_pessoa(&pool, "Mãe Um", "Costa", "F").await;
        let mae2 = criar_pessoa(&pool, "Mãe Dois", "Pereira", "F").await;
        let primo1 = criar_pessoa(&pool, "Primo 1", "Oliveira", "M").await;
        let primo2 = criar_pessoa(&pool, "Primo 2", "Oliveira", "M").await;

        ligar_uniao_e_filho(&pool, &pai1, &mae1, &primo1).await;
        ligar_uniao_e_filho(&pool, &pai2, &mae2, &primo2).await;

        let res = calcular(&pool, &primo1, &primo2).await.unwrap();
        assert!(res.tem_parentesco);
        assert_eq!(res.tipo_relacao, "consanguineo");
        assert_eq!(res.descricao_parentesco, "Primos de 1º grau (Primos-irmãos)");
        assert_eq!(res.distancia_geracoes_a, Some(2));
        assert_eq!(res.distancia_geracoes_b, Some(2));
    }

    #[tokio::test]
    async fn detecta_quando_nao_ha_parentesco() {
        let pool = pool_de_teste().await;
        let p1 = criar_pessoa(&pool, "Estranho 1", "Alpha", "M").await;
        let p2 = criar_pessoa(&pool, "Estranho 2", "Beta", "F").await;

        let res = calcular(&pool, &p1, &p2).await.unwrap();
        assert!(!res.tem_parentesco);
        assert_eq!(res.tipo_relacao, "nenhum");
    }

    #[tokio::test]
    async fn cruza_arvores_historicas_pedro2_e_pedro5() {
        let pool = pool_de_teste().await;
        crate::domain::semente_publica::garantir_acervo_publico(&pool).await.unwrap();

        // D. Pedro II do Brasil (pub_pedro2) e seu sobrinho D. Pedro V de Portugal (pub_pedro5_pt)
        let res = calcular(&pool, "pub_pedro2", "pub_pedro5_pt").await.unwrap();
        assert!(res.tem_parentesco);
        assert_eq!(res.tipo_relacao, "consanguineo");
        assert_eq!(res.descricao_parentesco, "Tio de B");
        assert_eq!(res.distancia_geracoes_a, Some(1));
        assert_eq!(res.distancia_geracoes_b, Some(2));
        let anc_id = res.ancestral_comum.as_ref().unwrap().pessoa_id.as_str();
        assert!(anc_id == "pub_pedro1" || anc_id == "pub_leopoldina");
    }
}
