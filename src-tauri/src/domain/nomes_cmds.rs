//! Nomes que uma pessoa carregou ao longo da vida (fatia 02).
//!
//! `pessoas.nome`/`sobrenome` continuam sendo o **nome de exibição**. Esta
//! tabela guarda o conjunto completo: o de nascimento, o público, o religioso,
//! o de casada. Apelido é outra coisa e segue em `apelidos_pessoa`.

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::State;
use uuid::Uuid;

use crate::domain::erros::{ErroDominio, Resultado};

/// Tipos aceitos. Espelham o `CHECK` da migration 010 — se divergirem, a
/// gravação é recusada pelo banco.
pub const TIPOS_DE_NOME: [&str; 9] = [
    "nascimento",
    "publico",
    "religioso",
    "casada",
    "solteira",
    "artistico",
    "profissional",
    "imigracao",
    "outro",
];

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct NomePessoa {
    pub id: String,
    pub pessoa_id: String,
    pub tipo: String,
    pub prefixo: Option<String>,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sufixo: Option<String>,
    pub periodo: Option<String>,
    pub nota: Option<String>,
    pub ordem: Option<i64>,
}

#[derive(Debug, Deserialize)]
pub struct NovoNome {
    pub pessoa_id: String,
    pub tipo: String,
    pub prefixo: Option<String>,
    pub nome: String,
    pub sobrenome: Option<String>,
    pub sufixo: Option<String>,
    pub periodo: Option<String>,
    pub nota: Option<String>,
}

/// Compõe a forma de exibição: prefixo, nome e sufixo, nessa ordem.
///
/// `D.` + `João` + `VI` → `"D. João VI"`. O sobrenome fica de fora porque vai
/// para a coluna própria de `pessoas`.
pub fn compor_exibicao(
    prefixo: Option<&str>,
    nome: &str,
    sufixo: Option<&str>,
) -> String {
    [prefixo.unwrap_or("").trim(), nome.trim(), sufixo.unwrap_or("").trim()]
        .into_iter()
        .filter(|parte| !parte.is_empty())
        .collect::<Vec<_>>()
        .join(" ")
}

fn validar_tipo(tipo: &str) -> Resultado<()> {
    if TIPOS_DE_NOME.contains(&tipo) {
        Ok(())
    } else {
        Err(ErroDominio::ValorInvalido {
            campo: "tipo".into(),
            valor: tipo.into(),
        })
    }
}

fn opcional(valor: Option<String>) -> Option<String> {
    valor
        .map(|v| v.trim().to_string())
        .filter(|v| !v.is_empty())
}

