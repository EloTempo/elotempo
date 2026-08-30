//! Monta o GEDCOM a partir do acervo (fatia 08).
//!
//! Três decisões atravessam este arquivo:
//!
//! 1. **Placeholder nunca vira `INDI`.** É nó técnico nosso, não alguém que
//!    existiu. Um `FAM` cujo pai é placeholder simplesmente omite o `HUSB` —
//!    GEDCOM válido, e o que a seção 2.2 já previa.
//! 2. **Nada que o usuário escreveu se perde.** O `DATE` tem gramática fechada;
//!    quando o texto original não é reproduzível por ela, ele sai numa `NOTE`.
//! 3. **Ocultar vivas não é omiti-las.** Apagar o `INDI` de alguém vivo
//!    desligaria os filhos da árvore de quem recebe o arquivo.

use std::collections::HashMap;

use serde::Deserialize;
use sqlx::{Row, SqlitePool};

use super::escritor::{data_gedcom, Escritor};
use crate::domain::datas::{compor_texto, DataEscolhida};
use crate::domain::erros::Resultado;
use crate::domain::eventos_cmds::tipos;

#[derive(Debug, Deserialize, Default)]
pub struct OpcoesExportacao {
    /// `None` = acervo inteiro; `Some(id)` = a árvore em volta dessa pessoa.
    pub raiz_id: Option<String>,
    pub ocultar_vivas: bool,
    /// Empacotar num GEDZip com a pasta de mídia (seção 4).
    pub incluir_midia: bool,
}

/// Resultado da montagem, antes de gravar em disco.
pub struct Exportacao {
    pub texto: String,
    pub pessoas: usize,
    pub unioes: usize,
    /// Caminhos relativos da mídia referenciada, para o GEDZip.
    pub midia: Vec<String>,
    pub vivas_ocultadas: usize,
}

/// Nossos ids são UUID, que não cabem numa xref. Viram `I1`, `F1` sequenciais.
struct Referencias {
    pessoas: HashMap<String, String>,
    unioes: HashMap<String, String>,
}

/// Tag GEDCOM de cada tipo de evento nosso. Tipo desconhecido vira `EVEN`
/// genérico com `TYPE`, que é como o padrão comporta o que não previu.
fn tag_do_evento(tipo: &str) -> (&'static str, bool) {
    match tipo {
        t if t == tipos::NASCIMENTO => ("BIRT", false),
        t if t == tipos::BATISMO => ("BAPM", false),
        t if t == tipos::FALECIMENTO => ("DEAT", false),
        t if t == tipos::SEPULTAMENTO => ("BURI", false),
        t if t == tipos::CASAMENTO => ("MARR", false),
        _ => ("EVEN", true),
    }
}

/// O `NAME` do GEDCOM marca o sobrenome entre barras.
fn nome_gedcom(nome: &str, sobrenome: Option<&str>) -> String {
    match sobrenome.map(str::trim).filter(|s| !s.is_empty()) {
        Some(s) => format!("{} /{}/", nome.trim(), s),
        None => nome.trim().to_string(),
    }
}

/// Tipo de nome nosso → `NAME.TYPE` do GEDCOM.
///
/// Público, religioso e artístico não têm tipo próprio no padrão e caem todos
/// em `AKA` — a distinção que fazemos internamente sobrevive na `NOTE`.
fn tipo_de_nome(tipo: &str) -> &'static str {
    match tipo {
        "nascimento" => "BIRTH",
        "casada" => "MARRIED",
        "solteira" => "MAIDEN",
        "profissional" => "PROFESSIONAL",
        "imigracao" => "IMMIGRANT",
        _ => "AKA",
    }
}

