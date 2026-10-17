//! Recuperador contextual e Record Linkage sobre o banco SQLCipher.
//!
//! Executa consultas de leitura seguras no `SqlitePool`, ranqueia pessoas,
//! árvores e marcos históricos com Jaro-Winkler + sobreposição léxica sem acento,
//! e monta o dossiê factual estrito para responder perguntas sem jamais inventar dados.

use sqlx::{Row, SqlitePool};
use crate::domain::erros::Resultado;
use crate::domain::texto::sem_acento;
use super::algoritmos_ml::{
    extrair_anos_do_texto, jaro_winkler, tokenizar_significativo,
};
use super::{CitacaoAcervoIa, PropostaCriarArvore};

/// Dossiê completo de fatos recuperados do banco para fundamentar a resposta.
#[derive(Debug, Clone, Default)]
pub struct DossieRecuperado {
    pub melhor_score: f64,
    pub total_fatos: usize,
    pub contexto_markdown: String,
    pub sintese_deterministica: String,
    pub citacoes: Vec<CitacaoAcervoIa>,
}

#[derive(Debug, Clone)]
struct PessoaCandidata {
    id: String,
    nome_completo: String,
    minibiografia: Option<String>,
    categoria: Option<String>,
    ano_nasc: Option<i64>,
    ano_morte: Option<i64>,
    score: f64,
}


