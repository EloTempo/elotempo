# CLAUDE.md — contexto para agentes de código

Este arquivo é lido automaticamente por assistentes de código que trabalham no
repositório. A especificação completa do produto está em
`Instruções/instrucoes-projeto-arvore-genealogica.md`; aqui fica só o que se
precisa saber para **não quebrar nada ao escrever código**.

---

## O que é

Software desktop **100% offline** para árvores genealógicas familiares, sem
limite de tamanho. Local-first: os dados nunca saem da máquina do usuário sem
ação explícita dele. Código aberto sob licença MIT.

O objetivo declarado não é catalogar parentesco — é **ajudar a memória das
pessoas**, situando cada vida no contexto histórico e cultural da sua época.
Quando houver dúvida sobre o que construir, essa é a pergunta que decide.

## Stack

| Camada | Escolha | Por quê |
|---|---|---|
| Desktop | Tauri v2 (Rust + webview) | Binário pequeno, cara de programa instalado |
| Frontend | React 18 + TypeScript strict + Vite 5 | — |
| Estilo | Tailwind sobre tokens CSS (4 temas) | Tema troca por `data-tema` no `<html>` |
| Visualização | SVG + D3 (só pan/zoom) | Layout é nosso, em `src/lib/tree/layout.ts` |
| Estado servidor | TanStack Query | — |
| Banco | SQLite via sqlx 0.8 | Formato de trabalho; GEDCOM é o de transporte |

## Comandos

```bash
npm run dev            # frontend só, em localhost:1420
npm run tauri dev      # app completo (Rust + webview)
npm run verificar      # typecheck + testes TS + testes Rust  ← rode antes de commitar
npm test               # só os testes do frontend
npm run test:rust      # só os testes do domínio
npm run build          # build do frontend
npm run abrir          # compila o que mudou e abre o app (ou abrir-arvore.cmd)
npm run instalador     # instalador MSI/NSIS (build de release, demorado)
npm run seed:ibge      # regera o seed de municípios (única coisa que usa a internet)
```

---

## AS INVARIANTES — leia antes de tocar no domínio

Estas são as regras de conexão da seção 3 da especificação. **São o coração da
correção do sistema.** Não gere código que as viole; se uma tarefa parecer
exigir isso, pare e sinalize o conflito.

1. **Acima** — uma pessoa pertence a **no máximo uma união como filho**. Vale
   para qualquer `tipo_vinculo`, não só biológico.
2. **União** — exatamente **um slot masculino e um feminino**. Slot sem nome
   nunca fica vazio: recebe uma **pessoa-placeholder** (nó real, sexo definido,
   `is_placeholder = true`).
3. **Filhos** — ancoram na **união**, nunca num pai ou mãe direto. É a união
   que aponta para os pais.
4. **Aciclia** — ninguém é ancestral de si mesmo.

Onde elas vivem:

- **No banco**: `ix_uniao_filhos_pessoa_unica` (migration 006) e os `CHECK` das
  migrations. Última linha de defesa — pega até import GEDCOM defeituoso.
- **No domínio**: `src-tauri/src/domain/regras.rs`. Esse módulo **não conhece o
  Tauri**: recebe `&SqlitePool` e devolve `Resultado<T>`, e é por isso que dá
  para testá-lo inteiro contra um banco em memória.
- **Nos testes**: `regras.rs` tem uma suíte cobrindo cada invariante, incluindo
  as tentativas de burlá-las. Ao mexer em regra de conexão, **o teste vem
  primeiro** — é exigência da seção 11 da especificação.

Os `#[tauri::command]` em `core_cmds.rs` são cascas finas. Regra nova vai em
`regras.rs`, com teste, nunca no comando.

---

## Decisões que já foram tomadas (não reabrir sem motivo)

- **Layout da árvore é vertical clássico**, de cima para baixo. Leque e
  horizontal foram descartados por decisão de design. O eixo *da linha do
  tempo* é horizontal — a proibição vale só para a árvore.
- **Ids são gerados no Rust**, não no frontend. Identificador estável é
  responsabilidade de quem guarda o dado.
