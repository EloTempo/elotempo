//! Semente de árvores e pessoas públicas de referência histórica (Fatia pós-MVP).
//!
//! Fornece genealogias canônicas amplamente conhecidas:
//! - Família Imperial do Brasil (de Dom João VI a Dom Pedro II e Princesa Isabel)
//! - Presidentes Históricos do Brasil (Deodoro, Vargas, JK e famílias)
//! - Linhagem Bíblica da Antiguidade (Rei David, Salomão, Roboão, Asa e ascendência)

use sqlx::SqlitePool;
use crate::domain::erros::Resultado;

pub async fn garantir_acervo_publico(pool: &SqlitePool) -> Resultado<()> {
    // Se a semente canônica original não existe, semeia.
    let count: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM arvores WHERE id = 'arv_imperial_brasil'")
        .fetch_one(pool)
        .await
        .unwrap_or(0);

    if count == 0 {
        println!("Iniciando semente publica original (count = {})...", count);

        let mut tx = pool.begin().await?;

    // -------------------------------------------------------------------------
    // 1. FAMÍLIA IMPERIAL DO BRASIL
    // -------------------------------------------------------------------------
    let pessoas_imperial = [
        ("pub_joao6", "D. João VI", Some("de Bragança"), "M", "Rei do Reino Unido de Portugal, Brasil e Algarves. Transferiu a sede da corte para o Rio de Janeiro em 1808."),
        ("pub_carlota", "Carlota Joaquina", Some("de Bourbon"), "F", "Rainha consorte de Portugal e do Brasil, infanta de Espanha."),
        ("pub_pedro1", "D. Pedro I", Some("de Bragança"), "M", "Proclamador da Independência e primeiro Imperador do Brasil (1822–1831). Rei de Portugal como D. Pedro IV."),
        ("pub_miguel1", "D. Miguel I", Some("de Bragança"), "M", "Rei de Portugal e irmão de D. Pedro I."),
        ("pub_leopoldina", "Maria Leopoldina", Some("da Áustria"), "F", "Arquiduquesa da Áustria e primeira Imperatriz consorte do Brasil, figura central na Independência de 1822."),
        ("pub_maria2", "D. Maria II", Some("de Bragança"), "F", "Rainha de Portugal, filha mais velha de D. Pedro I e Dona Leopoldina."),
        ("pub_januaria", "D. Januária", Some("de Bragança"), "F", "Princesa Imperial do Brasil e Condessa d’Áquila."),
        ("pub_francisca", "D. Francisca", Some("de Bragança"), "F", "Princesa do Brasil e Princesa de Joinville."),
        ("pub_pedro2", "D. Pedro II", Some("de Bragança"), "M", "Segundo e último Imperador do Brasil (1840–1889), patrono da ciência, cultura e educação."),
        ("pub_teresa", "Teresa Cristina", Some("das Duas Sicílias"), "F", "Imperatriz consorte do Brasil, conhecida como a \"Mãe dos Brasileiros\"."),
        ("pub_isabel", "Princesa Isabel", Some("de Bragança"), "F", "Princesa Imperial e Regente do Brasil. Assinou a Lei Áurea em 13 de maio de 1888."),
        ("pub_leopoldina_filha", "Princesa Leopoldina", Some("de Bragança"), "F", "Princesa do Brasil, casada com o Duque de Saxe."),
        ("pub_conde_deu", "Gastão de Orléans", Some("Conde d’Eu"), "M", "Príncipe francês da Casa de Orléans, marechal do Exército Brasileiro e consorte da Princesa Isabel."),
        ("pub_pedro_alcantara", "Pedro de Alcântara", Some("de Orléans e Bragança"), "M", "Príncipe do Grão-Pará, primogênito da Princesa Isabel."),
        ("pub_luis_orleans", "Luís", Some("de Orléans e Bragança"), "M", "Príncipe de Orléans e Bragança, escritor e ativista."),
        ("pub_antonio_orleans", "Antônio Gastão", Some("de Orléans e Bragança"), "M", "Príncipe de Orléans e Bragança, oficial na Primeira Guerra Mundial."),
    ];

    for (id, nome, sobrenome, sexo, bio) in &pessoas_imperial {
        sqlx::query(
            "INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico)
             VALUES (?, ?, ?, ?, ?, 0, 0, 1)"
        )
        .bind(id)
        .bind(nome)
        .bind(sobrenome)
        .bind(sexo)
        .bind(bio)
        .execute(&mut *tx)
        .await?;
    }

    let unioes_imperial = [
        ("pub_u_joao6_carlota", "pub_joao6", "pub_carlota", "casamento", "Casamento real em 1785"),
        ("pub_u_pedro1_leopoldina", "pub_pedro1", "pub_leopoldina", "casamento", "Casamento imperial em 1817"),
        ("pub_u_pedro2_teresa", "pub_pedro2", "pub_teresa", "casamento", "Casamento imperial em 1843"),
        ("pub_u_isabel_conde_deu", "pub_conde_deu", "pub_isabel", "casamento", "Casamento imperial em 1864"),
    ];

    for (uid, masc, fem, estado, nota) in &unioes_imperial {
        sqlx::query(
            "INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
             VALUES (?, ?, ?, ?, ?)"
        )
        .bind(uid)
        .bind(masc)
        .bind(fem)
        .bind(estado)
        .bind(nota)
        .execute(&mut *tx)
        .await?;
    }

    let filhos_imperial = [
        ("pub_u_joao6_carlota", "pub_pedro1", 1),
        ("pub_u_joao6_carlota", "pub_miguel1", 2),
        ("pub_u_pedro1_leopoldina", "pub_maria2", 1),
        ("pub_u_pedro1_leopoldina", "pub_januaria", 2),
        ("pub_u_pedro1_leopoldina", "pub_francisca", 3),
        ("pub_u_pedro1_leopoldina", "pub_pedro2", 4),
        ("pub_u_pedro2_teresa", "pub_isabel", 1),
        ("pub_u_pedro2_teresa", "pub_leopoldina_filha", 2),
        ("pub_u_isabel_conde_deu", "pub_pedro_alcantara", 1),
        ("pub_u_isabel_conde_deu", "pub_luis_orleans", 2),
        ("pub_u_isabel_conde_deu", "pub_antonio_orleans", 3),
    ];

    for (uid, pid, ordem) in &filhos_imperial {
        sqlx::query(
            "INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
             VALUES (?, ?, 'biologico', ?)"
        )
        .bind(uid)
        .bind(pid)
        .bind(ordem)
        .execute(&mut *tx)
        .await?;
    }

    let eventos_imperial = [
        ("ev_nasc_joao6", "pub_joao6", "nascimento", 1767, 1767, "exata", "13 de maio de 1767"),
        ("ev_morte_joao6", "pub_joao6", "falecimento", 1826, 1826, "exata", "10 de março de 1826"),
        ("ev_nasc_carlota", "pub_carlota", "nascimento", 1775, 1775, "exata", "25 de abril de 1775"),
        ("ev_morte_carlota", "pub_carlota", "falecimento", 1830, 1830, "exata", "7 de janeiro de 1830"),
        ("ev_nasc_pedro1", "pub_pedro1", "nascimento", 1798, 1798, "exata", "12 de outubro de 1798"),
        ("ev_morte_pedro1", "pub_pedro1", "falecimento", 1834, 1834, "exata", "24 de setembro de 1834"),
        ("ev_nasc_leopoldina", "pub_leopoldina", "nascimento", 1797, 1797, "exata", "22 de janeiro de 1797"),
        ("ev_morte_leopoldina", "pub_leopoldina", "falecimento", 1826, 1826, "exata", "11 de dezembro de 1826"),
        ("ev_nasc_pedro2", "pub_pedro2", "nascimento", 1825, 1825, "exata", "2 de dezembro de 1825"),
        ("ev_morte_pedro2", "pub_pedro2", "falecimento", 1891, 1891, "exata", "5 de dezembro de 1891"),
        ("ev_nasc_teresa", "pub_teresa", "nascimento", 1822, 1822, "exata", "14 de março de 1822"),
        ("ev_morte_teresa", "pub_teresa", "falecimento", 1889, 1889, "exata", "28 de dezembro de 1889"),
        ("ev_nasc_isabel", "pub_isabel", "nascimento", 1846, 1846, "exata", "29 de julho de 1846"),
        ("ev_morte_isabel", "pub_isabel", "falecimento", 1921, 1921, "exata", "14 de novembro de 1921"),
        ("ev_nasc_conde_deu", "pub_conde_deu", "nascimento", 1842, 1842, "exata", "28 de abril de 1842"),
        ("ev_morte_conde_deu", "pub_conde_deu", "falecimento", 1922, 1922, "exata", "28 de agosto de 1922"),
        ("ev_nasc_pedro_alcantara", "pub_pedro_alcantara", "nascimento", 1875, 1875, "exata", "15 de outubro de 1875"),
        ("ev_morte_pedro_alcantara", "pub_pedro_alcantara", "falecimento", 1940, 1940, "exata", "29 de janeiro de 1940"),
    ];

    for (eid, pid, tipo, ini, fim, qual, txt) in &eventos_imperial {
        sqlx::query(
            "INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        )
        .bind(eid)
        .bind(pid)
        .bind(tipo)
        .bind(ini)
        .bind(fim)
        .bind(qual)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    sqlx::query(
        "INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
         VALUES ('arv_imperial_brasil', 'Família Imperial do Brasil', 'Dinastia de Bragança: de Dom João VI a Dom Pedro II e Princesa Isabel', 'pub_pedro2', 1, 'Monarquias e Casas Reais', 'Brasil', 'Império (Séc. XIX)')"
    )
    .execute(&mut *tx)
    .await?;

    for (pid, _, _, _, _) in &pessoas_imperial {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES ('arv_imperial_brasil', ?, NULL)"
        )
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    // -------------------------------------------------------------------------
    // 2. PRESIDENTES HISTÓRICOS DO BRASIL
    // -------------------------------------------------------------------------
    let pessoas_pres = [
        ("pub_deodoro", "Deodoro", Some("da Fonseca"), "M", "Marechal e 1º Presidente da República do Brasil (1889–1891). Proclamou a República em 15 de novembro de 1889."),
        ("pub_mariana_deodoro", "Mariana Cecília", Some("da Fonseca"), "F", "Primeira-dama do Brasil, esposa do Marechal Deodoro."),
        ("pub_manuel_vargas", "Manuel do Nascimento", Some("Vargas"), "M", "General e veterano da Guerra do Paraguai, pai de Getúlio Vargas."),
        ("pub_candida_vargas", "Cândida Francisca", Some("Dornelles Vargas"), "F", "Mãe de Getúlio Vargas."),
        ("pub_vargas", "Getúlio", Some("Dornelles Vargas"), "M", "Advogado e político gaúcho, presidente do Brasil em dois mandatos (1930–1945 e 1951–1954)."),
        ("pub_darcy_vargas", "Darcy", Some("Sarmanho Vargas"), "F", "Primeira-dama do Brasil, filantropa e fundadora da Legião Brasileira de Assistência (LBA)."),
        ("pub_alzira_vargas", "Alzira", Some("Vargas do Amaral Peixoto"), "F", "Advogada, escritora e chefe do Gabinete Civil de Getúlio Vargas."),
        ("pub_joao_cesar", "João César", Some("de Oliveira"), "M", "Comerciante de Diamantina, pai de Juscelino Kubitschek."),
        ("pub_julia_kubitschek", "Júlia", Some("Kubitschek"), "F", "Professora primária de Diamantina de ascendência tcheca, mãe de Juscelino Kubitschek."),
        ("pub_jk", "Juscelino", Some("Kubitschek de Oliveira"), "M", "Médico e político mineiro, 21º Presidente do Brasil (1956–1961). Construtor de Brasília."),
        ("pub_sarah_jk", "Sarah", Some("Luísa Lemos Kubitschek"), "F", "Primeira-dama do Brasil, fundadora das Pioneiras Sociais."),
        ("pub_marcia_jk", "Márcia", Some("Kubitschek"), "F", "Jornalista e deputada federal constituinte, filha de JK e Sarah."),
    ];

    for (id, nome, sobrenome, sexo, bio) in &pessoas_pres {
        sqlx::query(
            "INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico)
             VALUES (?, ?, ?, ?, ?, 0, 0, 1)"
        )
        .bind(id)
        .bind(nome)
        .bind(sobrenome)
        .bind(sexo)
        .bind(bio)
        .execute(&mut *tx)
        .await?;
    }

    let unioes_pres = [
        ("pub_u_deodoro_mariana", "pub_deodoro", "pub_mariana_deodoro", "casamento", "Casamento em 1860"),
        ("pub_u_pais_vargas", "pub_manuel_vargas", "pub_candida_vargas", "casamento", "Casamento em 1872"),
        ("pub_u_getulio_darcy", "pub_vargas", "pub_darcy_vargas", "casamento", "Casamento em 1911"),
        ("pub_u_pais_jk", "pub_joao_cesar", "pub_julia_kubitschek", "casamento", "Casamento em 1898"),
        ("pub_u_jk_sarah", "pub_jk", "pub_sarah_jk", "casamento", "Casamento em 1931"),
    ];

    for (uid, masc, fem, estado, nota) in &unioes_pres {
        sqlx::query(
            "INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
             VALUES (?, ?, ?, ?, ?)"
        )
        .bind(uid)
        .bind(masc)
        .bind(fem)
        .bind(estado)
        .bind(nota)
        .execute(&mut *tx)
        .await?;
    }

    let filhos_pres = [
        ("pub_u_pais_vargas", "pub_vargas", 1),
        ("pub_u_getulio_darcy", "pub_alzira_vargas", 1),
        ("pub_u_pais_jk", "pub_jk", 1),
        ("pub_u_jk_sarah", "pub_marcia_jk", 1),
    ];

    for (uid, pid, ordem) in &filhos_pres {
        sqlx::query(
            "INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
             VALUES (?, ?, 'biologico', ?)"
        )
        .bind(uid)
        .bind(pid)
        .bind(ordem)
        .execute(&mut *tx)
        .await?;
    }

    let eventos_pres = [
        ("ev_nasc_deodoro", "pub_deodoro", "nascimento", 1827, 1827, "exata", "5 de agosto de 1827"),
        ("ev_morte_deodoro", "pub_deodoro", "falecimento", 1892, 1892, "exata", "23 de agosto de 1892"),
        ("ev_nasc_vargas", "pub_vargas", "nascimento", 1882, 1882, "exata", "19 de abril de 1882"),
        ("ev_morte_vargas", "pub_vargas", "falecimento", 1954, 1954, "exata", "24 de agosto de 1954"),
        ("ev_nasc_darcy", "pub_darcy_vargas", "nascimento", 1895, 1895, "exata", "12 de dezembro de 1895"),
        ("ev_morte_darcy", "pub_darcy_vargas", "falecimento", 1968, 1968, "exata", "25 de junho de 1968"),
        ("ev_nasc_alzira", "pub_alzira_vargas", "nascimento", 1914, 1914, "exata", "22 de novembro de 1914"),
        ("ev_morte_alzira", "pub_alzira_vargas", "falecimento", 1992, 1992, "exata", "26 de janeiro de 1992"),
        ("ev_nasc_jk", "pub_jk", "nascimento", 1902, 1902, "exata", "12 de setembro de 1902"),
        ("ev_morte_jk", "pub_jk", "falecimento", 1976, 1976, "exata", "22 de agosto de 1976"),
        ("ev_nasc_sarah", "pub_sarah_jk", "nascimento", 1908, 1908, "exata", "5 de outubro de 1908"),
        ("ev_morte_sarah", "pub_sarah_jk", "falecimento", 1996, 1996, "exata", "4 de fevereiro de 1996"),
        ("ev_nasc_marcia", "pub_marcia_jk", "nascimento", 1943, 1943, "exata", "22 de outubro de 1943"),
        ("ev_morte_marcia", "pub_marcia_jk", "falecimento", 2000, 2000, "exata", "5 de agosto de 2000"),
    ];

    for (eid, pid, tipo, ini, fim, qual, txt) in &eventos_pres {
        sqlx::query(
            "INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        )
        .bind(eid)
        .bind(pid)
        .bind(tipo)
        .bind(ini)
        .bind(fim)
        .bind(qual)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    sqlx::query(
        "INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
         VALUES ('arv_presidentes_brasil', 'Presidentes do Brasil', 'Linhagens e famílias de presidentes: Getúlio Vargas, Juscelino Kubitschek e Deodoro', 'pub_vargas', 1, 'Chefes de Estado e Lideranças Políticas', 'Brasil', 'República (Séc. XX)')"
    )
    .execute(&mut *tx)
    .await?;

    for (pid, _, _, _, _) in &pessoas_pres {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES ('arv_presidentes_brasil', ?, NULL)"
        )
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    // -------------------------------------------------------------------------
    // 3. LINHAGEM BÍBLICA DE DAVID (ANTIGUIDADE)
    // -------------------------------------------------------------------------
    let pessoas_bib = [
        ("pub_jesse", "Jessé", Some("de Belém"), "M", "Pai de David, neto de Boaz e Rute, residente de Belém de Judá."),
        ("pub_mae_david", "Esposa de Jessé", None, "F", "Mãe de David referenciada nos Salmos bíblicos."),
        ("pub_rei_david", "Rei David", Some("de Israel"), "M", "Segundo rei do Reino Unido de Israel e Judá, unificador das tribos e poeta autor dos Salmos."),
        ("pub_bate_seba", "Bate-Seba", None, "F", "Esposa de David, mãe do rei Salomão e rainha-mãe de Judá."),
        ("pub_rei_salomao", "Rei Salomão", Some("o Sábio"), "M", "Rei de Israel célebre pela sabedoria e construtor do Primeiro Templo de Jerusalém."),
        ("pub_naama", "Naama", Some("a Amonita"), "F", "Esposa de Salomão e mãe do rei Roboão."),
        ("pub_rei_roboao", "Rei Roboão", Some("de Judá"), "M", "Primeiro monarca do Reino de Judá após a divisão das doze tribos."),
        ("pub_maaca", "Maaca", None, "F", "Esposa de Roboão e mãe de Abias."),
        ("pub_rei_abias", "Rei Abias", Some("de Judá"), "M", "Segundo monarca do Reino de Judá, filho de Roboão."),
        ("pub_ana", "Esposa de Abias", None, "F", "Mãe de Asa, rei de Judá."),
        ("pub_rei_asa", "Rei Asa", Some("de Judá"), "M", "Terceiro rei de Judá que reinou por mais de quarenta anos."),
    ];

    for (id, nome, sobrenome, sexo, bio) in &pessoas_bib {
        sqlx::query(
            "INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico)
             VALUES (?, ?, ?, ?, ?, 0, 0, 1)"
        )
        .bind(id)
        .bind(nome)
        .bind(sobrenome)
        .bind(sexo)
        .bind(bio)
        .execute(&mut *tx)
        .await?;
    }

    let unioes_bib = [
        ("pub_u_jesse", "pub_jesse", "pub_mae_david", "casamento", "Linhagem de Belém"),
        ("pub_u_david_bateseba", "pub_rei_david", "pub_bate_seba", "casamento", "União real em Jerusalém"),
        ("pub_u_salomao_naama", "pub_rei_salomao", "pub_naama", "casamento", "União real"),
        ("pub_u_roboao_maaca", "pub_rei_roboao", "pub_maaca", "casamento", "União real em Judá"),
        ("pub_u_abias", "pub_rei_abias", "pub_ana", "casamento", "União real em Judá"),
    ];

    for (uid, masc, fem, estado, nota) in &unioes_bib {
        sqlx::query(
            "INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
             VALUES (?, ?, ?, ?, ?)"
        )
        .bind(uid)
        .bind(masc)
        .bind(fem)
        .bind(estado)
        .bind(nota)
        .execute(&mut *tx)
        .await?;
    }

    let filhos_bib = [
        ("pub_u_jesse", "pub_rei_david", 1),
        ("pub_u_david_bateseba", "pub_rei_salomao", 1),
        ("pub_u_salomao_naama", "pub_rei_roboao", 1),
        ("pub_u_roboao_maaca", "pub_rei_abias", 1),
        ("pub_u_abias", "pub_rei_asa", 1),
    ];

    for (uid, pid, ordem) in &filhos_bib {
        sqlx::query(
            "INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, tipo_vinculo, ordem)
             VALUES (?, ?, 'biologico', ?)"
        )
        .bind(uid)
        .bind(pid)
        .bind(ordem)
        .execute(&mut *tx)
        .await?;
    }

    let eventos_bib = [
        ("ev_nasc_jesse", "pub_jesse", "nascimento", -1100, -1100, "cerca_de", "cerca de 1100 a.C."),
        ("ev_morte_jesse", "pub_jesse", "falecimento", -1010, -1010, "cerca_de", "cerca de 1010 a.C."),
        ("ev_nasc_david", "pub_rei_david", "nascimento", -1040, -1040, "cerca_de", "cerca de 1040 a.C."),
        ("ev_morte_david", "pub_rei_david", "falecimento", -970, -970, "cerca_de", "cerca de 970 a.C."),
        ("ev_nasc_salomao", "pub_rei_salomao", "nascimento", -990, -990, "cerca_de", "cerca de 990 a.C."),
        ("ev_morte_salomao", "pub_rei_salomao", "falecimento", -931, -931, "cerca_de", "cerca de 931 a.C."),
        ("ev_nasc_roboao", "pub_rei_roboao", "nascimento", -972, -972, "cerca_de", "cerca de 972 a.C."),
        ("ev_morte_roboao", "pub_rei_roboao", "falecimento", -914, -914, "cerca_de", "cerca de 914 a.C."),
        ("ev_nasc_abias", "pub_rei_abias", "nascimento", -940, -940, "cerca_de", "cerca de 940 a.C."),
        ("ev_morte_abias", "pub_rei_abias", "falecimento", -911, -911, "cerca_de", "cerca de 911 a.C."),
        ("ev_nasc_asa", "pub_rei_asa", "nascimento", -920, -920, "cerca_de", "cerca de 920 a.C."),
        ("ev_morte_asa", "pub_rei_asa", "falecimento", -870, -870, "cerca_de", "cerca de 870 a.C."),
    ];

    for (eid, pid, tipo, ini, fim, qual, txt) in &eventos_bib {
        sqlx::query(
            "INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        )
        .bind(eid)
        .bind(pid)
        .bind(tipo)
        .bind(ini)
        .bind(fim)
        .bind(qual)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    sqlx::query(
        "INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
         VALUES ('arv_biblica_david', 'Casa Real de Davi (Linhagem Bíblica)', 'Reis de Judá e linhagem davídica da Antiguidade (anos antes de Cristo)', 'pub_rei_david', 1, 'Tradição Bíblica', 'Israel Antigo', 'Antiguidade (a.C.)')"
    )
    .execute(&mut *tx)
    .await?;

    for (pid, _, _, _, _) in &pessoas_bib {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES ('arv_biblica_david', ?, NULL)"
        )
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    // -------------------------------------------------------------------------
    // 4. CASA REAL DE PORTUGAL (BRAGANÇA)
    // -------------------------------------------------------------------------
    let pessoas_portugal = [
        ("pub_maria1_pt", "D. Maria I", Some("de Bragança"), "F", "Rainha de Portugal e do Brasil (1777–1816), cognominada 'A Piedosa'."),
        ("pub_pedro3_pt", "D. Pedro III", Some("de Bragança"), "M", "Rei consorte de Portugal, marido e tio de D. Maria I."),
        ("pub_fernando2_pt", "D. Fernando II", Some("de Saxe-Coburgo-Gota"), "M", "Rei consorte de Portugal, marido de D. Maria II e patrono das artes (Palácio da Pena)."),
        ("pub_pedro5_pt", "D. Pedro V", Some("de Bragança"), "M", "Rei de Portugal (1853–1861), 'O Esperançoso'. Sobrinho de D. Pedro II do Brasil."),
        ("pub_luis1_pt", "D. Luís I", Some("de Bragança"), "M", "Rei de Portugal (1861–1889), 'O Popular'. Sobrinho de D. Pedro II do Brasil."),
        ("pub_mariapia_pt", "Maria Pia", Some("de Saboia"), "F", "Rainha consorte de Portugal, filha do Rei Victor Emanuel II da Itália."),
        ("pub_carlos1_pt", "D. Carlos I", Some("de Bragança"), "M", "Rei de Portugal (1889–1908), oceanógrafo e pintor."),
    ];

    for (id, nome, sobrenome, sexo, bio) in &pessoas_portugal {
        sqlx::query(
            "INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
             VALUES (?, ?, ?, ?, ?, 0, 0, 1, 'Famílias Reais')"
        )
        .bind(id)
        .bind(nome)
        .bind(sobrenome)
        .bind(sexo)
        .bind(bio)
        .execute(&mut *tx)
        .await?;
    }

    let unioes_portugal = [
        ("pub_u_pedro3_maria1", "pub_pedro3_pt", "pub_maria1_pt", "casamento", "Casamento real em 1760"),
        ("pub_u_maria2_fernando2", "pub_fernando2_pt", "pub_maria2", "casamento", "Casamento real em 1836"),
        ("pub_u_luis1_mariapia", "pub_luis1_pt", "pub_mariapia_pt", "casamento", "Casamento real em 1862"),
    ];

    for (uid, masc, fem, tipo, txt) in &unioes_portugal {
        sqlx::query(
            "INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
             VALUES (?, ?, ?, ?, ?)"
        )
        .bind(uid)
        .bind(masc)
        .bind(fem)
        .bind(tipo)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    let filhos_portugal = [
        ("pub_u_pedro3_maria1", "pub_joao6", 1),
        ("pub_u_maria2_fernando2", "pub_pedro5_pt", 1),
        ("pub_u_maria2_fernando2", "pub_luis1_pt", 2),
        ("pub_u_luis1_mariapia", "pub_carlos1_pt", 1),
    ];

    for (uid, fid, ord) in &filhos_portugal {
        sqlx::query(
            "INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
             VALUES (?, ?, ?)"
        )
        .bind(uid)
        .bind(fid)
        .bind(ord)
        .execute(&mut *tx)
        .await?;
    }

    let eventos_portugal = [
        ("pub_maria1_pt", "nascimento", 1734, 1734, "exata", "17/12/1734"),
        ("pub_maria1_pt", "falecimento", 1816, 1816, "exata", "20/03/1816"),
        ("pub_pedro3_pt", "nascimento", 1717, 1717, "exata", "05/07/1717"),
        ("pub_pedro3_pt", "falecimento", 1786, 1786, "exata", "25/05/1786"),
        ("pub_fernando2_pt", "nascimento", 1816, 1816, "exata", "29/10/1816"),
        ("pub_fernando2_pt", "falecimento", 1885, 1885, "exata", "15/12/1885"),
        ("pub_pedro5_pt", "nascimento", 1837, 1837, "exata", "16/09/1837"),
        ("pub_pedro5_pt", "falecimento", 1861, 1861, "exata", "11/11/1861"),
        ("pub_luis1_pt", "nascimento", 1838, 1838, "exata", "31/10/1838"),
        ("pub_luis1_pt", "falecimento", 1889, 1889, "exata", "19/10/1889"),
        ("pub_mariapia_pt", "nascimento", 1847, 1847, "exata", "16/10/1847"),
        ("pub_mariapia_pt", "falecimento", 1911, 1911, "exata", "05/07/1911"),
        ("pub_carlos1_pt", "nascimento", 1863, 1863, "exata", "28/09/1863"),
        ("pub_carlos1_pt", "falecimento", 1908, 1908, "exata", "01/02/1908"),
    ];

    for (pid, tipo, ini, fim, qual, txt) in &eventos_portugal {
        let eid = format!("ev_{}_{}", pid, tipo);
        sqlx::query(
            "INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        )
        .bind(&eid)
        .bind(pid)
        .bind(tipo)
        .bind(ini)
        .bind(fim)
        .bind(qual)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    sqlx::query(
        "INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
         VALUES ('arv_real_portugal', 'Casa Real de Portugal (Bragança)', 'Monarcas de Portugal com ligação direta à dinastia imperial do Brasil', 'pub_maria1_pt', 1, 'Monarquias e Casas Reais', 'Portugal', 'Séc. XVIII-XIX')"
    )
    .execute(&mut *tx)
    .await?;

    let membros_portugal = [
        "pub_maria1_pt", "pub_pedro3_pt", "pub_joao6", "pub_carlota", "pub_pedro1",
        "pub_miguel1", "pub_maria2", "pub_fernando2_pt", "pub_pedro5_pt",
        "pub_luis1_pt", "pub_mariapia_pt", "pub_carlos1_pt"
    ];

    for pid in &membros_portugal {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES ('arv_real_portugal', ?, NULL)"
        )
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    // -------------------------------------------------------------------------
    // 5. FAMÍLIA REAL BRITÂNICA (CASA DE WINDSOR)
    // -------------------------------------------------------------------------
    let pessoas_windsor = [
        ("pub_vitoria_uk", "Rainha Vitória", Some("de Hanôver"), "F", "Rainha do Reino Unido e Imperatriz da Índia (1837–1901), matriz da 'Era Vitoriana'.", false),
        ("pub_alberto_uk", "Príncipe Alberto", Some("de Saxe-Coburgo-Gota"), "M", "Príncipe consorte do Reino Unido e marido da Rainha Vitória.", false),
        ("pub_edward7_uk", "Rei Edward VII", Some("de Saxe-Coburgo-Gota"), "M", "Rei do Reino Unido (1901–1910), inaugurou a Era Eduardiana.", false),
        ("pub_alexandra_uk", "Rainha Alexandra", Some("da Dinamarca"), "F", "Rainha consorte do Reino Unido, princesa da Dinamarca.", false),
        ("pub_george5_uk", "Rei George V", Some("de Windsor"), "M", "Fundador da Casa de Windsor em 1917. Rei durante a Primeira Guerra Mundial.", false),
        ("pub_mary_uk", "Rainha Mary", Some("de Teck"), "F", "Rainha consorte do Reino Unido e Imperatriz da Índia.", false),
        ("pub_george6_uk", "Rei George VI", Some("de Windsor"), "M", "Rei do Reino Unido (1936–1952) durante a Segunda Guerra Mundial, pai de Elizabeth II.", false),
        ("pub_elizabeth_mae_uk", "Elizabeth Bowes-Lyon", Some("Rainha Mãe"), "F", "Rainha consorte e posteriormente a amada Rainha Mãe (1900–2002).", false),
        ("pub_elizabeth2_uk", "Rainha Elizabeth II", Some("de Windsor"), "F", "Monarca mais longeva da história britânica (reinou de 1952 a 2022).", false),
        ("pub_philip_uk", "Príncipe Philip", Some("Duque de Edimburgo"), "M", "Consorte de Elizabeth II, nascido príncipe da Grécia e Dinamarca (1921–2021).", false),
        ("pub_charles3_uk", "Rei Charles III", Some("de Windsor"), "M", "Atual Rei do Reino Unido e Chefe da Commonwealth.", true),
        ("pub_diana_uk", "Diana Spencer", Some("Princesa de Gales"), "F", "Princesa de Gales (1961–1997), ícone global de humanitarismo.", false),
        ("pub_william_uk", "Príncipe William", Some("Príncipe de Gales"), "M", "Príncipe de Gales e herdeiro direto do trono britânico.", true),
        ("pub_catherine_uk", "Catherine Middleton", Some("Princesa de Gales"), "F", "Princesa de Gales e futura rainha consorte britânica.", true),
        ("pub_george_uk", "Príncipe George", Some("de Gales"), "M", "Segundo na linha de sucessão ao trono britânico, nascido em 2013.", true),
    ];

    for (id, nome, sobrenome, sexo, bio, is_vivo) in &pessoas_windsor {
        sqlx::query(
            "INSERT OR IGNORE INTO pessoas (id, nome, sobrenome, sexo, minibiografia, is_vivo, is_placeholder, is_publico, categoria)
             VALUES (?, ?, ?, ?, ?, ?, 0, 1, 'Famílias Reais')"
        )
        .bind(id)
        .bind(nome)
        .bind(sobrenome)
        .bind(sexo)
        .bind(bio)
        .bind(is_vivo)
        .execute(&mut *tx)
        .await?;
    }

    let unioes_windsor = [
        ("pub_u_vitoria_alberto", "pub_alberto_uk", "pub_vitoria_uk", "casamento", "Casamento real em 1840"),
        ("pub_u_edward7_alexandra", "pub_edward7_uk", "pub_alexandra_uk", "casamento", "Casamento real em 1863"),
        ("pub_u_george5_mary", "pub_george5_uk", "pub_mary_uk", "casamento", "Casamento real em 1893"),
        ("pub_u_george6_elizabeth", "pub_george6_uk", "pub_elizabeth_mae_uk", "casamento", "Casamento real em 1923"),
        ("pub_u_elizabeth2_philip", "pub_philip_uk", "pub_elizabeth2_uk", "casamento", "Casamento real em 1947"),
        ("pub_u_charles3_diana", "pub_charles3_uk", "pub_diana_uk", "casamento", "Casamento real em 1981"),
        ("pub_u_william_catherine", "pub_william_uk", "pub_catherine_uk", "casamento", "Casamento real em 2011"),
    ];

    for (uid, masc, fem, tipo, txt) in &unioes_windsor {
        sqlx::query(
            "INSERT OR IGNORE INTO unioes (id, slot_masculino_id, slot_feminino_id, estado_vinculo, nota)
             VALUES (?, ?, ?, ?, ?)"
        )
        .bind(uid)
        .bind(masc)
        .bind(fem)
        .bind(tipo)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    let filhos_windsor = [
        ("pub_u_vitoria_alberto", "pub_edward7_uk", 1),
        ("pub_u_edward7_alexandra", "pub_george5_uk", 1),
        ("pub_u_george5_mary", "pub_george6_uk", 1),
        ("pub_u_george6_elizabeth", "pub_elizabeth2_uk", 1),
        ("pub_u_elizabeth2_philip", "pub_charles3_uk", 1),
        ("pub_u_charles3_diana", "pub_william_uk", 1),
        ("pub_u_william_catherine", "pub_george_uk", 1),
    ];

    for (uid, fid, ord) in &filhos_windsor {
        sqlx::query(
            "INSERT OR IGNORE INTO uniao_filhos (uniao_id, pessoa_id, ordem)
             VALUES (?, ?, ?)"
        )
        .bind(uid)
        .bind(fid)
        .bind(ord)
        .execute(&mut *tx)
        .await?;
    }

    let eventos_windsor = [
        ("pub_vitoria_uk", "nascimento", 1819, 1819, "exata", "24/05/1819"),
        ("pub_vitoria_uk", "falecimento", 1901, 1901, "exata", "22/01/1901"),
        ("pub_alberto_uk", "nascimento", 1819, 1819, "exata", "26/08/1819"),
        ("pub_alberto_uk", "falecimento", 1861, 1861, "exata", "14/12/1861"),
        ("pub_edward7_uk", "nascimento", 1841, 1841, "exata", "09/11/1841"),
        ("pub_edward7_uk", "falecimento", 1910, 1910, "exata", "06/05/1910"),
        ("pub_alexandra_uk", "nascimento", 1844, 1844, "exata", "01/12/1844"),
        ("pub_alexandra_uk", "falecimento", 1925, 1925, "exata", "20/11/1925"),
        ("pub_george5_uk", "nascimento", 1865, 1865, "exata", "03/06/1865"),
        ("pub_george5_uk", "falecimento", 1936, 1936, "exata", "20/01/1936"),
        ("pub_mary_uk", "nascimento", 1867, 1867, "exata", "26/05/1867"),
        ("pub_mary_uk", "falecimento", 1953, 1953, "exata", "24/03/1953"),
        ("pub_george6_uk", "nascimento", 1895, 1895, "exata", "14/12/1895"),
        ("pub_george6_uk", "falecimento", 1952, 1952, "exata", "06/02/1952"),
        ("pub_elizabeth_mae_uk", "nascimento", 1900, 1900, "exata", "04/08/1900"),
        ("pub_elizabeth_mae_uk", "falecimento", 2002, 2002, "exata", "30/03/2002"),
        ("pub_elizabeth2_uk", "nascimento", 1926, 1926, "exata", "21/04/1926"),
        ("pub_elizabeth2_uk", "falecimento", 2022, 2022, "exata", "08/09/2022"),
        ("pub_philip_uk", "nascimento", 1921, 1921, "exata", "10/06/1921"),
        ("pub_philip_uk", "falecimento", 2021, 2021, "exata", "09/04/2021"),
        ("pub_charles3_uk", "nascimento", 1948, 1948, "exata", "14/11/1948"),
        ("pub_diana_uk", "nascimento", 1961, 1961, "exata", "01/07/1961"),
        ("pub_diana_uk", "falecimento", 1997, 1997, "exata", "31/08/1997"),
        ("pub_william_uk", "nascimento", 1982, 1982, "exata", "21/06/1982"),
        ("pub_catherine_uk", "nascimento", 1982, 1982, "exata", "09/01/1982"),
        ("pub_george_uk", "nascimento", 2013, 2013, "exata", "22/07/2013"),
    ];

    for (pid, tipo, ini, fim, qual, txt) in &eventos_windsor {
        let eid = format!("ev_{}_{}", pid, tipo);
        sqlx::query(
            "INSERT OR IGNORE INTO eventos (id, pessoa_id, tipo_evento, ano_inicio, ano_fim, data_qualificador, data_texto)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        )
        .bind(&eid)
        .bind(pid)
        .bind(tipo)
        .bind(ini)
        .bind(fim)
        .bind(qual)
        .bind(txt)
        .execute(&mut *tx)
        .await?;
    }

    sqlx::query(
        "INSERT OR IGNORE INTO arvores (id, nome, descricao, raiz_pessoa_id, is_publico, categoria, pais, periodo)
         VALUES ('arv_real_britanica', 'Casa Real Britânica (Windsor)', 'Da Rainha Vitória aos monarcas contemporâneos do Reino Unido', 'pub_vitoria_uk', 1, 'Monarquias e Casas Reais', 'Reino Unido', 'Séc. XIX-XXI')"
    )
    .execute(&mut *tx)
    .await?;

    for (pid, _, _, _, _, _) in &pessoas_windsor {
        sqlx::query(
            "INSERT OR IGNORE INTO arvore_membros (arvore_id, pessoa_id, uniao_id)
             VALUES ('arv_real_britanica', ?, NULL)"
        )
        .bind(pid)
        .execute(&mut *tx)
        .await?;
    }

    tx.commit().await?;
    }

    sanear_e_sincronizar_acervo(pool).await?;

    Ok(())
}

/// Saneia duplicatas, remove placeholders desnecessários, normaliza qualificadores e sincroniza novos membros.
pub async fn sanear_e_sincronizar_acervo(pool: &SqlitePool) -> Resultado<()> {
    // 1. Corrige qualquer qualificador legado 'aproximada' para 'cerca_de'
    sqlx::query("UPDATE eventos SET data_qualificador = 'cerca_de' WHERE data_qualificador = 'aproximada'")
        .execute(pool)
        .await?;

    // 2. Remove árvore duplicada de Windsor se existir, unificando em arv_real_britanica
    let tem_windsor_dup: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM arvores WHERE id = 'pub_arv_windsor'")
        .fetch_one(pool)
        .await
        .unwrap_or(0);
    if tem_windsor_dup > 0 {
        sqlx::query("DELETE FROM unioes WHERE slot_masculino_id LIKE 'pub_windsor_%' OR slot_feminino_id LIKE 'pub_windsor_%' OR slot_masculino_id LIKE 'pub_ph_pub_windsor_%' OR slot_feminino_id LIKE 'pub_ph_pub_windsor_%'")
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM arvore_membros WHERE arvore_id = 'pub_arv_windsor'")
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM arvores WHERE id = 'pub_arv_windsor'")
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM pessoas WHERE id LIKE 'pub_windsor_%' OR id LIKE 'pub_ph_pub_windsor_%'")
            .execute(pool)
            .await?;
    }
    sqlx::query("UPDATE arvores SET nome = 'Casa Real Britânica (Windsor)' WHERE id = 'arv_real_britanica'")
        .execute(pool)
        .await?;

    // 3. Remove árvore duplicada de Davi se existir, unificando em arv_biblica_david
    let tem_davi_dup: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM arvores WHERE id = 'pub_arv_casa_de_davi'")
        .fetch_one(pool)
        .await
        .unwrap_or(0);
    if tem_davi_dup > 0 {
        sqlx::query("DELETE FROM unioes WHERE slot_masculino_id LIKE 'pub_casa_de_davi_%' OR slot_feminino_id LIKE 'pub_casa_de_davi_%' OR slot_masculino_id LIKE 'pub_ph_pub_casa_de_davi_%' OR slot_feminino_id LIKE 'pub_ph_pub_casa_de_davi_%'")
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM arvore_membros WHERE arvore_id = 'pub_arv_casa_de_davi'")
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM arvores WHERE id = 'pub_arv_casa_de_davi'")
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM pessoas WHERE id LIKE 'pub_casa_de_davi_%' OR id LIKE 'pub_ph_pub_casa_de_davi_%'")
            .execute(pool)
            .await?;
    }
    sqlx::query("UPDATE arvores SET nome = 'Casa Real de Davi (Linhagem Bíblica)' WHERE id = 'arv_biblica_david'")
        .execute(pool)
        .await?;

    // 4. Limpa placeholders legados do Japão e Patriarcas
    sqlx::query("DELETE FROM unioes WHERE slot_masculino_id LIKE 'pub_ph_pub_casa_imperial_japao_%' OR slot_feminino_id LIKE 'pub_ph_pub_casa_imperial_japao_%'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE pessoa_id LIKE 'pub_ph_pub_casa_imperial_japao_%'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM pessoas WHERE id LIKE 'pub_ph_pub_casa_imperial_japao_%'")
        .execute(pool)
        .await?;

    sqlx::query("DELETE FROM unioes WHERE slot_masculino_id = 'pub_ph_pub_patriarcas_israel_jaco' OR slot_feminino_id = 'pub_ph_pub_patriarcas_israel_jaco'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE pessoa_id = 'pub_ph_pub_patriarcas_israel_jaco'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM pessoas WHERE id = 'pub_ph_pub_patriarcas_israel_jaco'")
        .execute(pool)
        .await?;

    // 5. Desconecta o salto de 2000 anos entre a Casa de Davi e Rashi (Lurie), fixando raiz em Rashi
    sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_lurie_david_rashi'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_lurie_david_rashi'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM unioes WHERE id = 'pub_u_lurie_david_rashi'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE arvore_id = 'pub_arv_lurie' AND pessoa_id = 'pub_rei_david'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE arvore_id = 'pub_arv_lurie' AND pessoa_id = 'pub_lurie_rei_david'")
        .execute(pool)
        .await?;
    sqlx::query("UPDATE arvores SET raiz_pessoa_id = 'pub_lurie_rashi' WHERE id = 'pub_arv_lurie'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM unioes WHERE slot_masculino_id = 'pub_lurie_rei_david' OR slot_feminino_id = 'pub_lurie_rei_david'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM pessoas WHERE id = 'pub_lurie_rei_david'")
        .execute(pool)
        .await?;

    // 6. Corrige árvore Curie legada: elimina união espúria Pierre Joliot + Marie Curie
    sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_pub_arv_curie_pub_curie_pierre_joliot_pub_curie_marie_'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_pub_arv_curie_pub_curie_pierre_joliot_pub_curie_marie_'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM unioes WHERE id = 'pub_u_pub_arv_curie_pub_curie_pierre_joliot_pub_curie_marie_'")
        .execute(pool)
        .await?;

    // 7. Corrige árvore Mussolini: desfaz união indevida com neta e vincula Donna Rachele
    sqlx::query("UPDATE unioes SET slot_feminino_id = 'pub_mussolini_rachele_mussolini' WHERE id = 'pub_u_pub_arv_mussolini_pub_mussolini_benito_mussolini_pub_m'")
        .execute(pool)
        .await?;

    // 8. Corrige Darwin: remove união antiga e placeholder de Josiah Wedgwood II se existir
    sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_ii_pub_ph_pu'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_ii_pub_ph_pu'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM unioes WHERE id = 'pub_u_pub_arv_darwin_pub_darwin_josiah_wedgwood_ii_pub_ph_pu'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM arvore_membros WHERE pessoa_id = 'pub_ph_pub_darwin_josiah_wedgwood_ii'")
        .execute(pool)
        .await?;
    sqlx::query("DELETE FROM pessoas WHERE id = 'pub_ph_pub_darwin_josiah_wedgwood_ii'")
        .execute(pool)
        .await?;

    // 9. Saneamento estrutural de uniões e placeholders espúrios (Bach, Kennedy, Roosevelt, Habsburgo, Buendía)
    // Bach: remove uniões com placeholders desconhecidos
    for uid in &[
        "pub_u_pub_arv_bach_pub_ph_pub_bach_maria_barbara_bach_pub_ba",
        "pub_u_pub_arv_bach_pub_ph_pub_bach_anna_magdalena_bach_pub_b",
        "pub_u_pub_arv_bach_pub_bach_johann_ambrosius_bach_pub_ph_pub",
    ] {
        sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = ?").bind(uid).execute(pool).await?;
        sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = ?").bind(uid).execute(pool).await?;
        sqlx::query("DELETE FROM unioes WHERE id = ?").bind(uid).execute(pool).await?;
    }
    sqlx::query("DELETE FROM pessoas WHERE id IN ('pub_ph_pub_bach_maria_barbara_bach', 'pub_ph_pub_bach_anna_magdalena_bach')").execute(pool).await?;

    // Kennedy: remove união incorreta RFK Jr. com a mãe
    sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_pub_arv_kennedy_pub_kennedy_robert_f_kennedy_jr_pub_ke'").execute(pool).await?;
    sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_pub_arv_kennedy_pub_kennedy_robert_f_kennedy_jr_pub_ke'").execute(pool).await?;
    sqlx::query("DELETE FROM unioes WHERE id = 'pub_u_pub_arv_kennedy_pub_kennedy_robert_f_kennedy_jr_pub_ke'").execute(pool).await?;

    // Roosevelt: remove uniões espúrias com filhos
    for uid in &[
        "pub_u_pub_arv_roosevelt_pub_roosevelt_eleanor_roosevelt_pub_",
        "pub_u_pub_arv_roosevelt_pub_roosevelt_elliott_roosevelt_filh",
    ] {
        sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = ?").bind(uid).execute(pool).await?;
        sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = ?").bind(uid).execute(pool).await?;
        sqlx::query("DELETE FROM unioes WHERE id = ?").bind(uid).execute(pool).await?;
    }

    // Habsburgo: remove união incorreta de Joana a Louca com neto Filipe II
    sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_pub_arv_habsburgo_pub_habsburgo_joana_de_castela_pub_h'").execute(pool).await?;
    sqlx::query("DELETE FROM arvore_membros WHERE uniao_id = 'pub_u_pub_arv_habsburgo_pub_habsburgo_joana_de_castela_pub_h'").execute(pool).await?;
    sqlx::query("DELETE FROM unioes WHERE id = 'pub_u_pub_arv_habsburgo_pub_habsburgo_joana_de_castela_pub_h'").execute(pool).await?;

    // Buendía: desvincula o último Aureliano da união dos fundadores
    sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id = 'pub_u_pub_arv_buendia_pub_buendia_jose_arcadio_buendia_pub_b' AND pessoa_id = 'pub_buendia_aureliano_o_ultimo'").execute(pool).await?;

    // Saneamento de uniões legadas com sobreposição/ciclos (Bourbon, Roosevelt, Habsburgo, Mao)
    let arvores_legadas = [
        "pub_arv_bourbon",
        "pub_arv_roosevelt",
        "pub_arv_habsburgo",
        "pub_arv_mao",
    ];
    for arv in &arvores_legadas {
        let prefix = format!("pub_u_{}_%", arv);
        sqlx::query("DELETE FROM uniao_filhos WHERE uniao_id IN (SELECT uniao_id FROM arvore_membros WHERE arvore_id = ? AND uniao_id LIKE ?)")
            .bind(arv)
            .bind(&prefix)
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM arvore_membros WHERE arvore_id = ? AND uniao_id LIKE ?")
            .bind(arv)
            .bind(&prefix)
            .execute(pool)
            .await?;
        sqlx::query("DELETE FROM unioes WHERE id LIKE ?")
            .bind(&prefix)
            .execute(pool)
            .await?;
    }

    // 10. Semeia / sincroniza árvores e eventos de pesquisa histórica atualizados
    const SQL_PESQUISA: &str = include_str!("seeds/arvores_pesquisa.sql");
    sqlx::raw_sql(SQL_PESQUISA).execute(pool).await?;

    // 11. Aplica enriquecimento biográfico, locais georreferenciados e correção vital (migração 029)
    const SQL_ENRIQUECIMENTO: &str = include_str!("../../migrations/029__enriquecimento_biografias_locais.sql");
    sqlx::raw_sql(SQL_ENRIQUECIMENTO).execute(pool).await?;

    // 12. Aplica reorganização de categorias canônicas e georreferenciamento ampliado (migração 030)
    const SQL_CATEGORIAS_LOCAIS: &str = include_str!("../../migrations/030__organizacao_categorias_e_locais_publicos.sql");
    sqlx::raw_sql(SQL_CATEGORIAS_LOCAIS).execute(pool).await?;

    // 13. Aplica enriquecimento de atributos culturais, idiomas, escolaridade, profissões e obras (migração 031)
    const SQL_ATRIBUTOS_CULTURAIS: &str = include_str!("../../migrations/031__enriquecimento_atributos_culturais_e_profissionais.sql");
    sqlx::raw_sql(SQL_ATRIBUTOS_CULTURAIS).execute(pool).await?;

    // 14. Aplica criação e catalogação de obras culturais e idiomas nativos (migração 032)
    const SQL_OBRAS_CULTURAIS: &str = include_str!("../../migrations/032__obras_culturais.sql");
    sqlx::raw_sql(SQL_OBRAS_CULTURAIS).execute(pool).await?;

    // 15. Aplica correção estrutural de conexões e famílias históricas (migração 033)
    const SQL_CORRECAO_CONEXOES: &str = include_str!("../../migrations/033__correcao_estrutural_conexoes_e_familias_historicas.sql");
    sqlx::raw_sql(SQL_CORRECAO_CONEXOES).execute(pool).await?;

    // 16. Aplica enriquecimento multitemático do acervo histórico (migração 034)
    const SQL_ENRIQUECIMENTO_MULTITEMATICO: &str = include_str!("../../migrations/034__enriquecimento_multitematico_acervo_historico.sql");
    sqlx::raw_sql(SQL_ENRIQUECIMENTO_MULTITEMATICO).execute(pool).await?;

    // 17. Aplica Lote Brasil Ilustre
    const SQL_BRASIL_ILUSTRE: &str = include_str!("seeds/lote_brasil_ilustre.sql");
    sqlx::raw_sql(SQL_BRASIL_ILUSTRE).execute(pool).await?;

    // 18. Aplica Lote 2: Revolução Científica e Invenção Tecnológica
    const SQL_REVOLUCAO_CIENTIFICA: &str = include_str!("seeds/revolucao_cientifica.sql");
    sqlx::raw_sql(SQL_REVOLUCAO_CIENTIFICA).execute(pool).await?;

    // 19. Aplica Lote 3: Grandes Lideranças Mundiais e Fundadores de Nações
    const SQL_LIDERANCAS_MUNDIAIS: &str = include_str!("seeds/liderancas_mundiais.sql");
    sqlx::raw_sql(SQL_LIDERANCAS_MUNDIAIS).execute(pool).await?;

    // 20. Aplica Lote 4: Grandes Gênios da Literatura e das Artes Clássicas
    const SQL_ARTES_LITERATURA: &str = include_str!("seeds/artes_literatura.sql");
    sqlx::raw_sql(SQL_ARTES_LITERATURA).execute(pool).await?;

    // 21. Aplica Lote 5: Grandes Dinastias Políticas do Século XX
    const SQL_DINASTIAS_POLITICAS: &str = include_str!("seeds/dinastias_politicas.sql");
    sqlx::raw_sql(SQL_DINASTIAS_POLITICAS).execute(pool).await?;

    // 22. Aplica Lote 6: Grandes Empreendedores & Pioneiros Industriais
    const SQL_EMPREENDEDORES: &str = include_str!("seeds/empreendedores_pioneiros.sql");
    sqlx::raw_sql(SQL_EMPREENDEDORES).execute(pool).await?;

    // 23. Aplica Lote 8: Pais Fundadores & Estadistas das Américas
    const SQL_PAIS_FUNDADORES: &str = include_str!("seeds/pais_fundadores_estadistas.sql");
    sqlx::raw_sql(SQL_PAIS_FUNDADORES).execute(pool).await?;

    // 24. Aplica Lote 9: Mestres da Música Clássica & Artes Cênicas
    const SQL_MESTRES_MUSICA: &str = include_str!("seeds/mestres_musica_classica.sql");
    sqlx::raw_sql(SQL_MESTRES_MUSICA).execute(pool).await?;

    // 25. Aplica Lote 10: Grandes Gênios da Literatura Universal & Dramaturgia
    const SQL_GRANDES_LITERATURA: &str = include_str!("seeds/grandes_genios_literatura.sql");
    sqlx::raw_sql(SQL_GRANDES_LITERATURA).execute(pool).await?;

    // 26. Aplica Lote 11: Grandes Monarquias, Impérios & Casas Reais
    const SQL_GRANDES_MONARQUIAS: &str = include_str!("seeds/grandes_monarquias_mundiais.sql");
    sqlx::raw_sql(SQL_GRANDES_MONARQUIAS).execute(pool).await?;

    // 27. Aplica Lote 12: Antiguidade, Tradição Bíblica & Genealogias Ficcionais
    const SQL_ANTIGUIDADE_BIBLIA_FICCAO: &str = include_str!("seeds/antiguidade_biblia_ficcao.sql");
    sqlx::raw_sql(SQL_ANTIGUIDADE_BIBLIA_FICCAO).execute(pool).await?;

    // 28. Saneamento estrutural definitivo: elimina ciclos de cônjuges, conecta pessoas solitárias e ajusta raízes
    const SQL_SANEAMENTO_ESTRUTURAL: &str = include_str!("seeds/saneamento_estrutural_definitivo.sql");
    sqlx::raw_sql(SQL_SANEAMENTO_ESTRUTURAL).execute(pool).await?;

    Ok(())
}

#[cfg(test)]
mod testes {
    use super::*;
    use sqlx::sqlite::SqlitePoolOptions;

    #[tokio::test]
    async fn semeia_arvores_publicas_com_sucesso() {
        let pool = SqlitePoolOptions::new()
            .connect("sqlite::memory:")
            .await
            .unwrap();

        sqlx::migrate!("./migrations").run(&pool).await.unwrap();

        garantir_acervo_publico(&pool).await.unwrap();

        let arvores: Vec<(String, String, bool)> = sqlx::query_as(
            "SELECT id, nome, is_publico FROM arvores WHERE is_publico = 1 ORDER BY nome"
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        assert!(arvores.len() >= 40);
        let nomes: Vec<String> = arvores.into_iter().map(|(_, n, _)| n).collect();
        assert!(nomes.contains(&"Família Imperial do Brasil".to_string()));
        assert!(nomes.contains(&"Casa Real Britânica (Windsor)".to_string()));
        assert!(nomes.contains(&"Casa Real de Davi (Linhagem Bíblica)".to_string()));
        assert!(nomes.contains(&"Genealogia de Adão (Gênesis / Antediluviana)".to_string()));
        assert!(nomes.contains(&"Dinastia Musical Bach".to_string()));
        assert!(nomes.contains(&"Família Curie / Joliot-Curie".to_string()));
        assert!(nomes.contains(&"Patriarcas de Israel (Abraão a José)".to_string()));
        assert!(nomes.contains(&"Casa Imperial do Japão (Dinastia Yamato)".to_string()));

        let total_publicos: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM pessoas WHERE is_publico = 1")
            .fetch_one(&pool)
            .await
            .unwrap();

        assert!(total_publicos >= 420);

        // Verifica que Jimmu tem datas registradas com cerca_de
        let ev_jimmu: Vec<(String, i64, String)> = sqlx::query_as(
            "SELECT tipo_evento, ano_inicio, data_qualificador FROM eventos WHERE pessoa_id = 'pub_casa_imperial_japao_imperador_jimmu' ORDER BY ano_inicio"
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        assert_eq!(ev_jimmu.len(), 2);
        assert_eq!(ev_jimmu[0].1, -711);
        assert_eq!(ev_jimmu[0].2, "cerca_de");
        assert_eq!(ev_jimmu[1].1, -585);
        assert_eq!(ev_jimmu[1].2, "cerca_de");

        let total_religioes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM religioes_pessoa")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total_religioes >= 170);

        let total_idiomas: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM idiomas_pessoa")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total_idiomas >= 760);

        let total_escolaridade: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM escolaridade_pessoa")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total_escolaridade >= 120);

        let total_profissoes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM profissoes_pessoa")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total_profissoes >= 230);

        let total_publicacoes: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM eventos WHERE tipo_evento = 'publicacao'")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total_publicacoes >= 40);

        let total_obras: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM obras_culturais")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert!(total_obras >= 180);

        // Validação de integridade estrutural das 5 famílias corrigidas:
        // 1. Stalin tem pai Besarion e mãe Ekaterine Geladze
        let pais_stalin: Vec<String> = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_stalin_stalin'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert_eq!(pais_stalin, vec!["pub_stalin_besarion_jughashvili".to_string()]);

        // 2. Perón: Juan Domingo Perón é casado com Eva Perón (e NÃO Mario Tomás!)
        let conjuge_eva: String = sqlx::query_scalar(
            "SELECT slot_masculino_id FROM unioes WHERE slot_feminino_id = 'pub_peron_eva_peron'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(conjuge_eva, "pub_peron_juan_domingo_peron".to_string());

        // 3. Hitler: William Patrick é filho de Alois Jr. (e NÃO de Alois Sr. e Klara)
        let pai_william: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_hitler_william_patrick_hitler'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_william, "pub_hitler_alois_hitler_jr".to_string());

        // 4. Rockefeller: John D. III é casado com Blanchette Hooker (e NÃO Laura Spelman)
        let esposa_jdr_iii: String = sqlx::query_scalar(
            "SELECT slot_feminino_id FROM unioes WHERE slot_masculino_id = 'pub_rockefeller_john_d_rockefeller_iii'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(esposa_jdr_iii, "pub_rockefeller_blanchette_hooker".to_string());

        // 5. Klabin-Lafer: Jenny Klabin Segall existe e está casada com Lasar Segall
        let conjuge_jenny: String = sqlx::query_scalar(
            "SELECT slot_masculino_id FROM unioes WHERE slot_feminino_id = 'pub_klabin_jenny_klabin_segall'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(conjuge_jenny, "pub_klabin_lasar_segall".to_string());

        // 6. Enriquecimento Lote 1-5: José Bonifácio, Jacqueline Kennedy, Confúcio e Rashi
        let profs_bonifacio: Vec<String> = sqlx::query_scalar(
            "SELECT ocupacao FROM profissoes_pessoa WHERE pessoa_id = 'pub_jose_bonifacio'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(!profs_bonifacio.is_empty());

        let obras_jackie: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_kennedy_jacqueline_kennedy_onassis'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_jackie.len() >= 2);

        // 7. Lote Brasil Ilustre (Caxias, Nabuco, Ruy, Mauá, Santos Dumont, Machado, Oswaldo Cruz, Chiquinha Gonzaga)
        let pai_caxias: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_caxias_luis_alves'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_caxias, "pub_caxias_francisco_de_lima_e_silva".to_string());

        let obras_nabuco: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_nabuco_joaquim_nabuco'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_nabuco.iter().any(|t| t.contains("Abolicionismo")));

        let obras_machado: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_machado_de_assis'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_machado.iter().any(|t| t.contains("Dom Casmurro")));

        let obras_dumont: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_dumont_alberto_santos'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_dumont.iter().any(|t| t.contains("14-Bis")));

        let obras_chiquinha: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_gonzaga_chiquinha'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_chiquinha.iter().any(|t| t.contains("Ó Abre Alas")));

        // 8. Lote 2: Revolução Científica (Einstein, Newton, Galileu, Da Vinci, Tesla, Edison)
        let pai_einstein: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_einstein_albert'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_einstein, "pub_einstein_hermann".to_string());

        let obras_einstein: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_einstein_albert'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_einstein.iter().any(|t| t.contains("Relatividade")));

        let mae_newton: String = sqlx::query_scalar(
            "SELECT u.slot_feminino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_newton_isaac'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(mae_newton, "pub_newton_hannah_ayscough".to_string());

        let obras_newton: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_newton_isaac'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_newton.iter().any(|t| t.contains("Principia")));

        let pai_galileu: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_galilei_galileo'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_galileu, "pub_galilei_vincenzo".to_string());

        let obras_galileu: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_galilei_galileo'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_galileu.iter().any(|t| t.contains("Sidereus Nuncius")));

        let pai_davinci: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_davinci_leonardo'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_davinci, "pub_davinci_piero".to_string());

        let obras_davinci: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_davinci_leonardo'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_davinci.iter().any(|t| t.contains("Mona Lisa")));

        let pai_tesla: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_tesla_nikola'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_tesla, "pub_tesla_milutin".to_string());

        let obras_tesla: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_tesla_nikola'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_tesla.iter().any(|t| t.contains("Corrente Alternada")));

        let pai_edison: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_edison_thomas'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_edison, "pub_edison_samuel".to_string());

        let obras_edison: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_edison_thomas'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_edison.iter().any(|t| t.contains("Fonógrafo")));

        // Validação Lote 6: Empreendedores Pioneiros
        let pai_matarazzo_jr: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_matarazzo_francisco_matarazzo_junior'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_matarazzo_jr, "pub_matarazzo_francesco_matarazzo".to_string());

        let pai_armando_penteado: String = sqlx::query_scalar(
            "SELECT u.slot_masculino_id FROM unioes u JOIN uniao_filhos uf ON uf.uniao_id = u.id WHERE uf.pessoa_id = 'pub_penteado_armando_alvares_penteado'"
        )
        .fetch_one(&pool)
        .await
        .unwrap();
        assert_eq!(pai_armando_penteado, "pub_penteado_antonio_alvares_leite_penteado".to_string());

        let obras_maua: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_maua_irineu_evangelista'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_maua.iter().any(|t| t.contains("Autobiografia")));

        let obras_klabin_jenny: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_klabin_jenny_klabin_segall'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_klabin_jenny.iter().any(|t| t.contains("Fausto")));

        // Validação Lote 7: Pioneiros da Revolução Científica (Curie, Darwin, Galilei, Melzi)
        let obras_curie: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_curie_marie_skodowska_curie'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_curie.iter().any(|t| t.contains("substances radioactives")));

        let obras_darwin_erasmus: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_darwin_erasmus_darwin'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_darwin_erasmus.iter().any(|t| t.contains("Zoonomia")));

        let obras_vincenzo_galilei: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_galilei_vincenzo'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_vincenzo_galilei.iter().any(|t| t.contains("musica antica")));

        let obras_melzi: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_davinci_melzi'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_melzi.iter().any(|t| t.contains("Codex Urbinas")));

        // Validação Lote 8: Pais Fundadores & Estadistas das Américas
        let obras_washington: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_washington_george'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_washington.iter().any(|t| t.contains("Rules of Civility")));

        let obras_jefferson: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_jefferson_thomas'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_jefferson.iter().any(|t| t.contains("Notes on the State of Virginia")));

        let obras_franklin: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_franklin_benjamin'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_franklin.iter().any(|t| t.contains("Poor Richard")));

        let obras_lincoln: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_lincoln_abraham'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_lincoln.iter().any(|t| t.contains("House Divided")));

        let obras_1822: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_goncalves_ledo', 'pub_antonio_carlos', 'pub_frei_caneca')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_1822.iter().any(|t| t.contains("Revérbero")));
        assert!(obras_1822.iter().any(|t| t.contains("Constituição da Mandioca")));

        // Validação Lote 9: Mestres da Música Clássica & Artes Cênicas
        let obras_bach: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_bach_johann_sebastian_bach'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_bach.iter().any(|t| t.contains("Paixão segundo São Mateus")));

        let obras_mozart: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_mozart_wolfgang'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_mozart.iter().any(|t| t.contains("Requiem")));

        let obras_beethoven: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_beethoven_ludwig'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_beethoven.iter().any(|t| t.contains("Sinfonia nº 9")));

        let obras_chiquinha: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_gonzaga_chiquinha'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_chiquinha.iter().any(|t| t.contains("Ó Abre Alas")));

        // Validação Lote 10: Grandes Gênios da Literatura Universal & Dramaturgia
        let obras_shak: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_shakespeare_william'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_shak.iter().any(|t| t.contains("Hamlet")));
        assert!(obras_shak.iter().any(|t| t.contains("Sonetos")));

        let obras_cerv: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id = 'pub_cervantes_miguel'"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_cerv.iter().any(|t| t.contains("Don Quijote") || t.contains("Dom Quixote")));

        let obras_dant: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_dante_alighieri', 'pub_dante_pietro')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_dant.iter().any(|t| t.contains("Divina Comédia")));
        assert!(obras_dant.iter().any(|t| t.contains("Commentarium")));

        let obras_goet: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_goethe_johann_wolfgang', 'pub_goethe_ottilie')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_goet.iter().any(|t| t.contains("Fausto")));
        assert!(obras_goet.iter().any(|t| t.contains("Chaos")));

        let obras_hugo: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_hugo_victor', 'pub_hugo_francois_victor')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_hugo.iter().any(|t| t.contains("Miseráveis") || t.contains("Misérables")));
        assert!(obras_hugo.iter().any(|t| t.contains("Shakespeare")));

        // Validação Lote 11: Grandes Monarquias, Impérios & Casas Reais
        let obras_windsor: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_vitoria_uk', 'pub_alberto_uk', 'pub_elizabeth2_uk')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_windsor.iter().any(|t| t.contains("Proclamação Real de 1858") || t.contains("Índia")));
        assert!(obras_windsor.iter().any(|t| t.contains("Grande Exposição")));

        let obras_habs: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_habsburgo_carlos_v', 'pub_habsburgo_filipe_ii', 'pub_habsburgo_maria_teresa')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_habs.iter().any(|t| t.contains("Worms")));
        assert!(obras_habs.iter().any(|t| t.contains("Escorial")));

        let obras_bourb: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_bourbon_henrique_iv_da_franca', 'pub_bourbon_luis_xiv', 'pub_bourbon_juan_carlos_i')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_bourb.iter().any(|t| t.contains("Nantes")));
        assert!(obras_bourb.iter().any(|t| t.contains("Versalhes")));
        assert!(obras_bourb.iter().any(|t| t.contains("23-F")));

        let obras_yamato: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_casa_imperial_japao_imperador_meiji', 'pub_casa_imperial_japao_imperador_showa')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_yamato.iter().any(|t| t.contains("Meiji")));
        assert!(obras_yamato.iter().any(|t| t.contains("Gyokuon")));

        // Validação Lote 12: Antiguidade, Tradição Bíblica & Genealogias Ficcionais
        let obras_antiguidade: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_dinastia_19_ramesses_ii', 'pub_kong_confucio_confucio', 'pub_moises_moises', 'pub_rei_david', 'pub_rei_salomao')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_antiguidade.iter().any(|t| t.contains("Qadesh")));
        assert!(obras_antiguidade.iter().any(|t| t.contains("Analectos")));
        assert!(obras_antiguidade.iter().any(|t| t.contains("Torá") || t.contains("Pentateuco")));
        assert!(obras_antiguidade.iter().any(|t| t.contains("Salmos")));
        assert!(obras_antiguidade.iter().any(|t| t.contains("Provérbios")));

        let obras_ficcao: Vec<String> = sqlx::query_scalar(
            "SELECT titulo FROM obras_culturais WHERE pessoa_id IN ('pub_buendia_coronel_aureliano_buendia', 'pub_corleone_vito_corleone', 'pub_karamazov_ivan_karamazov', 'pub_skywalker_luke_skywalker', 'pub_terra_cambara_capitao_rodrigo_cambara')"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        assert!(obras_ficcao.iter().any(|t| t.contains("Peixinhos de Ouro")));
        assert!(obras_ficcao.iter().any(|t| t.contains("Genco Pura")));
        assert!(obras_ficcao.iter().any(|t| t.contains("Grande Inquisidor")));
        assert!(obras_ficcao.iter().any(|t| t.contains("Cavaleiros Jedi")));
        assert!(obras_ficcao.iter().any(|t| t.contains("Farroupilha")));

        // Verifica que árvores e membros ficcionais estão marcados como 'ficticio'
        let tipo_arv_buendia: String = sqlx::query_scalar("SELECT tipo_tempo FROM arvores WHERE id = 'pub_arv_buendia'")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(tipo_arv_buendia, "ficticio");

        let tipo_arv_skywalker: String = sqlx::query_scalar("SELECT tipo_tempo FROM arvores WHERE id = 'pub_arv_skywalker'")
            .fetch_one(&pool)
            .await
            .unwrap();
        assert_eq!(tipo_arv_skywalker, "ficticio");
    }

    #[tokio::test]
    async fn diagnostico_estrutural_todas_arvores() {
        let pool = SqlitePoolOptions::new()
            .connect("sqlite::memory:")
            .await
            .unwrap();
        sqlx::migrate!("./migrations").run(&pool).await.unwrap();
        garantir_acervo_publico(&pool).await.unwrap();

        let arvores: Vec<(String, String, Option<String>)> = sqlx::query_as(
            "SELECT id, nome, raiz_pessoa_id FROM arvores WHERE is_publico = 1 ORDER BY nome"
        )
        .fetch_all(&pool)
        .await
        .unwrap();

        println!("=== DIAGNOSTICO DE {} ARVORES PUBLICAS ===", arvores.len());
        let mut total_solitarias = 0;
        let mut arvores_multi_comp = 0;

        for (arv_id, arv_nome, raiz_id) in &arvores {
            let membros: Vec<(String, String, Option<String>, bool)> = sqlx::query_as(
                "SELECT p.id, p.nome, p.sobrenome, p.is_placeholder
                 FROM arvore_membros am
                 JOIN pessoas p ON p.id = am.pessoa_id
                 WHERE am.arvore_id = ? AND am.pessoa_id IS NOT NULL"
            )
            .bind(arv_id)
            .fetch_all(&pool)
            .await
            .unwrap();

            let mut solitarias = Vec::new();
            for (pid, pnome, psob, _) in &membros {
                let tem_uniao: i64 = sqlx::query_scalar(
                    "SELECT COUNT(*) FROM unioes WHERE slot_masculino_id = ? OR slot_feminino_id = ?"
                )
                .bind(pid)
                .bind(pid)
                .fetch_one(&pool)
                .await
                .unwrap();

                let tem_pais: i64 = sqlx::query_scalar(
                    "SELECT COUNT(*) FROM uniao_filhos WHERE pessoa_id = ?"
                )
                .bind(pid)
                .fetch_one(&pool)
                .await
                .unwrap();

                if tem_uniao == 0 && tem_pais == 0 {
                    solitarias.push(format!("{} {} ({})", pnome, psob.clone().unwrap_or_default(), pid));
                }
            }

            let mut grafo_count = 0;
            let mut componentes = 0;
            let mut ilhas: Vec<Vec<String>> = Vec::new();
            if let Some(rid) = raiz_id {
                let g4 = crate::commands::tree_cmds::buscar_grafo_arvore_db(&pool, rid, Some(4), Some(4)).await.unwrap();
                grafo_count = g4.nodes.len();

                let mut adj: std::collections::HashMap<String, Vec<String>> = std::collections::HashMap::new();
                for n in &g4.nodes {
                    adj.entry(n.id.clone()).or_default();
                }
                for u in &g4.unions {
                    let p1 = &u.slot_masculino_id;
                    let p2 = &u.slot_feminino_id;
                    if adj.contains_key(p1) && adj.contains_key(p2) {
                        adj.entry(p1.clone()).or_default().push(p2.clone());
                        adj.entry(p2.clone()).or_default().push(p1.clone());
                    }
                }
                let mut union_map: std::collections::HashMap<String, (String, String)> = std::collections::HashMap::new();
                for u in &g4.unions {
                    union_map.insert(u.id.clone(), (u.slot_masculino_id.clone(), u.slot_feminino_id.clone()));
                }
                for l in &g4.links {
                    if let Some((pa, pb)) = union_map.get(&l.source) {
                        if adj.contains_key(pa) && adj.contains_key(&l.target) {
                            adj.entry(pa.clone()).or_default().push(l.target.clone());
                            adj.entry(l.target.clone()).or_default().push(pa.clone());
                        }
                        if adj.contains_key(pb) && adj.contains_key(&l.target) {
                            adj.entry(pb.clone()).or_default().push(l.target.clone());
                            adj.entry(l.target.clone()).or_default().push(pb.clone());
                        }
                    }
                }
                let mut visitados = std::collections::HashSet::new();
                for n in &g4.nodes {
                    if visitados.insert(n.id.clone()) {
                        componentes += 1;
                        let mut comp = Vec::new();
                        let mut fila = std::collections::VecDeque::new();
                        fila.push_back(n.id.clone());
                        while let Some(atual) = fila.pop_front() {
                            comp.push(atual.clone());
                            if let Some(vizinhos) = adj.get(&atual) {
                                for v in vizinhos {
                                    if visitados.insert(v.clone()) {
                                        fila.push_back(v.clone());
                                    }
                                }
                            }
                        }
                        ilhas.push(comp);
                    }
                }
            }

            if !solitarias.is_empty() || grafo_count < membros.len() || componentes > 1 {
                println!(
                    "ARVORE: {} ({}) | Membros={} | Grafo(g=4)={} | Componentes={} | Solitarias={:?} | Ilhas={:?}",
                    arv_nome, arv_id, membros.len(), grafo_count, componentes, solitarias, ilhas
                );
            }
            if componentes > 1 {
                arvores_multi_comp += 1;
            }
            total_solitarias += solitarias.len();
        }

        let ciclos_conjuge: Vec<(String, String, String)> = sqlx::query_as(
            "SELECT u1.id, u2.id, u1.slot_feminino_id
             FROM unioes u1
             JOIN uniao_filhos uf ON uf.uniao_id = u1.id
             JOIN unioes u2 ON (u2.slot_masculino_id = uf.pessoa_id AND u2.slot_feminino_id = u1.slot_feminino_id)
                            OR (u2.slot_feminino_id = uf.pessoa_id AND u2.slot_masculino_id = u1.slot_masculino_id)"
        )
        .fetch_all(&pool)
        .await
        .unwrap();
        println!("CICLOS CONJUGE-FILHO: {:?}", ciclos_conjuge);
        assert_eq!(total_solitarias, 0, "Existem pessoas solitarias!");
        assert!(ciclos_conjuge.is_empty(), "Existem ciclos conjuge-filho!");
        assert_eq!(arvores_multi_comp, 0, "Existem arvores com multiplas ilhas desconexas!");
    }
}


