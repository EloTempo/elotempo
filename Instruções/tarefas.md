# Lista de tarefas

O que está feito, o que vem a seguir e o que está esperando decisão. A
especificação diz *o que* o produto é; este arquivo diz *onde o trabalho está*.

Cada fatia vertical entregue tem uma spec própria em `Instruções/fatias/`.

Última revisão: **30/08/2026**.

---

## Entregue

| # | Fatia | Onde está documentada |
|---|---|---|
| — | Núcleo: pessoas, uniões, filhos, placeholders, as 4 invariantes | seção 3 da especificação |
| — | Árvore vertical com pan/zoom, busca por nome | — |
| 01 | Ficha da pessoa e atributos de vida | `fatias/01-ficha-da-pessoa.md` |
| 02 | Nomes ao longo da vida | `fatias/02-nomes-e-titulos.md` |
| 03 | Fotos e documentos | `fatias/03-fotos-e-documentos.md` |
| 04 | Locais (IBGE + estrangeiros) | `fatias/04-locais.md` |
| 05 | Relatórios nos três modos | `fatias/05-relatorios.md` |
| 06 | Busca multicritério | `fatias/06-busca-multicriterio.md` |
| 07 | Linhas do tempo — a gaveta | `fatias/07-linhas-do-tempo-gaveta.md` |
| 08 | Exportar GEDCOM 7.0 | `fatias/08-gedcom-exportacao.md` |

Os nove itens do MVP (seção 9) estão fechados.

---

## A seguir

### Fatia 09 — Importar GEDCOM
Spec escrita em `fatias/09-gedcom-importacao.md`. Aceita 5.5.1 e 7.0; conflitos
resolvidos caso a caso pelo usuário. O exportador já entrega o melhor teste que
o importador pode ter: exportar, reimportar, conferir se o acervo volta igual.

---

## Linhas do tempo — o que falta

A gaveta hoje faz uma coisa bem: põe **uma** vida ao lado de **até três** linhas
de contexto. O que a estrutura promete e ainda não entrega:

### Comparar duas ou mais vidas ao mesmo tempo
A gaveta mostra a vida de **uma** pessoa — a selecionada. Comparar a vida de
alguém com a de outro, e as duas com os acontecimentos históricos, pede várias
linhas pessoais empilhadas no mesmo eixo. É a mudança de maior valor de estudo
da lista, e cai naturalmente no desenho de abas abaixo: uma vida é mais uma aba.

### Zoom semântico
Previsto na seção 8: em escala de séculos mostram-se poucos marcos; ao aproximar,
aparecem os de menor relevância. Hoje a gaveta mostra só `relevancia = 'alta'`, e
`'media'` e `'detalhe'` não têm como aparecer em lugar nenhum. Amarrado à
impressão — ver abaixo.

### Abas, com um "+" — o estúdio de linhas do tempo
**Desenho proposto pelo Gabriel em 30/08/2026.** A fileira de camadas deixa de
ser uma lista de interruptores e passa a se comportar como abas de navegador:
abre-se uma linha, fecha-se outra, e um **`+`** no fim da fileira oferece duas
coisas — abrir uma linha já salva no acervo, ou **criar uma nova**.

Criar uma linha significa poder acrescentar marcos a ela, e a cada marco anotar
as **pessoas envolvidas**. Essas participações voltam na linha pessoal de quem
foi marcado: é o que permite estudar a vida de alguém contra os acontecimentos
de que participou, e não só contra a época em que viveu.

O esquema já aguenta a parte difícil, e por acidente feliz: `is_contexto` e
`is_bloqueada` são **colunas separadas** desde a migration 005, e os gatilhos da
013 disparam por `is_bloqueada`, não por `is_contexto`. Uma linha do usuário
nasce `is_contexto = 1, is_bloqueada = 0` — editável, sem tocar em gatilho
nenhum e sem risco para as cinco semeadas, que continuam imutáveis. O que falta
no banco é só o vínculo marco↔pessoa, que hoje não existe.

O que precisa ser decidido antes de escrever a spec:

- **O que "pessoa envolvida" afirma.** "Esteve neste acontecimento" é um dado
  novo sobre a pessoa, e vai querer aparecer na ficha, no relatório e na
  exportação. É também a porta pela qual a prosopografia — fora de escopo por
  decisão de 29/08/2026 — pode voltar sem que ninguém perceba. A fronteira
  precisa estar escrita antes da primeira linha de código.
