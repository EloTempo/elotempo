//! As regras de conexão da seção 3 — o coração da correção do sistema.
//!
//! Este módulo não conhece o Tauri. Recebe `&SqlitePool` e devolve
//! `Resultado<T>`, o que permite testá-lo inteiro contra um banco em memória.
//! Os `#[tauri::command]` em `core_cmds.rs` são cascas finas em volta daqui.
//!
//! As quatro invariantes, textualmente:
//!
//! 1. **Acima** — uma pessoa pertence a no máximo *uma* união como filho.
//! 2. **União** — exatamente um slot masculino e um feminino; slot sem nome é
//!    um placeholder, nunca um vazio.
//! 3. **Filhos** — só ancoram na união, nunca num pai ou mãe direto.
//! 4. **Aciclia** — ninguém é ancestral de si mesmo.
//!
//! A 1 também é garantida pelo índice único `ix_uniao_filhos_pessoa_unica`
//! (migration 006). Aqui ela é checada antes para render uma mensagem
//! decente em vez de um erro cru de constraint.

use sqlx::{Row, SqlitePool};
use uuid::Uuid;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::models::Pessoa;

/// Sexos aceitos, conforme GEDCOM 7.0.
pub const SEXOS_VALIDOS: [&str; 4] = ["M", "F", "X", "U"];

/// Tipos de vínculo filho→união (tag GEDCOM `PEDI`).
pub const VINCULOS_VALIDOS: [&str; 4] = ["biologico", "adotado", "enteado", "tutelado"];

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Slot {
    Masculino,
    Feminino,
}

impl Slot {
    pub fn como_str(&self) -> &'static str {
        match self {
            Slot::Masculino => "masculino",
            Slot::Feminino => "feminino",
        }
    }

    /// Sexo dado a um placeholder criado para preencher este slot.
    pub fn sexo_padrao(&self) -> &'static str {
        match self {
            Slot::Masculino => "M",
            Slot::Feminino => "F",
        }
    }

    pub fn nome_placeholder(&self) -> &'static str {
        match self {
            Slot::Masculino => "Desconhecido",
            Slot::Feminino => "Desconhecida",
        }
    }
}

// =====================================================================
// Validações puras — sem banco, testáveis isoladamente
// =====================================================================

/// Um slot aceita o sexo correspondente, e também `X` e `U`.
///
/// `U` é o que torna o placeholder possível; `X` existe porque o GEDCOM 7.0 o
/// define e recusá-lo aqui excluiria pessoas reais do acervo. A união continua
/// binária — o que se afrouxa é qual pessoa pode ocupar cada lado, não a
/// quantidade de lados.
pub fn sexo_cabe_no_slot(sexo: &str, slot: Slot) -> bool {
    match slot {
        Slot::Masculino => matches!(sexo, "M" | "X" | "U"),
        Slot::Feminino => matches!(sexo, "F" | "X" | "U"),
    }
}

pub fn validar_sexo(sexo: &str) -> Resultado<()> {
    if SEXOS_VALIDOS.contains(&sexo) {
        Ok(())
    } else {
        Err(ErroDominio::ValorInvalido {
            campo: "sexo".into(),
            valor: sexo.into(),
        })
    }
}

pub fn validar_tipo_vinculo(tipo: &str) -> Resultado<()> {
    if VINCULOS_VALIDOS.contains(&tipo) {
        Ok(())
    } else {
        Err(ErroDominio::ValorInvalido {
            campo: "tipo_vinculo".into(),
            valor: tipo.into(),
        })
    }
}

// =====================================================================
// Consultas de apoio
// =====================================================================

pub async fn buscar_pessoa(pool: &SqlitePool, id: &str) -> Resultado<Pessoa> {
    let row = sqlx::query(
        "SELECT id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, foto_url, is_publico, categoria, tipo_tempo
         FROM pessoas WHERE id = ?",
    )
    .bind(id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| ErroDominio::PessoaNaoEncontrada(id.to_string()))?;

    Ok(Pessoa {
        id: row.try_get("id")?,
        nome: row.try_get("nome")?,
        sobrenome: row.try_get("sobrenome")?,
        sexo: row.try_get("sexo")?,
        minibiografia: row.try_get("minibiografia")?,
        is_vivo: row.try_get("is_vivo")?,
        is_placeholder: row.try_get("is_placeholder")?,
        foto_url: row.try_get("foto_url")?,
        is_publico: row.try_get("is_publico")?,
        categoria: row.try_get("categoria").ok().flatten(),
        tipo_tempo: row.try_get("tipo_tempo").unwrap_or_else(|_| "real".to_string()),
    })
}

async fn uniao_existe(pool: &SqlitePool, uniao_id: &str) -> Resultado<()> {
    let existe: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM unioes WHERE id = ?")
        .bind(uniao_id)
        .fetch_one(pool)
        .await?;
    if existe == 0 {
        return Err(ErroDominio::UniaoNaoEncontrada(uniao_id.to_string()));
    }
    Ok(())
}

// =====================================================================
// Leitura das conexões de uma pessoa
// =====================================================================

/// Pessoa reduzida ao que o painel de conexões precisa mostrar.
#[derive(Debug, Clone, serde::Serialize, sqlx::FromRow)]
pub struct PessoaResumo {
    pub id: String,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub is_placeholder: bool,
}

/// Uma união com os dois lados resolvidos.
///
/// Os dois slots vêm sempre preenchidos — é a invariante 2, e é o que permite
/// a mesma estrutura servir para a união *dos pais* (onde a pessoa consultada
/// não é cônjuge de ninguém e precisa enxergar pai **e** mãe) e para a união
/// *da pessoa* (onde um dos dois é ela mesma).
#[derive(Debug, Clone, serde::Serialize)]
pub struct UniaoResumo {
    pub id: String,
    pub estado_vinculo: String,
    /// Ocupante do slot masculino. Nunca nulo — no pior caso, um placeholder.
    pub masculino: PessoaResumo,
    /// Ocupante do slot feminino. Nunca nulo.
    pub feminino: PessoaResumo,
    /// Onde está a pessoa consultada: "masculino", "feminino" ou "nenhum"
    /// (este último no caso da união dos pais dela).
    pub slot_da_pessoa: String,
    pub filhos: Vec<PessoaResumo>,
}

