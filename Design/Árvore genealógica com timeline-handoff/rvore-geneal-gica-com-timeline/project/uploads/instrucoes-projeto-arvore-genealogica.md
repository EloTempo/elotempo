# Instruções do Projeto — Software Local de Árvore Genealógica

> Cole este documento no campo de instruções do Projeto no Claude. Ele serve de
> contexto persistente para todo o desenvolvimento feito via Claude Code local.
> Versão 4 — inclui eventos de vida, atributos em lista (religião, escolaridade,
> profissões, idiomas), apelidos, nacionalidades, locais nacionais e estrangeiros,
> múltiplas árvores, relatórios impressos, pesquisa e estatísticas, linhas do tempo
> de contexto e pessoais, e a linguagem visual dos nós.

---

## 1. Objetivo e princípios

Software desktop instalável e **100% offline** para construir árvores genealógicas
familiares **sem limite de tamanho**. Todos os dados residem apenas na máquina; nenhuma
conexão com a internet é necessária para operar.

**Objetivo central: ajudar a memória das pessoas** — preservar lembranças familiares e
reativá-las situando cada vida no contexto cultural e histórico da sua época. Esse
propósito orienta as decisões de conteúdo (por exemplo, o critério do que entra nas linhas
do tempo de contexto).

Princípios inegociáveis:

- **Local-first**: os dados nunca saem da máquina sem ação explícita do usuário.
- **Portabilidade**: o usuário é dono do arquivo e deve poder exportar tudo.
- **Escala**: suportar árvores muito grandes (milhares de nós) sem travar a interface.
- **Padrão aberto**: alinhar o modelo ao GEDCOM 7.0 para interoperar com Gramps,
  Ancestris, FamilySearch etc.

---

## 2. Modelo de domínio

Segue o padrão **lineage-linked** do GEDCOM: pessoas (`INDI`) e uniões/famílias (`FAM`),
sendo a união a única fonte de ligação entre indivíduos.

### 2.1 Pessoa (`INDI`)
Cada pessoa é um **nó**. Campos:
- `id` (identificador único e estável)
- `nome` (estruturado em nome + sobrenome — convenção GEDCOM `/Sobrenome/` — para
  permitir busca e agrupamento por sobrenome)
- `apelidos` (lista opcional — alcunhas pelas quais a pessoa ficou conhecida em vida;
  quando vazia, não aparece na interface; GEDCOM `NICK`)
- `sexo` (valores GEDCOM: `M`, `F`, `X`, `U`)
- `nacionalidade` (lista — país(es); selecionável da lista de países de 2.4; GEDCOM `NATI`)
- `foto` (caminho para a miniatura/retrato principal)
- `minibiografia` (texto livre)
- `vivo` (flag booleano — controla ocultação de pessoas vivas na exportação)
- `documentos anexos` (lista de arquivos: imagens, PDFs etc.)
- eventos de vida (ver 2.3)
- atributos de vida em lista: religião, escolaridade, profissões, idiomas (ver 2.5)

### 2.2 União / Família (`FAM`)
Nó que **liga cônjuges e ancora os filhos**. É o elemento central do desenho.
- **Sempre dois slots: um masculino e um feminino** (regra de negócio definida).
- `filhos`: lista de ligações, cada uma com `tipo_vinculo` (ver 2.6).

**Regra do placeholder**: quando um dos pais é desconhecido, o slot é preenchido por uma
**pessoa-placeholder** — um nó real, com sexo definido, nome "Desconhecido/a" e flag
`is_placeholder = true`. Isso mantém a união sempre binária e permite cadastrar o filho
mesmo sem os dois nomes. Ao descobrir o nome, edita-se o placeholder e ele vira o
ancestral real, com os filhos já pendurados nele. Em GEDCOM corresponde a uma `FAM` com
só um dos parceiros nomeado, então segue compatível.

**Regra fundamental**: filhos NÃO se conectam a um pai ou mãe diretamente. Conectam-se a
uma **união**, e a união aponta para os pais.

### 2.3 Eventos de vida
Cada evento tem: `tipo`, `data` (com suporte a datas aproximadas/incompletas — só o ano,
"cerca de", intervalos), `local` (referência a 2.4), `nota` e `fonte` (opcional, ver 2.7).

Tipos: nascimento, batismo, casamento, falecimento, sepultamento (lista extensível).
- **MVP**: nascimento e falecimento (data + local), além do flag `vivo`. A data de morte
  é metade da identidade de um nó genealógico.
