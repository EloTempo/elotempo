//! Recuperador contextual universal e Record Linkage sobre todas as tabelas do banco SQLCipher.
//!
//! Executa consultas de leitura seguras no `SqlitePool`, cobrindo **todas as informações**
//! armazenadas no EloTempo:
//! 1. **Pessoas, Nomes ao longo da vida (`nomes_pessoa`) e Apelidos (`apelidos_pessoa`)**;
//! 2. **Árvores Genealógicas (`arvores`, `arvore_membros`) e Vínculos Familiares (`unioes`, `uniao_filhos`)**;
//! 3. **Eventos de Vida Completos (`eventos`: nascimento, batismo, casamento, falecimento, sepultamento, imigração, residência, etc.)**;
//! 4. **Geografia (`locais`, `paises`, `nacionalidades_pessoa`)**;
//! 5. **Atributos Biográficos (`profissoes_pessoa`, `escolaridade_pessoa`, `religioes_pessoa`, `idiomas_pessoa`, `obras_culturais`)**;
//! 6. **Linhas do Tempo (`linhas_tempo`), Marcos (`eventos_linha`), Participações (`marco_participantes`) e Marcadores (`marcadores_linha_tempo`)**;
//! 7. **Fontes Primárias (`fontes`), Citações Probatórias (`citacoes`) e Documentos/Fotos (`documentos`, `documento_vinculos`)**.