/// Pais e uniões de uma pessoa.
#[derive(Debug, Clone, serde::Serialize)]
pub struct ConexoesPessoa {
    pub pessoa: PessoaResumo,
    /// A união da qual ela é filha, se houver. No máximo uma (invariante 1).
    pub uniao_de_origem: Option<UniaoResumo>,
    /// As uniões em que ela é cônjuge. Podem ser várias.
    pub unioes: Vec<UniaoResumo>,
}

async fn resumo(pool: &SqlitePool, id: &str) -> Resultado<PessoaResumo> {
    sqlx::query_as::<_, PessoaResumo>(
        "SELECT id, nome, sobrenome, sexo, is_placeholder FROM pessoas WHERE id = ?",
    )
    .bind(id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| ErroDominio::PessoaNaoEncontrada(id.to_string()))
}

/// Monta o `UniaoResumo` de uma união, visto por `pessoa_id`.
async fn montar_uniao(
    pool: &SqlitePool,
    uniao_id: &str,
    pessoa_id: &str,
) -> Resultado<UniaoResumo> {
    let linha = sqlx::query(
        "SELECT slot_masculino_id, slot_feminino_id, estado_vinculo FROM unioes WHERE id = ?",
    )
    .bind(uniao_id)
    .fetch_optional(pool)
    .await?
    .ok_or_else(|| ErroDominio::UniaoNaoEncontrada(uniao_id.to_string()))?;

    let masculino: String = linha.try_get("slot_masculino_id")?;
    let feminino: String = linha.try_get("slot_feminino_id")?;
    let estado_vinculo: String = linha.try_get("estado_vinculo")?;

    // Quem consultou pode ocupar um dos slots — ou nenhum, que é o caso da
    // união dos próprios pais.
    let slot_da_pessoa = if masculino == pessoa_id {
        "masculino"
    } else if feminino == pessoa_id {
        "feminino"
    } else {
        "nenhum"
    };

    let filhos = sqlx::query_as::<_, PessoaResumo>(
        "SELECT p.id, p.nome, p.sobrenome, p.sexo, p.is_placeholder
         FROM uniao_filhos f
         JOIN pessoas p ON p.id = f.pessoa_id
         WHERE f.uniao_id = ?
         ORDER BY f.ordem",
    )
    .bind(uniao_id)
    .fetch_all(pool)
    .await?;

    Ok(UniaoResumo {
        id: uniao_id.to_string(),
        estado_vinculo,
        masculino: resumo(pool, &masculino).await?,
        feminino: resumo(pool, &feminino).await?,
        slot_da_pessoa: slot_da_pessoa.to_string(),
        filhos,
    })
}

/// Tudo que o painel de conexões precisa para uma pessoa.
///
/// Consulta direta, sem passar pelo grafo da árvore: o grafo é podado pelo
/// limite de gerações, e um cônjuge fora do recorte sumiria daqui — que é
/// justamente o lugar onde ele não pode faltar.
pub async fn buscar_conexoes(pool: &SqlitePool, pessoa_id: &str) -> Resultado<ConexoesPessoa> {
    let pessoa = resumo(pool, pessoa_id).await?;

    let origem = match uniao_de_origem(pool, pessoa_id).await? {
        Some(uid) => Some(montar_uniao(pool, &uid, pessoa_id).await?),
        None => None,
    };

    let ids_unioes: Vec<String> = sqlx::query_scalar(
        "SELECT id FROM unioes WHERE slot_masculino_id = ?1 OR slot_feminino_id = ?1 ORDER BY id",
    )
    .bind(pessoa_id)
    .fetch_all(pool)
    .await?;

    let mut unioes = Vec::with_capacity(ids_unioes.len());
    for uid in ids_unioes {
        unioes.push(montar_uniao(pool, &uid, pessoa_id).await?);
    }

    Ok(ConexoesPessoa {
        pessoa,
        uniao_de_origem: origem,
        unioes,
    })
}

/// A união da qual esta pessoa é filha, se houver.
pub async fn uniao_de_origem(pool: &SqlitePool, pessoa_id: &str) -> Resultado<Option<String>> {
    let r: Option<String> =
        sqlx::query_scalar("SELECT uniao_id FROM uniao_filhos WHERE pessoa_id = ?")
            .bind(pessoa_id)
            .fetch_optional(pool)
            .await?;
    Ok(r)
}

/// `candidato` é ancestral de `descendente`?
///
/// Sobe pelos dois slots de cada união. O `UNION` (e não `UNION ALL`)
/// deduplica, o que faz a recursão terminar mesmo se o grafo já estiver
/// corrompido com um ciclo.
pub async fn e_ancestral(
    pool: &SqlitePool,
    candidato: &str,
    descendente: &str,
) -> Resultado<bool> {
    let encontrou: i64 = sqlx::query_scalar(
        r#"
        WITH RECURSIVE ancestrais(id) AS (
            SELECT ?1
            UNION
            SELECT vinculo.progenitor
            FROM (
                SELECT f.pessoa_id AS filho, u.slot_masculino_id AS progenitor
                  FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                UNION ALL
                SELECT f.pessoa_id, u.slot_feminino_id
                  FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
            ) AS vinculo
            JOIN ancestrais a ON vinculo.filho = a.id
        )
        SELECT COUNT(*) FROM ancestrais WHERE id = ?2
        "#,
    )
    .bind(descendente)
    .bind(candidato)
    .fetch_one(pool)
    .await?;

    Ok(encontrou > 0)
}

// =====================================================================
// Pessoas
// =====================================================================

pub struct NovaPessoa {
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sexo: String,
    pub minibiografia: Option<String>,
    pub is_vivo: bool,
    pub foto_url: Option<String>,
    pub tipo_tempo: Option<String>,
    pub arvore_id: Option<String>,
}