- O batismo carrega opcionalmente sua própria denominação religiosa e igreja.

### 2.4 Locais (nacionais e estrangeiros)
Em vez de local como texto solto e repetido, uma tabela `locais`:
- `nome`, `uf`, `pais`, `codigo_ibge` (chave estável para o Brasil), coordenadas (opcional).
- Seed via **API de Localidades do IBGE** (~5.570 municípios), embutida no app —
  baixada uma vez e transformada em tabela do SQLite. Custo de espaço desprezível.
- Autocomplete no preenchimento (municípios brasileiros).
- **Nomes de cidade mudam com o tempo**: permitir um texto livre que sobrescreve o
  rótulo histórico ("nascido em Vila X, hoje município Y") mantendo o `codigo_ibge`
  como chave. Assim o autocomplete acelera sem enrijecer o dado histórico.
- **Locais estrangeiros**: o `país` é selecionável de uma lista de países (com os de
  imigração mais comuns no Brasil — Portugal, Itália, Espanha, Alemanha, Japão, Líbano,
  Síria, Polônia etc. — no topo). Para local no exterior, a **cidade é texto livre** (sem
  autocomplete e sem `codigo_ibge`); apenas o país é padronizado. Essa mesma lista de
  países alimenta a `nacionalidade` (2.1). Consequência para estatística: cidades
  estrangeiras (texto livre) não agrupam de forma confiável — agregar o exterior por país.

### 2.5 Atributos de vida em lista
Vários atributos são registrados como **listas** por pessoa, seguindo o mesmo padrão:
uma entrada por item, com **data/período opcional**. Regra transversal: **a data nunca é
obrigatória para salvar** — o app grava a entrada apenas com o valor.

- **Religião** — afiliações ao longo da vida (para capturar conversões). Cada item:
  `denominação` (grupo → subdenominação) + período opcional. Taxonomia inicial, com texto
  livre para o resto: Católica (Apostólica Romana); Evangélica/Protestante → Batista,
  Assembleia de Deus, Congregacional, Presbiteriana, Metodista, Universal, Adventista,
  Quadrangular; Espírita (kardecista); Umbanda; Candomblé; Testemunha de Jeová; Judaica;
  Islâmica; Budista; Maçonaria (ordem fraternal, registrada aqui a pedido); Sem religião /
  Não informada. Tag GEDCOM `RELI`.
- **Escolaridade** — nível de ensino alcançado + instituição (opcional) + data/período
  (opcional). Taxonomia BR: Fundamental (incompleto/completo), Médio (incompleto/
  completo), Técnico, Superior (incompleto/completo), Especialização, Mestrado, Doutorado.
  Tag GEDCOM `EDUC`.
- **Profissões** — ocupações ao longo da vida; uma pessoa pode ter várias. Cada item:
  `ocupação` + empregador/local (opcional) + período (opcional). Tag GEDCOM `OCCU`.
- **Idiomas** — lista simples de idiomas que a pessoa falava, sem data. Em GEDCOM não há
  tag padrão forte para idioma falado; registrar via extensão (`_LANG`) ou atributo
  customizado, sem quebrar a exportação.

### 2.6 Tipo de vínculo filho → união
A união é biológica por padrão, mas a ligação registra o tipo de parentesco:
biológico, adotado, enteado, tutelado (tag GEDCOM `PEDI`). Campo `tipo_vinculo` na
ligação filho–união, sem quebrar a regra de união masculino+feminino.

### 2.7 Fontes e citações (preparar cedo, preencher depois)
De onde veio cada informação (certidão, censo, registro paroquial). Mesmo fora do MVP,
deixar o modelo preparado para uma tabela `fontes` e citações ligando fato → fonte.

---

## 3. Regras de conexão e invariantes

Validar na camada de domínio (não só na UI), com testes automatizados:
- **Acima**: um nó recebe conexão de cima de **uma única união** (seus pais). Uma pessoa
  pertence a no máximo uma união como filho.
- **Lateral**: irmãos e cônjuges conectam-se pelas laterais.
- **Filhos**: só podem ser ancorados na linha de união entre os parceiros.
- **União**: exatamente um slot masculino e um feminino. Slot desconhecido = placeholder
  (2.2), nunca vazio no modelo de dados.
- Placeholder é editável e "promovível" a pessoa real sem perder os filhos.

---

## 4. Arquitetura técnica

- **Framework desktop**: **Tauri v2** (backend Rust + frontend web) — binário pequeno,
  webview nativo, cara de programa instalado. Fallback aceitável: Electron.
