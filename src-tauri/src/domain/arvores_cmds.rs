//! Múltiplas árvores nomeadas e conexões entre elas (Fatia 12, Seção 5 da Especificação).
//!
//! Uma árvore é uma visão nomeada e enraizada do grafo familiar comum.
//! Apagar uma árvore nunca apaga pessoas ou uniões do acervo.

use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool};
use tauri::State;

use crate::domain::erros::{ErroDominio, Resultado};
use crate::domain::models::default_tipo_tempo;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow, PartialEq)]
pub struct ArvoreInfo {
    pub id: String,
    pub nome: String,
    pub descricao: Option<String>,
    pub raiz_pessoa_id: Option<String>,
    pub raiz_pessoa_nome: Option<String>,
    pub total_membros: i64,
    pub data_criacao: Option<String>,
    pub data_modificacao: Option<String>,
    #[serde(default)]
    pub is_publico: bool,
    pub categoria: Option<String>,
    pub pais: Option<String>,
    pub periodo: Option<String>,
    #[serde(default = "default_tipo_tempo")]
    pub tipo_tempo: String,
}

#[derive(Debug, Deserialize, Default)]
pub struct NovaArvoreInput {
    pub nome: String,
    pub descricao: Option<String>,
    pub raiz_pessoa_id: Option<String>,
    #[serde(default)]
    pub categoria: Option<String>,
    #[serde(default)]
    pub pais: Option<String>,
    #[serde(default)]
    pub periodo: Option<String>,
    #[serde(default)]
    pub tipo_tempo: Option<String>,
}

#[derive(Debug, Deserialize, Default)]
pub struct AtualizarArvoreInput {
    pub id: String,
    pub nome: String,
    pub descricao: Option<String>,
    pub raiz_pessoa_id: Option<String>,
    #[serde(default)]
    pub categoria: Option<String>,
    #[serde(default)]
    pub pais: Option<String>,
    #[serde(default)]
    pub periodo: Option<String>,
    #[serde(default)]
    pub tipo_tempo: Option<String>,
}