- **O limite de camadas.** `LIMITE_DE_CAMADAS = 3` foi calibrado para
  interruptores, onde o usuário liga sem pensar. Com abas ele escolhe uma por
  uma, o que é diferente — mas o eixo continua tendo altura finita. Provável
  saída: abas sem limite e a gaveta rolando na vertical.
- **Onde a participação aparece na linha pessoal.** Um marco de que a pessoa
  participou não é um evento da vida dela; misturar os dois sem distinção
  visual faria a linha pessoal mentir.
- **O que acontece na exportação.** O GEDCOM não tem lugar para "participou de
  um marco histórico". Ou vira `NOTE`, ou fica de fora — e as duas escolhas
  precisam ser ditas em voz alta.

### Imprimir as linhas do tempo
Hoje só o relatório imprime — a superfície é `#print-container`, revelada pelo
`@media print`. A gaveta fica de fora, e uma linha do tempo é justamente o tipo
de coisa que se quer no papel, na parede ou num trabalho escolar.

O desenho pedido: escolher a **escala de zoom temporal** da impressão e sair com
as marcas no eixo e **os detalhes escritos abaixo** — que é a resposta certa
para papel, onde não há como passar o mouse sobre um marco.

Três mecânicas que isso implica:

- **Faixas de anos, com o eixo repetido.** Um período que não cabe numa folha
  quebra em faixas sucessivas, cada uma com seu próprio eixo no alto. Sem
  repetir o eixo, a segunda página vira um borrão sem referência.
- **Marcas numeradas.** Rótulo no eixo colide — foi o que já aconteceu na tela,
  e é o que a função `marcosComRotulo` existe para evitar. No papel a saída é
  numerar as marcas e listar os textos embaixo, na ordem.
- **Paisagem**, quase certamente.

Isto se cruza com o **zoom semântico**: escala larga pede poucos marcos, escala
estreita pede muitos, e é exatamente o que a `relevancia` serve para decidir. As
duas coisas provavelmente se fazem juntas.

### Detalhe do evento na linha pessoal
Um evento da vida da pessoa mostra o `data_texto` só no *tooltip*. Faltou o
painel de detalhe que os marcos de contexto têm.

---

## Depois do MVP (seção 9), ainda não começado

- **Estatísticas** (seção 7) com gráficos, e a opção de incluí-las no relatório.
- **Múltiplas árvores nomeadas** (seção 5). As tabelas `arvores` e
  `arvore_membros` existem desde a migration 004, sem nenhum comando nem tela.
- **Undo/redo.**
- **Visões auxiliares** de ancestrais e descendentes — sempre verticais.

---

## A linha do tempo deste programa

A migration 016 semeia a linha `Este programa`, com os marcos do próprio
desenvolvimento. Ela obedece à mesma regra das outras: **marco novo é migration
nova**, nunca edição. Os gatilhos da migration 013 recusam `UPDATE` e `DELETE`.

A cada versão publicada, escreva `0NN__linha_projeto_vX.sql` com um `INSERT`.

- [ ] **Marco da primeira versão pública.** Ainda não existe, de propósito:
      registrar coisa que não aconteceu é o oposto do que uma referência faz.
      Entra no dia em que sair.

---

## Esperando decisão do Gabriel

- [ ] **Licença.** Os arquivos dizem MIT; foi escolha minha, nunca confirmada.
      Ela permite que alguém pegue o código, feche e venda — se não for isso que
      se quer, a GPL é a alternativa usual.
- [ ] **Publicar no GitHub.** Adiado por decisão explícita. O repositório local
      está pronto; falta só a decisão.
- [ ] **Oito marcos de tecnologia** entraram com `relevancia = 'media'` por eu
      não ter certeza das datas de chegada ao Brasil. Não aparecem na gaveta até
      serem conferidos. Conferidos, sobem para `'alta'` — por migration.
- [ ] **Data real de início do projeto.** A linha do programa registra
      29/08/2026, que é o primeiro commit. Se o trabalho começou antes, a data
      certa entra por migration.

---

## Fora de escopo por decisão (29/08/2026)

Prosopografia — relações não familiares, instituições, hierarquias — e a tela de
fontes e citações. As tabelas `fontes` e `citacoes` ficam preparadas e vazias,
que é o que a seção 2.7 pede. O produto é árvore genealógica **familiar**.

Também fora, por princípio: nuvem, colaboração, qualquer coisa que dependa de
internet em tempo de execução.