pub async fn criar_pessoa(pool: &SqlitePool, nova: NovaPessoa) -> Resultado<String> {
    validar_sexo(&nova.sexo)?;
    let id = Uuid::new_v4().to_string();
    let tipo_tempo = nova.tipo_tempo.unwrap_or_else(|| "real".to_string());

    sqlx::query(
        "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, foto_url, tipo_tempo)
         VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?)",
    )
    .bind(&id)
    .bind(nova.nome.trim())
    .bind(&nova.sobrenome)
    .bind(&nova.sexo)
    .bind(&nova.minibiografia)
    .bind(nova.is_vivo)
    .bind(&nova.foto_url)
    .bind(&tipo_tempo)
    .execute(pool)
    .await?;

    // Se uma árvore foi indicada pelo usuário, associa a pessoa especificamente a ela
    if let Some(ref aid) = nova.arvore_id {
        let _ = sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
             VALUES (lower(hex(randomblob(16))), ?, ?, NULL)",
        )
        .bind(aid)
        .bind(&id)
        .execute(pool)
        .await;
    }

    Ok(id)
}

/// Cria a pessoa-placeholder da seção 2.2: um nó real, com sexo definido e
/// identidade em aberto, que ocupa um slot até alguém descobrir o nome.
pub async fn criar_placeholder(pool: &SqlitePool, slot: Slot) -> Resultado<String> {
    let id = Uuid::new_v4().to_string();

    sqlx::query(
        "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
         VALUES (?, ?, NULL, ?, 0, 1)",
    )
    .bind(&id)
    .bind(slot.nome_placeholder())
    .bind(slot.sexo_padrao())
    .execute(pool)
    .await?;

    Ok(id)
}

/// Transforma o placeholder no ancestral real. Os filhos já pendurados nele
/// permanecem, porque o `id` não muda — é esse o ponto inteiro da regra.
pub async fn promover_placeholder(
    pool: &SqlitePool,
    pessoa_id: &str,
    nome: &str,
    sobrenome: Option<&str>,
) -> Resultado<()> {
    let pessoa = buscar_pessoa(pool, pessoa_id).await?;
    if !pessoa.is_placeholder {
        return Err(ErroDominio::ValorInvalido {
            campo: "is_placeholder".into(),
            valor: "esta pessoa não é um placeholder".into(),
        });
    }

    sqlx::query("UPDATE pessoas SET nome = ?, sobrenome = ?, is_placeholder = 0 WHERE id = ?")
        .bind(nome.trim())
        .bind(sobrenome)
        .bind(pessoa_id)
        .execute(pool)
        .await?;

    Ok(())
}

/// Atualiza a pessoa, recusando trocas de sexo que quebrariam uma união
/// existente.
///
/// Este era um buraco real: `create_uniao` validava o slot, mas nada impedia
/// mudar o sexo de alguém depois de alocado, deixando um "M" no slot feminino.
pub async fn atualizar_pessoa(pool: &SqlitePool, pessoa: &Pessoa) -> Resultado<()> {
    validar_sexo(&pessoa.sexo)?;
    let atual = buscar_pessoa(pool, &pessoa.id).await?;

    if atual.sexo != pessoa.sexo {
        for (slot, coluna) in [
            (Slot::Masculino, "slot_masculino_id"),
            (Slot::Feminino, "slot_feminino_id"),
        ] {
            let uniao: Option<String> = sqlx::query_scalar(&format!(
                "SELECT id FROM unioes WHERE {coluna} = ? LIMIT 1"
            ))
            .bind(&pessoa.id)
            .fetch_optional(pool)
            .await?;

            if let Some(uniao_id) = uniao {
                if !sexo_cabe_no_slot(&pessoa.sexo, slot) {
                    return Err(ErroDominio::SexoTravadoPorUniao {
                        pessoa_id: pessoa.id.clone(),
                        uniao_id,
                        slot: slot.como_str().into(),
                    });
                }
            }
        }
    }

    sqlx::query(
        "UPDATE pessoas
         SET nome = ?, sobrenome = ?, sexo = ?, minibiografia = ?, is_vivo = ?, foto_url = ?, tipo_tempo = ?
         WHERE id = ?",
    )
    .bind(pessoa.nome.trim())
    .bind(&pessoa.sobrenome)
    .bind(&pessoa.sexo)
    .bind(&pessoa.minibiografia)
    .bind(pessoa.is_vivo)
    .bind(&pessoa.foto_url)
    .bind(&pessoa.tipo_tempo)
    .bind(&pessoa.id)
    .execute(pool)
    .await?;

    Ok(())
}

/// A pessoa pode ser removida?
///
/// Separado da remoção porque quem chama precisa saber **antes** de apagar os
/// arquivos de mídia dela: perder as fotos por causa de uma tentativa que o
/// domínio vai recusar em seguida seria um estrago irreversível.
pub async fn verificar_se_pode_remover(pool: &SqlitePool, pessoa_id: &str) -> Resultado<()> {
    buscar_pessoa(pool, pessoa_id).await?;

    let em_uniao: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM unioes WHERE slot_masculino_id = ?1 OR slot_feminino_id = ?1",
    )
    .bind(pessoa_id)
    .fetch_one(pool)
    .await?;

    if em_uniao > 0 {
        return Err(ErroDominio::PessoaEmUso {
            pessoa_id: pessoa_id.to_string(),
            motivo: format!(
                "ela ocupa um slot em {em_uniao} união(ões). Desfaça a união primeiro — \
                 ou, se o objetivo é apenas apagar o nome, transforme-a de volta em placeholder."
            ),
        });
    }

    Ok(())
}

/// Remove a pessoa. Recusa se ela ocupa um slot de união — apagar deixaria a
/// união com um lado só, o que o modelo não admite.
pub async fn remover_pessoa(pool: &SqlitePool, pessoa_id: &str) -> Resultado<()> {
    verificar_se_pode_remover(pool, pessoa_id).await?;

    sqlx::query("DELETE FROM pessoas WHERE id = ?")
        .bind(pessoa_id)
        .execute(pool)
        .await?;

    Ok(())
}

// =====================================================================
// Uniões
// =====================================================================