/// Recupera fatos do banco de dados SQLCipher relevantes para a `pergunta`.
pub async fn recuperar_contexto_acervo(
    pool: &SqlitePool,
    pergunta: &str,
) -> Resultado<DossieRecuperado> {
    let tokens = tokenizar_significativo(pergunta);
    let anos_pergunta = extrair_anos_do_texto(pergunta);
    let pergunta_norm = sem_acento(pergunta);

    // 1. Verifica se é uma pergunta de estatísticas globais do acervo
    let pede_resumo_global = pergunta_norm.contains("quantas pessoas")
        || pergunta_norm.contains("quantas arvores")
        || pergunta_norm.contains("estatisticas")
        || pergunta_norm.contains("resumo do acervo")
        || pergunta_norm.contains("total de pessoas");

    if pede_resumo_global {
        let total_pessoas: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas WHERE is_placeholder = 0")
            .fetch_one(pool)
            .await
            .unwrap_or(0);
        let total_arvores: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM arvores")
            .fetch_one(pool)
            .await
            .unwrap_or(0);
        let total_unioes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM unioes")
            .fetch_one(pool)
            .await
            .unwrap_or(0);
        let total_linhas: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM linhas_tempo")
            .fetch_one(pool)
            .await
            .unwrap_or(0);

        let resumo = format!(
            "O acervo atual do EloTempo possui **{} pessoas** cadastradas (excluindo placeholders), distribuídas em **{} árvores genealógicas**, **{} uniões familiares** e **{} linhas do tempo**.",
            total_pessoas, total_arvores, total_unioes, total_linhas
        );

        return Ok(DossieRecuperado {
            melhor_score: 1.0,
            total_fatos: 1,
            contexto_markdown: resumo.clone(),
            sintese_deterministica: resumo,
            citacoes: vec![CitacaoAcervoIa {
                tipo: "estatistica".to_string(),
                id: "acervo_global".to_string(),
                titulo: "Estatísticas Gerais do Acervo".to_string(),
                detalhe: format!("{} pessoas • {} árvores", total_pessoas, total_arvores),
            }],
        });
    }

    // 2. Busca e pontua pessoas no banco usando Jaro-Winkler + correspondência de tokens
    let linhas_pessoas = sqlx::query(
        r#"
        SELECT p.id, p.nome, p.sobrenome, p.sexo, p.minibiografia, p.categoria,
               (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'nascimento' LIMIT 1) AS ano_nasc,
               (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'falecimento' LIMIT 1) AS ano_morte
        FROM pessoas p
        WHERE p.is_placeholder = 0
        "#,
    )
    .fetch_all(pool)
    .await?;

    let mut candidatas: Vec<PessoaCandidata> = Vec::new();

    for row in linhas_pessoas {
        let id: String = row.get("id");
        let nome: String = row.get("nome");
        let sobrenome: Option<String> = row.get("sobrenome");
        let minibiografia: Option<String> = row.get("minibiografia");
        let categoria: Option<String> = row.get("categoria");
        let ano_nasc: Option<i64> = row.get("ano_nasc");
        let ano_morte: Option<i64> = row.get("ano_morte");

        let nome_completo = match &sobrenome {
            Some(s) if !s.trim().is_empty() => format!("{} {}", nome.trim(), s.trim()),
            _ => nome.trim().to_string(),
        };
        let nome_norm = sem_acento(&nome_completo);
        let prenome_norm = sem_acento(nome.trim());
        let bio_norm = minibiografia.as_deref().map(sem_acento).unwrap_or_default();

        let mut score: f64 = 0.0;

        // Se o nome completo ou o prenome composto inteiro aparece na pergunta
        if nome_norm.len() >= 3 && pergunta_norm.contains(&nome_norm) {
            score = 0.98;
        } else if prenome_norm.len() >= 4 && pergunta_norm.contains(&prenome_norm) {
            score = 0.94;
        } else if !tokens.is_empty() {
            let partes_nome: Vec<&str> = nome_norm.split_whitespace().collect();
            let mut hits_nome = 0usize;
            let mut soma_jw = 0.0;

            for tok in &tokens {
                let melhor_jw_parte = partes_nome
                    .iter()
                    .map(|p| jaro_winkler(tok, p))
                    .fold(0.0_f64, f64::max);

                if melhor_jw_parte >= 0.88 {
                    hits_nome += 1;
                    soma_jw += melhor_jw_parte;
                } else if bio_norm.contains(tok.as_str()) && tok.len() >= 4 {
                    soma_jw += 0.45;
                }
            }

            if hits_nome > 0 {
                let cobertura_pergunta = hits_nome as f64 / tokens.len() as f64;
                let cobertura_nome = (hits_nome as f64 / partes_nome.len().max(1) as f64).min(1.0);
                let media_jw = soma_jw / hits_nome as f64;
                score = (0.45 * media_jw) + (0.35 * cobertura_pergunta) + (0.20 * cobertura_nome);
            } else if soma_jw > 0.0 {
                score = (soma_jw / tokens.len() as f64).min(0.68);
            }
        }

        // Verifica correspondência por ano quando o usuário pergunta quem nasceu/morreu/vivia em um ano
        if !anos_pergunta.is_empty() {
            for &ano_q in &anos_pergunta {
                if ano_nasc == Some(ano_q) || ano_morte == Some(ano_q) {
                    score = score.max(0.85);
                } else if let (Some(n), Some(m)) = (ano_nasc, ano_morte) {
                    if ano_q >= n && ano_q <= m && (pergunta_norm.contains("viv") || tokens.is_empty()) {
                        score = score.max(0.75);
                    }
                }
            }
        }

        if score >= 0.55 {
            candidatas.push(PessoaCandidata {
                id,
                nome_completo,
                minibiografia,
                categoria,
                ano_nasc,
                ano_morte,
                score,
            });
        }
    }

    candidatas.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap_or(std::cmp::Ordering::Equal));
    candidatas.truncate(5);

    // 3. Busca marcos históricos nas linhas do tempo compatíveis com a pergunta
    let mut marcos_encontrados: Vec<(String, String, String, Option<i64>, Option<String>, f64)> = Vec::new();
    if !tokens.is_empty() || !anos_pergunta.is_empty() {
        let linhas_marcos = sqlx::query(
            r#"
            SELECT e.id, e.titulo, e.data_periodo_texto, e.ano_inicio, e.descricao, l.titulo AS linha_titulo
            FROM eventos_linha e
            JOIN linhas_tempo l ON l.id = e.linha_id
            "#,
        )
        .fetch_all(pool)
        .await?;

        for row in linhas_marcos {
            let id: String = row.get("id");
            let titulo: String = row.get("titulo");
            let data_txt: String = row.get("data_periodo_texto");
            let ano_ini: Option<i64> = row.get("ano_inicio");
            let desc: Option<String> = row.get("descricao");
            let linha_titulo: String = row.get("linha_titulo");

            let texto_marco = sem_acento(&format!(
                "{} {} {}",
                titulo,
                desc.as_deref().unwrap_or(""),
                linha_titulo
            ));

            let mut sc = 0.0_f64;
            if !tokens.is_empty() {
                let hits = tokens
                    .iter()
                    .filter(|t| t.len() >= 3 && texto_marco.contains(t.as_str()))
                    .count();
                if hits > 0 {
                    sc = (hits as f64 / tokens.len() as f64) * 0.90;
                }
            }
            if let Some(a) = ano_ini {
                if anos_pergunta.contains(&a) {
                    sc = sc.max(0.85);
                }
            }

            if sc >= 0.65 {
                marcos_encontrados.push((id, titulo, data_txt, ano_ini, desc, sc));
            }
        }

        marcos_encontrados.sort_by(|a, b| b.5.partial_cmp(&a.5).unwrap_or(std::cmp::Ordering::Equal));
        marcos_encontrados.truncate(5);
    }

    let melhor_score_pessoa = candidatas.first().map(|p| p.score).unwrap_or(0.0);
    let melhor_score_marco = marcos_encontrados.first().map(|m| m.5).unwrap_or(0.0);
    let melhor_score = melhor_score_pessoa.max(melhor_score_marco);
    let total_fatos = candidatas.len() + marcos_encontrados.len();

    if total_fatos == 0 {
        return Ok(DossieRecuperado {
            melhor_score: 0.0,
            total_fatos: 0,
            contexto_markdown: String::new(),
            sintese_deterministica: String::new(),
            citacoes: Vec::new(),
        });
    }

    // 4. Para cada pessoa candidata principal, busca pais, cônjuges e filhos reais no banco
    let mut blocos_contexto = Vec::new();
    let mut blocos_sintese = Vec::new();
    let mut citacoes = Vec::new();

    for p in &candidatas {
        let pais_rows = sqlx::query(
            r#"
            SELECT p_pai.nome || ' ' || COALESCE(p_pai.sobrenome, '') AS pai_nome,
                   p_mae.nome || ' ' || COALESCE(p_mae.sobrenome, '') AS mae_nome,
                   COALESCE(p_pai.is_placeholder, 1) AS pai_ph,
                   COALESCE(p_mae.is_placeholder, 1) AS mae_ph
            FROM uniao_filhos uf
            JOIN unioes u ON u.id = uf.uniao_id
            LEFT JOIN pessoas p_pai ON p_pai.id = u.slot_masculino_id
            LEFT JOIN pessoas p_mae ON p_mae.id = u.slot_feminino_id
            WHERE uf.pessoa_id = ?
            "#,
        )
        .bind(&p.id)
        .fetch_all(pool)
        .await?;

        let mut nomes_pais = Vec::new();
        for pr in pais_rows {
            let pai_ph: i64 = pr.try_get("pai_ph").unwrap_or(1);
            let mae_ph: i64 = pr.try_get("mae_ph").unwrap_or(1);
            if pai_ph == 0 {
                if let Ok(n) = pr.try_get::<String, _>("pai_nome") {
                    let nt = n.trim().to_string();
                    if !nt.is_empty() {
                        nomes_pais.push(nt);
                    }
                }
            }
            if mae_ph == 0 {
                if let Ok(n) = pr.try_get::<String, _>("mae_nome") {
                    let nt = n.trim().to_string();
                    if !nt.is_empty() {
                        nomes_pais.push(nt);
                    }
                }
            }
        }

        let conjuges_rows = sqlx::query(
            r#"
            SELECT CASE WHEN u.slot_masculino_id = ?1 THEN p2.nome || ' ' || COALESCE(p2.sobrenome, '')
                        ELSE p1.nome || ' ' || COALESCE(p1.sobrenome, '') END AS conjuge_nome,
                   CASE WHEN u.slot_masculino_id = ?1 THEN COALESCE(p2.is_placeholder, 1)
                        ELSE COALESCE(p1.is_placeholder, 1) END AS conjuge_ph,
                   u.id AS uniao_id
            FROM unioes u
            LEFT JOIN pessoas p1 ON p1.id = u.slot_masculino_id
            LEFT JOIN pessoas p2 ON p2.id = u.slot_feminino_id
            WHERE u.slot_masculino_id = ?1 OR u.slot_feminino_id = ?1
            "#,
        )
        .bind(&p.id)
        .fetch_all(pool)
        .await?;

        let mut nomes_conjuges = Vec::new();
        let mut nomes_filhos = Vec::new();

        for cr in conjuges_rows {
            let c_ph: i64 = cr.try_get("conjuge_ph").unwrap_or(1);
            if c_ph == 0 {
                if let Ok(cn) = cr.try_get::<String, _>("conjuge_nome") {
                    let cnt = cn.trim().to_string();
                    if !cnt.is_empty() && !nomes_conjuges.contains(&cnt) {
                        nomes_conjuges.push(cnt);
                    }
                }
            }

            let uid: String = cr.get("uniao_id");
            let filhos_rows = sqlx::query(
                r#"
                SELECT pf.nome || ' ' || COALESCE(pf.sobrenome, '') AS filho_nome,
                       (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id = pf.id AND e.tipo_evento = 'nascimento' LIMIT 1) AS filho_nasc
                FROM uniao_filhos uf
                JOIN pessoas pf ON pf.id = uf.pessoa_id
                WHERE uf.uniao_id = ? AND pf.is_placeholder = 0
                ORDER BY uf.ordem ASC
                "#,
            )
            .bind(&uid)
            .fetch_all(pool)
            .await?;

            for fr in filhos_rows {
                let fnome: String = fr.get("filho_nome");
                let fnasc: Option<i64> = fr.get("filho_nasc");
                let rotulo_filho = match fnasc {
                    Some(a) => format!("{} ({})", fnome.trim(), formatar_ano_pt(a)),
                    None => fnome.trim().to_string(),
                };
                if !nomes_filhos.contains(&rotulo_filho) {
                    nomes_filhos.push(rotulo_filho);
                }
            }
        }

        let datas_str = match (p.ano_nasc, p.ano_morte) {
            (Some(n), Some(m)) => format!("{} – {}", formatar_ano_pt(n), formatar_ano_pt(m)),
            (Some(n), None) => format!("nasc. {}", formatar_ano_pt(n)),
            (None, Some(m)) => format!("falec. {}", formatar_ano_pt(m)),
            (None, None) => "datas não registradas".to_string(),
        };

        let mut paragrafo = format!("• **{}** ({})", p.nome_completo, datas_str);
        if let Some(ref bio) = p.minibiografia {
            if !bio.trim().is_empty() {
                paragrafo.push_str(&format!(": {}", bio.trim()));
            }
        }
        if !nomes_pais.is_empty() {
            paragrafo.push_str(&format!("\n  - **Pais**: {}", nomes_pais.join(" e ")));
        }
        if !nomes_conjuges.is_empty() {
            paragrafo.push_str(&format!("\n  - **Cônjuge(s)**: {}", nomes_conjuges.join(", ")));
        }
        if !nomes_filhos.is_empty() {
            paragrafo.push_str(&format!("\n  - **Filhos ({})**: {}", nomes_filhos.len(), nomes_filhos.join(", ")));
        }

        blocos_contexto.push(paragrafo.clone());
        blocos_sintese.push(paragrafo);

        citacoes.push(CitacaoAcervoIa {
            tipo: "pessoa".to_string(),
            id: p.id.clone(),
            titulo: p.nome_completo.clone(),
            detalhe: match &p.categoria {
                Some(cat) => format!("{} • {}", datas_str, cat),
                None => datas_str,
            },
        });
    }

    for (mid, mtitulo, mdata, _mano, mdesc, _) in &marcos_encontrados {
        let linha = match mdesc {
            Some(d) if !d.trim().is_empty() => format!("• **[{}]** **{}** — {}", mdata, mtitulo, d.trim()),
            _ => format!("• **[{}]** **{}**", mdata, mtitulo),
        };
        blocos_contexto.push(linha.clone());
        blocos_sintese.push(linha);

        citacoes.push(CitacaoAcervoIa {
            tipo: "marco".to_string(),
            id: mid.clone(),
            titulo: mtitulo.clone(),
            detalhe: mdata.clone(),
        });
    }

    let sintese_deterministica = format!(
        "Com base nos registros verificados no acervo do EloTempo:\n\n{}",
        blocos_sintese.join("\n\n")
    );

    Ok(DossieRecuperado {
        melhor_score,
        total_fatos,
        contexto_markdown: blocos_contexto.join("\n\n"),
        sintese_deterministica,
        citacoes,
    })
}