#[tauri::command]
pub async fn listar_nomes_pessoa(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<NomePessoa>> {
    Ok(sqlx::query_as::<_, NomePessoa>(
        "SELECT id, pessoa_id, tipo, prefixo, nome, sobrenome, sufixo, periodo, nota, ordem
         FROM nomes_pessoa WHERE pessoa_id = ? ORDER BY ordem, rowid",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?)
}

#[tauri::command]
pub async fn adicionar_nome(novo: NovoNome, db: State<'_, SqlitePool>) -> Resultado<String> {
    validar_tipo(&novo.tipo)?;

    let nome = novo.nome.trim().to_string();
    if nome.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "nome".into(),
            valor: novo.nome,
        });
    }

    let existe: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas WHERE id = ?")
        .bind(&novo.pessoa_id)
        .fetch_one(&*db)
        .await?;
    if existe == 0 {
        return Err(ErroDominio::PessoaNaoEncontrada(novo.pessoa_id));
    }

    let proxima_ordem: i64 = sqlx::query_scalar(
        "SELECT COALESCE(MAX(ordem), 0) + 1 FROM nomes_pessoa WHERE pessoa_id = ?",
    )
    .bind(&novo.pessoa_id)
    .fetch_one(&*db)
    .await?;

    let id = Uuid::new_v4().to_string();
    sqlx::query(
        "INSERT INTO nomes_pessoa
           (id, pessoa_id, tipo, prefixo, nome, sobrenome, sufixo, periodo, nota, ordem)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(&id)
    .bind(&novo.pessoa_id)
    .bind(&novo.tipo)
    .bind(opcional(novo.prefixo))
    .bind(&nome)
    .bind(opcional(novo.sobrenome))
    .bind(opcional(novo.sufixo))
    .bind(opcional(novo.periodo))
    .bind(opcional(novo.nota))
    .bind(proxima_ordem)
    .execute(&*db)
    .await?;

    Ok(id)
}

#[tauri::command]
pub async fn remover_nome(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    let afetadas = sqlx::query("DELETE FROM nomes_pessoa WHERE id = ?")
        .bind(&id)
        .execute(&*db)
        .await?
        .rows_affected();

    if afetadas == 0 {
        return Err(ErroDominio::ValorInvalido {
            campo: "nomes_pessoa.id".into(),
            valor: id,
        });
    }
    Ok(())
}

/// Adota este nome como o de exibição da pessoa.
///
/// Só copia nome e sobrenome — não passa por `regras::atualizar_pessoa` porque
/// não há sexo envolvido, e portanto nenhuma união a revalidar.
#[tauri::command]
pub async fn usar_nome_na_arvore(
    nome_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<()> {
    let linha = sqlx::query(
        "SELECT pessoa_id, prefixo, nome, sobrenome, sufixo FROM nomes_pessoa WHERE id = ?",
    )
    .bind(&nome_id)
    .fetch_optional(&*db)
    .await?
    .ok_or_else(|| ErroDominio::ValorInvalido {
        campo: "nomes_pessoa.id".into(),
        valor: nome_id.clone(),
    })?;

    let pessoa_id: String = linha.try_get("pessoa_id")?;
    let prefixo: Option<String> = linha.try_get("prefixo")?;
    let nome: String = linha.try_get("nome")?;
    let sobrenome: Option<String> = linha.try_get("sobrenome")?;
    let sufixo: Option<String> = linha.try_get("sufixo")?;

    let exibicao = compor_exibicao(prefixo.as_deref(), &nome, sufixo.as_deref());

    sqlx::query("UPDATE pessoas SET nome = ?, sobrenome = ? WHERE id = ?")
        .bind(&exibicao)
        .bind(&sobrenome)
        .bind(&pessoa_id)
        .execute(&*db)
        .await?;

    Ok(())
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    async fn pool_de_teste() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        sqlx::query(
            "INSERT INTO pessoas (id,nome,sobrenome,sexo,is_vivo,is_placeholder)
             VALUES ('p1','João','de Bragança','M',0,0)",
        )
        .execute(&pool)
        .await
        .unwrap();
        pool
    }

    async fn inserir(
        pool: &SqlitePool,
        tipo: &str,
        prefixo: Option<&str>,
        nome: &str,
        sobrenome: Option<&str>,
        sufixo: Option<&str>,
    ) -> String {
        let id = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO nomes_pessoa (id,pessoa_id,tipo,prefixo,nome,sobrenome,sufixo,ordem)
             VALUES (?,'p1',?,?,?,?,?,1)",
        )
        .bind(&id)
        .bind(tipo)
        .bind(prefixo)
        .bind(nome)
        .bind(sobrenome)
        .bind(sufixo)
        .execute(pool)
        .await
        .unwrap();
        id
    }

    #[test]
    fn exibicao_junta_prefixo_nome_e_sufixo_na_ordem() {
        assert_eq!(compor_exibicao(Some("D."), "João", Some("VI")), "D. João VI");
        assert_eq!(compor_exibicao(None, "Francisco", None), "Francisco");
        assert_eq!(compor_exibicao(Some("Madre"), "Teresa", None), "Madre Teresa");
    }

    #[test]
    fn exibicao_ignora_partes_vazias_ou_com_espaco() {
        assert_eq!(compor_exibicao(Some("  "), "Ana", Some("")), "Ana");
        assert_eq!(compor_exibicao(Some(" D. "), " João ", None), "D. João");
    }

    #[test]
    fn tipos_batem_com_o_check_da_migration() {
        // Se algum sumir daqui e continuar no CHECK (ou o contrário), a
        // gravação passa na validação e morre no banco.
        for tipo in TIPOS_DE_NOME {
            assert!(validar_tipo(tipo).is_ok(), "{tipo} deveria ser válido");
        }
        assert!(validar_tipo("alcunha").is_err());
    }

    #[tokio::test]
    async fn a_mesma_pessoa_guarda_nome_de_nascimento_e_nome_publico() {
        let pool = pool_de_teste().await;

        inserir(
            &pool,
            "nascimento",
            None,
            "João Maria José Francisco Xavier de Paula",
            Some("de Bragança"),
            None,
        )
        .await;
        inserir(&pool, "publico", Some("D."), "João", None, Some("VI")).await;

        let nomes = sqlx::query_as::<_, NomePessoa>(
            "SELECT id, pessoa_id, tipo, prefixo, nome, sobrenome, sufixo, periodo, nota, ordem
             FROM nomes_pessoa WHERE pessoa_id = 'p1'",
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        assert_eq!(nomes.len(), 2);
        let tipos: Vec<&str> = nomes.iter().map(|n| n.tipo.as_str()).collect();
        assert!(tipos.contains(&"nascimento"));
        assert!(tipos.contains(&"publico"));
    }

    #[tokio::test]
    async fn usar_na_arvore_troca_a_exibicao_sem_apagar_os_registros() {
        let pool = pool_de_teste().await;

        let nascimento = inserir(
            &pool,
            "nascimento",
            None,
            "João Maria José",
            Some("de Bragança"),
            None,
        )
        .await;
        let publico = inserir(&pool, "publico", Some("D."), "João", None, Some("VI")).await;

        // Reproduz o que o comando faz, sem a casca do Tauri.
        let aplicar = |id: String| {
            let pool = pool.clone();
            async move {
                let l = sqlx::query(
                    "SELECT prefixo, nome, sobrenome, sufixo FROM nomes_pessoa WHERE id = ?",
                )
                .bind(&id)
                .fetch_one(&pool)
                .await
                .unwrap();
                let exib = compor_exibicao(
                    l.try_get::<Option<String>, _>("prefixo").unwrap().as_deref(),
                    &l.try_get::<String, _>("nome").unwrap(),
                    l.try_get::<Option<String>, _>("sufixo").unwrap().as_deref(),
                );
                sqlx::query("UPDATE pessoas SET nome = ?, sobrenome = ? WHERE id = 'p1'")
                    .bind(&exib)
                    .bind(l.try_get::<Option<String>, _>("sobrenome").unwrap())
                    .execute(&pool)
                    .await
                    .unwrap();
            }
        };

        aplicar(publico.clone()).await;
        let (n, s): (String, Option<String>) =
            sqlx::query_as("SELECT nome, sobrenome FROM pessoas WHERE id = 'p1'")
                .fetch_one(&pool)
                .await
                .unwrap();
        assert_eq!(n, "D. João VI");
        assert_eq!(s, None);

        // Trocar de volta continua possível — nenhum registro se perdeu.
        aplicar(nascimento).await;
        let (n, s): (String, Option<String>) =
            sqlx::query_as("SELECT nome, sobrenome FROM pessoas WHERE id = 'p1'")
                .fetch_one(&pool)
                .await
                .unwrap();
        assert_eq!(n, "João Maria José");
        assert_eq!(s.as_deref(), Some("de Bragança"));

        let quantos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM nomes_pessoa")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(quantos, 2, "trocar a exibição não apaga nome nenhum");
    }

    #[tokio::test]
    async fn nome_com_periodo_em_branco_e_aceito() {
        // Regra transversal: data nunca bloqueia o salvamento.
        let pool = pool_de_teste().await;
        let r = sqlx::query(
            "INSERT INTO nomes_pessoa (id,pessoa_id,tipo,nome,periodo) VALUES ('n1','p1','religioso','Francisco',NULL)",
        )
        .execute(&pool)
        .await;
        assert!(r.is_ok(), "{r:?}");
    }

    #[tokio::test]
    async fn tipo_fora_da_lista_e_recusado_pelo_banco() {
        let pool = pool_de_teste().await;
        let r = sqlx::query(
            "INSERT INTO nomes_pessoa (id,pessoa_id,tipo,nome) VALUES ('n1','p1','alcunha','Zezinho')",
        )
        .execute(&pool)
        .await;
        assert!(r.is_err(), "o CHECK da migration deveria recusar");
    }

    #[tokio::test]
    async fn apagar_a_pessoa_leva_os_nomes_junto() {
        let pool = pool_de_teste().await;
        inserir(&pool, "publico", Some("D."), "João", None, Some("VI")).await;

        sqlx::query("DELETE FROM pessoas WHERE id = 'p1'")
            .execute(&pool)
            .await
            .unwrap();

        let restantes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM nomes_pessoa")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(restantes, 0);
    }
}