- **Nomes de comando em português**, verbo primeiro: `criar_pessoa`,
  `listar_eventos_pessoa`, `buscar_grafo_arvore`. Antes era metade em inglês.
- **Datas nunca bloqueiam o salvamento.** O usuário escreve o que sabe; o
  `data_texto` guarda o original intacto, e `datas.rs` deriva
  `data_qualificador`, `ano_inicio` e `ano_fim`, que existem só para ordenar e
  plotar. Nunca exiba os anos derivados no lugar do texto do usuário.
- **Tipos de evento são minúsculos e canônicos** (`domain::eventos_cmds::tipos`
  no Rust, `TIPOS_EVENTO` no TS). Nunca escreva `'Nascimento'` solto: já houve
  um bug em que a query procurava com maiúscula e a UI gravava com minúscula.
- **Linhas do tempo de contexto são somente leitura.** Nunca gere fluxo que
  permita o usuário editá-las (`is_bloqueada`).
- **Nada de rede em tempo de execução.** A única exceção é
  `scripts/gerar-seed-ibge.mjs`, que roda na máquina de quem desenvolve e cujo
  resultado é versionado. Fontes são embarcadas via `@fontsource`; se você se
  pegar escrevendo uma URL `https://` em código de runtime, está errado.

---

## Mapa do código

```
src-tauri/
  migrations/          001-005 schema original · 006 invariantes+índices
                       007 datas/fontes · 008 países · 009 municípios (gerado)
  src/
    main.rs            abre o acervo em app_data_dir() e registra os comandos
    domain/
      regras.rs        ← AS INVARIANTES + testes
      datas.rs         interpreta data em texto livre + testes
      erros.rs         ErroDominio, serializado como { codigo, mensagem }
      core_cmds.rs     comandos de pessoa/união/filho (cascas finas)
      eventos_cmds.rs  eventos de vida + tipos canônicos
      atributos_cmds.rs religião, profissão, idioma, escolaridade…
    commands/
      tree_cmds.rs     monta o grafo da árvore e a busca por nome

src/
  lib/tree/layout.ts   ← O LAYOUT (duas passadas: medir, depois colocar) + testes
  lib/api/             fronteira com o Rust; tudo passa por `chamar()`
  components/tree/     TreeCanvas (D3 só para pan/zoom) e NodeCard
  features/            protótipos visuais ainda não ligados (ver abaixo)
```

### Protótipos não ligados

Estes componentes são maquetes com dados fixos, guardadas no código para não se
perder e para continuarem passando pelo TypeScript. Cada um traz um aviso no
topo. **Não são features** — não os cite como prontos:

`UnionEditor` · `TimelineDrawer` · `ReportGenerator` ·
`SearchAndStatsPanel` · `GedcomImportWizard`

O `UnionEditor` foi superado na prática pelo `PainelConexoes`, que é a tela de
conexões que realmente funciona. Ele segue guardado porque desenha uma tela
dedicada de união (com os dois slots lado a lado) que o painel lateral não
cobre; se essa tela não for construída, o certo é apagá-lo.

### Fatias documentadas

Cada fatia vertical maior tem uma spec curta em `Instruções/fatias/`, derivada
da especificação principal, com escopo, o que fica de fora e critérios de
aceite. Ao começar uma fatia nova, escreva a dela antes.

**`Instruções/tarefas.md` é a lista de tarefas do projeto** — o que está
entregue, o que vem a seguir, o que espera decisão do Gabriel. A especificação
diz o que o produto é; esse arquivo diz onde o trabalho está. Ao fechar uma
fatia, atualize-o.

Ao ligar um deles, troque os valores fixos por `useQuery` sobre `src/lib/api` e
apague o aviso.

---

## Armadilhas já pagas (não repetir)

- **Medir antes de colocar** no layout. Posicionar uma pessoa consome as
  uniões dela; medir depois disso devolve a largura da caixa sozinha, sem a
  descendência, e o próximo ramo é desenhado por cima. Já aconteceu duas vezes
  no mesmo arquivo.
