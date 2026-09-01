# Fatia 09 — Importar GEDCOM

> **Entregue em 01/09/2026.** As políticas abaixo foram decididas com o autor
> em 30/08/2026 e valeram todas. O que a implementação acrescentou está na
> seção 8.

---

## 1. O que muda em relação a exportar

Exportar só lê. **Importar escreve**, e escreve dados que vieram de outro
programa, com outras regras. É a metade arriscada, e o risco tem nome:

> **As invariantes da seção 3 são mais estritas do que o GEDCOM.**

| Nossa regra | O que o GEDCOM permite |
|---|---|
| União tem exatamente um slot masculino e um feminino | `FAM` com `HUSB`/`WIFE` ausentes, ou dois do mesmo sexo |
| Pessoa é filha de **no máximo uma** união | Vários `FAMC` por indivíduo |
| Ninguém é ancestral de si mesmo | Nada impede |

Arquivos reais violam isso, e não como exceção: `FAMC` múltiplo é o jeito normal
de registrar adoção, e famílias de mesmo sexo aparecem em qualquer acervo
contemporâneo.

**As invariantes não se relaxam.** São o que mantém o acervo íntegro e o que os
125 testes de domínio protegem. Quem cede é a importação.

---

## 2. Política de conflito: perguntar caso a caso

Decidido em 30/08/2026. O assistente para em cada conflito e mostra a escolha
com nome e contexto — "João Ferreira aparece como filho de duas famílias: a de
Antônio e Maria, e a de José e Ana. Qual manter?" — em vez de decidir sozinho
ou entregar um relatório para o usuário conferir depois.

É mais trabalho e é o certo: **nada se perde em silêncio**, e a decisão é
tomada olhando a árvore, não um log.

O protótipo `GedcomImportWizard` já desenhou esse fluxo, com a etapa
"Conflitos" e o contador "3 de 4". Esta fatia o transforma na tela real.

### Os conflitos previstos

| Situação | O que se pergunta |
|---|---|
| Vários `FAMC` | Qual união fica como a de origem; as outras viram nota |
| `FAM` de mesmo sexo | Qual pessoa ocupa qual slot, ou descartar a união |
| `FAM` sem nenhum parceiro nomeado | Criar dois placeholders, ou descartar |
| Ciclo genealógico | Qual ligação romper |
| `SEX` ausente ou inválido | Adotar `U`, que é o valor do desconhecido |

---

## 3. Versões: 5.5.1 e 7.0

Decidido em 30/08/2026, contrariando a letra da seção 4 — e com motivo.

A §4 pede 7.0. Mas quase todo arquivo que existe no mundo hoje é **5.5.1**: os
que Gramps e programas antigos geram, e os que estão guardados em pastas de
família desde os anos 1990. Importar só 7.0 tornaria o recurso quase inútil
justamente para o caso que ele existe para resolver — trazer pesquisa já feita.

**O custo é a codificação.** O 7.0 é UTF-8 sempre. O 5.5.1 pode vir em ANSEL,
UTF-8, UTF-16 ou Windows-1252, e é aí que nomes brasileiros quebram: um
"Conceição" mal decodificado vira lixo silencioso, do tipo que só se descobre
meses depois. A detecção de codificação precisa de teste próprio, com arquivos
reais de cada tipo.

O 5.5.1 também usa `CONC`/`CONT` para partir texto longo entre linhas; o 7.0
mantém só `CONT`.

---

## 4. Onde o parser roda: no Rust

Isto contraria a seção 4, que manda "comprar o que é padrão e custoso de
reimplementar (parsing GEDCOM)", e a seção 12, que lista bibliotecas JS/TS.
Registro a discordância em vez de segui-la em silêncio.

**Dois motivos.**

As invariantes vivem em `regras.rs`. Uma importação precisa passar por elas, e
um caminho em que o TypeScript parseia e depois chama os comandos um a um
transformaria um acervo de 5.000 pessoas em 5.000 idas e voltas pela IPC.

E o que é caro no GEDCOM não é a gramática de linha — nível, xref, tag, valor,
que cabe em algumas dezenas de linhas — mas o **mapeamento semântico** para o
nosso schema, que nenhuma biblioteca faz.