- **Banco de trabalho**: **SQLite** local. Tabelas mínimas: `pessoas`, `unioes`,
  `uniao_filhos`, `eventos`, `locais`, `paises`, `religioes_pessoa`, `escolaridade_pessoa`,
  `profissoes_pessoa`, `idiomas_pessoa`, `apelidos_pessoa`, `nacionalidades_pessoa`,
  `documentos`, `arvores`, `arvore_membros`, `linhas_tempo`, `eventos_linha`, e (futuro)
  `fontes`/`citacoes`.
- **Mídia/documentos**: arquivos numa pasta de dados do app; caminho relativo no banco
  (evitar BLOBs grandes). Para portabilidade, empacotar num bundle no modelo GEDZip
  (zip com o `.ged` + a pasta de mídia).
- **Intercâmbio**: **GEDCOM 7.0** para import/export. O SQLite é o formato de trabalho;
  o GEDCOM é o de transporte/backup.
- **Visualização**: SVG com D3 (pan/zoom, colapsar/expandir ramos). Ver seção 12.
- **Estratégia de dependências (build vs. buy)**: usar bibliotecas para o que é padrão e
  custoso de reimplementar (parsing GEDCOM, gráficos estatísticos, acesso ao SQLite);
  construir sob medida o que é diferencial e específico (as regras de conexão da seção 3,
  o layout da árvore, o zoom semântico da linha do tempo). Toda dependência deve rodar
  offline, ter licença permissiva e não inchar o binário do Tauri.

---

## 5. Múltiplas árvores e conexões entre elas

- **Banco único** com `arvores` como entidade e `arvore_membros` (uma pessoa/união pode
  pertencer a uma ou mais árvores).
- **Conectar árvores**: ou a mesma pessoa passa a pertencer às duas (ponte), ou cria-se
  uma união entre uma pessoa da Árvore A e outra da Árvore B.
- Uma "árvore" é uma **visão nomeada e enraizada** do grafo, não um silo isolado. Ainda
  assim, qualquer árvore pode ser exportada isoladamente para um GEDCOM próprio.
- Trade-off aceito: perde-se a simplicidade de "um arquivo por árvore" em troca da única
  arquitetura que torna a conexão entre árvores viável.

---

## 6. Relatórios e impressão

O software gera relatórios salváveis e imprimíveis dos membros, **do mais antigo ao mais
recente**. A árvore adota sempre o layout **clássico vertical (de cima para baixo)** —
gráficos em leque e horizontais foram descartados por decisão de design.

**Três modos de impressão** (o usuário escolhe):
- **Só hierarquia** — a árvore visual (nós com miniatura), mostrando apenas a estrutura de
  parentesco, sem o texto detalhado. É o "mapa" da família.
- **Só texto** — registro cronológico em lista, do mais antigo ao mais recente, sem
  imagens. Compacto e barato de imprimir; ideal para arquivo/documentação.
- **Combinado** — árvore visual no topo seguida do registro em texto abaixo. Contexto
  visual e detalhe na mesma folha.

- **Ordenação (modos com texto)**: data de nascimento ascendente; sem data conhecida,
  cair para a profundidade geracional e depois o nome — para ninguém sumir da lista.
- **Escopo selecionável**: uma árvore específica ou todas.
- **Saída**: documento paginado (A4 retrato), salvável e imprimível. Gerar **PDF** via
  print-to-PDF do webview do Tauri, além de impressão direta. Considerar quebra de página
  entre gerações e a opção de incluir ou não miniaturas (fotos encarecem a impressão).
- **Conteúdo por entrada (texto)**: nome, apelidos, sexo, nascimento e falecimento, local,
  nacionalidade, religião, pais/união e filhos.
- **Estatísticas opcionais**: o usuário pode anexar ao relatório as estatísticas e
  gráficos da seção 7, respeitando o filtro ativo no momento da geração.
- **Linhas do tempo opcionais**: o usuário pode anexar uma linha do tempo (pessoal +
  contexto sobreposto, ver seção 8) ao relatório.
- **MVP**: os três modos em PDF, no layout vertical clássico.
- **Evolução**: formatos genealógicos de publicação (relatório tipo registro / Register,
  tabela de ancestrais / Ahnentafel).

---

## 7. Pesquisa e estatísticas