pub async fn montar(pool: &SqlitePool, opcoes: &OpcoesExportacao) -> Resultado<Exportacao> {
    // ------------------------------------------------------------------
    // 1. Quem entra
    // ------------------------------------------------------------------
    let ids: Vec<String> = match &opcoes.raiz_id {
        None => sqlx::query_scalar("SELECT id FROM pessoas")
            .fetch_all(pool)
            .await?,
        Some(raiz) => {
            sqlx::query_scalar(
                r#"
                WITH RECURSIVE
                acima(id) AS (
                    SELECT ?1
                    UNION
                    SELECT v.progenitor FROM (
                        SELECT f.pessoa_id AS filho, u.slot_masculino_id AS progenitor
                          FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                        UNION ALL
                        SELECT f.pessoa_id, u.slot_feminino_id
                          FROM uniao_filhos f JOIN unioes u ON u.id = f.uniao_id
                    ) v JOIN acima a ON v.filho = a.id
                ),
                abaixo(id) AS (
                    SELECT ?1
                    UNION
                    SELECT f.pessoa_id FROM abaixo d
                    JOIN unioes u ON u.slot_masculino_id = d.id OR u.slot_feminino_id = d.id
                    JOIN uniao_filhos f ON f.uniao_id = u.id
                ),
                nucleo(id) AS (SELECT id FROM acima UNION SELECT id FROM abaixo)
                SELECT id FROM nucleo
                UNION
                SELECT u.slot_masculino_id FROM unioes u JOIN nucleo n ON u.slot_feminino_id = n.id
                UNION
                SELECT u.slot_feminino_id FROM unioes u JOIN nucleo n ON u.slot_masculino_id = n.id
                "#,
            )
            .bind(raiz)
            .fetch_all(pool)
            .await?
        }
    };

    let mut escritor = Escritor::novo();
    cabecalho(&mut escritor);

    if ids.is_empty() {
        return Ok(Exportacao {
            texto: escritor.finalizar(),
            pessoas: 0,
            unioes: 0,
            midia: vec![],
            vivas_ocultadas: 0,
        });
    }

    let marcadores = vec!["?"; ids.len()].join(",");

    // ------------------------------------------------------------------
    // 2. As pessoas, e as xrefs
    // ------------------------------------------------------------------
    let sql = format!(
        "SELECT id, nome, sobrenome, sexo, is_vivo, is_placeholder, minibiografia
         FROM pessoas WHERE id IN ({marcadores}) ORDER BY rowid"
    );
    let mut q = sqlx::query(&sql);
    for id in &ids {
        q = q.bind(id);
    }
    let linhas_pessoas = q.fetch_all(pool).await?;

    let mut refs = Referencias {
        pessoas: HashMap::new(),
        unioes: HashMap::new(),
    };

    struct Pessoa {
        id: String,
        nome: String,
        sobrenome: Option<String>,
        sexo: String,
        is_vivo: bool,
        minibiografia: Option<String>,
    }

    let mut pessoas: Vec<Pessoa> = Vec::new();
    for l in linhas_pessoas {
        // Placeholder não vira INDI, e por isso nem ganha xref.
        if l.try_get::<bool, _>("is_placeholder")? {
            continue;
        }
        let id: String = l.try_get("id")?;
        refs.pessoas
            .insert(id.clone(), format!("I{}", refs.pessoas.len() + 1));
        pessoas.push(Pessoa {
            id,
            nome: l.try_get("nome")?,
            sobrenome: l.try_get("sobrenome")?,
            sexo: l.try_get("sexo")?,
            is_vivo: l.try_get("is_vivo")?,
            minibiografia: l.try_get("minibiografia")?,
        });
    }

    // ------------------------------------------------------------------
    // 3. Uniões que ligam gente do recorte
    // ------------------------------------------------------------------
    let sql = format!(
        "SELECT id, slot_masculino_id, slot_feminino_id, estado_vinculo
         FROM unioes
         WHERE slot_masculino_id IN ({m}) OR slot_feminino_id IN ({m})
         ORDER BY rowid",
        m = marcadores
    );
    let mut q = sqlx::query(&sql);
    for id in &ids {
        q = q.bind(id);
    }
    for id in &ids {
        q = q.bind(id);
    }

    struct Uniao {
        id: String,
        masculino: String,
        feminino: String,
    }
    let mut unioes: Vec<Uniao> = Vec::new();
    for l in q.fetch_all(pool).await? {
        let id: String = l.try_get("id")?;
        refs.unioes
            .insert(id.clone(), format!("F{}", refs.unioes.len() + 1));
        unioes.push(Uniao {
            id,
            masculino: l.try_get("slot_masculino_id")?,
            feminino: l.try_get("slot_feminino_id")?,
        });
    }

    // ------------------------------------------------------------------
    // 4. Dados auxiliares, em lote
    // ------------------------------------------------------------------
    let eventos = eventos_por_pessoa(pool, &ids, &marcadores).await?;
    let eventos_uniao = eventos_por_uniao(pool, &refs).await?;
    let nomes = nomes_por_pessoa(pool, &ids, &marcadores).await?;
    let atributos = atributos_por_pessoa(pool, &ids, &marcadores).await?;
    let midia_por_pessoa = midia_por_pessoa(pool, &ids, &marcadores).await?;

    // Filhos e vínculos de família
    let mut filhos_da_uniao: HashMap<String, Vec<(String, String)>> = HashMap::new();
    let mut uniao_de_origem: HashMap<String, (String, String)> = HashMap::new();
    if !refs.unioes.is_empty() {
        let ids_uniao: Vec<&String> = refs.unioes.keys().collect();
        let mu = vec!["?"; ids_uniao.len()].join(",");
        let sql = format!(
            "SELECT uniao_id, pessoa_id, tipo_vinculo FROM uniao_filhos
             WHERE uniao_id IN ({mu}) ORDER BY ordem"
        );
        let mut q = sqlx::query(&sql);
        for id in &ids_uniao {
            q = q.bind(*id);
        }
        for l in q.fetch_all(pool).await? {
            let uniao_id: String = l.try_get("uniao_id")?;
            let pessoa_id: String = l.try_get("pessoa_id")?;
            let vinculo: String = l.try_get("tipo_vinculo")?;
            filhos_da_uniao
                .entry(uniao_id.clone())
                .or_default()
                .push((pessoa_id.clone(), vinculo.clone()));
            uniao_de_origem.insert(pessoa_id, (uniao_id, vinculo));
        }
    }

    // Em quais uniões cada pessoa é cônjuge
    let mut unioes_da_pessoa: HashMap<String, Vec<String>> = HashMap::new();
    for u in &unioes {
        for lado in [&u.masculino, &u.feminino] {
            unioes_da_pessoa
                .entry(lado.clone())
                .or_default()
                .push(u.id.clone());
        }
    }

    // ------------------------------------------------------------------
    // 5. Os INDI
    // ------------------------------------------------------------------
    let mut vivas_ocultadas = 0usize;
    let mut midia_usada: Vec<String> = Vec::new();

    for p in &pessoas {
        let xref = refs.pessoas.get(&p.id).unwrap().clone();
        escritor.registro(&xref, "INDI");

        // Ocultar vivas: a pessoa continua no arquivo, sem os dados. Omitir o
        // INDI desligaria os filhos dela da árvore de quem recebe.
        let ocultar = opcoes.ocultar_vivas && p.is_vivo;
        if ocultar {
            vivas_ocultadas += 1;
            let rotulo = if p.sexo == "F" { "Viva" } else { "Vivo" };
            escritor.campo(1, "NAME", rotulo);
            escritor.campo(1, "SEX", &p.sexo);
        } else {
            escritor.campo(1, "NAME", &nome_gedcom(&p.nome, p.sobrenome.as_deref()));

            for n in nomes.get(&p.id).into_iter().flatten() {
                escritor.campo(1, "NAME", &nome_gedcom(&n.nome, n.sobrenome.as_deref()));
                escritor.campo(2, "TYPE", tipo_de_nome(&n.tipo));
                escritor.campo_opcional(2, "NOTE", n.periodo.as_deref());
            }

            for apelido in atributos.apelidos.get(&p.id).into_iter().flatten() {
                escritor.campo(1, "NICK", apelido);
            }

            escritor.campo(1, "SEX", &p.sexo);

            for e in eventos.get(&p.id).into_iter().flatten() {
                escrever_evento(&mut escritor, e);
            }

            for (tag, valores) in [
                ("RELI", atributos.religioes.get(&p.id)),
                ("EDUC", atributos.escolaridade.get(&p.id)),
                ("OCCU", atributos.profissoes.get(&p.id)),
                ("NATI", atributos.nacionalidades.get(&p.id)),
                // Idioma falado não tem tag padrão; a seção 2.5 já previa a
                // extensão `_LANG`.
                ("_LANG", atributos.idiomas.get(&p.id)),
            ] {
                for v in valores.into_iter().flatten() {
                    escritor.campo(1, tag, v);
                }
            }

            escritor.campo_opcional(1, "NOTE", p.minibiografia.as_deref());

            for doc in midia_por_pessoa.get(&p.id).into_iter().flatten() {
                escritor.tag(1, "OBJE");
                escritor.campo(2, "FILE", &doc.caminho);
                escritor.campo_opcional(3, "TITL", doc.titulo.as_deref());
                if !midia_usada.contains(&doc.caminho) {
                    midia_usada.push(doc.caminho.clone());
                }
            }
        }

        // Os vínculos de família saem sempre — é o que mantém a árvore inteira
        // mesmo com as pessoas vivas ocultadas.
        if let Some((uniao_id, vinculo)) = uniao_de_origem.get(&p.id) {
            if let Some(fam) = refs.unioes.get(uniao_id) {
                escritor.referencia(1, "FAMC", fam);
                if vinculo != "biologico" {
                    escritor.campo(2, "PEDI", pedigree(vinculo));
                }
            }
        }
        for uniao_id in unioes_da_pessoa.get(&p.id).into_iter().flatten() {
            if let Some(fam) = refs.unioes.get(uniao_id) {
                escritor.referencia(1, "FAMS", fam);
            }
        }
    }

    // ------------------------------------------------------------------
    // 6. Os FAM
    // ------------------------------------------------------------------
    for u in &unioes {
        let xref = refs.unioes.get(&u.id).unwrap().clone();
        escritor.registro(&xref, "FAM");

        // Placeholder: o lado simplesmente não é emitido.
        if let Some(h) = refs.pessoas.get(&u.masculino) {
            escritor.referencia(1, "HUSB", h);
        }
        if let Some(w) = refs.pessoas.get(&u.feminino) {
            escritor.referencia(1, "WIFE", w);
        }

        for (filho_id, _) in filhos_da_uniao.get(&u.id).into_iter().flatten() {
            if let Some(c) = refs.pessoas.get(filho_id) {
                escritor.referencia(1, "CHIL", c);
            }
        }

        for e in eventos_uniao.get(&u.id).into_iter().flatten() {
            escrever_evento(&mut escritor, e);
        }
    }

    Ok(Exportacao {
        texto: escritor.finalizar(),
        pessoas: pessoas.len(),
        unioes: unioes.len(),
        midia: midia_usada,
        vivas_ocultadas,
    })
}

