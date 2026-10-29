//! Executor transacional de ações propostas pelo Assistente IA.
//!
//! Recebe uma `PropostaAcaoIa` já auditada pelo verificador Quote-and-Verify
//! e confirmada pelo usuário na interface ("Human-in-the-Loop") e grava todas
//! as entidades em uma transação atômica no SQLCipher.

use std::collections::HashMap;
use sqlx::{Row, SqlitePool};
use uuid::Uuid;

use crate::domain::arvores_cmds::sincronizar_membros_arvore;
use crate::domain::erros::{ErroDominio, Resultado};
use super::{
    PropostaAcaoIa, PropostaAdicionarParentesco, PropostaCriarArvore, PropostaCriarLinhaTempo,
    PropostaEditarLinhaTempo, PropostaEditarPessoa, ResultadoExecucaoIa,
};

/// Executa uma proposta confirmada pelo usuário no banco de dados.
pub async fn executar_proposta_confirmada(
    pool: &SqlitePool,
    proposta: PropostaAcaoIa,
) -> Resultado<ResultadoExecucaoIa> {
    match proposta {
        PropostaAcaoIa::CriarArvore(arvore) => executar_criar_arvore_db(pool, arvore).await,
        PropostaAcaoIa::CriarLinhaTempo(linha) => executar_criar_linha_tempo_db(pool, linha).await,
        PropostaAcaoIa::EditarPessoa(edicao) => executar_editar_pessoa_db(pool, edicao).await,
        PropostaAcaoIa::AdicionarParentesco(par) => executar_adicionar_parentesco_db(pool, par).await,
        PropostaAcaoIa::EditarLinhaTempo(ed_linha) => executar_editar_linha_tempo_db(pool, ed_linha).await,
    }
}