/// Cria a união. Slot passado como `None` ganha um placeholder automático —
/// é assim que a seção 2.2 diz que o modelo nunca tem slot vazio.
pub async fn criar_uniao(
    pool: &SqlitePool,
    slot_masculino: Option<&str>,
    slot_feminino: Option<&str>,
    estado_vinculo: &str,
) -> Resultado<String> {
    let masculino_id = match slot_masculino {
        Some(id) => {
            let p = buscar_pessoa(pool, id).await?;
            if !sexo_cabe_no_slot(&p.sexo, Slot::Masculino) {
                return Err(ErroDominio::SlotIncompativel {
                    slot: Slot::Masculino.como_str().into(),
                    pessoa_id: id.into(),
                    sexo: p.sexo,
                });
            }
            id.to_string()
        }
        None => criar_placeholder(pool, Slot::Masculino).await?,
    };

    let feminino_id = match slot_feminino {
        Some(id) => {
            let p = buscar_pessoa(pool, id).await?;
            if !sexo_cabe_no_slot(&p.sexo, Slot::Feminino) {
                return Err(ErroDominio::SlotIncompativel {
                    slot: Slot::Feminino.como_str().into(),
                    pessoa_id: id.into(),
                    sexo: p.sexo,
                });
            }
            id.to_string()
        }
        None => criar_placeholder(pool, Slot::Feminino).await?,
    };

    if masculino_id == feminino_id {
        return Err(ErroDominio::CicloGenealogico {
            pessoa_id: masculino_id,
            motivo: "a mesma pessoa não pode ocupar os dois slots da união".into(),
        });
    }

    let id = Uuid::new_v4().to_string();
    sqlx::query(
        "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
         VALUES (?, ?, ?, ?, NULL)",
    )
    .bind(&id)
    .bind(&masculino_id)
    .bind(&feminino_id)
    .bind(estado_vinculo)
    .execute(pool)
    .await?;

    // Se algum dos cônjuges já pertencer a árvores genealógicas, vincula o outro cônjuge
    // e a união recém-criada às mesmas árvores
    let _ = sqlx::query(
        "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
         SELECT lower(hex(randomblob(16))), arvore_id, ?1, NULL FROM arvore_membros WHERE pessoa_id = ?2
         UNION
         SELECT lower(hex(randomblob(16))), arvore_id, ?2, NULL FROM arvore_membros WHERE pessoa_id = ?1
         UNION
         SELECT lower(hex(randomblob(16))), arvore_id, NULL, ?3 FROM arvore_membros WHERE pessoa_id IN (?1, ?2)",
    )
    .bind(&feminino_id)
    .bind(&masculino_id)
    .bind(&id)
    .execute(pool)
    .await;

    Ok(id)
}

/// Remove a união e limpa os placeholders que ficarem sem serventia.
///
/// Os vínculos de filho caem junto (ON DELETE CASCADE). As pessoas ficam —
/// **exceto** placeholders que, sem esta união, não estão mais ligados a nada.
/// Eles só existiam para segurar o slot; mantê-los encheria o acervo de
/// "Desconhecido" invisíveis a cada correção de engano.
///
/// Quem foi promovido a pessoa real não é tocado: promover zera o
/// `is_placeholder`, e a checagem abaixo se apoia justamente nesse campo.
pub async fn remover_uniao(pool: &SqlitePool, uniao_id: &str) -> Resultado<()> {
    let linha = sqlx::query("SELECT slot_masculino_id, slot_feminino_id FROM unioes WHERE id = ?")
        .bind(uniao_id)
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| ErroDominio::UniaoNaoEncontrada(uniao_id.to_string()))?;

    let masculino: String = linha.try_get("slot_masculino_id")?;
    let feminino: String = linha.try_get("slot_feminino_id")?;

    sqlx::query("DELETE FROM unioes WHERE id = ?")
        .bind(uniao_id)
        .execute(pool)
        .await?;

    for ocupante in [&masculino, &feminino] {
        remover_placeholder_orfao(pool, ocupante).await?;
    }

    Ok(())
}

/// Apaga a pessoa **apenas** se ela for um placeholder que não sobrou ligado a
/// nada. Silenciosa nos demais casos: é faxina, não uma exclusão pedida.
async fn remover_placeholder_orfao(pool: &SqlitePool, pessoa_id: &str) -> Resultado<()> {
    let apagaveis: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM pessoas p
         WHERE p.id = ?1
           AND p.is_placeholder = 1
           AND NOT EXISTS (SELECT 1 FROM unioes u
                            WHERE u.slot_masculino_id = ?1 OR u.slot_feminino_id = ?1)
           AND NOT EXISTS (SELECT 1 FROM uniao_filhos f WHERE f.pessoa_id = ?1)",
    )
    .bind(pessoa_id)
    .fetch_one(pool)
    .await?;

    if apagaveis > 0 {
        sqlx::query("DELETE FROM pessoas WHERE id = ?")
            .bind(pessoa_id)
            .execute(pool)
            .await?;
    }
    Ok(())
}

// =====================================================================
// Filhos
// =====================================================================

/// Anexa um filho à união, aplicando as quatro invariantes.
pub async fn anexar_filho(
    pool: &SqlitePool,
    uniao_id: &str,
    pessoa_id: &str,
    tipo_vinculo: &str,
) -> Resultado<()> {
    validar_tipo_vinculo(tipo_vinculo)?;
    uniao_existe(pool, uniao_id).await?;
    buscar_pessoa(pool, pessoa_id).await?;

    // Invariante 1 — no máximo uma união como filho, seja qual for o vínculo.
    if let Some(existente) = uniao_de_origem(pool, pessoa_id).await? {
        return Err(ErroDominio::FilhoJaTemUniao {
            pessoa_id: pessoa_id.to_string(),
            uniao_existente: existente,
        });
    }

    // Invariante 4 — ninguém é filho dos próprios descendentes, nem de si mesmo.
    let (pai, mae): (String, String) = {
        let row = sqlx::query("SELECT slot_masculino_id, slot_feminino_id FROM unioes WHERE id = ?")
            .bind(uniao_id)
            .fetch_one(pool)
            .await?;
        (row.try_get(0)?, row.try_get(1)?)
    };

    if pessoa_id == pai || pessoa_id == mae {
        return Err(ErroDominio::CicloGenealogico {
            pessoa_id: pessoa_id.to_string(),
            motivo: "uma pessoa não pode ser filha da própria união".into(),
        });
    }

    for progenitor in [&pai, &mae] {
        if e_ancestral(pool, pessoa_id, progenitor).await? {
            return Err(ErroDominio::CicloGenealogico {
                pessoa_id: pessoa_id.to_string(),
                motivo: "esta pessoa já é ancestral de um dos pais desta união — \
                         a ligação criaria um laço no grafo"
                    .into(),
            });
        }
    }

    let proxima_ordem: i64 =
        sqlx::query_scalar("SELECT COALESCE(MAX(ordem), 0) + 1 FROM uniao_filhos WHERE uniao_id = ?")
            .bind(uniao_id)
            .fetch_one(pool)
            .await?;

    sqlx::query(
        "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES (?, ?, ?, ?)",
    )
    .bind(uniao_id)
    .bind(pessoa_id)
    .bind(tipo_vinculo)
    .bind(proxima_ordem)
    .execute(pool)
    .await?;

    // Garante que o filho faça parte de todas as árvores a que os pais ou a união pertencem
    let _ = sqlx::query(
        "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
         SELECT lower(hex(randomblob(16))), arvore_id, ?1, NULL
         FROM arvore_membros
         WHERE pessoa_id IN (?2, ?3) OR uniao_id = ?4",
    )
    .bind(pessoa_id)
    .bind(&pai)
    .bind(&mae)
    .bind(uniao_id)
    .execute(pool)
    .await;

    Ok(())
}