use std::collections::BTreeMap;
use sqlx::{Row, SqlitePool};
use crate::domain::erros::Resultado;
use crate::domain::texto::sem_acento;
use super::algoritmos_ml::{
    contem_frase_exata, eh_consulta_catalogo_acervo, expandir_termos_semanticos_consulta,
    extrair_anos_do_texto, extrair_intervalo_seculo_ou_periodo, extrair_nome_alvo_consulta_pessoa,
    jaro_winkler, normalizar_nome_busca_ia, radical_pt, similaridade_token_nome_pt,
    tokenizar_significativo,
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
struct ArvoreCandidata {
    id: String,
    nome: String,
    descricao: Option<String>,
    categoria: Option<String>,
    periodo: Option<String>,
    raiz_pessoa_id: Option<String>,
    score: f64,
}

#[derive(Debug, Clone)]
struct PessoaCandidata {
    id: String,
    nome_completo: String,
    minibiografia: Option<String>,
    arvore_id: Option<String>,
    arvore_nome: Option<String>,
    obras_resumo: Option<String>,
    profissoes_resumo: Option<String>,
    escolaridade_resumo: Option<String>,
    religiao_resumo: Option<String>,
    idiomas_resumo: Option<String>,
    apelidos_resumo: Option<String>,
    nomes_alternativos_resumo: Option<String>,
    locais_resumo: Option<String>,
    nacionalidades_resumo: Option<String>,
    ano_nasc: Option<i64>,
    ano_morte: Option<i64>,
    data_nasc_texto: Option<String>,
    data_morte_texto: Option<String>,
    score: f64,
    match_por_nome: bool,
}

/// Recupera fatos do banco de dados SQLCipher relevantes para a `pergunta`,
/// pesquisando em todas as tabelas do EloTempo.
pub async fn recuperar_contexto_acervo(
    pool: &SqlitePool,
    pergunta: &str,
) -> Resultado<DossieRecuperado> {
    let tokens = tokenizar_significativo(pergunta);
    let termos_semanticos = expandir_termos_semanticos_consulta(pergunta);
    let anos_pergunta = extrair_anos_do_texto(pergunta);
    let seculo_periodo = extrair_intervalo_seculo_ou_periodo(pergunta);
    let pergunta_norm = sem_acento(pergunta);
    let pergunta_busca = normalizar_nome_busca_ia(pergunta);
    let nome_pessoa_alvo = extrair_nome_alvo_consulta_pessoa(pergunta);

    // 1. Verifica se é uma consulta panorâmica/catálogo global do acervo
    if eh_consulta_catalogo_acervo(pergunta) {
        return montar_dossie_catalogo_global(pool).await;
    }

    // 2. Verifica se é uma consulta analítica/superlativa ("pessoa mais antiga", "viveu mais tempo")
    let pede_mais_antiga = pergunta_norm.contains("mais antig")
        || pergunta_norm.contains("nasceu primeiro")
        || pergunta_norm.contains("primeira pessoa");
    let pede_mais_longeva = pergunta_norm.contains("viveu mais")
        || pergunta_norm.contains("mais longev")
        || pergunta_norm.contains("mais velh");

    // Filtro opcional por sexo feminino quando perguntado explicitamente
    let filtra_mulheres = pergunta_norm.contains("mulher")
        || pergunta_norm.contains("feminina")
        || pergunta_norm.contains("rainhas")
        || pergunta_norm.contains("imperatrizes")
        || pergunta_norm.contains("princesas")
        || pergunta_norm.contains("escritoras")
        || pergunta_norm.contains("cientistas mulheres");

    // 3. Busca e pontua Árvores Genealógicas do acervo (apenas quando NÃO é busca por nome específico de pessoa)
    let linhas_arvores = sqlx::query(
        r#"
        SELECT a.id, a.nome, a.descricao, a.categoria, a.pais, a.periodo, a.tipo_tempo, a.raiz_pessoa_id
        FROM arvores a
        ORDER BY a.nome ASC
        "#,
    )
    .fetch_all(pool)
    .await?;

    let mut arvores_candidatas: Vec<ArvoreCandidata> = Vec::new();
    let mut ids_arvores_tematicas: Vec<String> = Vec::new();
    let mut raizes_arvores: Vec<String> = Vec::new();

    for row in linhas_arvores {
        let id: String = row.get("id");
        let nome: String = row.get("nome");
        let descricao: Option<String> = row.get("descricao");
        let categoria: Option<String> = row.get("categoria");
        let pais: Option<String> = row.get("pais");
        let periodo: Option<String> = row.get("periodo");
        let tipo_tempo: Option<String> = row.try_get("tipo_tempo").ok().flatten();
        let raiz_pessoa_id: Option<String> = row.get("raiz_pessoa_id");

        if let Some(ref rid) = raiz_pessoa_id {
            raizes_arvores.push(rid.clone());
        }

        if nome_pessoa_alvo.is_some() {
            continue;
        }

        let texto_arvore = sem_acento(&format!(
            "{} {} {} {} {} {}",
            nome,
            descricao.as_deref().unwrap_or(""),
            categoria.as_deref().unwrap_or(""),
            pais.as_deref().unwrap_or(""),
            periodo.as_deref().unwrap_or(""),
            tipo_tempo.as_deref().unwrap_or("")
        ));

        let mut score_arv = 0.0_f64;
        let nome_arv_norm = sem_acento(&nome);
        if nome_arv_norm.len() >= 4 && pergunta_norm.contains(&nome_arv_norm) {
            score_arv = 0.98;
        } else if !tokens.is_empty() {
            let mut hits_diretos = 0usize;
            for tok in &tokens {
                let rad = radical_pt(tok);
                if texto_arvore.contains(tok.as_str())
                    || (rad.len() >= 4 && texto_arvore.contains(&rad))
                {
                    hits_diretos += 1;
                }
            }
            let hits_semanticos = termos_semanticos
                .iter()
                .filter(|ts| ts.len() >= 4 && texto_arvore.contains(ts.as_str()))
                .count();

            if hits_diretos > 0 {
                let cob = hits_diretos as f64 / tokens.len() as f64;
                score_arv = 0.80 + (0.16 * cob);
            } else if hits_semanticos > 0 {
                score_arv = (0.76 + (hits_semanticos as f64 * 0.04)).min(0.92);
            }
        }

        if score_arv >= 0.75 {
            ids_arvores_tematicas.push(id.clone());
            arvores_candidatas.push(ArvoreCandidata {
                id,
                nome,
                descricao,
                categoria,
                periodo,
                raiz_pessoa_id,
                score: score_arv,
            });
        }
    }

    arvores_candidatas.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap_or(std::cmp::Ordering::Equal));

    // 4. Busca e pontua Pessoas no banco cruzando TODOS os atributos de vida, locais, eventos, nomes e obras
    let linhas_pessoas = sqlx::query(
        r#"
        SELECT p.id, p.nome, p.sobrenome, p.sexo, p.minibiografia, p.categoria, p.tipo_tempo,
               (SELECT am.arvore_id FROM arvore_membros am WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_id,
               (SELECT a.nome FROM arvores a JOIN arvore_membros am ON am.arvore_id = a.id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_nome,
               (SELECT a.categoria FROM arvores a JOIN arvore_membros am ON am.arvore_id = a.id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_cat,
               (SELECT a.pais FROM arvores a JOIN arvore_membros am ON am.arvore_id = a.id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_pais,
               (SELECT a.periodo FROM arvores a JOIN arvore_membros am ON am.arvore_id = a.id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_periodo,
               (SELECT GROUP_CONCAT(o.titulo || COALESCE(' (' || o.ano || ')', ''), '; ') FROM obras_culturais o WHERE o.pessoa_id = p.id) AS obras_resumo,
               (SELECT GROUP_CONCAT(pr.ocupacao || COALESCE(' (' || pr.empregador_local || ')', ''), ', ') FROM profissoes_pessoa pr WHERE pr.pessoa_id = p.id) AS profissoes_resumo,
               (SELECT GROUP_CONCAT(es.nivel || COALESCE(' - ' || es.instituicao, ''), '; ') FROM escolaridade_pessoa es WHERE es.pessoa_id = p.id) AS escolaridade_resumo,
               (SELECT GROUP_CONCAT(re.denominacao, ', ') FROM religioes_pessoa re WHERE re.pessoa_id = p.id) AS religiao_resumo,
               (SELECT GROUP_CONCAT(id_p.idioma, ', ') FROM idiomas_pessoa id_p WHERE id_p.pessoa_id = p.id) AS idiomas_resumo,
               (SELECT GROUP_CONCAT(ap.apelido, ', ') FROM apelidos_pessoa ap WHERE ap.pessoa_id = p.id) AS apelidos_resumo,
               (SELECT GROUP_CONCAT(TRIM(COALESCE(np.prefixo || ' ', '') || np.nome || COALESCE(' ' || np.sobrenome, '') || ' [' || np.tipo || ']'), '; ') FROM nomes_pessoa np WHERE np.pessoa_id = p.id) AS nomes_alternativos_resumo,
               (SELECT GROUP_CONCAT(DISTINCT COALESCE(e.rotulo_historico_livre, l.nome || COALESCE(', ' || l.uf, '') || COALESCE(', ' || pa.nome, '')))
                FROM eventos e LEFT JOIN locais l ON l.id = e.local_id LEFT JOIN paises pa ON pa.id = l.pais_id
                WHERE e.pessoa_id = p.id) AS locais_resumo,
               (SELECT GROUP_CONCAT(pa_n.nome, ', ') FROM nacionalidades_pessoa np_a JOIN paises pa_n ON pa_n.id = np_a.pais_id WHERE np_a.pessoa_id = p.id) AS nacionalidades_resumo,
               (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'nascimento' LIMIT 1) AS ano_nasc,
               (SELECT e.ano_inicio FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'falecimento' LIMIT 1) AS ano_morte,
               (SELECT e.data_texto FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'nascimento' LIMIT 1) AS data_nasc_texto,
               (SELECT e.data_texto FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'falecimento' LIMIT 1) AS data_morte_texto
        FROM pessoas p
        WHERE p.is_placeholder = 0
        "#,
    )
    .fetch_all(pool)
    .await?;

    let mut candidatas: Vec<PessoaCandidata> = Vec::new();
    let conectores_nome = ["de", "da", "do", "dos", "das", "del", "di", "von", "van", "e"];

    for row in linhas_pessoas {
        let id: String = row.get("id");
        let nome: String = row.get("nome");
        let sobrenome: Option<String> = row.get("sobrenome");
        let sexo: String = row.try_get("sexo").unwrap_or_else(|_| "U".to_string());
        let minibiografia: Option<String> = row.get("minibiografia");
        let categoria: Option<String> = row.get("categoria");
        let tipo_tempo: Option<String> = row.try_get("tipo_tempo").ok().flatten();
        let arvore_id: Option<String> = row.try_get("arvore_id").ok().flatten();
        let arvore_nome: Option<String> = row.try_get("arvore_nome").ok().flatten();
        let arvore_cat: Option<String> = row.try_get("arvore_cat").ok().flatten();
        let arvore_pais: Option<String> = row.try_get("arvore_pais").ok().flatten();
        let arvore_periodo: Option<String> = row.try_get("arvore_periodo").ok().flatten();
        let obras_resumo: Option<String> = row.try_get("obras_resumo").ok().flatten();
        let profissoes_resumo: Option<String> = row.try_get("profissoes_resumo").ok().flatten();
        let escolaridade_resumo: Option<String> = row.try_get("escolaridade_resumo").ok().flatten();
        let religiao_resumo: Option<String> = row.try_get("religiao_resumo").ok().flatten();
        let idiomas_resumo: Option<String> = row.try_get("idiomas_resumo").ok().flatten();
        let apelidos_resumo: Option<String> = row.try_get("apelidos_resumo").ok().flatten();
        let nomes_alternativos_resumo: Option<String> = row.try_get("nomes_alternativos_resumo").ok().flatten();
        let locais_resumo: Option<String> = row.try_get("locais_resumo").ok().flatten();
        let nacionalidades_resumo: Option<String> = row.try_get("nacionalidades_resumo").ok().flatten();
        let ano_nasc: Option<i64> = row.get("ano_nasc");
        let ano_morte: Option<i64> = row.get("ano_morte");
        let data_nasc_texto: Option<String> = row.try_get("data_nasc_texto").ok().flatten();
        let data_morte_texto: Option<String> = row.try_get("data_morte_texto").ok().flatten();

        if filtra_mulheres && sexo != "F" && !tokens.is_empty() && nome_pessoa_alvo.is_none() {
            let nome_busca_chk = normalizar_nome_busca_ia(&format!(
                "{} {}",
                nome.trim(),
                sobrenome.as_deref().unwrap_or("")
            ));
            if !contem_frase_exata(&pergunta_busca, &nome_busca_chk) {
                continue;
            }
        }

        let nome_completo = match &sobrenome {
            Some(s) if !s.trim().is_empty() => format!("{} {}", nome.trim(), s.trim()),
            _ => nome.trim().to_string(),
        };
        let nome_busca = normalizar_nome_busca_ia(&nome_completo);
        let prenome_busca = normalizar_nome_busca_ia(nome.trim());
        let apelidos_norm = apelidos_resumo.as_deref().map(sem_acento).unwrap_or_default();
        let alternativos_norm = nomes_alternativos_resumo.as_deref().map(sem_acento).unwrap_or_default();

        let mut score: f64 = 0.0;
        let mut match_por_nome = false;

        if let Some(ref nome_alvo) = nome_pessoa_alvo {
            // MODO ESTRITO DE PESSOA POR NOME:
            // Quando o usuário pergunta por uma pessoa específica ("Existe alguém cadastrado com o nome de Gabriel Fernandes?",
            // "Quem foi Machado de Asis?", "Quando nasceu Dom Pedo II?"), NUNCA pontua por árvore temática nem descrição de terceiros!
            let alvo_norm = normalizar_nome_busca_ia(nome_alvo);
            let partes_alvo: Vec<&str> = alvo_norm
                .split_whitespace()
                .filter(|w| !conectores_nome.contains(w))
                .collect();

            let universo_nomes = format!("{} {} {}", nome_busca, apelidos_norm, alternativos_norm);
            let partes_cand: Vec<&str> = universo_nomes
                .split(|c: char| !c.is_alphanumeric())
                .filter(|w| !w.is_empty() && !conectores_nome.contains(w))
                .collect();

            if !alvo_norm.is_empty()
                && nome_busca.len() >= 3
                && (contem_frase_exata(&nome_busca, &alvo_norm) || contem_frase_exata(&alvo_norm, &nome_busca))
                && (partes_alvo.len() >= 2 || partes_cand.len() == 1)
            {
                score = 0.99;
                match_por_nome = true;
            } else if !alvo_norm.is_empty()
                && prenome_busca.len() >= 4
                && prenome_busca == alvo_norm
                && (prenome_busca.contains(' ') || partes_alvo.len() == 1)
            {
                score = if prenome_busca.contains(' ') { 0.98 } else { 0.93 };
                match_por_nome = true;
            } else if !partes_alvo.is_empty() && !partes_cand.is_empty() {
                let mut hits_alvo = 0usize;
                let mut soma_sim = 0.0_f64;

                for tok_a in &partes_alvo {
                    let melhor_sim = partes_cand
                        .iter()
                        .map(|pc| similaridade_token_nome_pt(tok_a, pc))
                        .fold(0.0_f64, f64::max);
                    if melhor_sim >= 0.85 {
                        hits_alvo += 1;
                        soma_sim += melhor_sim;
                    }
                }

                // Se o nome buscado tem 2 ou mais palavras ("Gabriel Fernandes", "Machado de Asis", "Pedro II"),
                // TODAS as palavras do nome buscado precisam encontrar correspondência no nome da pessoa!
                if hits_alvo == partes_alvo.len() {
                    let media_sim = soma_sim / partes_alvo.len() as f64;
                    score = if partes_alvo.len() >= 2 {
                        (0.90 + 0.08 * media_sim).min(0.98)
                    } else {
                        (0.86 + 0.07 * media_sim).min(0.93)
                    };
                    match_por_nome = true;
                }
            }
        } else {
            let perfil_tematico = sem_acento(&format!(
                "{} {} {} {} {} {} {} {} {} {} {} {} {} {} {}",
                minibiografia.as_deref().unwrap_or(""),
                categoria.as_deref().unwrap_or(""),
                arvore_nome.as_deref().unwrap_or(""),
                arvore_cat.as_deref().unwrap_or(""),
                arvore_pais.as_deref().unwrap_or(""),
                arvore_periodo.as_deref().unwrap_or(""),
                obras_resumo.as_deref().unwrap_or(""),
                profissoes_resumo.as_deref().unwrap_or(""),
                escolaridade_resumo.as_deref().unwrap_or(""),
                religiao_resumo.as_deref().unwrap_or(""),
                idiomas_resumo.as_deref().unwrap_or(""),
                nomes_alternativos_resumo.as_deref().unwrap_or(""),
                locais_resumo.as_deref().unwrap_or(""),
                nacionalidades_resumo.as_deref().unwrap_or(""),
                tipo_tempo.as_deref().unwrap_or("")
            ));

            // A. Correspondência exata de frase no nome completo ou prenome composto
            if nome_busca.len() >= 3 && contem_frase_exata(&pergunta_busca, &nome_busca) {
                score = 0.99;
                match_por_nome = true;
            } else if prenome_busca.len() >= 4
                && contem_frase_exata(&pergunta_busca, &prenome_busca)
                && (prenome_busca.contains(' ') || tokens.len() == 1)
            {
                score = if prenome_busca.contains(' ') { 0.97 } else { 0.92 };
                match_por_nome = true;
            } else if !apelidos_norm.is_empty()
                && apelidos_norm
                    .split(',')
                    .map(str::trim)
                    .any(|ap| ap.len() >= 4 && contem_frase_exata(&pergunta_norm, ap))
            {
                score = 0.96;
                match_por_nome = true;
            } else if !tokens.is_empty() {
                // B. Correspondência por partes do nome usando `similaridade_token_nome_pt`
                let partes_nome: Vec<&str> = nome_busca
                    .split_whitespace()
                    .filter(|w| !conectores_nome.contains(w))
                    .collect();
                let mut hits_nome = 0usize;
                let mut soma_jw = 0.0;

                for tok in &tokens {
                    let melhor_jw_parte = partes_nome
                        .iter()
                        .map(|p| similaridade_token_nome_pt(tok, p))
                        .fold(0.0_f64, f64::max);

                    if melhor_jw_parte >= 0.86 {
                        hits_nome += 1;
                        soma_jw += melhor_jw_parte;
                    }
                }

                if hits_nome == tokens.len() && hits_nome > 0 {
                    let cobertura_nome = (hits_nome as f64 / partes_nome.len().max(1) as f64).min(1.0);
                    let media_jw = soma_jw / hits_nome as f64;
                    let score_nome = (0.70 * media_jw) + (0.30 * cobertura_nome);
                    if score_nome >= 0.78 {
                        score = score_nome.max(0.92);
                        match_por_nome = true;
                    }
                }

                // C. Busca Temática, Semântica e Morfológica (países, categorias, obras, profissões, escolaridade, locais, biografias)
                if score < 0.78 {
                    let pertence_arvore_tematica = arvore_id
                        .as_ref()
                        .map(|aid| ids_arvores_tematicas.contains(aid))
                        .unwrap_or(false);
                    let eh_raiz_destaque = raizes_arvores.contains(&id);

                    let mut hits_diretos_tema = 0usize;
                    for tok in &tokens {
                        let rad = radical_pt(tok);
                        if perfil_tematico.contains(tok.as_str())
                            || (rad.len() >= 4 && perfil_tematico.contains(&rad))
                        {
                            hits_diretos_tema += 1;
                        }
                    }

                    let hits_semanticos = termos_semanticos
                        .iter()
                        .filter(|ts| ts.len() >= 4 && perfil_tematico.contains(ts.as_str()))
                        .count();

                    let mut score_tematico = 0.0_f64;
                    if pertence_arvore_tematica {
                        score_tematico = if eh_raiz_destaque { 0.89 } else { 0.83 };
                        if hits_diretos_tema > 0 || hits_semanticos > 0 {
                            score_tematico = (score_tematico + 0.05).min(0.95);
                        }
                    } else if hits_diretos_tema > 0 {
                        let cob = hits_diretos_tema as f64 / tokens.len() as f64;
                        score_tematico = 0.74 + (0.18 * cob);
                        if eh_raiz_destaque {
                            score_tematico += 0.03;
                        }
                    } else if hits_semanticos > 0 {
                        score_tematico = (0.72 + (hits_semanticos as f64 * 0.04)).min(0.88);
                        if eh_raiz_destaque {
                            score_tematico += 0.03;
                        }
                    }

                    if score_tematico > score {
                        score = score_tematico;
                    }
                }
            }

            // D. Correspondência por ano específico ou data textual mencionada na pergunta
            if !anos_pergunta.is_empty() {
                for &ano_q in &anos_pergunta {
                    if ano_nasc == Some(ano_q) || ano_morte == Some(ano_q) {
                        score = score.max(0.88);
                    } else if let (Some(n), Some(m)) = (ano_nasc, ano_morte) {
                        if ano_q >= n && ano_q <= m && tokens.is_empty() {
                            score = score.max(0.75);
                        }
                    }
                }
            }

            // E. Correspondência por século, década, intervalo ou data aproximada ("por volta de 1825")
            if let Some((sec_ini, sec_fim, _)) = &seculo_periodo {
                let viveu_no_periodo = if pergunta_norm.contains("nasceu") || pergunta_norm.contains("nascid") || pergunta_norm.contains("por volta") || pergunta_norm.contains("cerca de") || pergunta_norm.contains("aprox") {
                    ano_nasc.map(|n| n >= *sec_ini && n <= *sec_fim).unwrap_or(false)
                } else {
                    match (ano_nasc, ano_morte) {
                        (Some(n), Some(m)) => n <= *sec_fim && m >= *sec_ini,
                        (Some(n), None) => n >= *sec_ini && n <= *sec_fim,
                        (None, Some(m)) => m >= *sec_ini && m <= *sec_fim,
                        (None, None) => false,
                    }
                };
                if viveu_no_periodo {
                    let bonus_raiz = if raizes_arvores.contains(&id) { 0.04 } else { 0.0 };
                    score = score.max(0.80 + bonus_raiz);
                }
            }

            // F. Consultas analíticas ("pessoa mais antiga", "viveu mais tempo")
            if pede_mais_antiga && ano_nasc.is_some() && score < 0.70 && tokens.is_empty() {
                score = 0.75;
            }
            if pede_mais_longeva && ano_nasc.is_some() && ano_morte.is_some() && score < 0.70 && tokens.is_empty() {
                score = 0.75;
            }
        }

        if score >= 0.65 {
            candidatas.push(PessoaCandidata {
                id,
                nome_completo,
                minibiografia,
                arvore_id,
                arvore_nome,
                obras_resumo,
                profissoes_resumo,
                escolaridade_resumo,
                religiao_resumo,
                idiomas_resumo,
                apelidos_resumo,
                nomes_alternativos_resumo,
                locais_resumo,
                nacionalidades_resumo,
                ano_nasc,
                ano_morte,
                data_nasc_texto,
                data_morte_texto,
                score,
                match_por_nome,
            });
        }
    }

    // Se a pergunta buscava uma pessoa específica pelo nome e ninguém no banco correspondeu ao nome,
    // retorna imediatamente dossiê vazio para acionar o Portão de Abstenção e sugerir criar o cadastro!
    if nome_pessoa_alvo.is_some() && candidatas.is_empty() {
        return Ok(DossieRecuperado::default());
    }

    if pede_mais_antiga {
        candidatas.sort_by_key(|p| p.ano_nasc.unwrap_or(99999));
    } else if pede_mais_longeva {
        candidatas.sort_by_key(|p| {
            let duracao = match (p.ano_nasc, p.ano_morte) {
                (Some(n), Some(m)) if m >= n => m - n,
                _ => -1,
            };
            std::cmp::Reverse(duracao)
        });
    } else {
        candidatas.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap_or(std::cmp::Ordering::Equal));
    }

    let eh_busca_pessoa_especifica = nome_pessoa_alvo.is_some()
        || candidatas
            .first()
            .map(|c| c.match_por_nome && c.score >= 0.90)
            .unwrap_or(false);

    if eh_busca_pessoa_especifica {
        let melhor_sc = candidatas.first().map(|c| c.score).unwrap_or(0.0);
        if melhor_sc >= 0.96 {
            candidatas.retain(|c| c.score >= 0.94);
        } else if melhor_sc >= 0.90 {
            candidatas.retain(|c| c.score >= 0.88);
        }
        candidatas.truncate(2);
    } else {
        candidatas.truncate(6);
    }

    // 5. Busca em `eventos_linha` (marcos das linhas do tempo), `marcadores_linha_tempo` e `fontes`
    let mut marcos_encontrados = Vec::new();
    if !eh_busca_pessoa_especifica {
        let linhas_marcos = sqlx::query(
            r#"
            SELECT m.id, m.titulo, m.data_periodo_texto, m.ano_inicio, m.descricao,
                   l.titulo AS linha_titulo
            FROM eventos_linha m
            LEFT JOIN linhas_tempo l ON l.id = m.linha_id
            "#,
        )
        .fetch_all(pool)
        .await
        .unwrap_or_default();

        for row in linhas_marcos {
            let id: String = row.get("id");
            let titulo: String = row.get("titulo");
            let data_texto: String = row.get("data_periodo_texto");
            let ano_inicio: Option<i64> = row.get("ano_inicio");
            let descricao: Option<String> = row.get("descricao");
            let linha_titulo: Option<String> = row.try_get("linha_titulo").ok().flatten();

            let mut sc = 0.0_f64;
            let texto_marco = sem_acento(&format!(
                "{} {} {}",
                titulo,
                descricao.as_deref().unwrap_or(""),
                linha_titulo.as_deref().unwrap_or("")
            ));

            if !tokens.is_empty() {
                let hits = tokens
                    .iter()
                    .filter(|t| {
                        let rad = radical_pt(t);
                        texto_marco.contains(t.as_str())
                            || (rad.len() >= 4 && texto_marco.contains(&rad))
                    })
                    .count();
                let hits_sem = termos_semanticos
                    .iter()
                    .filter(|ts| ts.len() >= 4 && texto_marco.contains(ts.as_str()))
                    .count();
                if hits > 0 {
                    sc = 0.70 + 0.22 * (hits as f64 / tokens.len() as f64);
                } else if hits_sem > 0 {
                    sc = (0.68 + 0.04 * hits_sem as f64).min(0.84);
                }
            }
            if let Some(ano_m) = ano_inicio {
                if anos_pergunta.contains(&ano_m) {
                    sc = sc.max(0.88);
                }
                if let Some((sec_ini, sec_fim, _)) = &seculo_periodo {
                    if ano_m >= *sec_ini && ano_m <= *sec_fim && sc >= 0.65 {
                        sc = sc.max(0.76);
                    }
                }
            }

            if sc >= 0.68 {
                marcos_encontrados.push((id, titulo, data_texto, ano_inicio, descricao, sc));
            }
        }

        marcos_encontrados.sort_by(|a, b| b.5.partial_cmp(&a.5).unwrap_or(std::cmp::Ordering::Equal));
        marcos_encontrados.truncate(4);
    }

    // 5b. Busca em `fontes` e `marcadores_linha_tempo` quando relevantes
    let mut fontes_encontradas = Vec::new();
    if !eh_busca_pessoa_especifica && !tokens.is_empty() {
        let rows_fontes = sqlx::query(
            "SELECT id, titulo, tipo, autor_orgao, repositorio, referencia, nota FROM fontes",
        )
        .fetch_all(pool)
        .await
        .unwrap_or_default();

        for rf in rows_fontes {
            let fid: String = rf.get("id");
            let ftitulo: String = rf.get("titulo");
            let ftipo: Option<String> = rf.try_get("tipo").ok().flatten();
            let fautor: Option<String> = rf.try_get("autor_orgao").ok().flatten();
            let frep: Option<String> = rf.try_get("repositorio").ok().flatten();
            let fnota: Option<String> = rf.try_get("nota").ok().flatten();

            let txt_f = sem_acento(&format!(
                "{} {} {} {} {}",
                ftitulo,
                ftipo.as_deref().unwrap_or(""),
                fautor.as_deref().unwrap_or(""),
                frep.as_deref().unwrap_or(""),
                fnota.as_deref().unwrap_or("")
            ));

            let hits = tokens.iter().filter(|t| txt_f.contains(t.as_str())).count();
            if hits > 0 || pergunta_norm.contains("fonte") || pergunta_norm.contains("certidao") {
                let sc = if hits > 0 { 0.78 + 0.15 * (hits as f64 / tokens.len() as f64) } else { 0.75 };
                fontes_encontradas.push((fid, ftitulo, ftipo, fautor, frep, sc));
            }
        }
        fontes_encontradas.truncate(4);
    }

    let melhor_score_pessoa = candidatas.first().map(|c| c.score).unwrap_or(0.0);
    let melhor_score_arvore = arvores_candidatas.first().map(|a| a.score).unwrap_or(0.0);
    let melhor_score_marco = marcos_encontrados.first().map(|m| m.5).unwrap_or(0.0);
    let melhor_score_fonte = fontes_encontradas.first().map(|f| f.5).unwrap_or(0.0);
    let melhor_score = melhor_score_pessoa
        .max(melhor_score_arvore)
        .max(melhor_score_marco)
        .max(melhor_score_fonte);

    let total_fatos = candidatas.len()
        + arvores_candidatas.len()
        + marcos_encontrados.len()
        + fontes_encontradas.len();

    if total_fatos == 0 {
        return Ok(DossieRecuperado::default());
    }

    // 6. Monta os blocos de contexto e síntese determinística
    let mut blocos_contexto = Vec::new();
    let mut blocos_sintese = Vec::new();
    let mut citacoes = Vec::new();

    if !eh_busca_pessoa_especifica && !arvores_candidatas.is_empty() {
        let mut linhas_arv = Vec::new();
        for arv in arvores_candidatas.iter().take(8) {
            let meta = match (&arv.categoria, &arv.periodo) {
                (Some(c), Some(p)) => format!("{} • {}", c, p),
                (Some(c), None) => c.clone(),
                (None, Some(p)) => p.clone(),
                (None, None) => "Árvore do Acervo".to_string(),
            };
            let desc_str = arv
                .descricao
                .as_deref()
                .filter(|d| !d.trim().is_empty())
                .map(|d| format!(" — {}", d.trim()))
                .unwrap_or_default();
            linhas_arv.push(format!("• **{}** ({}){}", arv.nome, meta, desc_str));

            if citacoes.len() < 4 {
                if let Some(ref rid) = arv.raiz_pessoa_id {
                    citacoes.push(CitacaoAcervoIa {
                        tipo: "arvore".to_string(),
                        id: rid.clone(),
                        titulo: arv.nome.clone(),
                        detalhe: meta,
                        arvore_id: Some(arv.id.clone()),
                    });
                }
            }
        }
        let bloco_arvores = format!(
            "**Árvores Genealógicas Relacionadas no Acervo ({}):**\n{}",
            arvores_candidatas.len().min(8),
            linhas_arv.join("\n")
        );
        blocos_contexto.push(bloco_arvores.clone());
        blocos_sintese.push(bloco_arvores);
    }

    // Para cada pessoa candidata, busca pais, cônjuges, filhos, eventos extras, fontes e documentos
    for (idx, p) in candidatas.iter().enumerate() {
        let buscar_vinculos_detalhados = eh_busca_pessoa_especifica || idx < 6;

        let mut nomes_pais = Vec::new();
        let mut nomes_conjuges = Vec::new();
        let mut nomes_filhos = Vec::new();
        let mut outros_eventos_txt = Vec::new();
        let mut fontes_pessoa_txt = Vec::new();
        let mut qtd_documentos: i64 = 0;

        if buscar_vinculos_detalhados {
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

            // Eventos adicionais (batismo, casamento, sepultamento, imigração, residência, etc.) e locais
            let ev_rows = sqlx::query(
                r#"
                SELECT e.tipo_evento, e.data_texto, e.ano_inicio,
                       COALESCE(e.rotulo_historico_livre,
                                CASE WHEN l.id IS NOT NULL THEN l.nome || COALESCE(', ' || l.uf, '') || COALESCE(', ' || pa.nome, '') ELSE NULL END) AS local_nome,
                       e.instituicao, e.nota
                FROM eventos e
                LEFT JOIN locais l ON l.id = e.local_id
                LEFT JOIN paises pa ON pa.id = l.pais_id
                WHERE e.pessoa_id = ?
                ORDER BY COALESCE(e.ano_inicio, 99999) ASC
                "#,
            )
            .bind(&p.id)
            .fetch_all(pool)
            .await
            .unwrap_or_default();

            for er in ev_rows {
                let tipo_ev: String = er.get("tipo_evento");
                let dt_ev: Option<String> = er.try_get("data_texto").ok().flatten();
                let ano_ev: Option<i64> = er.try_get("ano_inicio").ok().flatten();
                let loc_ev: Option<String> = er.try_get("local_nome").ok().flatten();
                let nota_ev: Option<String> = er.try_get("nota").ok().flatten();

                let data_str = dt_ev.or_else(|| ano_ev.map(formatar_ano_pt)).unwrap_or_default();
                let loc_str = loc_ev.map(|l| format!(" em {}", l)).unwrap_or_default();
                let nota_str = nota_ev.filter(|n| !n.trim().is_empty()).map(|n| format!(" ({})", n.trim())).unwrap_or_default();

                if !loc_str.is_empty() || (! matches!(tipo_ev.as_str(), "nascimento" | "falecimento")) {
                    outros_eventos_txt.push(format!("{}: {}{}{}", tipo_ev, data_str, loc_str, nota_str));
                }
            }

            // Fontes e citações vinculadas à pessoa
            let cit_rows = sqlx::query(
                r#"
                SELECT f.titulo, c.pagina_folha, c.transcricao
                FROM citacoes c
                JOIN fontes f ON f.id = c.fonte_id
                WHERE c.alvo_tipo = 'pessoa' AND c.alvo_id = ?
                "#,
            )
            .bind(&p.id)
            .fetch_all(pool)
            .await
            .unwrap_or_default();

            for cr in cit_rows {
                let ftit: String = cr.get("titulo");
                let fpag: Option<String> = cr.try_get("pagina_folha").ok().flatten();
                match fpag {
                    Some(pg) if !pg.trim().is_empty() => fontes_pessoa_txt.push(format!("{} ({})", ftit, pg.trim())),
                    _ => fontes_pessoa_txt.push(ftit),
                }
            }

            qtd_documentos = sqlx::query_scalar(
                "SELECT COUNT(*) FROM documento_vinculos WHERE pessoa_id = ?",
            )
            .bind(&p.id)
            .fetch_one(pool)
            .await
            .unwrap_or(0);
        }

        let nasc_exib = p
            .data_nasc_texto
            .as_deref()
            .filter(|t| !t.trim().is_empty())
            .map(|t| t.trim().to_string())
            .or_else(|| p.ano_nasc.map(formatar_ano_pt));
        let morte_exib = p
            .data_morte_texto
            .as_deref()
            .filter(|t| !t.trim().is_empty())
            .map(|t| t.trim().to_string())
            .or_else(|| p.ano_morte.map(formatar_ano_pt));

        let datas_str = match (nasc_exib, morte_exib) {
            (Some(n), Some(m)) => format!("{} – {}", n, m),
            (Some(n), None) => format!("nasc. {}", n),
            (None, Some(m)) => format!("falec. {}", m),
            (None, None) => "datas não registradas".to_string(),
        };

        let sufixo_arvore = p
            .arvore_nome
            .as_deref()
            .map(|an| format!(" [Árvore: {}]", an))
            .unwrap_or_default();

        let mut paragrafo = format!("• **{}** ({}){}", p.nome_completo, datas_str, sufixo_arvore);
        if let Some(ref bio) = p.minibiografia {
            if !bio.trim().is_empty() {
                paragrafo.push_str(&format!(": {}", bio.trim()));
            }
        }
        if let Some(ref ap) = p.apelidos_resumo {
            if !ap.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Apelidos/Títulos**: {}", ap.trim()));
            }
        }
        if let Some(ref na) = p.nomes_alternativos_resumo {
            if !na.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Nomes registrados**: {}", na.trim()));
            }
        }
        if let Some(ref profs) = p.profissoes_resumo {
            if !profs.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Atuação/Profissão**: {}", profs.trim()));
            }
        }
        if let Some(ref esc) = p.escolaridade_resumo {
            if !esc.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Escolaridade/Formação**: {}", esc.trim()));
            }
        }
        if let Some(ref obras) = p.obras_resumo {
            if !obras.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Obras/Realizações**: {}", obras.trim()));
            }
        }
        if let Some(ref rel) = p.religiao_resumo {
            if !rel.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Religião**: {}", rel.trim()));
            }
        }
        if let Some(ref idi) = p.idiomas_resumo {
            if !idi.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Idiomas**: {}", idi.trim()));
            }
        }
        if let Some(ref nac) = p.nacionalidades_resumo {
            if !nac.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Nacionalidade**: {}", nac.trim()));
            }
        }
        if let Some(ref locs) = p.locais_resumo {
            if !locs.trim().is_empty() {
                paragrafo.push_str(&format!("\n  - **Locais vinculados**: {}", locs.trim()));
            }
        }
        if !outros_eventos_txt.is_empty() {
            paragrafo.push_str(&format!("\n  - **Eventos e Locais**: {}", outros_eventos_txt.join("; ")));
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
        if !fontes_pessoa_txt.is_empty() {
            paragrafo.push_str(&format!("\n  - **Fontes Probatórias**: {}", fontes_pessoa_txt.join("; ")));
        }
        if qtd_documentos > 0 {
            paragrafo.push_str(&format!("\n  - **Mídias/Documentos anexados**: {}", qtd_documentos));
        }

        blocos_contexto.push(paragrafo.clone());
        blocos_sintese.push(paragrafo);

        citacoes.push(CitacaoAcervoIa {
            tipo: "pessoa".to_string(),
            id: p.id.clone(),
            titulo: p.nome_completo.clone(),
            detalhe: match &p.arvore_nome {
                Some(arv) => format!("{} • {}", datas_str, arv),
                None => datas_str,
            },
            arvore_id: p.arvore_id.clone(),
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
            arvore_id: None,
        });
    }

    for (_fid, ftitulo, ftipo, fautor, frep, _) in &fontes_encontradas {
        let linha = format!(
            "• **Fonte Documental: {}** ({}{}{})",
            ftitulo,
            ftipo.as_deref().unwrap_or("Documento"),
            fautor.as_deref().map(|a| format!(" • {}", a)).unwrap_or_default(),
            frep.as_deref().map(|r| format!(" • {}", r)).unwrap_or_default()
        );
        blocos_contexto.push(linha.clone());
        blocos_sintese.push(linha);
    }

    if eh_busca_pessoa_especifica {
        citacoes.truncate(2);
    } else {
        citacoes.truncate(3);
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

/// Localiza a melhor correspondência de pessoa no banco para um nome ou frase,
/// retornando `Some((id, nome_completo, arvore_id))`.
pub async fn resolver_pessoa_no_banco(
    pool: &SqlitePool,
    nome_ou_texto: &str,
) -> Resultado<Option<(String, String, Option<String>)>> {
    let dossie = recuperar_contexto_acervo(pool, nome_ou_texto).await?;
    if dossie.melhor_score >= 0.72 {
        if let Some(cit) = dossie.citacoes.into_iter().find(|c| c.tipo == "pessoa") {
            return Ok(Some((cit.id, cit.titulo, cit.arvore_id)));
        }
    }
    Ok(None)
}

/// Audita a qualidade dos cadastros no acervo (pessoas sem data de nascimento,
/// uniões com genitor desconhecido/placeholder e possíveis duplicatas).
pub async fn auditar_qualidade_acervo_db(
    pool: &SqlitePool,
    _filtro_texto: &str,
) -> Resultado<DossieRecuperado> {
    let sem_nasc_rows = sqlx::query(
        r#"
        SELECT p.id, p.nome, p.sobrenome,
               (SELECT am.arvore_id FROM arvore_membros am WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_id,
               (SELECT a.nome FROM arvores a JOIN arvore_membros am ON am.arvore_id = a.id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_nome
        FROM pessoas p
        WHERE p.is_placeholder = 0
          AND NOT EXISTS (SELECT 1 FROM eventos e WHERE e.pessoa_id = p.id AND e.tipo_evento = 'nascimento' AND e.ano_inicio IS NOT NULL)
        LIMIT 10
        "#,
    )
    .fetch_all(pool)
    .await?;

    let sem_bio_rows = sqlx::query(
        r#"
        SELECT p.id, p.nome, p.sobrenome,
               (SELECT am.arvore_id FROM arvore_membros am WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_id,
               (SELECT a.nome FROM arvores a JOIN arvore_membros am ON am.arvore_id = a.id WHERE am.pessoa_id = p.id LIMIT 1) AS arvore_nome
        FROM pessoas p
        WHERE p.is_placeholder = 0
          AND (p.minibiografia IS NULL OR TRIM(p.minibiografia) = '')
        LIMIT 8
        "#,
    )
    .fetch_all(pool)
    .await?;

    let total_placeholders: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM pessoas WHERE is_placeholder = 1",
    )
    .fetch_one(pool)
    .await
    .unwrap_or(0);

    let mut citacoes = Vec::new();
    let mut linhas_sem_nasc = Vec::new();
    for r in sem_nasc_rows {
        let pid: String = r.get("id");
        let nome: String = r.get("nome");
        let sob: Option<String> = r.get("sobrenome");
        let arv_id: Option<String> = r.try_get("arvore_id").ok().flatten();
        let arv_nome: Option<String> = r.try_get("arvore_nome").ok().flatten();
        let completo = format!("{} {}", nome.trim(), sob.as_deref().unwrap_or("")).trim().to_string();
        linhas_sem_nasc.push(format!(
            "• **{}**{}",
            completo,
            arv_nome.as_deref().map(|a| format!(" ({})", a)).unwrap_or_default()
        ));
        if citacoes.len() < 8 {
            citacoes.push(CitacaoAcervoIa {
                tipo: "pessoa".to_string(),
                id: pid,
                titulo: completo,
                detalhe: "Sem ano de nascimento registrado".to_string(),
                arvore_id: arv_id,
            });
        }
    }

    let mut linhas_sem_bio = Vec::new();
    for r in sem_bio_rows {
        let pid: String = r.get("id");
        let nome: String = r.get("nome");
        let sob: Option<String> = r.get("sobrenome");
        let arv_id: Option<String> = r.try_get("arvore_id").ok().flatten();
        let completo = format!("{} {}", nome.trim(), sob.as_deref().unwrap_or("")).trim().to_string();
        linhas_sem_bio.push(format!("• **{}**", completo));
        if citacoes.len() < 10 && !citacoes.iter().any(|c| c.id == pid) {
            citacoes.push(CitacaoAcervoIa {
                tipo: "pessoa".to_string(),
                id: pid,
                titulo: completo,
                detalhe: "Sem minibiografia preenchida".to_string(),
                arvore_id: arv_id,
            });
        }
    }

    let mut secoes = Vec::new();
    if linhas_sem_nasc.is_empty() {
        secoes.push("✅ **Datas de Nascimento**: Todas as pessoas cadastradas possuem ano de nascimento registrado.".to_string());
    } else {
        secoes.push(format!(
            "⚠️ **Pessoas sem ano de nascimento registrado ({} listadas)**:\n{}",
            linhas_sem_nasc.len(),
            linhas_sem_nasc.join("\n")
        ));
    }

    if !linhas_sem_bio.is_empty() {
        secoes.push(format!(
            "📝 **Pessoas sem minibiografia preenchida ({} listadas)**:\n{}",
            linhas_sem_bio.len(),
            linhas_sem_bio.join("\n")
        ));
    }

    secoes.push(format!(
        "🌳 **Genitores em aberto (Placeholders)**: existem **{}** posições de pai/mãe desconhecidos aguardando identificação nas árvores.",
        total_placeholders
    ));

    let texto = format!(
        "**Relatório de Auditoria e Completude do Acervo EloTempo:**\n\n{}",
        secoes.join("\n\n")
    );

    Ok(DossieRecuperado {
        melhor_score: 1.0,
        total_fatos: 1 + citacoes.len(),
        contexto_markdown: texto.clone(),
        sintese_deterministica: texto,
        citacoes,
    })
}

/// Monta um dossiê panorâmico completo quando o usuário pergunta sobre o acervo como um todo.
async fn montar_dossie_catalogo_global(pool: &SqlitePool) -> Resultado<DossieRecuperado> {
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

    let arvores_rows = sqlx::query(
        r#"
        SELECT a.id, a.nome, COALESCE(a.categoria, 'Acervo Pessoal') AS categoria,
               a.pais, a.periodo, a.raiz_pessoa_id,
               (SELECT p.nome || ' ' || COALESCE(p.sobrenome, '') FROM pessoas p WHERE p.id = a.raiz_pessoa_id) AS raiz_nome
        FROM arvores a
        ORDER BY categoria ASC, a.nome ASC
        "#,
    )
    .fetch_all(pool)
    .await?;

    let mut por_categoria: BTreeMap<String, Vec<String>> = BTreeMap::new();
    let mut citacoes = vec![CitacaoAcervoIa {
        tipo: "estatistica".to_string(),
        id: "acervo_global".to_string(),
        titulo: "Estatísticas Gerais do Acervo".to_string(),
        detalhe: format!("{} pessoas • {} árvores", total_pessoas, total_arvores),
        arvore_id: None,
    }];

    for row in arvores_rows {
        let arv_id: String = row.get("id");
        let arv_nome: String = row.get("nome");
        let cat: String = row.get("categoria");
        let pais: Option<String> = row.try_get("pais").ok().flatten();
        let raiz_id: Option<String> = row.try_get("raiz_pessoa_id").ok().flatten();
        let raiz_nome: Option<String> = row.try_get("raiz_nome").ok().flatten();

        let detalhe_pais = pais
            .as_deref()
            .filter(|p| !p.trim().is_empty())
            .map(|p| format!(" [{}]", p))
            .unwrap_or_default();
        let detalhe_raiz = raiz_nome
            .as_deref()
            .map(str::trim)
            .filter(|r| !r.is_empty())
            .map(|r| format!(" (destaque: {})", r))
            .unwrap_or_default();

        por_categoria
            .entry(cat.clone())
            .or_default()
            .push(format!("{}{}{}", arv_nome, detalhe_pais, detalhe_raiz));

        if citacoes.len() < 10 {
            if let (Some(rid), Some(rnome)) = (raiz_id, raiz_nome) {
                let rnome_limpo = rnome.trim().to_string();
                if !rnome_limpo.is_empty() {
                    citacoes.push(CitacaoAcervoIa {
                        tipo: "pessoa".to_string(),
                        id: rid,
                        titulo: rnome_limpo,
                        detalhe: format!("{} • {}", arv_nome, cat),
                        arvore_id: Some(arv_id),
                    });
                }
            }
        }
    }

    let mut secao_categorias = Vec::new();
    for (cat, lista) in &por_categoria {
        secao_categorias.push(format!(
            "• **{} ({} árvore(s))**: {}",
            cat,
            lista.len(),
            lista.join("; ")
        ));
    }

    let resumo_topo = format!(
        "O acervo atual do EloTempo possui **{} pessoas** cadastradas (excluindo placeholders), distribuídas em **{} árvores genealógicas**, **{} uniões familiares** e **{} linhas do tempo**.",
        total_pessoas, total_arvores, total_unioes, total_linhas
    );

    let texto_completo = if secao_categorias.is_empty() {
        resumo_topo
    } else {
        format!(
            "{}\n\n**Catálogo de Árvores por Categoria Temática:**\n{}",
            resumo_topo,
            secao_categorias.join("\n")
        )
    };

    Ok(DossieRecuperado {
        melhor_score: 1.0,
        total_fatos: 1 + por_categoria.len(),
        contexto_markdown: texto_completo.clone(),
        sintese_deterministica: texto_completo,
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
            let compativel_ano = match (p.ano_nascimento, *ano_db) {
                (Some(a), Some(b)) => (a - b).abs() <= 2,
                _ => jw >= 0.96,
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

pub fn formatar_ano_pt(ano: i64) -> String {
    if ano < 0 {
        format!("{} a.C.", ano.abs())
    } else {
        ano.to_string()
    }
}