/// Cria uma árvore genealógica completa com pessoas, eventos, placeholders, uniões e filhos
/// em uma única transação atômica.
pub async fn executar_criar_arvore_db(
    pool: &SqlitePool,
    proposta: PropostaCriarArvore,
) -> Resultado<ResultadoExecucaoIa> {
    if proposta.pessoas.is_empty() {
        return Err(ErroDominio::Validacao(
            "A proposta de árvore não contém nenhuma pessoa válida.".to_string(),
        ));
    }

    let mut tx = pool.begin().await?;
    let mut mapa_refs: HashMap<String, String> = HashMap::new();
    let mut mapa_sexo: HashMap<String, String> = HashMap::new();
    let mut pessoas_criadas = 0usize;
    let mut avisos: Vec<String> = Vec::new();

    for p in &proposta.pessoas {
        let sexo_valido = match p.sexo.as_str() {
            "M" | "F" | "X" | "U" => p.sexo.clone(),
            _ => "U".to_string(),
        };

        let real_id = if let Some(ref existente_id) = p.pessoa_existente_id {
            existente_id.clone()
        } else {
            let pid = Uuid::new_v4().to_string();
            let is_vivo = p.ano_falecimento.is_none()
                && p.ano_nascimento.map(|a| a >= 1935).unwrap_or(false);

            sqlx::query(
                "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
                 VALUES (?, ?, ?, ?, ?, ?, 0, 0, ?)",
            )
            .bind(&pid)
            .bind(p.nome.trim())
            .bind(p.sobrenome.as_deref().map(str::trim))
            .bind(&sexo_valido)
            .bind(p.minibiografia.as_deref())
            .bind(is_vivo)
            .bind(proposta.categoria.as_deref().unwrap_or("Pessoal"))
            .execute(&mut *tx)
            .await?;

            if let Some(ano_n) = p.ano_nascimento {
                let eid = Uuid::new_v4().to_string();
                let txt = if ano_n < 0 {
                    format!("{} a.C.", ano_n.abs())
                } else {
                    ano_n.to_string()
                };
                sqlx::query(
                    "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                     VALUES (?, ?, 'nascimento', ?, ?, 'exata', ?)",
                )
                .bind(&eid)
                .bind(&pid)
                .bind(ano_n)
                .bind(ano_n)
                .bind(&txt)
                .execute(&mut *tx)
                .await?;
            }

            if let Some(ano_m) = p.ano_falecimento {
                let eid = Uuid::new_v4().to_string();
                let txt = if ano_m < 0 {
                    format!("{} a.C.", ano_m.abs())
                } else {
                    ano_m.to_string()
                };
                sqlx::query(
                    "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                     VALUES (?, ?, 'falecimento', ?, ?, 'exata', ?)",
                )
                .bind(&eid)
                .bind(&pid)
                .bind(ano_m)
                .bind(ano_m)
                .bind(&txt)
                .execute(&mut *tx)
                .await?;
            }

            pessoas_criadas += 1;
            pid
        };

        mapa_refs.insert(p.ref_id.clone(), real_id);
        mapa_sexo.insert(p.ref_id.clone(), sexo_valido);
    }

    let mut unioes_criadas = 0usize;
    let mut ids_unioes_criadas = Vec::new();

    for u in &proposta.unioes {
        let mut slot_masc: Option<String> = u
            .pai_ref
            .as_ref()
            .and_then(|r| mapa_refs.get(r).cloned());
        let mut slot_fem: Option<String> = u
            .mae_ref
            .as_ref()
            .and_then(|r| mapa_refs.get(r).cloned());

        if slot_masc.is_none() && slot_fem.is_none() {
            continue;
        }

        if let Some(ref pref) = u.pai_ref {
            if mapa_sexo.get(pref).map(|s| s.as_str()) == Some("F") && slot_fem.is_none() {
                slot_fem = slot_masc.take();
            }
        }
        if let Some(ref mref) = u.mae_ref {
            if mapa_sexo.get(mref).map(|s| s.as_str()) == Some("M") && slot_masc.is_none() {
                slot_masc = slot_fem.take();
            }
        }

        let id_masculino = match slot_masc {
            Some(id) => id,
            None => {
                let ph_id = Uuid::new_v4().to_string();
                sqlx::query(
                    "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico)
                     VALUES (?, 'Desconhecido', NULL, 'M', 0, 1, 0)",
                )
                .bind(&ph_id)
                .execute(&mut *tx)
                .await?;
                ph_id
            }
        };

        let id_feminino = match slot_fem {
            Some(id) => id,
            None => {
                let ph_id = Uuid::new_v4().to_string();
                sqlx::query(
                    "INSERT INTO pessoas (id, nome, sobrenome, sexo, is_vivo, is_placeholder, is_publico)
                     VALUES (?, 'Desconhecida', NULL, 'F', 0, 1, 0)",
                )
                .bind(&ph_id)
                .execute(&mut *tx)
                .await?;
                ph_id
            }
        };

        if id_masculino == id_feminino {
            continue;
        }

        let uniao_id = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
             VALUES (?, ?, ?, 'casamento')",
        )
        .bind(&uniao_id)
        .bind(&id_masculino)
        .bind(&id_feminino)
        .execute(&mut *tx)
        .await?;

        if let Some(ano_c) = u.ano_casamento {
            let eid = Uuid::new_v4().to_string();
            let txt = ano_c.to_string();
            sqlx::query(
                "INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                 VALUES (?, ?, 'casamento', ?, ?, 'exata', ?)",
            )
            .bind(&eid)
            .bind(&uniao_id)
            .bind(ano_c)
            .bind(ano_c)
            .bind(&txt)
            .execute(&mut *tx)
            .await?;
        }

        for (ordem, f_ref) in u.filhos_refs.iter().enumerate() {
            if let Some(filho_id) = mapa_refs.get(f_ref) {
                if filho_id != &id_masculino && filho_id != &id_feminino {
                    let ja_tem_pais: Option<(String,)> =
                        sqlx::query_as("SELECT uniao_id FROM uniao_filhos WHERE pessoa_id = ?")
                            .bind(filho_id)
                            .fetch_optional(&mut *tx)
                            .await?;

                    if ja_tem_pais.is_some() {
                        let nome = proposta
                            .pessoas
                            .iter()
                            .find(|p| &p.ref_id == f_ref)
                            .map(|p| p.nome.trim().to_string())
                            .unwrap_or_else(|| f_ref.clone());
                        avisos.push(format!(
                            "{} já constava no acervo com pais registrados, então esse vínculo de filiação não foi criado. Cada pessoa tem um único par de pais.",
                            nome
                        ));
                        continue;
                    }

                    sqlx::query(
                        "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
                         VALUES (?, ?, 'biologico', ?)",
                    )
                    .bind(&uniao_id)
                    .bind(filho_id)
                    .bind((ordem + 1) as i64)
                    .execute(&mut *tx)
                    .await?;
                }
            }
        }

        ids_unioes_criadas.push(uniao_id);
        unioes_criadas += 1;
    }

    let arvore_id = Uuid::new_v4().to_string();
    let raiz_id = mapa_refs
        .get(&proposta.raiz_ref)
        .cloned()
        .or_else(|| proposta.pessoas.first().and_then(|p| mapa_refs.get(&p.ref_id).cloned()));

    sqlx::query(
        "INSERT INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, tipo_tempo)
         VALUES (?, ?, ?, ?, 0, ?, 'real')",
    )
    .bind(&arvore_id)
    .bind(proposta.nome_arvore.trim())
    .bind(proposta.descricao.as_deref())
    .bind(&raiz_id)
    .bind(proposta.categoria.as_deref().unwrap_or("Pessoal"))
    .execute(&mut *tx)
    .await?;

    for pid in mapa_refs.values() {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
             VALUES (lower(hex(randomblob(16))), ?, ?, NULL)",
        )
        .bind(&arvore_id)
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    for uid in &ids_unioes_criadas {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
             VALUES (lower(hex(randomblob(16))), ?, NULL, ?)",
        )
        .bind(&arvore_id)
        .bind(uid)
        .execute(&mut *tx)
        .await?;
    }

    tx.commit().await?;

    let _ = sincronizar_membros_arvore(pool, &arvore_id, raiz_id.as_deref()).await;

    Ok(ResultadoExecucaoIa {
        tipo: "arvore".to_string(),
        entidade_id: arvore_id,
        raiz_pessoa_id: raiz_id,
        titulo: proposta.nome_arvore,
        itens_criados: pessoas_criadas + unioes_criadas,
        mensagem: format!(
            "Árvore criada com sucesso contendo {} pessoa(s) e {} união(ões).",
            pessoas_criadas, unioes_criadas
        ),
        avisos,
    })
}