**Busca multicritério**: pesquisar pessoas por critérios combináveis — nome, sobrenome,
cidade, país/nacionalidade, década (derivada da data de nascimento), religião — e, por
extensão, escolaridade, profissão e idioma. Filtros combináveis, com resultado em lista
navegável que centraliza a pessoa na árvore ao ser selecionada.

**Estatísticas e gráficos**: sobre o conjunto atual (todas as pessoas ou o subconjunto
filtrado), gerar agregações que mostram a **porcentagem de cada categoria** — por religião,
cidade, país, década, sobrenome, profissão etc. Tipos de gráfico: pizza/rosca e barras.
Mostrar sempre a **contagem absoluta junto do percentual** (ex.: "6 de 12 · 50%") para o
número não enganar em amostras pequenas.

**O filtro alimenta a estatística**: os gráficos refletem sempre o filtro ativo. Ex.:
filtrar "nascidos na década de 1940 em Campos" e ver a distribuição de religiões desse
recorte específico.

**Inclusão no relatório**: opção de anexar essas estatísticas (tabelas + gráficos) ao
documento impresso, integrando-se aos três modos da seção 6.

**Requisitos de dados** (já atendidos pelo modelo): nome estruturado para agrupar por
sobrenome; década derivada da data de nascimento; cidade via `locais` (agrupar pelo
`codigo_ibge`, não pelo rótulo livre); exterior agrupado por país.

---

## 8. Linhas do tempo

Recurso para situar as pessoas da árvore no seu contexto histórico.

**Dois tipos:**
- **Linhas de contexto** — pré-criadas, baseadas em bibliografia, e **somente leitura**
  (o usuário exibe e combina, mas nunca edita). Vêm empacotadas com o app e versionadas.
  Categorias, cada uma sendo uma linha separada: história geral; história da Igreja
  Católica Apostólica Romana; escolas filosóficas; escolas artísticas; moeda da época;
  política; população segundo fontes oficiais; desenvolvimento científico; tecnologias de
  acesso público; cinema (grandes filmes e estilos/movimentos cinematográficos); música
  (grandes marcos, lançamentos de músicas muito conhecidas, e história/movimentos da
  música); literatura (grandes livros do Ocidente, base na lista de Mortimer Adler); livros populares no
  Brasil (os que o público de fato leu — para o gatilho de memória). Lista extensível.
- **Linhas pessoais** — geradas a partir dos eventos de vida das pessoas da árvore
  (nascimento, batismo, casamento, falecimento etc.). Derivadas dos dados, não duplicadas.

**Combinação e sobreposição**: várias linhas podem ser exibidas juntas, empilhadas no
mesmo eixo temporal, para situar a vida de um ancestral no contexto (ex.: a vida de um
bisavô sobre as linhas de política + moeda + tecnologia da época). O usuário liga/desliga
cada camada.

**Limite de camadas (configurável)**: padrão 3 camadas de contexto ativas; nas
configurações, até 10. O limite vale só para o contexto — a vida da pessoa selecionada
aparece sempre e não ocupa vaga. Acima de ~5, a gaveta rola verticalmente em vez de
espremer as faixas. Pessoas fixadas para comparação têm limite próprio e pequeno (2–3).

**Gaveta vs. árvore**: quando expandida, a gaveta divide a tela com a árvore (split) por
uma alça arrastável — a árvore sobe, a gaveta cresce, o usuário escolhe a proporção. Não
é overlay.

**Clique num marco de contexto**: mostra o detalhe e a fonte do marco E destaca na árvore
quem estava vivo naquele período/ano (dois comportamentos combinados).

**Imutabilidade do contexto**: as linhas de contexto são dados de referência; garantir que
o usuário não as altere preserva a integridade da referência bibliográfica (flag
`is_bloqueada`).

**Eixo e escala**: o eixo do tempo é naturalmente horizontal — a proibição de layout
horizontal vale só para a *árvore*, não para as linhas do tempo. Deve ser navegável com
zoom, já que o contexto cobre séculos e a vida de uma pessoa cobre décadas.

**Zoom semântico (nível de detalhe)**: o detalhe muda com a escala. No "século",
aglomerados densos viram contagens ("12 presidentes", "5 reis", "4 moedas"); no "década",
viram barras/marcos; no "ano", viram nomes. Evita espremer dezenas de itens num trecho
minúsculo. O agrupamento pode disparar por nível de zoom ou automaticamente quando os
itens se sobreporiam; clicar numa contagem aproxima e a expande.

**Ponto vs. intervalo**: eventos podem ser pontuais (uma batalha, uma lei) ou de duração
(uma escola filosófica, um período monetário). O modelo de eventos já suporta datas
aproximadas e intervalos (2.3).