/// Sincroniza todos os membros conectados pelo grafo familiar na árvore.
/// Garante isolamento estrito: pessoas de outras famílias ou avulsas não são
/// incorporadas à árvore, apenas membros conectados por parentesco ou explicitamente atribuídos.
pub async fn sincronizar_membros_arvore(
    pool: &SqlitePool,
    arvore_id: &str,
    raiz_pessoa_id: Option<&str>,
) -> Resultado<()> {
    let arvore_eh_publica: bool = sqlx::query_scalar(
        "SELECT COALESCE(is_publico, 0) != 0 FROM arvores WHERE id = ?",
    )
    .bind(arvore_id)
    .fetch_optional(pool)
    .await?
    .unwrap_or(false);

    if let Some(rid) = raiz_pessoa_id {
        if !arvore_eh_publica {
            // 1. Insere a própria raiz (em árvore pessoal)
            sqlx::query(
                "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
                 VALUES (lower(hex(randomblob(16))), ?, ?, NULL)",
            )
            .bind(arvore_id)
            .bind(rid)
            .execute(pool)
            .await?;
        } else {
            sqlx::query(
                "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
                 SELECT lower(hex(randomblob(16))), ?1, p.id, NULL
                 FROM pessoas p WHERE p.id = ?2 AND p.is_publico = 1",
            )
            .bind(arvore_id)
            .bind(rid)
            .execute(pool)
            .await?;
        }
    }

    // 2. Insere todos os membros conectados recursivamente no grafo familiar
    // a partir dos membros já presentes nesta árvore (ou da raiz).
    // Se a árvore for pública (`is_publico = 1`), jamais incorpora pessoas pessoais (`is_publico = 0`).
    let sql_conexos = if arvore_eh_publica {
        r#"
        INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
        WITH RECURSIVE conexos(id) AS (
            SELECT am.pessoa_id FROM arvore_membros am
            JOIN pessoas p ON p.id = am.pessoa_id
            WHERE am.arvore_id = ?1 AND am.pessoa_id IS NOT NULL AND p.is_publico = 1
            UNION
            -- Pais públicos
            SELECT u.slot_masculino_id FROM conexos c
            JOIN uniao_filhos uf ON uf.pessoa_id = c.id
            JOIN unioes u ON u.id = uf.uniao_id
            JOIN pessoas p ON p.id = u.slot_masculino_id
            WHERE u.slot_masculino_id IS NOT NULL AND p.is_publico = 1
            UNION
            SELECT u.slot_feminino_id FROM conexos c
            JOIN uniao_filhos uf ON uf.pessoa_id = c.id
            JOIN unioes u ON u.id = uf.uniao_id
            JOIN pessoas p ON p.id = u.slot_feminino_id
            WHERE u.slot_feminino_id IS NOT NULL AND p.is_publico = 1
            UNION
            -- Filhos públicos
            SELECT uf.pessoa_id FROM conexos c
            JOIN unioes u ON u.slot_masculino_id = c.id OR u.slot_feminino_id = c.id
            JOIN uniao_filhos uf ON uf.uniao_id = u.id
            JOIN pessoas p ON p.id = uf.pessoa_id
            WHERE p.is_publico = 1
            UNION
            -- Cônjuges públicos
            SELECT u.slot_masculino_id FROM conexos c
            JOIN unioes u ON u.slot_feminino_id = c.id
            JOIN pessoas p ON p.id = u.slot_masculino_id
            WHERE u.slot_masculino_id IS NOT NULL AND p.is_publico = 1
            UNION
            SELECT u.slot_feminino_id FROM conexos c
            JOIN unioes u ON u.slot_masculino_id = c.id
            JOIN pessoas p ON p.id = u.slot_feminino_id
            WHERE u.slot_feminino_id IS NOT NULL AND p.is_publico = 1
        )
        SELECT lower(hex(randomblob(16))), ?1, id, NULL FROM conexos WHERE id IS NOT NULL;
        "#
    } else {
        r#"
        INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
        WITH RECURSIVE conexos(id) AS (
            SELECT pessoa_id FROM arvore_membros WHERE arvore_id = ?1 AND pessoa_id IS NOT NULL
            UNION
            -- Pais
            SELECT u.slot_masculino_id FROM conexos c
            JOIN uniao_filhos uf ON uf.pessoa_id = c.id
            JOIN unioes u ON u.id = uf.uniao_id
            WHERE u.slot_masculino_id IS NOT NULL
            UNION
            SELECT u.slot_feminino_id FROM conexos c
            JOIN uniao_filhos uf ON uf.pessoa_id = c.id
            JOIN unioes u ON u.id = uf.uniao_id
            WHERE u.slot_feminino_id IS NOT NULL
            UNION
            -- Filhos
            SELECT uf.pessoa_id FROM conexos c
            JOIN unioes u ON u.slot_masculino_id = c.id OR u.slot_feminino_id = c.id
            JOIN uniao_filhos uf ON uf.uniao_id = u.id
            UNION
            -- Cônjuges
            SELECT u.slot_masculino_id FROM conexos c
            JOIN unioes u ON u.slot_feminino_id = c.id
            WHERE u.slot_masculino_id IS NOT NULL
            UNION
            SELECT u.slot_feminino_id FROM conexos c
            JOIN unioes u ON u.slot_masculino_id = c.id
            WHERE u.slot_feminino_id IS NOT NULL
        )
        SELECT lower(hex(randomblob(16))), ?1, id, NULL FROM conexos WHERE id IS NOT NULL;
        "#
    };
    let _ = sqlx::query(sql_conexos)
        .bind(arvore_id)
        .execute(pool)
        .await;

    // 3. Associa as uniões correspondentes a esses membros à árvore
    let sql_unioes = r#"
        INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
        SELECT DISTINCT lower(hex(randomblob(16))), ?1, NULL, u.id
        FROM unioes u
        JOIN arvore_membros am1 ON am1.arvore_id = ?1 AND (u.slot_masculino_id = am1.pessoa_id OR u.slot_feminino_id = am1.pessoa_id)
        WHERE u.id IS NOT NULL;
    "#;
    let _ = sqlx::query(sql_unioes)
        .bind(arvore_id)
        .execute(pool)
        .await;

    Ok(())
}