/// Cria uma Linha do Tempo completa com todos os seus marcos históricos em uma transação atômica.
pub async fn executar_criar_linha_tempo_db(
    pool: &SqlitePool,
    proposta: PropostaCriarLinhaTempo,
) -> Resultado<ResultadoExecucaoIa> {
    if proposta.marcos.is_empty() {
        return Err(ErroDominio::Validacao(
            "A proposta de linha do tempo não contém nenhum marco válido.".to_string(),
        ));
    }

    let mut tx = pool.begin().await?;
    let linha_id = Uuid::new_v4().to_string();

    sqlx::query(
        "INSERT INTO linhas_tempo (id, categoria, titulo, fonte_referencia, is_contexto, is_bloqueada)
         VALUES (?, ?, ?, ?, 0, 0)",
    )
    .bind(&linha_id)
    .bind(proposta.categoria.trim())
    .bind(proposta.titulo_linha.trim())
    .bind(proposta.fonte_referencia.as_deref())
    .execute(&mut *tx)
    .await?;

    let mut marcos_criados = 0usize;
    for m in &proposta.marcos {
        let mid = Uuid::new_v4().to_string();
        let relevancia = match m.relevancia.as_str() {
            "alta" | "media" | "baixa" => m.relevancia.as_str(),
            _ => "alta",
        };
        sqlx::query(
            "INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        )
        .bind(&mid)
        .bind(&linha_id)
        .bind(&m.data_periodo_texto)
        .bind(m.titulo.trim())
        .bind(m.descricao.as_deref())
        .bind(relevancia)
        .bind(m.ano_inicio)
        .bind(m.ano_fim.or(Some(m.ano_inicio)))
        .execute(&mut *tx)
        .await?;

        marcos_criados += 1;
    }

    tx.commit().await?;

    Ok(ResultadoExecucaoIa {
        tipo: "linha_tempo".to_string(),
        entidade_id: linha_id,
        raiz_pessoa_id: None,
        titulo: proposta.titulo_linha,
        itens_criados: marcos_criados,
        mensagem: format!(
            "Linha do tempo criada com sucesso contendo {} marco(s) cronológico(s).",
            marcos_criados
        ),
        avisos: Vec::new(),
    })
}

/// Atualiza dados e atributos de uma pessoa já cadastrada no acervo.
pub async fn executar_editar_pessoa_db(
    pool: &SqlitePool,
    edicao: PropostaEditarPessoa,
) -> Resultado<ResultadoExecucaoIa> {
    let eh_publica: bool = sqlx::query_scalar(
        "SELECT COALESCE(is_publico, 0) != 0 FROM pessoas WHERE id = ?",
    )
    .bind(&edicao.pessoa_id)
    .fetch_optional(pool)
    .await?
    .unwrap_or(false);

    if eh_publica {
        return Err(ErroDominio::Validacao(format!(
            "'{}' pertence ao acervo histórico público curado e é protegido contra alterações.",
            edicao.pessoa_nome
        )));
    }

    let mut tx = pool.begin().await?;
    let mut alteracoes = 0usize;

    if let Some(ref bio) = edicao.nova_minibiografia {
        sqlx::query("UPDATE pessoas SET minibiografia = ? WHERE id = ?")
            .bind(bio.trim())
            .bind(&edicao.pessoa_id)
            .execute(&mut *tx)
            .await?;
        alteracoes += 1;
    }

    if let Some(ref ano_n) = edicao.ano_nascimento {
        let txt = ano_n.to_string();
        let ja_existe: Option<(String,)> = sqlx::query_as(
            "SELECT id FROM eventos WHERE pessoa_id = ? AND tipo_evento = 'nascimento' LIMIT 1",
        )
        .bind(&edicao.pessoa_id)
        .fetch_optional(&mut *tx)
        .await?;

        if let Some((ev_id,)) = ja_existe {
            sqlx::query(
                "UPDATE eventos SET ano_inicio = ?, ano_fim = ?, data_texto = ? WHERE id = ?",
            )
            .bind(ano_n)
            .bind(ano_n)
            .bind(&txt)
            .bind(&ev_id)
            .execute(&mut *tx)
            .await?;
        } else {
            let eid = Uuid::new_v4().to_string();
            sqlx::query(
                "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                 VALUES (?, ?, 'nascimento', ?, ?, 'exata', ?)",
            )
            .bind(&eid)
            .bind(&edicao.pessoa_id)
            .bind(ano_n)
            .bind(ano_n)
            .bind(&txt)
            .execute(&mut *tx)
            .await?;
        }
        alteracoes += 1;
    }

    if let Some(ref ano_m) = edicao.ano_falecimento {
        let txt = ano_m.to_string();
        let ja_existe: Option<(String,)> = sqlx::query_as(
            "SELECT id FROM eventos WHERE pessoa_id = ? AND tipo_evento = 'falecimento' LIMIT 1",
        )
        .bind(&edicao.pessoa_id)
        .fetch_optional(&mut *tx)
        .await?;

        if let Some((ev_id,)) = ja_existe {
            sqlx::query(
                "UPDATE eventos SET ano_inicio = ?, ano_fim = ?, data_texto = ? WHERE id = ?",
            )
            .bind(ano_m)
            .bind(ano_m)
            .bind(&txt)
            .bind(&ev_id)
            .execute(&mut *tx)
            .await?;
        } else {
            let eid = Uuid::new_v4().to_string();
            sqlx::query(
                "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                 VALUES (?, ?, 'falecimento', ?, ?, 'exata', ?)",
            )
            .bind(&eid)
            .bind(&edicao.pessoa_id)
            .bind(ano_m)
            .bind(ano_m)
            .bind(&txt)
            .execute(&mut *tx)
            .await?;
        }
        sqlx::query("UPDATE pessoas SET is_vivo = 0 WHERE id = ?")
            .bind(&edicao.pessoa_id)
            .execute(&mut *tx)
            .await?;
        alteracoes += 1;
    }

    if let Some(ref prof) = edicao.nova_profissao {
        if !prof.trim().is_empty() {
            sqlx::query(
                "INSERT INTO profissoes_pessoa (id, pessoa_id, ocupacao) VALUES (?, ?, ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&edicao.pessoa_id)
            .bind(prof.trim())
            .execute(&mut *tx)
            .await?;
            alteracoes += 1;
        }
    }

    if let Some(ref obra) = edicao.nova_obra_titulo {
        if !obra.trim().is_empty() {
            sqlx::query(
                "INSERT INTO obras_culturais (id, pessoa_id, categoria, titulo, ano) VALUES (?, ?, 'Literatura & Publicações', ?, ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&edicao.pessoa_id)
            .bind(obra.trim())
            .bind(edicao.nova_obra_ano)
            .execute(&mut *tx)
            .await?;
            alteracoes += 1;
        }
    }

    if let Some(ref ap) = edicao.novo_apelido {
        if !ap.trim().is_empty() {
            sqlx::query("INSERT INTO apelidos_pessoa (id, pessoa_id, apelido) VALUES (?, ?, ?)")
                .bind(Uuid::new_v4().to_string())
                .bind(&edicao.pessoa_id)
                .bind(ap.trim())
                .execute(&mut *tx)
                .await?;
            alteracoes += 1;
        }
    }

    if let Some(ref esc) = edicao.nova_escolaridade {
        if !esc.trim().is_empty() {
            sqlx::query(
                "INSERT INTO escolaridade_pessoa (id, pessoa_id, nivel) VALUES (?, ?, ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&edicao.pessoa_id)
            .bind(esc.trim())
            .execute(&mut *tx)
            .await?;
            alteracoes += 1;
        }
    }

    if let Some(ref rel) = edicao.nova_religiao {
        if !rel.trim().is_empty() {
            sqlx::query(
                "INSERT INTO religioes_pessoa (id, pessoa_id, denominacao) VALUES (?, ?, ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&edicao.pessoa_id)
            .bind(rel.trim())
            .execute(&mut *tx)
            .await?;
            alteracoes += 1;
        }
    }

    if let Some(ref idi) = edicao.novo_idioma {
        if !idi.trim().is_empty() {
            sqlx::query("INSERT INTO idiomas_pessoa (id, pessoa_id, idioma) VALUES (?, ?, ?)")
                .bind(Uuid::new_v4().to_string())
                .bind(&edicao.pessoa_id)
                .bind(idi.trim())
                .execute(&mut *tx)
                .await?;
            alteracoes += 1;
        }
    }

    tx.commit().await?;

    Ok(ResultadoExecucaoIa {
        tipo: "edicao_pessoa".to_string(),
        entidade_id: edicao.pessoa_id.clone(),
        raiz_pessoa_id: Some(edicao.pessoa_id),
        titulo: edicao.pessoa_nome.clone(),
        itens_criados: alteracoes,
        mensagem: format!(
            "Ficha de {} atualizada com sucesso ({} campo(s)/atributo(s) gravado(s)).",
            edicao.pessoa_nome, alteracoes
        ),
        avisos: Vec::new(),
    })
}

/// Adiciona um parentesco (filho, cônjuge, pai ou mãe) a uma pessoa já cadastrada.
pub async fn executar_adicionar_parentesco_db(
    pool: &SqlitePool,
    par: PropostaAdicionarParentesco,
) -> Resultado<ResultadoExecucaoIa> {
    let mut tx = pool.begin().await?;
    let mut avisos = Vec::new();

    // 1. Obtém sexo da pessoa base
    let sexo_base: String = sqlx::query_scalar("SELECT sexo FROM pessoas WHERE id = ?")
        .bind(&par.pessoa_base_id)
        .fetch_optional(&mut *tx)
        .await?
        .unwrap_or_else(|| "M".to_string());

    // 2. Cria ou recupera o ID do familiar
    let familiar_id = if let Some(ref ex_id) = par.familiar_existente_id {
        ex_id.clone()
    } else {
        let fid = Uuid::new_v4().to_string();
        let sexo_valido = match par.familiar_sexo.as_str() {
            "M" | "F" | "X" | "U" => par.familiar_sexo.as_str(),
            _ => "U",
        };
        let is_vivo = par.familiar_ano_falecimento.is_none();
        sqlx::query(
            "INSERT INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico)
             VALUES (?, ?, ?, ?, ?, ?, 0, 0)",
        )
        .bind(&fid)
        .bind(par.familiar_nome.trim())
        .bind(par.familiar_sobrenome.as_deref().map(str::trim))
        .bind(sexo_valido)
        .bind(par.familiar_minibiografia.as_deref())
        .bind(is_vivo)
        .execute(&mut *tx)
        .await?;

        if let Some(ano_n) = par.familiar_ano_nascimento {
            sqlx::query(
                "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                 VALUES (?, ?, 'nascimento', ?, ?, 'exata', ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&fid)
            .bind(ano_n)
            .bind(ano_n)
            .bind(ano_n.to_string())
            .execute(&mut *tx)
            .await?;
        }
        if let Some(ano_m) = par.familiar_ano_falecimento {
            sqlx::query(
                "INSERT INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                 VALUES (?, ?, 'falecimento', ?, ?, 'exata', ?)",
            )
            .bind(Uuid::new_v4().to_string())
            .bind(&fid)
            .bind(ano_m)
            .bind(ano_m)
            .bind(ano_m.to_string())
            .execute(&mut *tx)
            .await?;
        }
        fid
    };

    let mut uniao_vinculada_id: Option<String> = None;

    match par.tipo_parentesco.as_str() {
        "conjuge" => {
            let (slot_m, slot_f) = if sexo_base == "F" {
                (familiar_id.clone(), par.pessoa_base_id.clone())
            } else {
                (par.pessoa_base_id.clone(), familiar_id.clone())
            };
            let uid = Uuid::new_v4().to_string();
            sqlx::query(
                "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
                 VALUES (?, ?, ?, 'casamento')",
            )
            .bind(&uid)
            .bind(&slot_m)
            .bind(&slot_f)
            .execute(&mut *tx)
            .await?;

            if let Some(ano_c) = par.ano_casamento {
                sqlx::query(
                    "INSERT INTO eventos (id, uniao_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
                     VALUES (?, ?, 'casamento', ?, ?, 'exata', ?)",
                )
                .bind(Uuid::new_v4().to_string())
                .bind(&uid)
                .bind(ano_c)
                .bind(ano_c)
                .bind(ano_c.to_string())
                .execute(&mut *tx)
                .await?;
            }
            uniao_vinculada_id = Some(uid);
        }
        "filho" | "filha" => {
            // Procura se a pessoa base já possui uma união para anexar o filho; se não, cria com placeholder
            let uniao_existente: Option<(String,)> = sqlx::query_as(
                "SELECT id FROM unioes WHERE slot_masculino_id = ?1 OR slot_feminino_id = ?1 LIMIT 1",
            )
            .bind(&par.pessoa_base_id)
            .fetch_optional(&mut *tx)
            .await?;

            let uid = match uniao_existente {
                Some((u,)) => u,
                None => {
                    let ph_id = Uuid::new_v4().to_string();
                    let (slot_m, slot_f, ph_sexo, ph_nome) = if sexo_base == "F" {
                        (ph_id.clone(), par.pessoa_base_id.clone(), "M", "Desconhecido")
                    } else {
                        (par.pessoa_base_id.clone(), ph_id.clone(), "F", "Desconhecida")
                    };
                    sqlx::query(
                        "INSERT INTO pessoas (id, nome, sexo, is_vivo, is_placeholder, is_publico)
                         VALUES (?, ?, ?, 0, 1, 0)",
                    )
                    .bind(&ph_id)
                    .bind(ph_nome)
                    .bind(ph_sexo)
                    .execute(&mut *tx)
                    .await?;

                    let nova_u = Uuid::new_v4().to_string();
                    sqlx::query(
                        "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
                         VALUES (?, ?, ?, 'casamento')",
                    )
                    .bind(&nova_u)
                    .bind(&slot_m)
                    .bind(&slot_f)
                    .execute(&mut *tx)
                    .await?;
                    nova_u
                }
            };

            let ja_tem_pais: Option<(String,)> =
                sqlx::query_as("SELECT uniao_id FROM uniao_filhos WHERE pessoa_id = ?")
                    .bind(&familiar_id)
                    .fetch_optional(&mut *tx)
                    .await?;

            if ja_tem_pais.is_some() {
                avisos.push("Esta pessoa já possuía pais registrados no acervo.".to_string());
            } else {
                sqlx::query(
                    "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
                     VALUES (?, ?, 'biologico', 1)",
                )
                .bind(&uid)
                .bind(&familiar_id)
                .execute(&mut *tx)
                .await?;
            }
            uniao_vinculada_id = Some(uid);
        }
        "pai" | "mae" => {
            // Verifica se a pessoa base já está em uma uniao_filhos
            let uniao_pais: Option<(String,)> =
                sqlx::query_as("SELECT uniao_id FROM uniao_filhos WHERE pessoa_id = ? LIMIT 1")
                    .bind(&par.pessoa_base_id)
                    .fetch_optional(&mut *tx)
                    .await?;

            if let Some((uid,)) = uniao_pais {
                let row_u = sqlx::query(
                    "SELECT slot_masculino_id, slot_feminino_id FROM unioes WHERE id = ?",
                )
                .bind(&uid)
                .fetch_one(&mut *tx)
                .await?;
                let slot_m: String = row_u.get("slot_masculino_id");
                let slot_f: String = row_u.get("slot_feminino_id");

                // Preencher um slot vazio e TROCAR um pai ja registrado sao
                // coisas diferentes. Substituir sem perguntar desliga da uniao
                // alguem que o usuario registrou -- a pessoa continua no
                // acervo, mas deixa de ser pai ou mae daqueles filhos, e nada
                // na tela diz isso. Num programa que existe para guardar a
                // memoria da familia, apagar um laco em silencio e o pior
                // defeito possivel. Placeholder pode ser trocado a vontade:
                // ele e invencao nossa para o slot nao ficar vazio.
                let (slot_atual, rotulo) = if par.tipo_parentesco == "pai" {
                    (slot_m.clone(), "pai")
                } else {
                    (slot_f.clone(), "mãe")
                };

                let ocupante: Option<(String, i64)> = sqlx::query_as(
                    "SELECT COALESCE(nome,''), is_placeholder FROM pessoas WHERE id = ?",
                )
                .bind(&slot_atual)
                .fetch_optional(&mut *tx)
                .await?;

                let ocupado_por_pessoa_real = ocupante
                    .as_ref()
                    .map(|(_, ph)| *ph == 0)
                    .unwrap_or(false);

                if ocupado_por_pessoa_real && slot_atual != familiar_id {
                    let nome_atual = ocupante
                        .map(|(n, _)| n)
                        .filter(|n| !n.trim().is_empty())
                        .unwrap_or_else(|| "alguém".to_string());
                    avisos.push(format!(
                        "{} já tem {} registrado(a): {}. O vínculo não foi trocado — para substituir, desfaça o atual na tela de conexões.",
                        par.pessoa_base_nome, rotulo, nome_atual
                    ));
                } else if slot_atual != familiar_id {
                    let coluna = if par.tipo_parentesco == "pai" {
                        "slot_masculino_id"
                    } else {
                        "slot_feminino_id"
                    };
                    sqlx::query(&format!("UPDATE unioes SET {} = ? WHERE id = ?", coluna))
                        .bind(&familiar_id)
                        .bind(&uid)
                        .execute(&mut *tx)
                        .await?;
                    let _ = sqlx::query("DELETE FROM pessoas WHERE id = ? AND is_placeholder = 1")
                        .bind(&slot_atual)
                        .execute(&mut *tx)
                        .await;
                }
                uniao_vinculada_id = Some(uid);
            } else {
                let ph_id = Uuid::new_v4().to_string();
                let (slot_m, slot_f, ph_sexo, ph_nome) = if par.tipo_parentesco == "pai" {
                    (familiar_id.clone(), ph_id.clone(), "F", "Desconhecida")
                } else {
                    (ph_id.clone(), familiar_id.clone(), "M", "Desconhecido")
                };
                sqlx::query(
                    "INSERT INTO pessoas (id, nome, sexo, is_vivo, is_placeholder, is_publico)
                     VALUES (?, ?, ?, 0, 1, 0)",
                )
                .bind(&ph_id)
                .bind(ph_nome)
                .bind(ph_sexo)
                .execute(&mut *tx)
                .await?;

                let nova_u = Uuid::new_v4().to_string();
                sqlx::query(
                    "INSERT INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo)
                     VALUES (?, ?, ?, 'casamento')",
                )
                .bind(&nova_u)
                .bind(&slot_m)
                .bind(&slot_f)
                .execute(&mut *tx)
                .await?;

                sqlx::query(
                    "INSERT INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
                     VALUES (?, ?, 'biologico', 1)",
                )
                .bind(&nova_u)
                .bind(&par.pessoa_base_id)
                .execute(&mut *tx)
                .await?;
                uniao_vinculada_id = Some(nova_u);
            }
        }
        _ => {}
    }

    if let Some(ref arv_id) = par.arvore_id {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
             VALUES (lower(hex(randomblob(16))), ?, ?, NULL)",
        )
        .bind(arv_id)
        .bind(&familiar_id)
        .execute(&mut *tx)
        .await?;

        if let Some(ref uid) = uniao_vinculada_id {
            sqlx::query(
                "INSERT OR IGNORE INTO arvore_membros (id, arvore_id, pessoa_id, uniao_id)
                 VALUES (lower(hex(randomblob(16))), ?, NULL, ?)",
            )
            .bind(arv_id)
            .bind(uid)
            .execute(&mut *tx)
            .await?;
        }
    }

    tx.commit().await?;

    if let Some(ref arv_id) = par.arvore_id {
        let _ = sincronizar_membros_arvore(pool, arv_id, Some(&par.pessoa_base_id)).await;
    }

    let nome_fam_completo = format!(
        "{} {}",
        par.familiar_nome.trim(),
        par.familiar_sobrenome.as_deref().unwrap_or("")
    )
    .trim()
    .to_string();

    Ok(ResultadoExecucaoIa {
        tipo: "parentesco".to_string(),
        entidade_id: par.arvore_id.clone().unwrap_or_else(|| par.pessoa_base_id.clone()),
        raiz_pessoa_id: Some(par.pessoa_base_id.clone()),
        titulo: format!("{} ({})", nome_fam_completo, par.tipo_parentesco),
        itens_criados: 1,
        mensagem: format!(
            "Vínculo de {} ({}) adicionado com sucesso a {}.",
            par.tipo_parentesco, nome_fam_completo, par.pessoa_base_nome
        ),
        avisos,
    })
}

/// Adiciona novos marcos a uma Linha do Tempo já existente no acervo.
pub async fn executar_editar_linha_tempo_db(
    pool: &SqlitePool,
    ed: PropostaEditarLinhaTempo,
) -> Resultado<ResultadoExecucaoIa> {
    let bloqueada: bool = sqlx::query_scalar(
        "SELECT (COALESCE(is_bloqueada, 0) != 0 OR COALESCE(is_contexto, 0) != 0) FROM linhas_tempo WHERE id = ?",
    )
    .bind(&ed.linha_id)
    .fetch_optional(pool)
    .await?
    .unwrap_or(false);

    if bloqueada {
        return Err(ErroDominio::Validacao(format!(
            "A linha do tempo '{}' é uma linha histórica de referência (somente leitura) e não pode receber marcos.",
            ed.titulo_linha
        )));
    }

    let mut tx = pool.begin().await?;
    let mut criados = 0usize;

    for m in &ed.marcos_para_adicionar {
        let mid = Uuid::new_v4().to_string();
        sqlx::query(
            "INSERT INTO eventos_linha (id, linha_id, data_periodo_texto, titulo, descricao, relevancia, ano_inicio, ano_fim)
             VALUES (?, ?, ?, ?, ?, 'alta', ?, ?)",
        )
        .bind(&mid)
        .bind(&ed.linha_id)
        .bind(&m.data_periodo_texto)
        .bind(m.titulo.trim())
        .bind(m.descricao.as_deref())
        .bind(m.ano_inicio)
        .bind(m.ano_fim.or(Some(m.ano_inicio)))
        .execute(&mut *tx)
        .await?;
        criados += 1;
    }

    tx.commit().await?;

    Ok(ResultadoExecucaoIa {
        tipo: "linha_tempo".to_string(),
        entidade_id: ed.linha_id,
        raiz_pessoa_id: None,
        titulo: ed.titulo_linha.clone(),
        itens_criados: criados,
        mensagem: format!(
            "Linha do tempo '{}' atualizada com {} novo(s) marco(s).",
            ed.titulo_linha, criados
        ),
        avisos: Vec::new(),
    })
}

#[cfg(test)]
mod testes {
    use super::*;
    use crate::domain::assistente_ia::PropostaAdicionarParentesco;
    use sqlx::sqlite::SqlitePoolOptions;

    async fn banco() -> SqlitePool {
        let p = SqlitePoolOptions::new()
            .max_connections(1)
            .connect("sqlite::memory:")
            .await
            .expect("banco em memória");
        sqlx::migrate!("./migrations").run(&p).await.expect("migrations");
        p
    }

    fn proposta_pai(nome: &str) -> PropostaAdicionarParentesco {
        PropostaAdicionarParentesco {
            pessoa_base_id: "filho".into(),
            pessoa_base_nome: "Filho".into(),
            arvore_id: None,
            tipo_parentesco: "pai".into(),
            familiar_existente_id: None,
            familiar_nome: nome.into(),
            familiar_sobrenome: None,
            familiar_sexo: "M".into(),
            familiar_ano_nascimento: None,
            familiar_ano_falecimento: None,
            familiar_minibiografia: None,
            ano_casamento: None,
        }
    }

    /// Pai já registrado não é trocado por baixo do usuário.
    ///
    /// O código fazia `UPDATE unioes SET slot_masculino_id` sem olhar quem
    /// estava no slot: um pai real registrado era desligado da união, sem
    /// aviso, e virava uma pessoa sem família no acervo. Num programa feito
    /// para guardar a memória da família, apagar um laço em silêncio é o pior
    /// defeito possível — pior que recusar a ação.
    #[tokio::test]
    async fn pai_ja_registrado_nao_e_substituido_em_silencio() {
        let p = banco().await;
        sqlx::query(
            "INSERT INTO pessoas (id,nome,sexo,is_vivo,is_placeholder,is_publico) VALUES
             ('filho','Filho','M',1,0,0),
             ('pai_antigo','Pai Antigo','M',0,0,0),
             ('mae','Mae','F',0,0,0)",
        )
        .execute(&p)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO unioes (id,slot_masculino_id,slot_feminino_id,estado_vinculo)
             VALUES ('u1','pai_antigo','mae','casamento')",
        )
        .execute(&p)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id,pessoa_id,tipo_vinculo,ordem)
             VALUES ('u1','filho','biologico',1)",
        )
        .execute(&p)
        .await
        .unwrap();

        let r = executar_adicionar_parentesco_db(&p, proposta_pai("Pai Novo"))
            .await
            .expect("execução");

        let slot: String = sqlx::query_scalar("SELECT slot_masculino_id FROM unioes WHERE id='u1'")
            .fetch_one(&p)
            .await
            .unwrap();
        assert_eq!(slot, "pai_antigo", "o pai registrado foi trocado sem permissão");
        assert!(
            r.avisos.iter().any(|a| a.contains("já tem pai")),
            "a troca foi recusada, mas o usuário não foi avisado: {:?}",
            r.avisos
        );
    }

    /// Slot com placeholder continua sendo preenchido normalmente.
    ///
    /// Placeholder é invenção nossa para o slot não ficar vazio; trocá-lo pelo
    /// nome real é exatamente o fluxo que se quer. A guarda acima não pode
    /// atrapalhar este caso.
    #[tokio::test]
    async fn placeholder_no_slot_e_substituido_pelo_pai_real() {
        let p = banco().await;
        sqlx::query(
            "INSERT INTO pessoas (id,nome,sexo,is_vivo,is_placeholder,is_publico) VALUES
             ('filho','Filho','M',1,0,0),
             ('ph','Desconhecido','M',0,1,0),
             ('mae','Mae','F',0,0,0)",
        )
        .execute(&p)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO unioes (id,slot_masculino_id,slot_feminino_id,estado_vinculo)
             VALUES ('u1','ph','mae','casamento')",
        )
        .execute(&p)
        .await
        .unwrap();
        sqlx::query(
            "INSERT INTO uniao_filhos (uniao_id,pessoa_id,tipo_vinculo,ordem)
             VALUES ('u1','filho','biologico',1)",
        )
        .execute(&p)
        .await
        .unwrap();

        let r = executar_adicionar_parentesco_db(&p, proposta_pai("Pai Real"))
            .await
            .expect("execução");

        let nome: String = sqlx::query_scalar(
            "SELECT p.nome FROM unioes u JOIN pessoas p ON p.id = u.slot_masculino_id
             WHERE u.id='u1'",
        )
        .fetch_one(&p)
        .await
        .unwrap();
        assert_eq!(nome, "Pai Real", "o placeholder deveria ter dado lugar ao pai real");
        assert!(
            !r.avisos.iter().any(|a| a.contains("já tem pai")),
            "trocar placeholder não é substituição e não deve gerar aviso"
        );
    }

    #[tokio::test]
    async fn recusa_editar_pessoa_publica_ou_linha_de_contexto_bloqueada() {
        let p = banco().await;
        sqlx::query(
            "INSERT INTO pessoas (id,nome,sobrenome,sexo,minibiografia,is_vivo,is_placeholder,is_publico)
             VALUES ('pub_machado','Machado','de Assis','M','Biografia curada original',0,0,1)",
        )
        .execute(&p)
        .await
        .unwrap();

        let res_pessoa = executar_editar_pessoa_db(
            &p,
            PropostaEditarPessoa {
                pessoa_id: "pub_machado".into(),
                pessoa_nome: "Machado de Assis".into(),
                arvore_id: None,
                nova_minibiografia: Some("Texto alterado".into()),
                ano_nascimento: None,
                ano_falecimento: None,
                nova_profissao: None,
                nova_obra_titulo: None,
                nova_obra_ano: None,
                novo_apelido: None,
                nova_escolaridade: None,
                nova_religiao: None,
                novo_idioma: None,
                resumo_alteracoes: Vec::new(),
            },
        )
        .await;
        assert!(
            res_pessoa.is_err(),
            "deveria recusar edição de pessoa pública curada"
        );

        let linha_bloqueada_id: String = sqlx::query_scalar(
            "SELECT id FROM linhas_tempo WHERE is_bloqueada = 1 OR is_contexto = 1 LIMIT 1",
        )
        .fetch_one(&p)
        .await
        .unwrap();

        let res_linha = executar_editar_linha_tempo_db(
            &p,
            PropostaEditarLinhaTempo {
                linha_id: linha_bloqueada_id,
                titulo_linha: "História do Brasil".into(),
                marcos_para_adicionar: vec![crate::domain::assistente_ia::ItemMarcoProposto {
                    ano_inicio: 2026,
                    ano_fim: None,
                    data_periodo_texto: "2026".into(),
                    titulo: "Marco indevido".into(),
                    descricao: None,
                    relevancia: "alta".into(),
                    trecho_evidencia: "2026".into(),
                }],
            },
        )
        .await;
        assert!(
            res_linha.is_err(),
            "deveria recusar inserção de marco em linha de contexto bloqueada"
        );
    }
}