**Fontes**: cada evento de contexto deve, idealmente, carregar sua fonte bibliográfica.

**Contexto do Brasil (pré-criado)**: a linha de história do Brasil vai da chegada dos
portugueses (1500) à pandemia de COVID-19 (2019–2020), com marcos de consenso
historiográfico. Semente inicial no arquivo `linha-tempo-brasil.md`.

**Duas superfícies, um só núcleo de dados**: (1) a *gaveta* junto da árvore mostra apenas
os marcos de **alta relevância** — contexto enxuto para situar a pessoa; (2) uma parte
dedicada do software, o *estúdio de linhas do tempo*, dá acesso à profundidade completa
(todas as categorias, todos os eventos, combinações livres). As duas leem o **mesmo banco
local** — não são programas separados, são duas superfícies principais do mesmo app.

**Relevância como filtro**: cada evento de contexto tem um nível de `relevancia` (ex.:
alta / média / detalhe). A gaveta mostra só a alta; o estúdio mostra tudo. É o irmão do
zoom semântico — lá o filtro é a escala, aqui é a importância.

**Princípio — critério por linha**: não há critério único; cada linha de contexto é curada
no seu próprio espírito (presidentes = factual e fechado; cinema, música e livros populares
= fama pública; literatura de Adler = cânone; filosofia e arte = movimentos/escolas).

**Curadoria por domínio (o critério varia conforme o propósito)**, sempre a serviço de
*ajudar a memória*:
- **Cinema e música** — critério é **fama pública / penetração cultural, não prêmios**.
  Entra o que o grande público conheceu e amou, com ou sem aval da crítica (ex.:
  "Evidências", Roberto Carlos, Padre Marcelo Rossi, Xuxa, "Rebeldes"; Titanic, Esqueceram
  de Mim, As Branquelas, Todo Mundo em Pânico, Jogos Mortais, A Paixão de Cristo, Todo
  Mundo Odeia o Chris). Forte relevância brasileira — o que marcou o público daqui. A
  cultura popular é o gatilho de memória mais forte (situa a pessoa na própria vida).
- **Literatura (cânone)** — base na lista dos grandes livros do Ocidente de **Mortimer
  Adler** (Great Books / Syntopicon): critério **canônico**, não popular. Contexto
  intelectual, como filosofia e arte.
- **Livros populares no Brasil (memória)** — os que o público brasileiro de fato leu (ex.:
  Machado de Assis, Jorge Amado, Paulo Coelho, a fase Harry Potter, best-sellers e leituras
  escolares marcantes): critério de **fama/leitura de massa**, como cinema e música. As
  duas linhas de livros coexistem — uma para contexto, outra para memória.

Registrar sempre apenas **fatos** (títulos, datas, movimentos, diretores/intérpretes,
autores), nunca conteúdo protegido (letras, trechos, imagens). Estilos/movimentos são
eventos de intervalo; obras individuais são pontos.

**Modelo de dados**: `linhas_tempo` (id, categoria, título, `is_contexto`, `is_bloqueada`,
fonte) e `eventos_linha` (linha_id, data/período, título, descrição, `relevancia`, fonte).
Linhas pessoais podem ser uma *view* sobre os eventos das pessoas.

---

## 9. Escopo do MVP vs. futuro

**MVP:**
1. CRUD de pessoas com nascimento, falecimento e flag "vivo".
2. Uniões e anexação de filhos respeitando as regras da seção 3 (com placeholder).
3. Renderização da árvore com pan/zoom.
4. Persistência em SQLite (abrir/salvar projeto).
5. Foto e documentos anexos.
6. Locais com autocomplete (IBGE) e locais estrangeiros por país.
7. Atributos de vida em lista (religião, escolaridade, profissões, idiomas), apelidos e
   nacionalidade, com data/período sempre opcional.
8. **Relatórios em PDF nos três modos (só hierarquia, só texto, combinado), do mais
   antigo ao mais recente, em layout vertical.**
9. Busca multicritério básica (nome, sobrenome, cidade, década, religião, país).

**Depois do MVP:** import/export GEDCOM 7.0; fontes e citações; visões auxiliares de
ancestrais e descendentes (sempre verticais); relatórios estilo registro; estatísticas
da seção 7 com gráficos e inclusão opcional no relatório; **linhas do tempo de contexto e
pessoais, combináveis e sobrepostas**; navegação avançada; undo/redo; privacidade (ocultar
pessoas vivas na exportação).