/// Garante que haja pelo menos uma árvore pessoal no banco se o acervo contiver dados.
pub async fn garantir_arvore_padrao(pool: &SqlitePool) -> Resultado<()> {
    // 1. Sincroniza membros de todas as árvores pessoais existentes
    let arvores_pessoais: Vec<(String, Option<String>)> = sqlx::query_as(
        "SELECT id, raiz_pessoa_id FROM arvores WHERE is_publico = 0",
    )
    .fetch_all(pool)
    .await?;

    for (arv_id, raiz_opt) in &arvores_pessoais {
        let _ = sincronizar_membros_arvore(pool, arv_id, raiz_opt.as_deref()).await;
    }

    // 2. Se não houver árvores pessoais, verifica se há pessoas pessoais cadastradas
    if arvores_pessoais.is_empty() {
        let primeira: Option<(String, String, Option<String>)> = sqlx::query_as(
            "SELECT id, nome, sobrenome FROM pessoas WHERE is_placeholder = 0 AND is_publico = 0 ORDER BY data_criacao ASC LIMIT 1",
        )
        .fetch_optional(pool)
        .await?;

        if let Some((pid, nome, sobrenome)) = primeira {
            let arvore_id = uuid::Uuid::new_v4().to_string();
            let nome_arvore = match sobrenome {
                Some(ref s) if !s.trim().is_empty() => format!("Família {}", s.trim()),
                _ => format!("Árvore de {}", nome.trim()),
            };

            sqlx::query(
                "INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico)
                 VALUES (?, ?, 'Árvore genealógica pessoal', ?, 0)",
            )
            .bind(&arvore_id)
            .bind(&nome_arvore)
            .bind(&pid)
            .execute(pool)
            .await?;

            let _ = sincronizar_membros_arvore(pool, &arvore_id, Some(&pid)).await;
        }
    }

    // 3. Fallback genérico caso nem árvores públicas nem pessoas existam (acervo 100% novo)
    let contagem_total: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM arvores")
        .fetch_one(pool)
        .await?;

    if contagem_total.0 == 0 {
        let arvore_id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO arvores (id, nome, descricao, is_publico)
             VALUES (?, 'Árvore Principal', 'Árvore genealógica principal do acervo', 0)",
        )
        .bind(&arvore_id)
        .execute(pool)
        .await?;
    }

    Ok(())
}

#[tauri::command]
pub async fn listar_arvores(db: State<'_, SqlitePool>) -> Resultado<Vec<ArvoreInfo>> {
    listar(&db).await
}

pub async fn listar(pool: &SqlitePool) -> Resultado<Vec<ArvoreInfo>> {
    garantir_arvore_padrao(pool).await?;

    let sql = r#"
        SELECT
            a.id,
            a.nome,
            a.descricao,
            a.raiz_pessoa_id,
            CASE
                WHEN p.id IS NOT NULL THEN p.nome || ' ' || COALESCE(p.sobrenome, '')
                ELSE NULL
            END AS raiz_pessoa_nome,
            (SELECT COUNT(DISTINCT am.pessoa_id) FROM arvore_membros am WHERE am.arvore_id = a.id) AS total_membros,
            strftime('%Y-%m-%d %H:%M:%S', a.data_criacao) AS data_criacao,
            strftime('%Y-%m-%d %H:%M:%S', a.data_modificacao) AS data_modificacao,
            a.is_publico,
            a.categoria,
            a.pais,
            a.periodo,
            a.tipo_tempo
        FROM arvores a
        LEFT JOIN pessoas p ON p.id = a.raiz_pessoa_id
        ORDER BY a.is_publico ASC, a.data_criacao ASC
    "#;

    let arvores = sqlx::query_as::<sqlx::Sqlite, ArvoreInfo>(sql)
        .fetch_all(pool)
        .await?;

    Ok(arvores)
}

#[tauri::command]
pub async fn obter_arvore(id: String, db: State<'_, SqlitePool>) -> Resultado<ArvoreInfo> {
    obter(&db, &id).await
}

pub async fn obter(pool: &SqlitePool, id: &str) -> Resultado<ArvoreInfo> {
    let sql = r#"
        SELECT
            a.id,
            a.nome,
            a.descricao,
            a.raiz_pessoa_id,
            CASE
                WHEN p.id IS NOT NULL THEN p.nome || ' ' || COALESCE(p.sobrenome, '')
                ELSE NULL
            END AS raiz_pessoa_nome,
            (SELECT COUNT(DISTINCT am.pessoa_id) FROM arvore_membros am WHERE am.arvore_id = a.id) AS total_membros,
            strftime('%Y-%m-%d %H:%M:%S', a.data_criacao) AS data_criacao,
            strftime('%Y-%m-%d %H:%M:%S', a.data_modificacao) AS data_modificacao,
            a.is_publico,
            a.categoria,
            a.pais,
            a.periodo,
            a.tipo_tempo
        FROM arvores a
        LEFT JOIN pessoas p ON p.id = a.raiz_pessoa_id
        WHERE a.id = ?
    "#;

    let arvore = sqlx::query_as::<sqlx::Sqlite, ArvoreInfo>(sql)
        .bind(id)
        .fetch_optional(pool)
        .await?
        .ok_or_else(|| ErroDominio::ArvoreNaoEncontrada(id.to_string()))?;

    Ok(arvore)
}