- **`sqlite::memory:` exige `max_connections(1)`.** Cada conexão abriria um
  banco diferente, e os testes passariam mentindo.
- **Recursão em CTE usa `UNION`, não `UNION ALL`.** A deduplicação é o que faz
  a consulta terminar se o grafo chegar com um ciclo.
- **Nunca monte HTML com interpolação de nome de pessoa.** É dado do usuário e
  vai passar a vir de GEDCOM de terceiros. O `TreeCanvas` renderiza os cards
  com React justamente por isso.
- **`AND` entre os dois slots** na busca de uniões fazia a união inteira sumir
  quando um cônjuge ficava fora do recorte. É `OR`.

---

## Dependências: critério e licenças

Toda dependência precisa **rodar offline**, ter **licença permissiva** e não
inchar o binário. Ao introduzir uma, registre aqui e em `TERCEIROS.md`.

Comprar o que é padrão e custoso de reimplementar (parsing GEDCOM, acesso ao
SQLite, gráficos). Construir sob medida o que é diferencial: as regras de
conexão, o layout da árvore, o zoom semântico da linha do tempo.

---

## Estado atual

**Funciona ponta a ponta:** cadastro de pessoa com nascimento/falecimento;
montagem do grafo; layout vertical com pan/zoom; busca por nome; **construção
da família pelo painel de conexões** — adicionar pais (que nascem como
placeholders), cônjuge, filhos, identificar um placeholder, desvincular,
trocar o estado do vínculo, **excluir pessoa e união**; **sugestão de sobrenome
pela convenção brasileira**; e todas as invariantes com teste.

Sobre a sugestão de sobrenome (`src/lib/nomes.ts`): no Brasil a ordem é
**materno primeiro, paterno por último**, e o sobrenome que alguém transmite
aos filhos é o **último** dele. A sugestão vale nos dois sentidos — compõe o
sobrenome do filho a partir dos pais, e deduz o do pai/mãe a partir do filho ao
identificar um placeholder. É palpite editável, nunca imposição; partículas
("da Silva", "dos Santos") andam grudadas.

**Nomes ao longo da vida** (fatia 02): `nomes_pessoa` guarda vários nomes por
pessoa, com tipo (nascimento, público, religioso, de casada, de imigração…),
prefixo e sufixo. `pessoas.nome`/`sobrenome` continuam sendo o **nome de
exibição** — o que aparece no card, na busca e nos relatórios; a tabela é o
registro completo, e "usar na árvore" copia um deles para a exibição. A
duplicação é consciente: derivar a exibição da tabela obrigaria a mexer no
grafo, na busca e nos índices NOCASE. **Apelido não é nome público**: alcunha
afetiva segue em `apelidos_pessoa`, e "D. João VI" é nome, não apelido.

**Ficha da pessoa** (fatia 01): o botão "Detalhes" abre o registro completo, e
é onde os atributos de vida da seção 2.5 finalmente ganharam tela — apelidos,
nacionalidades, religiões, escolaridade, profissões e idiomas, mais os eventos
de vida. As taxonomias entram como `<datalist>`: sugerem sem travar.

**Fotos e documentos** (fatia 03): anexar arquivo, marcar o retrato que aparece
no card, remover. O arquivo é **copiado** para `<app_data>/midia/` com nome
gerado, e o banco guarda só o caminho relativo — é o que faz o acervo
sobreviver a uma cópia entre máquinas. Exibição pelo protocolo `asset:`, com
escopo limitado a `$APPDATA/midia/**`. A capability concede só
`dialog:allow-open`: **nunca conceda `fs:`** — quem lê e escreve arquivo é o
Rust, dentro da pasta do app.

**Locais** (fatia 04): autocomplete sobre os 5.571 municípios do IBGE, e cidade
estrangeira com país da lista. A busca usa a coluna `locais.nome_busca`, sem
acento — o `COLLATE NOCASE` do SQLite só entende ASCII, e sem ela "sao paulo"
não acha "São Paulo". **A normalização existe em dois lugares** (a migration
012, que preencheu os 5.571, e `domain::texto::sem_acento`, que grava as
estrangeiras): se divergirem, a busca erra em silêncio, e é o teste
`a_normalizacao_do_rust_bate_com_a_da_migration` que prende as duas pontas.

