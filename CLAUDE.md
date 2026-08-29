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
npm run tauri build    # instalador
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
`SearchAndStatsPanel` · `GedcomImportWizard` · `ExportGedzipDialog`

O `UnionEditor` foi superado na prática pelo `PainelConexoes`, que é a tela de
conexões que realmente funciona. Ele segue guardado porque desenha uma tela
dedicada de união (com os dois slots lado a lado) que o painel lateral não
cobre; se essa tela não for construída, o certo é apagá-lo.

### Fatias documentadas

Cada fatia vertical maior tem uma spec curta em `Instruções/fatias/`, derivada
da especificação principal, com escopo, o que fica de fora e critérios de
aceite. Ao começar uma fatia nova, escreva a dela antes.

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

**Ficha da pessoa** (fatia 01): o botão "Detalhes" abre o registro completo, e
é onde os atributos de vida da seção 2.5 finalmente ganharam tela — apelidos,
nacionalidades, religiões, escolaridade, profissões e idiomas, mais os eventos
de vida. As taxonomias entram como `<datalist>`: sugerem sem travar.

**Ainda não:** múltiplas árvores nomeadas da seção 5 (as tabelas `arvores` e
`arvore_membros` existem, sem comando nem tela), documentos e fotos, locais com
autocomplete, relatórios em PDF, estatísticas, GEDCOM, linhas do tempo.

Trabalhe em **fatias verticais**: cada feature ponta a ponta (dado → domínio →
UI) antes de começar a próxima.