fn pedigree(vinculo: &str) -> &'static str {
    match vinculo {
        "adotado" => "ADOPTED",
        "enteado" => "STEP",
        "tutelado" => "FOSTER",
        _ => "BIRTH",
    }
}

/// Cabeçalho do arquivo.
///
/// A VERIFICAR antes de considerar o exportador fechado (spec da fatia 08,
/// seção 10): a estrutura exata que o 7.0 exige aqui. O que sai abaixo é o que
/// tenho confiança de ser válido; `CHAR` não é emitido porque o 7.0 é UTF-8 por
/// definição.
fn cabecalho(e: &mut Escritor) {
    e.tag(0, "HEAD");
    e.tag(1, "GEDC");
    e.campo(2, "VERS", "7.0");
    e.campo(1, "SOUR", "ARVORE_GENEALOGICA");
    e.campo(2, "NAME", "Árvore Genealógica");
    e.campo(2, "VERS", env!("CARGO_PKG_VERSION"));
}

struct EventoExportavel {
    tipo: String,
    data_texto: Option<String>,
    qualificador: String,
    dia: Option<i64>,
    mes: Option<i64>,
    ano_inicio: Option<i64>,
    ano_fim: Option<i64>,
    local: Option<String>,
    codigo_ibge: Option<String>,
    nota: Option<String>,
}