/// Executa Record Linkage (Jaro-Winkler + comparação de ano de nascimento)
/// para identificar se alguma pessoa proposta em uma nova árvore já existe no banco.
pub async fn vincular_pessoas_existentes(
    pool: &SqlitePool,
    proposta: &mut PropostaCriarArvore,
) -> Resultado<()> {
    let existentes = sqlx::query(
        r#"
        SELECT p.id, p.nome, p.sobrenome,
               (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'nascimento' LIMIT 1) AS ano_nasc
        FROM pessoas p
        WHERE p.is_placeholder = 0
        "#,
    )
    .fetch_all(pool)
    .await?;

    let mut catalogo = Vec::with_capacity(existentes.len());
    for row in existentes {
        let id: String = row.get("id");
        let nome: String = row.get("nome");
        let sobrenome: Option<String> = row.get("sobrenome");
        let ano_nasc: Option<i64> = row.get("ano_nasc");
        let completo = match sobrenome {
            Some(s) if !s.trim().is_empty() => format!("{} {}", nome.trim(), s.trim()),
            _ => nome.trim().to_string(),
        };
        catalogo.push((id, completo, ano_nasc));
    }

    for p in &mut proposta.pessoas {
        let nome_prop = match &p.sobrenome {
            Some(s) if !s.trim().is_empty() => format!("{} {}", p.nome.trim(), s.trim()),
            _ => p.nome.trim().to_string(),
        };

        let mut melhor_id: Option<String> = None;
        let mut melhor_score = 0.0_f64;

        for (id_db, nome_db, ano_db) in &catalogo {
            let jw = jaro_winkler(&nome_prop, nome_db);
            if jw < 0.90 {
                continue;
            }
            // Se ambos têm ano de nascimento, exige que sejam próximos (diferença <= 2 anos)
            let compativel_ano = match (p.ano_nascimento, *ano_db) {
                (Some(a), Some(b)) => (a - b).abs() <= 2,
                _ => jw >= 0.96, // Sem ano de nascimento nas duas pontas, exige nome quase idêntico
            };

            if compativel_ano && jw > melhor_score {
                melhor_score = jw;
                melhor_id = Some(id_db.clone());
            }
        }

        p.pessoa_existente_id = melhor_id;
    }

    Ok(())
}

fn formatar_ano_pt(ano: i64) -> String {
    if ano < 0 {
        format!("{} a.C.", ano.abs())
    } else {
        ano.to_string()
    }
}