pub async fn desvincular_filho(pool: &SqlitePool, pessoa_id: &str) -> Resultado<()> {
    sqlx::query("DELETE FROM uniao_filhos WHERE pessoa_id = ?")
        .bind(pessoa_id)
        .execute(pool)
        .await?;
    Ok(())
}

// =====================================================================
// Testes das regras de conexão — obrigatórios pela seção 11
// =====================================================================
#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    /// Banco em memória com todas as migrations aplicadas.
    ///
    /// `max_connections(1)` é obrigatório: cada conexão a `sqlite::memory:`
    /// abriria um banco *diferente*, e os testes passariam a mentir.
    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("abrir sqlite em memória");
        sqlx::migrate!("./migrations")
            .run(&pool)
            .await
            .expect("aplicar migrations");
        pool
    }

    async fn pessoa(pool: &SqlitePool, nome: &str, sexo: &str) -> String {
        criar_pessoa(
            pool,
            NovaPessoa {
                nome: nome.into(),
                sobrenome: None,
                sexo: sexo.into(),
                minibiografia: None,
                is_vivo: false,
                foto_url: None,
                tipo_tempo: None,
                arvore_id: None,
            },
        )
        .await
        .expect("criar pessoa")
    }

    // ---------- Invariante: slots da união ----------

    #[test]
    fn slot_masculino_aceita_m_x_u_e_recusa_f() {
        assert!(sexo_cabe_no_slot("M", Slot::Masculino));
        assert!(sexo_cabe_no_slot("X", Slot::Masculino));
        assert!(sexo_cabe_no_slot("U", Slot::Masculino));
        assert!(!sexo_cabe_no_slot("F", Slot::Masculino));
    }

    #[test]
    fn slot_feminino_aceita_f_x_u_e_recusa_m() {
        assert!(sexo_cabe_no_slot("F", Slot::Feminino));
        assert!(sexo_cabe_no_slot("X", Slot::Feminino));
        assert!(sexo_cabe_no_slot("U", Slot::Feminino));
        assert!(!sexo_cabe_no_slot("M", Slot::Feminino));
    }

    #[tokio::test]
    async fn uniao_recusa_sexo_errado_no_slot() {
        let pool = pool_de_teste().await;
        let joao = pessoa(&pool, "João", "M").await;
        let maria = pessoa(&pool, "Maria", "F").await;

        // Invertidos de propósito.
        let erro = criar_uniao(&pool, Some(&maria), Some(&joao), "casamento")
            .await
            .unwrap_err();

        assert!(matches!(erro, ErroDominio::SlotIncompativel { .. }), "{erro:?}");
    }

    #[tokio::test]
    async fn uniao_recusa_a_mesma_pessoa_nos_dois_slots() {
        let pool = pool_de_teste().await;
        let alguem = pessoa(&pool, "Alguém", "X").await;
        let erro = criar_uniao(&pool, Some(&alguem), Some(&alguem), "nao_informado")
            .await
            .unwrap_err();
        assert!(matches!(erro, ErroDominio::CicloGenealogico { .. }), "{erro:?}");
    }

    // ---------- Invariante: placeholder ----------

    #[tokio::test]
    async fn slot_sem_nome_vira_placeholder_e_nunca_fica_vazio() {
        let pool = pool_de_teste().await;
        let maria = pessoa(&pool, "Maria", "F").await;

        // Só a mãe é conhecida.
        let uniao = criar_uniao(&pool, None, Some(&maria), "nao_informado")
            .await
            .unwrap();

        let row = sqlx::query("SELECT slot_masculino_id, slot_feminino_id FROM unioes WHERE id = ?")
            .bind(&uniao)
            .fetch_one(&pool)
            .await
            .unwrap();
        let masculino: String = row.try_get(0).unwrap();

        let pai = buscar_pessoa(&pool, &masculino).await.unwrap();
        assert!(pai.is_placeholder, "o slot vazio deveria ter virado placeholder");
        assert_eq!(pai.sexo, "M");
        assert_eq!(pai.nome, "Desconhecido");
    }

    #[tokio::test]
    async fn promover_placeholder_mantem_os_filhos_pendurados() {
        let pool = pool_de_teste().await;
        let maria = pessoa(&pool, "Maria", "F").await;
        let filho = pessoa(&pool, "Filho", "M").await;

        let uniao = criar_uniao(&pool, None, Some(&maria), "nao_informado")
            .await
            .unwrap();
        anexar_filho(&pool, &uniao, &filho, "biologico").await.unwrap();

        let pai_id: String = sqlx::query_scalar("SELECT slot_masculino_id FROM unioes WHERE id = ?")
            .bind(&uniao)
            .fetch_one(&pool)
            .await
            .unwrap();

        // Descobriu-se o nome do avô.
        promover_placeholder(&pool, &pai_id, "Joaquim", Some("Ferreira"))
            .await
            .unwrap();

        let promovido = buscar_pessoa(&pool, &pai_id).await.unwrap();
        assert_eq!(promovido.nome, "Joaquim");
        assert!(!promovido.is_placeholder);

        // E o filho continua lá, na mesma união.
        assert_eq!(uniao_de_origem(&pool, &filho).await.unwrap(), Some(uniao));
    }

    // ---------- Invariante: uma única união como filho ----------

    #[tokio::test]
    async fn filho_nao_entra_em_duas_unioes_nem_mudando_o_tipo_de_vinculo() {
        let pool = pool_de_teste().await;
        let filho = pessoa(&pool, "Filho", "M").await;

        let mae1 = pessoa(&pool, "Mãe Biológica", "F").await;
        let mae2 = pessoa(&pool, "Mãe Adotiva", "F").await;
        let uniao1 = criar_uniao(&pool, None, Some(&mae1), "nao_informado").await.unwrap();
        let uniao2 = criar_uniao(&pool, None, Some(&mae2), "nao_informado").await.unwrap();

        anexar_filho(&pool, &uniao1, &filho, "biologico").await.unwrap();

        // O furo antigo: bastava trocar o tipo para escapar da checagem.
        let erro = anexar_filho(&pool, &uniao2, &filho, "adotado")
            .await
            .unwrap_err();

        assert!(matches!(erro, ErroDominio::FilhoJaTemUniao { .. }), "{erro:?}");
    }

    #[tokio::test]
    async fn o_banco_tambem_barra_a_segunda_uniao() {
        // Cinto e suspensório: mesmo que alguém contorne a checagem de domínio,
        // o índice único da migration 006 recusa.
        let pool = pool_de_teste().await;
        let filho = pessoa(&pool, "Filho", "M").await;
        let m1 = pessoa(&pool, "M1", "F").await;
        let m2 = pessoa(&pool, "M2", "F").await;
        let u1 = criar_uniao(&pool, None, Some(&m1), "nao_informado").await.unwrap();
        let u2 = criar_uniao(&pool, None, Some(&m2), "nao_informado").await.unwrap();

        anexar_filho(&pool, &u1, &filho, "biologico").await.unwrap();

        let bruto = sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem) VALUES (?,?,?,1)",
        )
        .bind(&u2)
        .bind(&filho)
        .bind("enteado")
        .execute(&pool)
        .await;

        assert!(bruto.is_err(), "o índice único deveria ter recusado");
    }

    #[tokio::test]
    async fn desvincular_libera_para_outra_uniao() {
        let pool = pool_de_teste().await;
        let filho = pessoa(&pool, "Filho", "M").await;
        let m1 = pessoa(&pool, "M1", "F").await;
        let m2 = pessoa(&pool, "M2", "F").await;
        let u1 = criar_uniao(&pool, None, Some(&m1), "nao_informado").await.unwrap();
        let u2 = criar_uniao(&pool, None, Some(&m2), "nao_informado").await.unwrap();

        anexar_filho(&pool, &u1, &filho, "biologico").await.unwrap();
        desvincular_filho(&pool, &filho).await.unwrap();
        anexar_filho(&pool, &u2, &filho, "adotado").await.unwrap();

        assert_eq!(uniao_de_origem(&pool, &filho).await.unwrap(), Some(u2));
    }

    // ---------- Invariante: aciclia ----------

    #[tokio::test]
    async fn pessoa_nao_pode_ser_filha_da_propria_uniao() {
        let pool = pool_de_teste().await;
        let joao = pessoa(&pool, "João", "M").await;
        let maria = pessoa(&pool, "Maria", "F").await;
        let uniao = criar_uniao(&pool, Some(&joao), Some(&maria), "casamento")
            .await
            .unwrap();

        let erro = anexar_filho(&pool, &uniao, &joao, "biologico").await.unwrap_err();
        assert!(matches!(erro, ErroDominio::CicloGenealogico { .. }), "{erro:?}");
    }

    #[tokio::test]
    async fn avo_nao_pode_virar_neto_do_proprio_neto() {
        let pool = pool_de_teste().await;

        // avô ─┬─ avó
        //      └── pai ─┬─ mãe
        //               └── neto
        let avo_m = pessoa(&pool, "Avô", "M").await;
        let avo_f = pessoa(&pool, "Avó", "F").await;
        let pai = pessoa(&pool, "Pai", "M").await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let neto = pessoa(&pool, "Neto", "M").await;

        let u_avos = criar_uniao(&pool, Some(&avo_m), Some(&avo_f), "casamento").await.unwrap();
        anexar_filho(&pool, &u_avos, &pai, "biologico").await.unwrap();

        let u_pais = criar_uniao(&pool, Some(&pai), Some(&mae), "casamento").await.unwrap();
        anexar_filho(&pool, &u_pais, &neto, "biologico").await.unwrap();

        assert!(e_ancestral(&pool, &avo_m, &neto).await.unwrap());
        assert!(!e_ancestral(&pool, &neto, &avo_m).await.unwrap());

        // Tentar fechar o laço: o avô como filho da união do próprio neto.
        let esposa_neto = pessoa(&pool, "Esposa", "F").await;
        let u_neto = criar_uniao(&pool, Some(&neto), Some(&esposa_neto), "casamento")
            .await
            .unwrap();

        desvincular_filho(&pool, &avo_m).await.unwrap();
        let erro = anexar_filho(&pool, &u_neto, &avo_m, "biologico").await.unwrap_err();
        assert!(matches!(erro, ErroDominio::CicloGenealogico { .. }), "{erro:?}");
    }

    // ---------- Invariante: sexo travado por união ----------

    #[tokio::test]
    async fn nao_da_para_trocar_o_sexo_de_quem_ocupa_um_slot() {
        let pool = pool_de_teste().await;
        let joao = pessoa(&pool, "João", "M").await;
        let maria = pessoa(&pool, "Maria", "F").await;
        criar_uniao(&pool, Some(&joao), Some(&maria), "casamento").await.unwrap();

        let mut alterado = buscar_pessoa(&pool, &joao).await.unwrap();
        alterado.sexo = "F".into();

        let erro = atualizar_pessoa(&pool, &alterado).await.unwrap_err();
        assert!(matches!(erro, ErroDominio::SexoTravadoPorUniao { .. }), "{erro:?}");
    }

    #[tokio::test]
    async fn trocar_para_x_e_permitido_porque_x_cabe_nos_dois_slots() {
        let pool = pool_de_teste().await;
        let joao = pessoa(&pool, "João", "M").await;
        let maria = pessoa(&pool, "Maria", "F").await;
        criar_uniao(&pool, Some(&joao), Some(&maria), "casamento").await.unwrap();

        let mut alterado = buscar_pessoa(&pool, &joao).await.unwrap();
        alterado.sexo = "X".into();

        assert!(atualizar_pessoa(&pool, &alterado).await.is_ok());
    }

    #[tokio::test]
    async fn quem_nao_esta_em_uniao_pode_mudar_de_sexo_livremente() {
        let pool = pool_de_teste().await;
        let solto = pessoa(&pool, "Solto", "M").await;
        let mut alterado = buscar_pessoa(&pool, &solto).await.unwrap();
        alterado.sexo = "F".into();
        assert!(atualizar_pessoa(&pool, &alterado).await.is_ok());
    }

    // ---------- Exclusão ----------

    #[tokio::test]
    async fn remover_uniao_leva_junto_o_placeholder_que_ficou_sem_serventia() {
        // O cenário do engano: criou "adicionar pais" sem querer, e desfaz.
        // Os dois desconhecidos não podem ficar boiando no acervo.
        let pool = pool_de_teste().await;
        let filho = pessoa(&pool, "Filho", "M").await;

        let uniao = criar_uniao(&pool, None, None, "nao_informado").await.unwrap();
        anexar_filho(&pool, &uniao, &filho, "biologico").await.unwrap();

        let total_antes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(total_antes, 3, "filho + dois placeholders");

        remover_uniao(&pool, &uniao).await.unwrap();

        let restantes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(restantes, 1, "só o filho deveria sobrar");
        assert!(buscar_pessoa(&pool, &filho).await.is_ok());
    }

    #[tokio::test]
    async fn remover_uniao_preserva_quem_foi_promovido() {
        // Se o placeholder virou uma pessoa real, ele deixou de ser descartável.
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let uniao = criar_uniao(&pool, None, Some(&mae), "casamento").await.unwrap();

        let pai_id: String = sqlx::query_scalar("SELECT slot_masculino_id FROM unioes WHERE id = ?")
            .bind(&uniao)
            .fetch_one(&pool)
            .await
            .unwrap();
        promover_placeholder(&pool, &pai_id, "Joaquim", Some("Ferreira")).await.unwrap();

        remover_uniao(&pool, &uniao).await.unwrap();

        assert!(
            buscar_pessoa(&pool, &pai_id).await.is_ok(),
            "quem ganhou nome não pode ser varrido junto com a união"
        );
        assert!(buscar_pessoa(&pool, &mae).await.is_ok());
    }

    #[tokio::test]
    async fn remover_uniao_preserva_placeholder_que_ainda_serve_a_outra() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "F").await;

        // Um placeholder masculino em duas uniões distintas.
        let u1 = criar_uniao(&pool, None, Some(&mae), "casamento").await.unwrap();
        let pai_id: String = sqlx::query_scalar("SELECT slot_masculino_id FROM unioes WHERE id = ?")
            .bind(&u1)
            .fetch_one(&pool)
            .await
            .unwrap();

        let outra = pessoa(&pool, "Outra", "F").await;
        criar_uniao(&pool, Some(&pai_id), Some(&outra), "estavel").await.unwrap();

        remover_uniao(&pool, &u1).await.unwrap();

        assert!(
            buscar_pessoa(&pool, &pai_id).await.is_ok(),
            "ele ainda ocupa o slot da outra união"
        );
    }

    #[tokio::test]
    async fn remover_uniao_inexistente_da_erro() {
        let pool = pool_de_teste().await;
        let erro = remover_uniao(&pool, "nao-existe").await.unwrap_err();
        assert!(matches!(erro, ErroDominio::UniaoNaoEncontrada(_)), "{erro:?}");
    }

    #[tokio::test]
    async fn apagar_pessoa_leva_junto_os_eventos_dela() {
        let pool = pool_de_teste().await;
        let p = pessoa(&pool, "Enganado", "M").await;

        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador)
             VALUES ('e1',?,'nascimento','1900','exata')",
        )
        .bind(&p)
        .execute(&pool)
        .await
        .unwrap();

        remover_pessoa(&pool, &p).await.unwrap();

        let eventos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM eventos WHERE pessoa_id = ?")
            .bind(&p)
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(eventos, 0, "o ON DELETE CASCADE deveria ter levado o evento");
    }

    #[tokio::test]
    async fn apagar_filho_nao_derruba_a_uniao_dos_pais() {
        let pool = pool_de_teste().await;
        let pai = pessoa(&pool, "Pai", "M").await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let filho = pessoa(&pool, "Filho", "M").await;
        let uniao = criar_uniao(&pool, Some(&pai), Some(&mae), "casamento").await.unwrap();
        anexar_filho(&pool, &uniao, &filho, "biologico").await.unwrap();

        remover_pessoa(&pool, &filho).await.unwrap();

        assert!(buscar_pessoa(&pool, &pai).await.is_ok());
        assert!(buscar_pessoa(&pool, &mae).await.is_ok());
        let vinculos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM uniao_filhos WHERE uniao_id = ?")
            .bind(&uniao)
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(vinculos, 0);
    }

    #[tokio::test]
    async fn nao_da_para_apagar_quem_ocupa_um_slot() {
        let pool = pool_de_teste().await;
        let joao = pessoa(&pool, "João", "M").await;
        let maria = pessoa(&pool, "Maria", "F").await;
        criar_uniao(&pool, Some(&joao), Some(&maria), "casamento").await.unwrap();

        let erro = remover_pessoa(&pool, &joao).await.unwrap_err();
        assert!(matches!(erro, ErroDominio::PessoaEmUso { .. }), "{erro:?}");
    }

    // ---------- Validações de valor ----------

    #[tokio::test]
    async fn sexo_fora_do_gedcom_e_recusado() {
        let pool = pool_de_teste().await;
        let erro = criar_pessoa(
            &pool,
            NovaPessoa {
                nome: "Teste".into(),
                sobrenome: None,
                sexo: "Z".into(),
                minibiografia: None,
                is_vivo: true,
                foto_url: None,
                tipo_tempo: None,
                arvore_id: None,
            },
        )
        .await
        .unwrap_err();
        assert!(matches!(erro, ErroDominio::ValorInvalido { .. }), "{erro:?}");
    }

    #[tokio::test]
    async fn tipo_de_vinculo_fora_da_lista_e_recusado() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let filho = pessoa(&pool, "Filho", "M").await;
        let uniao = criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        let erro = anexar_filho(&pool, &uniao, &filho, "padrinho").await.unwrap_err();
        assert!(matches!(erro, ErroDominio::ValorInvalido { .. }), "{erro:?}");
    }

    #[tokio::test]
    async fn referencia_inexistente_da_erro_claro() {
        let pool = pool_de_teste().await;
        let filho = pessoa(&pool, "Filho", "M").await;
        let erro = anexar_filho(&pool, "uniao-que-nao-existe", &filho, "biologico")
            .await
            .unwrap_err();
        assert!(matches!(erro, ErroDominio::UniaoNaoEncontrada(_)), "{erro:?}");
    }

    // ---------- Leitura das conexões ----------

    #[tokio::test]
    async fn conexoes_trazem_pais_conjuge_e_filhos() {
        let pool = pool_de_teste().await;

        let avo_m = pessoa(&pool, "Avô", "M").await;
        let avo_f = pessoa(&pool, "Avó", "F").await;
        let pai = pessoa(&pool, "Pai", "M").await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let filha = pessoa(&pool, "Filha", "F").await;

        let u_avos = criar_uniao(&pool, Some(&avo_m), Some(&avo_f), "casamento").await.unwrap();
        anexar_filho(&pool, &u_avos, &pai, "biologico").await.unwrap();

        let u_pais = criar_uniao(&pool, Some(&pai), Some(&mae), "casamento").await.unwrap();
        anexar_filho(&pool, &u_pais, &filha, "biologico").await.unwrap();

        let c = buscar_conexoes(&pool, &pai).await.unwrap();

        assert_eq!(c.pessoa.nome, "Pai");

        // Os pais dele: na união de origem ele não ocupa slot nenhum, e é
        // justamente por isso que os DOIS lados precisam vir resolvidos —
        // senão o pai sumiria do painel.
        let origem = c.uniao_de_origem.expect("o pai é filho da união dos avós");
        assert_eq!(origem.id, u_avos);
        assert_eq!(origem.slot_da_pessoa, "nenhum");
        assert_eq!(origem.masculino.nome, "Avô");
        assert_eq!(origem.feminino.nome, "Avó");
        assert_eq!(origem.filhos.len(), 1);

        // A união dele
        assert_eq!(c.unioes.len(), 1);
        assert_eq!(c.unioes[0].slot_da_pessoa, "masculino");
        assert_eq!(c.unioes[0].masculino.nome, "Pai");
        assert_eq!(c.unioes[0].feminino.nome, "Mãe");
        assert_eq!(c.unioes[0].filhos.len(), 1);
        assert_eq!(c.unioes[0].filhos[0].nome, "Filha");
    }

    #[tokio::test]
    async fn conexoes_veem_o_placeholder_como_conjuge() {
        // O caso que motiva a regra da seção 2.2: cadastrar um filho sabendo
        // só o nome da mãe. O painel precisa mostrar o pai desconhecido como
        // um nó clicável, não como um vazio.
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let uniao = criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        let c = buscar_conexoes(&pool, &mae).await.unwrap();
        assert_eq!(c.unioes.len(), 1);
        assert_eq!(c.unioes[0].id, uniao);
        assert_eq!(c.unioes[0].slot_da_pessoa, "feminino");
        assert!(c.unioes[0].masculino.is_placeholder);
        assert_eq!(c.unioes[0].masculino.sexo, "M");
        assert!(!c.unioes[0].feminino.is_placeholder);
    }

    #[tokio::test]
    async fn conexoes_de_quem_nao_tem_ninguem_nao_falham() {
        let pool = pool_de_teste().await;
        let sozinha = pessoa(&pool, "Sozinha", "F").await;
        let c = buscar_conexoes(&pool, &sozinha).await.unwrap();
        assert!(c.uniao_de_origem.is_none());
        assert!(c.unioes.is_empty());
    }

    #[tokio::test]
    async fn conexoes_listam_as_duas_unioes_de_quem_casou_de_novo() {
        let pool = pool_de_teste().await;
        let homem = pessoa(&pool, "Homem", "M").await;
        let primeira = pessoa(&pool, "Primeira", "F").await;
        let segunda = pessoa(&pool, "Segunda", "F").await;

        criar_uniao(&pool, Some(&homem), Some(&primeira), "dissolvida").await.unwrap();
        criar_uniao(&pool, Some(&homem), Some(&segunda), "casamento").await.unwrap();

        let c = buscar_conexoes(&pool, &homem).await.unwrap();
        assert_eq!(c.unioes.len(), 2);
        let esposas: Vec<&str> = c.unioes.iter().map(|u| u.feminino.nome.as_str()).collect();
        assert!(esposas.contains(&"Primeira"));
        assert!(esposas.contains(&"Segunda"));
        // E ele aparece do lado masculino nas duas.
        assert!(c.unioes.iter().all(|u| u.masculino.nome == "Homem"));
    }

    // ---------- Ordem dos filhos ----------

    #[tokio::test]
    async fn filhos_recebem_ordem_sequencial() {
        let pool = pool_de_teste().await;
        let mae = pessoa(&pool, "Mãe", "F").await;
        let uniao = criar_uniao(&pool, None, Some(&mae), "nao_informado").await.unwrap();

        for nome in ["Primeiro", "Segundo", "Terceiro"] {
            let f = pessoa(&pool, nome, "M").await;
            anexar_filho(&pool, &uniao, &f, "biologico").await.unwrap();
        }

        let ordens: Vec<i64> =
            sqlx::query_scalar("SELECT ordem FROM uniao_filhos WHERE uniao_id = ? ORDER BY ordem")
                .bind(&uniao)
                .fetch_all(&pool)
                .await
                .unwrap();

        assert_eq!(ordens, vec![1, 2, 3]);
    }
}