/// Emite um evento, preservando o texto da data quando o `DATE` não o alcança.
fn escrever_evento(e: &mut Escritor, ev: &EventoExportavel) {
    let (tag, generico) = tag_do_evento(&ev.tipo);
    e.tag(1, tag);
    if generico {
        e.campo(2, "TYPE", &ev.tipo);
    }

    let data = data_gedcom(&ev.qualificador, ev.dia, ev.mes, ev.ano_inicio, ev.ano_fim);
    if let Some(d) = &data {
        e.campo(2, "DATE", d);
    }

    e.campo_opcional(2, "PLAC", ev.local.as_deref());
    if let Some(ibge) = &ev.codigo_ibge {
        e.campo(3, "_IBGE", ibge);
    }

    // Nada do que o usuário escreveu se perde. Se o texto original não for
    // reproduzível pelo DATE emitido, ele vai para uma NOTE — inclusive quando
    // não houve DATE nenhum ("na época da guerra").
    let reproduzido = compor_texto(&DataEscolhida {
        qualificador: Some(ev.qualificador.clone()),
        dia: ev.dia.map(|v| v as i32),
        mes: ev.mes.map(|v| v as i32),
        ano: ano_dito(&ev.qualificador, ev.ano_inicio, ev.ano_fim),
        ano_fim: ev.ano_fim.map(|v| v as i32),
        texto_livre: None,
    });

    if let Some(original) = ev.data_texto.as_deref().map(str::trim) {
        if !original.is_empty() && original != reproduzido {
            e.campo(2, "NOTE", &format!("Data como registrada: {original}"));
        }
    }

    e.campo_opcional(2, "NOTE", ev.nota.as_deref());
}