**Relatórios** (fatia 05): os três modos da seção 6 — só hierarquia, só texto,
combinado —, com escopo, ocultar vivas, miniaturas e quebra por geração. O PDF
sai por `window.print()`; **não há geração de PDF em Rust**, e não deve haver:
o motor de layout da webview já faz isso, e uma biblioteca duplicaria peso.
A superfície impressa é `#print-container`, que o `@media print` do
globals.css revela enquanto esconde o resto.

**Ordenação do relatório** — geração, depois ano de nascimento, depois nome.
É uma *leitura declarada* da seção 6, que pede "data de nascimento ascendente"
mas também "do mais antigo ao mais recente": ordenar só por ano espalha uma
família pelo documento inteiro quando faltam datas, e num acervo real faltam
muitas. Está justificado em `Instruções/fatias/05-relatorios.md`; se for para
mudar, muda lá primeiro.

**Busca por nome alcança quatro lugares**: o nome de exibição
(`pessoas.nome`/`sobrenome`), qualquer nome de `nomes_pessoa`, e os apelidos.
E **ignora acento dos dois lados** — `domain::texto::sem_acento_sql` gera a
expressão que normaliza a coluna, e `normalizar_busca` normaliza o termo. As
duas saem da mesma tabela `SUBSTITUICOES`, então não têm como divergir.

Cuidado ao mexer: o `COLLATE NOCASE` do SQLite **só conhece ASCII**, e o
`lower()` embutido não mexe em letra acentuada — `lower('JOSÉ')` devolve
`josÉ`. Por isso as maiúsculas acentuadas estão na tabela. Sem isso, "jose" não
acha "José" e "goncalves" não acha "Gonçalves", que num acervo brasileiro é
quase toda busca.

**Busca multicritério** (fatia 06): nome, sobrenome, cidade de nascimento,
nacionalidade, década, religião, profissão, escolaridade, idioma e situação de
vida, todos combináveis em `E`. Os seletores oferecem **só o que existe no
acervo**, com contagem — oferecer a taxonomia inteira faria o usuário escolher
um valor sem ninguém e receber lista vazia, o que parece defeito.
A consulta é montada dinamicamente conforme os filtros ativos, mas **só a
estrutura varia: todo valor vai por bind**. Há teste de injeção provando isso.

---

**Linhas do tempo — a gaveta** (fatia 07): quatro linhas de contexto semeadas
nas migrations 013–014 (história do Brasil, presidentes, moeda, tecnologias),
mais a linha pessoal da pessoa selecionada. Split arrastável, não overlay.
Clicar num marco mostra o detalhe e **destaca na árvore quem estava vivo**.

Três coisas para não quebrar aqui:

- **Linha de contexto é imutável, e o banco garante.** Não existe comando que
  altere, e os gatilhos da migration 013 recusam `UPDATE`/`DELETE` em linha com
  `is_bloqueada = 1`. `INSERT` fica aberto de propósito: é por ele que as
  migrations semeiam, e corrigir um marco é escrever migration nova — que
  deixa rastro, o que se quer de uma referência.
- **A regra de "quem estava vivo" tem três ramos**, não dois. Além de "morreu
  depois" e "está viva", há o caso de quem não tem data de morte: presume-se
  viva dentro de `IDADE_MAXIMA_PRESUMIDA` (105) anos do nascimento. Sem isso,
  quem nasceu em 1930 sumia da tela ao clicar num marco de 1930 — absurdo que
  os testes pegaram.
- **Quem não tem data de nascimento fica fora do destaque, mas é contado.** A
  gaveta diz quantos ficaram de fora. Sumir em silêncio faria o usuário
  concluir que o antepassado não viveu naquela época.

**Curadoria**: marcos de que não se tem certeza entram com `relevancia =
'media'` e **não sobem à gaveta**, que só mostra `'alta'`. É salvaguarda
editorial, não detalhe de interface — melhor faltar um marco do que afirmar uma
data errada com ar de referência.