O que se ganha comprando um parser é a robustez contra arquivos malformados,
que é real. A mitigação é teste com arquivos de verdade, incluindo torto.

---

## 5. Esboço do trabalho

1. **Léxico** — linha em (nível, xref, tag, valor), com `CONC`/`CONT`.
2. **Codificação** — detectar e converter para UTF-8 antes de tudo.
3. **Árvore de registros** — `INDI`, `FAM`, `OBJE`, `NOTE` por xref.
4. **Análise prévia, sem escrever nada** — contar registros, detectar todos os
   conflitos e montar a lista de perguntas.
5. **Assistente** — arquivo, leitura, conflitos, aplicar (as quatro etapas do
   protótipo).
6. **Aplicação em transação** — passando por `regras.rs`. Falhou, nada entra.
7. **Resumo** — o que entrou, o que foi descartado e por quê.

**A importação nunca escreve fora de transação.** Um acervo pela metade, com
metade das ligações, é pior do que nenhuma importação.

---

## 6. Fora de escopo

- Mesclar com acervo existente (detectar que "João Silva" importado é o mesmo
  "João Silva" que já existe). É problema difícil por si só, e merece fatia
  própria.
- Importar `SOUR` — fontes estão fora de escopo por decisão de 29/08/2026.
- Reimportar para atualizar.

---

## 7. O teste que o exportador entrega de graça

Exportar o acervo, importar o arquivo num acervo vazio e comparar: **as duas
árvores têm de ser a mesma**. Pessoas, uniões, filiações, datas, atributos.

É o teste mais forte possível para os dois lados, e só existe porque a
exportação vem primeiro.


---

## 8. O que a implementação acrescentou

- **`.gdz` também entra.** Simetria com a exportação: o que este programa
  empacota, ele desempacota. A detecção é pela assinatura do zip, não pela
  extensão — arquivo renomeado é comum, e o conteúdo não mente.
- **A aciclia é verificada em memória**, sobre o grafo do arquivo, antes de
  qualquer gravação. É onde o grafo é conhecido inteiro, o que torna a checagem
  exata e barata — melhor do que consultar o banco a cada `INSERT`.
- **`SEX` ausente virou `U`, e isso não é conflito.** `U` cabe nos dois slots
  (`sexo_cabe_no_slot`), então não trava união nenhuma. A tabela da seção 2 o
  listava como pergunta; na prática é só um padrão.
- **Lados invertidos são trocados, não descartados.** `HUSB` mulher e `WIFE`
  homem é engano comum de arquivo antigo; trocar resolve sem inventar
  desconhecido, e é a opção sugerida quando os dois cabem invertidos.
- **`NATI` não cria país.** `nacionalidades_pessoa` aponta para `paises`. O que
  não casar com a lista vira aviso — inventar encheria a tabela de referência
  com "Brasil", "BRASIL" e "Brazil" como três países.
- **O importador não chama `regras.rs`.** As funções de escrita de lá recebem
  `&SqlitePool` e gravariam por fora da transação, quebrando o "falhou, nada
  entra". Reusadas são as funções puras; duplicado é só o `INSERT`, e o índice
  único de `uniao_filhos` segue como última linha de defesa.

## 9. Critérios de aceite

- [x] Arquivo 5.5.1 em ANSEL importa "José" e "Conceição" sem estragar.
- [x] `CONC`/`CONT` não viram campos falsos.
- [x] `FAMC` múltiplo vira pergunta, e só uma filiação entra.
- [x] `FAM` de mesmo sexo vira pergunta, com a saída de descartar.
- [x] Ciclo no arquivo não entra no acervo.
- [x] União sem pais nomeados ganha dois desconhecidos, ou é descartada.
- [x] Falha no meio não deixa acervo pela metade (teste com gatilho).
- [x] Exportar e reimportar devolve a mesma árvore.
- [x] `npm run verificar` passa.
- [ ] Importar um arquivo real, gerado por outro programa. Os testes usam
      arquivos que este projeto escreve ou que eu escrevi à mão; arquivo de
      verdade só se prova com arquivo de verdade.