/// O ano que a pessoa disse, desfazendo a margem do aproximado.
fn ano_dito(qualificador: &str, inicio: Option<i64>, fim: Option<i64>) -> Option<i32> {
    match qualificador {
        "cerca_de" => match (inicio, fim) {
            (Some(de), Some(ate)) => Some(((de + ate) / 2) as i32),
            (Some(a), None) | (None, Some(a)) => Some(a as i32),
            _ => None,
        },
        "antes_de" => fim.map(|a| a as i32),
        _ => inicio.map(|a| a as i32),
    }
}

// ---------------------------------------------------------------------------
// Consultas auxiliares, todas em lote
// ---------------------------------------------------------------------------

async fn eventos_por_pessoa(
    pool: &SqlitePool,
    ids: &[String],
    marcadores: &str,
) -> Resultado<HashMap<String, Vec<EventoExportavel>>> {
    let sql = format!(
        "SELECT e.pessoa_id, e.tipo_evento, e.data_texto, e.data_qualificador,
                e.dia_inicio, e.mes_inicio, e.ano_inicio, e.ano_fim, e.nota,
                COALESCE(e.rotulo_historico_livre,
                         CASE WHEN l.id IS NULL THEN NULL
                              WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                              ELSE l.nome || ', ' || p.nome END) AS local,
                l.codigo_ibge
         FROM eventos e
         LEFT JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises p ON p.id = l.pais_id
         WHERE e.pessoa_id IN ({marcadores})
         ORDER BY (e.ano_inicio IS NULL), e.ano_inicio"
    );
    let mut q = sqlx::query(&sql);
    for id in ids {
        q = q.bind(id);
    }

    let mut mapa: HashMap<String, Vec<EventoExportavel>> = HashMap::new();
    for l in q.fetch_all(pool).await? {
        let pessoa_id: String = l.try_get("pessoa_id")?;
        mapa.entry(pessoa_id).or_default().push(EventoExportavel {
            tipo: l.try_get("tipo_evento")?,
            data_texto: l.try_get("data_texto")?,
            qualificador: l.try_get("data_qualificador")?,
            dia: l.try_get("dia_inicio")?,
            mes: l.try_get("mes_inicio")?,
            ano_inicio: l.try_get("ano_inicio")?,
            ano_fim: l.try_get("ano_fim")?,
            local: l.try_get("local")?,
            codigo_ibge: l.try_get("codigo_ibge")?,
            nota: l.try_get("nota")?,
        });
    }
    Ok(mapa)
}