#[tauri::command]
pub async fn criar_arvore(
    dados: NovaArvoreInput,
    db: State<'_, SqlitePool>,
) -> Resultado<ArvoreInfo> {
    criar(&db, dados).await
}

pub async fn criar(pool: &SqlitePool, dados: NovaArvoreInput) -> Resultado<ArvoreInfo> {
    let nome = dados.nome.trim();
    if nome.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "nome".into(),
            valor: "O nome da árvore não pode ser vazio.".into(),
        });
    }

    let id = uuid::Uuid::new_v4().to_string();

    // Se informou raiz, confere se a pessoa existe
    if let Some(ref rid) = dados.raiz_pessoa_id {
        let existe: Option<(String,)> =
            sqlx::query_as("SELECT id FROM pessoas WHERE id = ?")
                .bind(rid)
                .fetch_optional(pool)
                .await?;
        if existe.is_none() {
            return Err(ErroDominio::PessoaNaoEncontrada(rid.clone()));
        }
    }

    let tipo_tempo = dados.tipo_tempo.as_deref().unwrap_or("real");

    sqlx::query(
        "INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, categoria, pais, periodo, tipo_tempo, is_publico)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)",
    )
    .bind(&id)
    .bind(nome)
    .bind(&dados.descricao)
    .bind(&dados.raiz_pessoa_id)
    .bind(&dados.categoria)
    .bind(&dados.pais)
    .bind(&dados.periodo)
    .bind(tipo_tempo)
    .execute(pool)
    .await?;

    sincronizar_membros_arvore(pool, &id, dados.raiz_pessoa_id.as_deref()).await?;

    obter(pool, &id).await
}

#[tauri::command]
pub async fn atualizar_arvore(
    dados: AtualizarArvoreInput,
    db: State<'_, SqlitePool>,
) -> Resultado<ArvoreInfo> {
    atualizar(&db, dados).await
}

pub async fn atualizar(pool: &SqlitePool, dados: AtualizarArvoreInput) -> Resultado<ArvoreInfo> {
    let nome = dados.nome.trim();
    if nome.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "nome".into(),
            valor: "O nome da árvore não pode ser vazio.".into(),
        });
    }

    // Confere se a árvore existe
    let atual = obter(pool, &dados.id).await?;
    let tipo_tempo = dados.tipo_tempo.as_deref().unwrap_or(&atual.tipo_tempo);

    // Se alterou raiz, confere se a nova raiz existe
    if let Some(ref rid) = dados.raiz_pessoa_id {
        let existe: Option<(String,)> =
            sqlx::query_as("SELECT id FROM pessoas WHERE id = ?")
                .bind(rid)
                .fetch_optional(pool)
                .await?;
        if existe.is_none() {
            return Err(ErroDominio::PessoaNaoEncontrada(rid.clone()));
        }
    }

    sqlx::query(
        "UPDATE arvores
         SET nome = ?, descricao = ?, raiz_pessoa_id = ?, categoria = ?, pais = ?, periodo = ?, tipo_tempo = ?, data_modificacao = CURRENT_TIMESTAMP
         WHERE id = ?",
    )
    .bind(nome)
    .bind(&dados.descricao)
    .bind(&dados.raiz_pessoa_id)
    .bind(&dados.categoria)
    .bind(&dados.pais)
    .bind(&dados.periodo)
    .bind(tipo_tempo)
    .bind(&dados.id)
    .execute(pool)
    .await?;

    sincronizar_membros_arvore(pool, &dados.id, dados.raiz_pessoa_id.as_deref()).await?;

    obter(pool, &dados.id).await
}

#[tauri::command]
pub async fn deletar_arvore(
    id: String,
    ticket_autorizacao: Option<String>,
    db: State<'_, SqlitePool>,
    seguranca: State<'_, crate::domain::seguranca::EstadoSeguranca>,
) -> Resultado<()> {
    crate::domain::seguranca::autorizar_acao_sensivel(&seguranca, None, ticket_autorizacao.as_deref()).await?;
    deletar(&db, &id).await
}

