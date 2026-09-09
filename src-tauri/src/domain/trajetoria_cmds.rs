//! Trajetória geográfica e atlas biográfico de uma pessoa.
//!
//! Recupera os acontecimentos da vida de uma pessoa que possuem georreferenciamento
//! (latitude e longitude válidas), ordenados cronologicamente para exibição no
//! mapa interativo com animação de voo (flyTo), destaque de cidades e linhas de rota.

use serde::{Deserialize, Serialize};
use sqlx::{Row, SqlitePool};
use tauri::State;

use crate::domain::erros::Resultado;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct PontoTrajetoria {
    pub evento_id: String,
    pub tipo_evento: String,
    pub ano: Option<i64>,
    pub data_texto: Option<String>,
    pub local_id: Option<String>,
    pub local_nome: String,
    pub rotulo_historico: Option<String>,
    pub latitude: f64,
    pub longitude: f64,
    pub nota: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TrajetoriaPessoa {
    pub pessoa_id: String,
    pub total_pontos: usize,
    pub pontos: Vec<PontoTrajetoria>,
    pub min_lat: Option<f64>,
    pub max_lat: Option<f64>,
    pub min_lon: Option<f64>,
    pub max_lon: Option<f64>,
}

/// Recupera a trajetória geográfica de vida de uma pessoa com pontos ordenados.
#[tauri::command]
pub async fn obter_trajetoria_pessoa(
    pessoa_id: String,
    db: State<'_, SqlitePool>,
) -> Resultado<TrajetoriaPessoa> {
    obter_trajetoria_pessoa_interno(&pessoa_id, &*db).await
}

pub async fn obter_trajetoria_pessoa_interno(
    pessoa_id: &str,
    pool: &SqlitePool,
) -> Resultado<TrajetoriaPessoa> {
    let rows = sqlx::query(
        "SELECT e.id AS evento_id,
                e.tipo_evento,
                e.ano_inicio AS ano,
                e.data_texto,
                e.local_id,
                CASE
                  WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                  WHEN p.nome IS NOT NULL THEN l.nome || ', ' || p.nome
                  ELSE l.nome
                END AS local_nome,
                e.rotulo_historico_livre AS rotulo_historico,
                l.latitude,
                l.longitude,
                CASE
                  WHEN outro.id IS NOT NULL AND outro.is_placeholder = 0 THEN
                    CASE WHEN e.nota IS NOT NULL AND TRIM(e.nota) != ''
                         THEN 'Casamento com ' || TRIM(outro.nome || ' ' || COALESCE(outro.sobrenome, '')) || ' · ' || e.nota
                         ELSE 'Casamento com ' || TRIM(outro.nome || ' ' || COALESCE(outro.sobrenome, ''))
                    END
                  ELSE e.nota
                END AS nota
         FROM eventos e
         JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises p ON p.id = l.pais_id
         LEFT JOIN unioes u ON u.id = e.uniao_id
         LEFT JOIN pessoas outro
                ON outro.id = CASE WHEN u.slot_masculino_id = ?1 THEN u.slot_feminino_id ELSE u.slot_masculino_id END
         WHERE (e.pessoa_id = ?1 OR u.slot_masculino_id = ?1 OR u.slot_feminino_id = ?1)
           AND l.latitude IS NOT NULL
           AND l.longitude IS NOT NULL
         ORDER BY (e.ano_inicio IS NULL), e.ano_inicio, e.tipo_evento",
    )
    .bind(pessoa_id)
    .fetch_all(pool)
    .await?;

    let mut pontos = Vec::with_capacity(rows.len());
    let mut min_lat: Option<f64> = None;
    let mut max_lat: Option<f64> = None;
    let mut min_lon: Option<f64> = None;
    let mut max_lon: Option<f64> = None;

    for row in rows {
        let lat: f64 = row.try_get("latitude")?;
        let lon: f64 = row.try_get("longitude")?;

        min_lat = Some(min_lat.map_or(lat, |m| m.min(lat)));
        max_lat = Some(max_lat.map_or(lat, |m| m.max(lat)));
        min_lon = Some(min_lon.map_or(lon, |m| m.min(lon)));
        max_lon = Some(max_lon.map_or(lon, |m| m.max(lon)));

        pontos.push(PontoTrajetoria {
            evento_id: row.try_get("evento_id")?,
            tipo_evento: row.try_get("tipo_evento")?,
            ano: row.try_get("ano")?,
            data_texto: row.try_get("data_texto")?,
            local_id: row.try_get("local_id")?,
            local_nome: row.try_get("local_nome")?,
            rotulo_historico: row.try_get("rotulo_historico")?,
            latitude: lat,
            longitude: lon,
            nota: row.try_get("nota")?,
        });
    }

    Ok(TrajetoriaPessoa {
        pessoa_id: pessoa_id.to_string(),
        total_pontos: pontos.len(),
        pontos,
        min_lat,
        max_lat,
        min_lon,
        max_lon,
    })
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    async fn criar_banco_teste() -> SqlitePool {
        let pool = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");

        sqlx::migrate!("./migrations")
            .run(&pool)
            .await
            .expect("migrations");

        pool
    }

    #[tokio::test]
    async fn pessoa_sem_eventos_retorna_trajetoria_vazia() {
        let pool = criar_banco_teste().await;
        let res = obter_trajetoria_pessoa_interno("pessoa_inexistente", &pool)
            .await
            .expect("consulta ok");

        assert_eq!(res.total_pontos, 0);
        assert!(res.pontos.is_empty());
        assert!(res.min_lat.is_none());
    }

    #[tokio::test]
    async fn pessoa_com_eventos_georreferenciados_retorna_pontos_e_limites() {
        let pool = criar_banco_teste().await;

        // Criar pessoa de teste
        sqlx::query("INSERT INTO pessoas (id, nome, sexo, is_vivo, is_placeholder, is_publico) VALUES ('p_teste', 'Viajante', 'M', 0, 0, 1)")
            .execute(&pool)
            .await
            .unwrap();

        // Evento 1 em Santos (SP)
        // ibge-3548500 = Santos (SP)
        sqlx::query("INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, local_id) VALUES ('ev_1', 'p_teste', 'nascimento', 1920, 'ibge-3548500')")
            .execute(&pool)
            .await
            .unwrap();

        // Evento 2 em Petrópolis (RJ)
        // ibge-3303906 = Petrópolis (RJ)
        sqlx::query("INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, local_id) VALUES ('ev_2', 'p_teste', 'casamento', 1945, 'ibge-3303906')")
            .execute(&pool)
            .await
            .unwrap();

        let traj = obter_trajetoria_pessoa_interno("p_teste", &pool)
            .await
            .expect("trajetoria ok");

        assert_eq!(traj.total_pontos, 2);
        assert_eq!(traj.pontos[0].tipo_evento, "nascimento");
        assert_eq!(traj.pontos[0].ano, Some(1920));
        assert_eq!(traj.pontos[1].tipo_evento, "casamento");
        assert_eq!(traj.pontos[1].ano, Some(1945));

        assert!(traj.min_lat.is_some());
        assert!(traj.max_lat.is_some());
        assert!(traj.min_lon.is_some());
        assert!(traj.max_lon.is_some());
    }

    #[tokio::test]
    async fn casamento_em_uniao_aparece_na_trajetoria_dos_dois_conjuges() {
        let pool = criar_banco_teste().await;

        // Criar marido e esposa
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico) VALUES ('marido', 'Pedro', 'Silva', 'M', 0, 0, 1)")
            .execute(&pool).await.unwrap();
        sqlx::query("INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico) VALUES ('esposa', 'Maria', 'Ferreira', 'F', 0, 0, 1)")
            .execute(&pool).await.unwrap();

        // Criar união entre eles
        sqlx::query("INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo) VALUES ('u_casal', 'marido', 'esposa', 'casamento')")
            .execute(&pool).await.unwrap();

        // Casamento vinculado à união (pessoa_id é NULL)
        // ibge-3548500 = Santos (SP)
        sqlx::query("INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, local_id, nota) VALUES ('ev_casamento', 'u_casal', 'casamento', 1950, 'ibge-3548500', 'Na Igreja Matriz')")
            .execute(&pool).await.unwrap();

        let traj_marido = obter_trajetoria_pessoa_interno("marido", &pool).await.unwrap();
        let traj_esposa = obter_trajetoria_pessoa_interno("esposa", &pool).await.unwrap();

        assert_eq!(traj_marido.total_pontos, 1);
        assert_eq!(traj_marido.pontos[0].tipo_evento, "casamento");
        assert!(traj_marido.pontos[0].nota.as_deref().unwrap().contains("Maria Ferreira"));

        assert_eq!(traj_esposa.total_pontos, 1);
        assert_eq!(traj_esposa.pontos[0].tipo_evento, "casamento");
        assert!(traj_esposa.pontos[0].nota.as_deref().unwrap().contains("Pedro Silva"));
    }
}