async fn eventos_por_uniao(
    pool: &SqlitePool,
    refs: &Referencias,
) -> Resultado<HashMap<String, Vec<EventoExportavel>>> {
    let mut mapa: HashMap<String, Vec<EventoExportavel>> = HashMap::new();
    if refs.unioes.is_empty() {
        return Ok(mapa);
    }

    let ids: Vec<&String> = refs.unioes.keys().collect();
    let m = vec!["?"; ids.len()].join(",");
    let sql = format!(
        "SELECT e.uniao_id, e.tipo_evento, e.data_texto, e.data_qualificador,
                e.dia_inicio, e.mes_inicio, e.ano_inicio, e.ano_fim, e.nota,
                COALESCE(e.rotulo_historico_livre,
                         CASE WHEN l.id IS NULL THEN NULL
                              WHEN l.uf IS NOT NULL THEN l.nome || ', ' || l.uf
                              ELSE l.nome || ', ' || p.nome END) AS local,
                l.codigo_ibge
         FROM eventos e
         LEFT JOIN locais l ON l.id = e.local_id
         LEFT JOIN paises p ON p.id = l.pais_id
         WHERE e.uniao_id IN ({m})"
    );
    let mut q = sqlx::query(&sql);
    for id in &ids {
        q = q.bind(*id);
    }

    for l in q.fetch_all(pool).await? {
        let uniao_id: String = l.try_get("uniao_id")?;
        mapa.entry(uniao_id).or_default().push(EventoExportavel {
            tipo: l.try_get("tipo_evento")?,
            data_texto: l.try_get("data_texto")?,
            qualificador: l.try_get("data_qualificador")?,
            dia: l.try_get("dia_inicio")?,
            mes: l.try_get("mes_inicio")?,
            ano_inicio: l.try_get("ano_inicio")?,
            ano_fim: l.try_get("ano_fim")?,
            local: l.try_get("local")?,
            codigo_ibge: l.try_get("codigo_ibge")?,
            nota: l.try_get("nota")?,
        });
    }
    Ok(mapa)
}

struct NomeExportavel {
    tipo: String,
    nome: String,
    sobrenome: Option<String>,
    periodo: Option<String>,
}

async fn nomes_por_pessoa(
    pool: &SqlitePool,
    ids: &[String],
    marcadores: &str,
) -> Resultado<HashMap<String, Vec<NomeExportavel>>> {
    let sql = format!(
        "SELECT pessoa_id, tipo,
                TRIM(COALESCE(prefixo || ' ','') || nome || COALESCE(' ' || sufixo,'')) AS nome,
                sobrenome, periodo
         FROM nomes_pessoa WHERE pessoa_id IN ({marcadores}) ORDER BY ordem"
    );
    let mut q = sqlx::query(&sql);
    for id in ids {
        q = q.bind(id);
    }

    let mut mapa: HashMap<String, Vec<NomeExportavel>> = HashMap::new();
    for l in q.fetch_all(pool).await? {
        let pessoa_id: String = l.try_get("pessoa_id")?;
        mapa.entry(pessoa_id).or_default().push(NomeExportavel {
            tipo: l.try_get("tipo")?,
            nome: l.try_get("nome")?,
            sobrenome: l.try_get("sobrenome")?,
            periodo: l.try_get("periodo")?,
        });
    }
    Ok(mapa)
}