**Fora de escopo (por ora):** nuvem, colaboração multiusuário, qualquer coisa que
dependa de internet.

---

## 10. Design / UI

- **Linguagem dos nós**: card com miniatura de foto à esquerda, ponto de sexo antes do
  nome, dados-chave em uma linha (`n.` nascimento, `†` falecimento), e uma fileira de
  **ícones de presença** que indicam o que existe de informação (foto, documentos,
  religião, biografia). Um botão "Detalhes" abre uma caixa com o registro completo
  (apelidos quando houver, nascimento, batismo, falecimento, nacionalidade, religiões,
  escolaridade, profissões, idiomas, biografia, documentos).
- **Placeholder**: card com borda tracejada e identidade em aberto.
- **União**: anel marcador; filhos pendurados na linha de união.
- **Layout canônico**: árvore vertical clássica, de cima para baixo (ancestrais no topo,
  descendentes abaixo). Leque e horizontal descartados (vale só para a árvore).
- **Painel de pesquisa e estatísticas**: filtros combináveis (nome, sobrenome, cidade,
  país, década, religião) com gráficos (pizza/barras) que respondem ao filtro ativo.
- **Linhas do tempo**: eixo horizontal navegável com zoom; camadas (contexto + pessoal)
  empilhadas e alternáveis; linhas de contexto visivelmente marcadas como somente leitura.
- **Estilo**: editorial, tipografia forte, whitespace generoso; pan/zoom; colapsar/
  expandir ramos.
- **Convenção genealógica**: `✳`/`n.` para nascimento, `†` para falecimento.
- **Temas**: pelo menos quatro (clássico e moderno, cada um em claro e escuro), conforme
  as imagens de referência anexas ao Projeto.

---

## 11. Workflow com Claude Code

- Manter um `CLAUDE.md` na raiz com stack, comandos de build/test e as invariantes da
  seção 3 (para o Claude Code não violá-las ao gerar código).
- Trabalhar em fatias verticais: cada feature entregue ponta-a-ponta (dado → domínio →
  UI) antes da próxima.
- Testes automatizados obrigatórios para as **regras de conexão** — são o coração da
  correção do sistema.
- Ao introduzir uma dependência (parser GEDCOM, lib de visualização, lib de gráficos,
  lib de timeline), registrar decisão e licença no `CLAUDE.md`.

---

## 12. Referências a consultar

**Padrão:**
- GEDCOM 7.0 — spec oficial: https://gedcom.io/specifications/FamilySearchGEDCOMv7.html
- API de Localidades do IBGE (seed de municípios/UF/código).

**Parsers GEDCOM (JS/TS):**
- `arbre-app/read-gedcom` — TS, zero deps, browser+Node, leve.
- `gedcom7code/js-gedcom` — parser + validador GEDCOM v7.
- `@treeviz/gedcom-parser` — TS, plugável (GEDCOM 5.5.1).

**Visualização, gráficos e timeline:**
- `donatso/family-chart` — D3, pan/zoom, modela a linha de união nativamente. Começar aqui.
- `BenPortner/js_family_tree` — conceito explícito de `unions`; espelha o modelo.
- `ErikGartner/dTree` — "marriage nodes" com filhos ancorados na união.
- `justincy/d3-pedigree-examples` — didático sobre os problemas difíceis de layout.
- Recharts, Chart.js ou D3 — gráficos das estatísticas (pizza/rosca, barras).
- `vis-timeline` (vis.js) ou D3 — eixo de linha do tempo com zoom e camadas.

**Apps completos para estudar arquitetura (conferir licenças):**
- GEDKeeper — filosofia idêntica (offline, sem limites, GEDCOM).
- Gramps — padrão-ouro desktop; modelo de eventos/fontes/privacidade.
- Genea.app (`captmicro/genea`) — MIT, JS, browser, dados em GEDCOM.

---

## 13. Como o Claude deve se comportar neste Projeto

- Tratar as regras da seção 3 como invariantes; nunca gerar código que as viole sem
  sinalizar o conflito.
- Preferir soluções que preservem a compatibilidade GEDCOM.
- Antes de propor uma dependência, verificar licença e se ela roda offline.
- Quando uma decisão de design tiver trade-offs relevantes, expor as opções e
  consequências em vez de escolher silenciosamente.
- Linhas do tempo de contexto são somente leitura; nunca gerar fluxo que permita o usuário
  editá-las.