**A quinta linha é o próprio programa** (migration 016, categoria `projeto`).
Vale a mesma regra: **marco novo é migration nova** — `0NN__linha_projeto_vX.sql`
com um `INSERT`, que os gatilhos permitem —, nunca edição da 016. E nada entra
antes de acontecer: não há marco da primeira versão pública porque ela ainda não
saiu. Ao acrescentar uma categoria de linha, defina `--lt-<categoria>` nos
**quatro** temas: `contraste.test.ts` mede a paleta real do `globals.css` e
reprova cor ilegível ou repetida.

---

**Exportar GEDCOM** (fatia 08): `domain::gedcom` escreve GEDCOM 7.0 do acervo
inteiro ou do recorte de uma raiz, com opção de ocultar vivas e de empacotar as
mídias num GEDZip. É o que cumpre a promessa da seção 1 — "o usuário é dono do
arquivo" —, porque um SQLite que só este programa lê deixa isso pela metade.

Quatro coisas que decidem a correção do arquivo gerado:

- **Placeholder não vira `INDI`.** Ele é invenção nossa para não deixar slot
  vazio; exportá-lo encheria a árvore de quem recebe com "desconhecidos" que
  não existem. A `FAM` simplesmente sai sem o `HUSB` ou sem o `WIFE`, que é
  GEDCOM válido.
- **Ocultar vivas não as apaga.** Sai `INDI` com `NAME` "Vivo"/"Viva", `SEX` e
  os `FAMC`/`FAMS` — sem isso o parentesco de quem recebe se parte em duas
  árvores soltas.
- **O texto original da data nunca se perde.** O `DATE` leva o que o GEDCOM
  sabe representar; quando a linha emitida não reproduz o que o usuário
  escreveu, o resto vai para `2 NOTE Data como registrada: …`. É a mesma regra
  de sempre: os campos derivados existem para ordenar, não para substituir.
- **`escritor.rs` escapa e limpa em um lugar só.** `@` inicial dobrado,
  controle removido, quebra de linha virando `CONT`. Nome de pessoa é dado do
  usuário e vai passar a vir de GEDCOM de terceiros — não monte linha à mão.

**Não confie na memória do 5.5.1 ao escrever 7.0.** O cabeçalho declara 7.0, e
quatro estruturas mudaram de forma entre as versões: `NICK` é peça de `NAME`
(nível 2, não 1); mídia é registro `0 @O1@ OBJE` com `FORM` obrigatório, e não
mais `OBJE`/`FILE` embutido; toda tag de extensão (`_LANG`, `_IBGE`) precisa
estar declarada em `HEAD.SCHMA`; e não existe `PEDI STEP` — enteado é `OTHER`
com `PHRASE`. O GEDZip, por sua vez, exige que o arquivo interno se chame
`gedcom.ged`. Cada um desses está preso por teste; a seção 10 da spec da fatia
08 explica por quê.

O `escolher onde salvar` é do frontend (`dialog:allow-save`); quem escreve o
arquivo é o Rust. **Continua valendo: nada de `fs:` na capability.**

---

## O MVP está completo

Os 9 itens da seção 9 estão entregues, e o primeiro item do "depois do MVP"
— exportar GEDCOM — também. Falta do mesmo item: **importar** GEDCOM (5.5.1 e
7.0), estatísticas, o estúdio de linhas do tempo e o zoom semântico, múltiplas
árvores nomeadas (seção 5 — as tabelas `arvores` e `arvore_membros` existem sem
comando nem tela), undo/redo.

**Fora de escopo por decisão:** prosopografia e a tela de fontes/citações
(29/08/2026).

**Fora de escopo por decisão de 29/08/2026:** prosopografia (relações não
familiares, instituições, hierarquias) e a tela de fontes/citações. As tabelas
`fontes` e `citacoes` da migration 007 ficam preparadas e vazias, que é o que a
seção 2.7 pede. O produto é **árvore genealógica familiar** — não reabrir sem o
Gabriel pedir.

Trabalhe em **fatias verticais**: cada feature ponta a ponta (dado → domínio →
UI) antes de começar a próxima.