pub async fn deletar(pool: &SqlitePool, id: &str) -> Resultado<()> {
    // Impede exclusão de árvores públicas de referência
    let arvore = obter(pool, id).await?;
    if arvore.is_publico {
        return Err(ErroDominio::ValorInvalido {
            campo: "arvore".into(),
            valor: "Árvores históricas de referência pública não podem ser excluídas.".into(),
        });
    }

    // Não permite apagar a única árvore do acervo
    let contagem: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM arvores")
        .fetch_one(pool)
        .await?;

    if contagem.0 <= 1 {
        return Err(ErroDominio::ValorInvalido {
            campo: "arvore".into(),
            valor: "Não é possível excluir a única árvore do acervo.".into(),
        });
    }

    let resultado = sqlx::query("DELETE FROM arvores WHERE id = ?")
        .bind(id)
        .execute(pool)
        .await?;

    if resultado.rows_affected() == 0 {
        return Err(ErroDominio::ArvoreNaoEncontrada(id.to_string()));
    }

    Ok(())
}

#[tauri::command]
pub async fn definir_raiz_arvore(
    arvore_id: String,
    raiz_pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<ArvoreInfo> {
    definir_raiz(&db, &arvore_id, &raiz_pessoa_id).await
}

pub async fn definir_raiz(
    pool: &SqlitePool,
    arvore_id: &str,
    raiz_pessoa_id: &str,
) -> Resultado<ArvoreInfo> {
    // Confere se a pessoa existe
    let pessoa_existe: Option<(String,)> =
        sqlx::query_as("SELECT id FROM pessoas WHERE id = ?")
            .bind(raiz_pessoa_id)
            .fetch_optional(pool)
            .await?;
    if pessoa_existe.is_none() {
        return Err(ErroDominio::PessoaNaoEncontrada(raiz_pessoa_id.to_string()));
    }

    // Confere se a árvore existe
    let _ = obter(pool, arvore_id).await?;

    sqlx::query(
        "UPDATE arvores
         SET raiz_pessoa_id = ?, data_modificacao = CURRENT_TIMESTAMP
         WHERE id = ?",
    )
    .bind(raiz_pessoa_id)
    .bind(arvore_id)
    .execute(pool)
    .await?;

    sincronizar_membros_arvore(pool, arvore_id, Some(raiz_pessoa_id)).await?;

    obter(pool, arvore_id).await
}

#[cfg(test)]
mod testes {
    use super::*;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePool::connect("sqlite::memory:").await.unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        pool
    }

    #[tokio::test]
    async fn cria_arvore_padrao_se_nenhuma_existir() {
        let pool = pool_de_teste().await;
        let lista = listar(&pool).await.unwrap();
        assert_eq!(lista.len(), 1);
        assert_eq!(lista[0].nome, "Árvore Principal");
    }

    #[tokio::test]
    async fn cria_e_atualiza_arvore_nomeada() {
        let pool = pool_de_teste().await;

        // Inserir pessoa para ser raiz
        let p_id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'Joaquim', 'Albuquerque', 'M', 1, 0)",
        )
        .bind(&p_id)
        .execute(&pool)
        .await
        .unwrap();

        let nova = criar(
            &pool,
            NovaArvoreInput {
                nome: "Família Albuquerque".into(),
                descricao: Some("Ramo materno".into()),
                raiz_pessoa_id: Some(p_id.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        assert_eq!(nova.nome, "Família Albuquerque");
        assert_eq!(nova.descricao.as_deref(), Some("Ramo materno"));
        assert_eq!(nova.raiz_pessoa_id.as_deref(), Some(p_id.as_str()));
        assert_eq!(nova.raiz_pessoa_nome.as_deref(), Some("Joaquim Albuquerque"));

        // Atualizar
        let editada = atualizar(
            &pool,
            AtualizarArvoreInput {
                id: nova.id.clone(),
                nome: "Família Albuquerque e Silva".into(),
                descricao: Some("Ramo atualizado".into()),
                raiz_pessoa_id: Some(p_id.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        assert_eq!(editada.nome, "Família Albuquerque e Silva");
        assert_eq!(editada.descricao.as_deref(), Some("Ramo atualizado"));
    }

    #[tokio::test]
    async fn recusar_apagar_unica_arvore() {
        let pool = pool_de_teste().await;
        let lista = listar(&pool).await.unwrap();
        assert_eq!(lista.len(), 1);

        let res = deletar(&pool, &lista[0].id).await;
        assert!(res.is_err());
    }

    #[tokio::test]
    async fn apagar_arvore_nao_apaga_as_pessoas() {
        let pool = pool_de_teste().await;

        // Inserir pessoa
        let p_id = uuid::Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder)
             VALUES (?, 'Teresa', 'Cristina', 'F', 0, 0)",
        )
        .bind(&p_id)
        .execute(&pool)
        .await
        .unwrap();

        garantir_arvore_padrao(&pool).await.unwrap();

        // Criar segunda árvore
        let a2 = criar(
            &pool,
            NovaArvoreInput {
                nome: "Árvore Imperial".into(),
                descricao: None,
                raiz_pessoa_id: Some(p_id.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        assert_eq!(listar(&pool).await.unwrap().len(), 2);

        // Deletar a2
        deletar(&pool, &a2.id).await.unwrap();
        assert_eq!(listar(&pool).await.unwrap().len(), 1);

        // A pessoa continua viva e salva no banco de dados!
        let pessoa_continua: Option<(String,)> =
            sqlx::query_as("SELECT nome FROM pessoas WHERE id = ?")
                .bind(&p_id)
                .fetch_optional(&pool)
                .await
                .unwrap();
        assert_eq!(pessoa_continua.unwrap().0, "Teresa");
    }

    #[tokio::test]
    async fn arvore_isolada_nao_herda_pessoas_avulsas_ou_de_outras_familias() {
        let pool = pool_de_teste().await;

        // 1. Cria a pessoa Manuel Ferreira e a árvore "Árvore Genealógica Ferreira"
        let p_manuel = crate::domain::regras::criar_pessoa(
            &pool,
            crate::domain::regras::NovaPessoa {
                nome: "Manuel".into(),
                sobrenome: Some("Ferreira".into()),
                sexo: "M".into(),
                minibiografia: None,
                is_vivo: false,
                foto_url: None,
                tipo_tempo: None,
                arvore_id: None,
            },
        )
        .await
        .unwrap();

        let arv_ferreira = criar(
            &pool,
            NovaArvoreInput {
                nome: "Árvore Genealógica Ferreira".into(),
                descricao: Some("Família Ferreira".into()),
                raiz_pessoa_id: Some(p_manuel.clone()),
                ..Default::default()
            },
        )
        .await
        .unwrap();

        // 2. Cria pessoa "Aguiar Ferreira" como pessoa avulsa (arvore_id: None)
        let p_aguiar = crate::domain::regras::criar_pessoa(
            &pool,
            crate::domain::regras::NovaPessoa {
                nome: "Aguiar".into(),
                sobrenome: Some("Ferreira".into()),
                sexo: "M".into(),
                minibiografia: None,
                is_vivo: true,
                foto_url: None,
                tipo_tempo: None,
                arvore_id: None,
            },
        )
        .await
        .unwrap();

        // 3. Cria pessoa "Rosa Ferreira" explicitamente associada à Árvore Ferreira
        let p_rosa = crate::domain::regras::criar_pessoa(
            &pool,
            crate::domain::regras::NovaPessoa {
                nome: "Rosa".into(),
                sobrenome: Some("Ferreira".into()),
                sexo: "F".into(),
                minibiografia: None,
                is_vivo: false,
                foto_url: None,
                tipo_tempo: None,
                arvore_id: Some(arv_ferreira.id.clone()),
            },
        )
        .await
        .unwrap();

        // Sincroniza a árvore Ferreira
        sincronizar_membros_arvore(&pool, &arv_ferreira.id, Some(&p_manuel)).await.unwrap();

        // 4. Verifica membros da Árvore Ferreira
        let membros: Vec<String> = sqlx::query_scalar(
            "SELECT pessoa_id FROM arvore_membros WHERE arvore_id = ? AND pessoa_id IS NOT NULL",
        )
        .bind(&arv_ferreira.id)
        .fetch_all(&pool)
        .await
        .unwrap();

        assert!(membros.contains(&p_manuel), "Manuel deve estar na Árvore Ferreira");
        assert!(membros.contains(&p_rosa), "Rosa deve estar na Árvore Ferreira");
        assert!(
            !membros.contains(&p_aguiar),
            "Aguiar Ferreira é avulso e NÃO deve estar na Árvore Ferreira mesmo tendo o mesmo sobrenome!"
        );
    }
}