#[derive(Default)]
struct Atributos {
    apelidos: HashMap<String, Vec<String>>,
    religioes: HashMap<String, Vec<String>>,
    escolaridade: HashMap<String, Vec<String>>,
    profissoes: HashMap<String, Vec<String>>,
    idiomas: HashMap<String, Vec<String>>,
    nacionalidades: HashMap<String, Vec<String>>,
}

async fn atributos_por_pessoa(
    pool: &SqlitePool,
    ids: &[String],
    m: &str,
) -> Resultado<Atributos> {
    async fn lote(
        pool: &SqlitePool,
        sql: &str,
        ids: &[String],
    ) -> Resultado<HashMap<String, Vec<String>>> {
        let mut q = sqlx::query_as::<_, (String, String)>(sql);
        for id in ids {
            q = q.bind(id);
        }
        let mut mapa: HashMap<String, Vec<String>> = HashMap::new();
        for (pessoa_id, valor) in q.fetch_all(pool).await? {
            mapa.entry(pessoa_id).or_default().push(valor);
        }
        Ok(mapa)
    }

    Ok(Atributos {
        apelidos: lote(
            pool,
            &format!("SELECT pessoa_id, apelido FROM apelidos_pessoa WHERE pessoa_id IN ({m})"),
            ids,
        )
        .await?,
        religioes: lote(
            pool,
            &format!("SELECT pessoa_id, denominacao FROM religioes_pessoa WHERE pessoa_id IN ({m})"),
            ids,
        )
        .await?,
        escolaridade: lote(
            pool,
            &format!("SELECT pessoa_id, nivel FROM escolaridade_pessoa WHERE pessoa_id IN ({m})"),
            ids,
        )
        .await?,
        profissoes: lote(
            pool,
            &format!("SELECT pessoa_id, ocupacao FROM profissoes_pessoa WHERE pessoa_id IN ({m})"),
            ids,
        )
        .await?,
        idiomas: lote(
            pool,
            &format!("SELECT pessoa_id, idioma FROM idiomas_pessoa WHERE pessoa_id IN ({m})"),
            ids,
        )
        .await?,
        nacionalidades: lote(
            pool,
            &format!(
                "SELECT n.pessoa_id, p.nome FROM nacionalidades_pessoa n
                 JOIN paises p ON p.id = n.pais_id WHERE n.pessoa_id IN ({m})"
            ),
            ids,
        )
        .await?,
    })
}

struct MidiaExportavel {
    caminho: String,
    titulo: Option<String>,
}

async fn midia_por_pessoa(
    pool: &SqlitePool,
    ids: &[String],
    m: &str,
) -> Resultado<HashMap<String, Vec<MidiaExportavel>>> {
    let sql = format!(
        "SELECT v.pessoa_id, d.caminho_relativo, COALESCE(d.titulo, d.nome_original) AS titulo
         FROM documento_vinculos v
         JOIN documentos d ON d.id = v.documento_id
         WHERE v.pessoa_id IN ({m})"
    );
    let mut q = sqlx::query(&sql);
    for id in ids {
        q = q.bind(id);
    }

    let mut mapa: HashMap<String, Vec<MidiaExportavel>> = HashMap::new();
    for l in q.fetch_all(pool).await? {
        let pessoa_id: String = l.try_get("pessoa_id")?;
        mapa.entry(pessoa_id).or_default().push(MidiaExportavel {
            caminho: l.try_get("caminho_relativo")?,
            titulo: l.try_get("titulo")?,
        });
    }
    Ok(mapa)
}
