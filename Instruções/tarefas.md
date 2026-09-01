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
**Spec escrita:** `fatias/10-estudio-linhas-do-tempo.md`. Recomenda partir em
duas — **10a** (criar linha e marcos, abas com `+`) e **10b** (participação,
visibilidade e a linha pessoal com duas origens).

Decisões já tomadas ali: a linha do usuário nasce `is_bloqueada = 0` e não
afrouxa gatilho nenhum; a participação é sempre gravada e a visibilidade é só
uma chave, com padrão visível e o interruptor no marco; a chave não existe para
os eventos da própria vida; e a fronteira com a prosopografia fica em pessoa →
marco, nunca pessoa → pessoa, sem rede de coocorrência.

**Passo zero — feito em 01/09/2026.** O casamento agora é gravado na união, pelo
painel de conexões, e aparece na linha do tempo dos dois cônjuges, com o nome do
outro. Antes só existia "Casamento" na ficha da pessoa, onde o evento saía preso
a um `pessoa_id` — o casamento era do marido *ou* da esposa.

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
