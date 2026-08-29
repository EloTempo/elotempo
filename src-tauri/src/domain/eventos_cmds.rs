//! Eventos de vida (seção 2.3).
//!
//! Toda gravação passa por `datas::interpretar`, que preenche
//! `data_qualificador`, `ano_inicio` e `ano_fim` a partir do texto livre. O
//! texto original é preservado intacto em `data_texto` — ele é o que aparece
//! na tela; os anos existem só para ordenar e plotar.

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::State;
use uuid::Uuid;

use crate::domain::datas;
use crate::domain::erros::{ErroDominio, Resultado};

/// Tipos canônicos de evento.
///
/// Antes existia só a string solta, e o backend procurava `'Nascimento'` com
/// maiúscula enquanto nada garantia que era isso que a UI gravava — um evento
/// escrito com outra caixa simplesmente não aparecia no card da árvore.
/// Estas constantes são a única forma permitida de nomear um tipo.
pub mod tipos {
    pub const NASCIMENTO: &str = "nascimento";
    pub const BATISMO: &str = "batismo";
    pub const CASAMENTO: &str = "casamento";
    pub const FALECIMENTO: &str = "falecimento";
    pub const SEPULTAMENTO: &str = "sepultamento";

    /// A lista é extensível (seção 2.3): tipos fora daqui são aceitos, desde
    /// que em minúsculas, para não travar quem registra um evento incomum.
    pub const CONHECIDOS: [&str; 5] =
        [NASCIMENTO, BATISMO, CASAMENTO, FALECIMENTO, SEPULTAMENTO];
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Evento {
    pub id: String,
    pub pessoa_id: Option<String>,
    pub uniao_id: Option<String>,
    pub tipo_evento: String,
    pub data_texto: Option<String>,
    pub data_qualificador: String,
    pub ano_inicio: Option<i64>,
    pub ano_fim: Option<i64>,
    pub local_id: Option<String>,
    pub rotulo_historico_livre: Option<String>,
    pub denominacao_religiosa: Option<String>,
    pub instituicao: Option<String>,
    pub nota: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct NovoEvento {
    pub pessoa_id: Option<String>,
    pub uniao_id: Option<String>,
    pub tipo_evento: String,
    pub data_texto: Option<String>,
    pub local_id: Option<String>,
    pub rotulo_historico_livre: Option<String>,
    pub denominacao_religiosa: Option<String>,
    pub instituicao: Option<String>,
    pub nota: Option<String>,
}

/// Normaliza o tipo para minúsculas sem espaço nas pontas.
fn normalizar_tipo(tipo: &str) -> Resultado<String> {
    let t = tipo.trim().to_lowercase();
    if t.is_empty() {
        return Err(ErroDominio::ValorInvalido {
            campo: "tipo_evento".into(),
            valor: tipo.into(),
        });
    }
    Ok(t)
}

#[tauri::command]
pub async fn criar_evento(novo: NovoEvento, db: State<'_, SqlitePool>) -> Resultado<String> {
    if novo.pessoa_id.is_none() && novo.uniao_id.is_none() {
        return Err(ErroDominio::ValorInvalido {
            campo: "evento".into(),
            valor: "um evento precisa pertencer a uma pessoa ou a uma união".into(),
        });
    }

    let tipo = normalizar_tipo(&novo.tipo_evento)?;
    let data = datas::interpretar(novo.data_texto.as_deref().unwrap_or(""));
    let id = Uuid::new_v4().to_string();

    sqlx::query(
        "INSERT INTO eventos
           (id, pessoa_id, uniao_id, tipo_evento, data_texto, data_qualificador,
            ano_inicio, ano_fim, local_id, rotulo_historico_livre,
            denominacao_religiosa, instituicao, nota)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    )
    .bind(&id)
    .bind(&novo.pessoa_id)
    .bind(&novo.uniao_id)
    .bind(&tipo)
    .bind(&novo.data_texto)
    .bind(data.qualificador.como_str())
    .bind(data.ano_inicio)
    .bind(data.ano_fim)
    .bind(&novo.local_id)
    .bind(&novo.rotulo_historico_livre)
    .bind(&novo.denominacao_religiosa)
    .bind(&novo.instituicao)
    .bind(&novo.nota)
    .execute(&*db)
    .await?;

    Ok(id)
}

#[tauri::command]
pub async fn atualizar_evento(evento: Evento, db: State<'_, SqlitePool>) -> Resultado<()> {
    let tipo = normalizar_tipo(&evento.tipo_evento)?;
    // Reinterpreta: o texto pode ter mudado, e os anos precisam acompanhar.
    let data = datas::interpretar(evento.data_texto.as_deref().unwrap_or(""));

    let afetadas = sqlx::query(
        "UPDATE eventos SET
            tipo_evento = ?, data_texto = ?, data_qualificador = ?,
            ano_inicio = ?, ano_fim = ?, local_id = ?, rotulo_historico_livre = ?,
            denominacao_religiosa = ?, instituicao = ?, nota = ?
         WHERE id = ?",
    )
    .bind(&tipo)
    .bind(&evento.data_texto)
    .bind(data.qualificador.como_str())
    .bind(data.ano_inicio)
    .bind(data.ano_fim)
    .bind(&evento.local_id)
    .bind(&evento.rotulo_historico_livre)
    .bind(&evento.denominacao_religiosa)
    .bind(&evento.instituicao)
    .bind(&evento.nota)
    .bind(&evento.id)
    .execute(&*db)
    .await?
    .rows_affected();

    if afetadas == 0 {
        return Err(ErroDominio::ValorInvalido {
            campo: "evento.id".into(),
            valor: evento.id,
        });
    }
    Ok(())
}

#[tauri::command]
pub async fn remover_evento(id: String, db: State<'_, SqlitePool>) -> Resultado<()> {
    sqlx::query("DELETE FROM eventos WHERE id = ?")
        .bind(&id)
        .execute(&*db)
        .await?;
    Ok(())
}

/// Eventos de uma pessoa, já em ordem cronológica.
///
/// Quem não tem ano vai para o fim (`NULLS LAST` emulado), nunca some — a
/// mesma regra do relatório na seção 6.
#[tauri::command]
pub async fn listar_eventos_pessoa(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<Vec<Evento>> {
    let rows = sqlx::query(
        "SELECT id, pessoa_id, uniao_id, tipo_evento, data_texto, data_qualificador,
                ano_inicio, ano_fim, local_id, rotulo_historico_livre,
                denominacao_religiosa, instituicao, nota
         FROM eventos
         WHERE pessoa_id = ?
         ORDER BY (ano_inicio IS NULL), ano_inicio, tipo_evento",
    )
    .bind(&pessoa_id)
    .fetch_all(&*db)
    .await?;

    rows.into_iter().map(linha_para_evento).collect()
}

fn linha_para_evento(row: sqlx::sqlite::SqliteRow) -> Resultado<Evento> {
    Ok(Evento {
        id: row.try_get("id")?,
        pessoa_id: row.try_get("pessoa_id")?,
        uniao_id: row.try_get("uniao_id")?,
        tipo_evento: row.try_get("tipo_evento")?,
        data_texto: row.try_get("data_texto")?,
        data_qualificador: row.try_get("data_qualificador")?,
        ano_inicio: row.try_get("ano_inicio")?,
        ano_fim: row.try_get("ano_fim")?,
        local_id: row.try_get("local_id")?,
        rotulo_historico_livre: row.try_get("rotulo_historico_livre")?,
        denominacao_religiosa: row.try_get("denominacao_religiosa")?,
        instituicao: row.try_get("instituicao")?,
        nota: row.try_get("nota")?,
    })
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
        pool
    }

    #[test]
    fn tipo_e_normalizado_para_minusculas() {
        assert_eq!(normalizar_tipo("Nascimento").unwrap(), "nascimento");
        assert_eq!(normalizar_tipo("  FALECIMENTO ").unwrap(), "falecimento");
        assert!(normalizar_tipo("   ").is_err());
    }

    #[tokio::test]
    async fn gravar_evento_preenche_os_anos_derivados() {
        let pool = pool_de_teste().await;
        sqlx::query("INSERT INTO pessoas (id,nome,sexo,is_vivo,is_placeholder) VALUES ('p1','Ana','F',0,0)")
            .execute(&pool)
            .await
            .unwrap();

        let data = datas::interpretar("cerca de 1890");
        sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,ano_inicio,ano_fim)
             VALUES ('e1','p1',?,?,?,?,?)",
        )
        .bind(tipos::NASCIMENTO)
        .bind("cerca de 1890")
        .bind(data.qualificador.como_str())
        .bind(data.ano_inicio)
        .bind(data.ano_fim)
        .execute(&pool)
        .await
        .unwrap();

        let row = sqlx::query("SELECT data_texto, data_qualificador, ano_inicio, ano_fim FROM eventos WHERE id='e1'")
            .fetch_one(&pool)
            .await
            .unwrap();

        // O texto do usuário sobrevive intacto...
        let texto: String = row.try_get("data_texto").unwrap();
        assert_eq!(texto, "cerca de 1890");
        // ...e os anos derivados existem ao lado dele.
        assert_eq!(row.try_get::<String, _>("data_qualificador").unwrap(), "cerca_de");
        assert_eq!(row.try_get::<i64, _>("ano_inicio").unwrap(), 1885);
        assert_eq!(row.try_get::<i64, _>("ano_fim").unwrap(), 1895);
    }

    #[tokio::test]
    async fn evento_sem_data_e_aceito() {
        // Regra transversal da seção 2.5.
        let pool = pool_de_teste().await;
        sqlx::query("INSERT INTO pessoas (id,nome,sexo,is_vivo,is_placeholder) VALUES ('p1','Ana','F',0,0)")
            .execute(&pool)
            .await
            .unwrap();

        let data = datas::interpretar("");
        let r = sqlx::query(
            "INSERT INTO eventos (id,pessoa_id,tipo_evento,data_texto,data_qualificador,ano_inicio,ano_fim)
             VALUES ('e1','p1',?,NULL,?,?,?)",
        )
        .bind(tipos::FALECIMENTO)
        .bind(data.qualificador.como_str())
        .bind(data.ano_inicio)
        .bind(data.ano_fim)
        .execute(&pool)
        .await;

        assert!(r.is_ok(), "evento sem data deveria ser aceito: {r:?}");
    }
}
