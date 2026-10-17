#[cfg(test)]
mod testes_sqlcipher {
    use sqlx::sqlite::{SqliteConnectOptions, SqlitePoolOptions};
    use sqlx::Row;
    use std::fs;
    use crate::domain::seguranca::criptografia::{derivar_chave, gerar_sal_aleatorio};

    #[tokio::test]
    async fn validar_criptografia_real_sqlcipher() {
        let temp_dir = std::env::temp_dir().join(format!("elotempo_sqlcipher_test_{}", uuid::Uuid::new_v4()));
        fs::create_dir_all(&temp_dir).unwrap();
        let db_path = temp_dir.join("acervo_cifrado.sqlite");

        let sal = gerar_sal_aleatorio();
        let chave = derivar_chave("SenhaUltraSecretaEloTempo2026!", &sal).unwrap();
        let pragma_key = format_sqlcipher_key(&chave);

        // 1. Criar banco cifrado e inserir dados
        {
            let opts = SqliteConnectOptions::new()
                .filename(&db_path)
                .create_if_missing(true)
                .pragma("key", pragma_key.clone());

            let pool = SqlitePoolOptions::new()
                .max_connections(1)
                .connect_with(opts)
                .await
                .expect("Falha ao conectar com chave SQLCipher");

            sqlx::query("CREATE TABLE pessoas_secretas (id INTEGER PRIMARY KEY, nome TEXT);")
                .execute(&pool)
                .await
                .expect("Falha ao criar tabela");

            sqlx::query("INSERT INTO pessoas_secretas (nome) VALUES ('Machado de Assis');")
                .execute(&pool)
                .await
                .expect("Falha ao inserir registro");

            pool.close().await;
        }

        // 2. Inspecionar o arquivo em disco: NÃO pode começar com "SQLite format 3\0"!
        let bytes_disco = fs::read(&db_path).expect("Falha ao ler arquivo do banco cifrado");
        assert!(bytes_disco.len() >= 16);
        assert_ne!(
            &bytes_disco[..16],
            b"SQLite format 3\0",
            "VULNERABILIDADE: O arquivo em repouso começa com cabeçalho SQLite texto claro!"
        );

        // 3. Tentar conectar SEM a chave: DEVE FALHAR!
        {
            let opts_sem_chave = SqliteConnectOptions::new()
                .filename(&db_path)
                .create_if_missing(false);

            let pool_falha = SqlitePoolOptions::new()
                .max_connections(1)
                .connect_with(opts_sem_chave)
                .await;

            // No sqlx, o connect_with pode passar, mas a primeira query DEVE falhar com erro de formato
            if let Ok(p) = pool_falha {
                let query_result = sqlx::query("SELECT nome FROM pessoas_secretas").fetch_one(&p).await;
                assert!(
                    query_result.is_err(),
                    "FALHA DE SEGURANÇA: Foi possível ler o banco de dados sem fornecer a chave SQLCipher!"
                );
                p.close().await;
            }
        }

        // 4. Conectar COM a chave correta: DEVE FUNCIONAR e ler os dados!
        {
            let opts_com_chave = SqliteConnectOptions::new()
                .filename(&db_path)
                .create_if_missing(false)
                .pragma("key", pragma_key.clone());

            let pool_correta = SqlitePoolOptions::new()
                .max_connections(1)
                .connect_with(opts_com_chave)
                .await
                .expect("Deveria conectar com a chave correta");

            let row = sqlx::query("SELECT nome FROM pessoas_secretas WHERE id = 1")
                .fetch_one(&pool_correta)
                .await
                .expect("Deveria ler registro com chave correta");

            let nome: String = row.get("nome");
            assert_eq!(nome, "Machado de Assis");

            pool_correta.close().await;
        }

        // Limpeza
        let _ = fs::remove_dir_all(&temp_dir);
    }

    #[tokio::test]
    async fn migra_sqlite_texto_claro_para_sqlcipher_sem_perder_dados() {
        use crate::domain::seguranca::chave_acervo::{
            eh_sqlite_texto_claro, formatar_sqlcipher_key, migrar_sqlite_legado_para_cifrado,
            obter_ou_criar_chave_acervo,
        };

        let temp_dir = std::env::temp_dir().join(format!("elotempo_mig_legado_{}", uuid::Uuid::new_v4()));
        fs::create_dir_all(&temp_dir).unwrap();
        let db_path = temp_dir.join("acervo.sqlite");

        // 1. Cria um banco SQLite legado (SEM chave SQLCipher, texto claro)
        {
            let opts_legado = SqliteConnectOptions::new()
                .filename(&db_path)
                .create_if_missing(true);

            let pool_legado = SqlitePoolOptions::new()
                .max_connections(1)
                .connect_with(opts_legado)
                .await
                .unwrap();

            sqlx::query("CREATE TABLE familia (id INTEGER PRIMARY KEY, ancestral TEXT);")
                .execute(&pool_legado)
                .await
                .unwrap();

            sqlx::query("INSERT INTO familia (ancestral) VALUES ('Dom Pedro II');")
                .execute(&pool_legado)
                .await
                .unwrap();

            pool_legado.close().await;
        }

        // Confirma que começa em texto claro ("SQLite format 3\0")
        assert!(eh_sqlite_texto_claro(&db_path), "O banco legado deveria estar em texto claro inicialmente");

        // 2. Executa a migração automática para SQLCipher
        let chave = obter_ou_criar_chave_acervo(&temp_dir).unwrap();
        migrar_sqlite_legado_para_cifrado(&db_path, &chave)
            .await
            .expect("Migração de banco legado para SQLCipher falhou");

        // 3. Confirma que NÃO está mais em texto claro!
        assert!(!eh_sqlite_texto_claro(&db_path), "O banco migrado NÃO pode mais estar em texto claro");

        // 4. Abre com a chave SQLCipher e verifica que "Dom Pedro II" está intacto!
        {
            let pragma_key = formatar_sqlcipher_key(&chave);
            let opts_cifrado = SqliteConnectOptions::new()
                .filename(&db_path)
                .create_if_missing(false)
                .pragma("key", pragma_key);

            let pool_cifrado = SqlitePoolOptions::new()
                .max_connections(1)
                .connect_with(opts_cifrado)
                .await
                .unwrap();

            let row = sqlx::query("SELECT ancestral FROM familia WHERE id = 1")
                .fetch_one(&pool_cifrado)
                .await
                .unwrap();

            let ancestral: String = row.get("ancestral");
            assert_eq!(ancestral, "Dom Pedro II");

            pool_cifrado.close().await;
        }

        let _ = fs::remove_dir_all(&temp_dir);
    }

    fn format_sqlcipher_key(chave: &[u8; 32]) -> String {
        let hex: String = chave.iter().map(|b| format!("{:02x}", b)).collect();
        format!("\"x'{}'\"", hex)
    }
}
