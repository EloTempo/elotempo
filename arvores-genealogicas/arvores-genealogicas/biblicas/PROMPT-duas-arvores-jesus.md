# Prompt: como escrever as DUAS árvores genealógicas de Jesus

Prompt reutilizável para gerar (ou regerar) a genealogia de Jesus até Davi em
qualquer assistente de IA, sem cair na armadilha de inventar uma linhagem única.

---

## Prompt (copie a partir daqui)

Preciso das genealogias de Jesus até o Rei Davi para um aplicativo de
genealogia. Siga estritamente as regras abaixo.

**REGRA CENTRAL — NÃO FUNDIR AS LISTAS.**
Existem duas genealogias nos Evangelhos e elas divergem quase inteiramente entre
Davi e Jesus. Produza-as como duas árvores PARALELAS, nunca como uma só.
Fundi-las inventaria uma linhagem que nenhuma fonte atesta. Se você se pegar
"resolvendo" a divergência para entregar uma lista limpa, pare: a divergência é
o dado, não um defeito a corrigir.

**As duas fontes:**
- MATEUS 1,1-17 — desce de Davi por SALOMÃO; pai de José = JACÓ; começa em
  Abraão; ordem descendente (A gerou B).
- LUCAS 3,23-38 — desce de Davi por NATÃ; pai de José = HELI; retrocede até
  Adão; ordem ascendente.
- Entre Davi e Jesus, os ÚNICOS nomes comuns são SALATIEL e ZOROBABEL. Não
  invente outras coincidências.

**Estruture a saída em cinco blocos, nesta ordem:**
1. Tronco comum (Abraão → Jessé → Davi), onde as listas concordam.
2. Ponto de bifurcação em Davi.
3. Ramo A (Mateus, por Salomão) e Ramo B (Lucas, por Natã), lado a lado.
4. Ponto de reencontro (Salatiel e Zorobabel) e nova separação (Abiúde x Resa).
5. A geração final: Jacó x Heli como pai de José; José, Maria, Jesus.

**Marque cada pessoa com um campo `linhagem: mateus | lucas | ambas`,** para que
a interface possa exibir uma OU outra árvore.

**Distinga certeza por VÍNCULO, não só por pessoa:**
- `[EXPLÍCITO]` — o texto afirma diretamente.
- `[INFERIDO]` — depende de identificar personagens entre si (debatido).
- `[TRADIÇÃO]` — hagiografia posterior, sem base no texto bíblico.
- `[DIVERGENTE]` — as fontes se contradizem; registre AS DUAS versões.

**Trate as hipóteses de harmonização como hipóteses, jamais como fatos.**
Apresente-as nomeando o autor e a data, sem escolher vencedora:
- Mateus = linha legal de José / Lucas = linha de Maria (tradicional desde
  c. 1490; Lucas NÃO afirma isso explicitamente).
- Levirato (Júlio Africano, c. 200, preservado por Eusébio).
- Linha real x linha natural (Agostinho, *De Consensu Evangelistarum*).
- Leitura acadêmica moderna: ambas são composições teológicas.

**Inclua a moldura da Igreja Católica**, se o contexto for católico: a Igreja
não define lista oficial; define o vínculo Jesus–Davi como doutrina, e manda
ler o texto pelo gênero literário (Dei Verbum 12; Pontifícia Comissão Bíblica,
1993). Mateus organiza em 3×14 gerações — número simbólico, possivelmente
criptograma de DAVI (DWD = 4+6+4 = 14) — e para isso OMITIU reis conhecidos.

**Acrescente as ramificações de parentesco, cada uma com seu nível:**
- João Batista `[EXPLÍCITO]` — Isabel é "parenta" (grego *syngenis*) de Maria,
  Lc 1,36. O texto NÃO diz o grau; "prima" é tradição, não texto.
- "Irmãos do Senhor" (Tiago, José, Simão, Judas) — citados explicitamente, mas
  o GRAU é debatido: irmãos de sangue, meio-irmãos ou primos, conforme a
  confissão. Apresente as três leituras.
- Apóstolos irmãos entre si `[EXPLÍCITO]`: Pedro e André; Tiago Maior e João
  (filhos de Zebedeu e Salomé).
- Primos de Jesus `[INFERIDO]`: depende de quem é a "irmã de Maria" de Jo 19,25
  — Salomé (então Tiago e João são primos) ou Maria de Clopas (então os filhos
  de Alfeu). Registre as DUAS hipóteses, sem escolher.
- "Santa Parentela" medieval (Ana casada três vezes etc.) `[TRADIÇÃO]` — não
  está na Bíblia e as versões se contradizem; inclua só como aviso.

**Sinalize os homônimos,** que são a maior fonte de erro aqui: dois Jacó (o
patriarca e o pai de José); três Tiagos (Maior, Menor, o Justo); dois Judas
(Tadeu e Iscariotes); dois Josés; dois Simões; quatro Marias. Desambigue por
nome de registro + filiação, nunca pelo nome público.

**Formato de saída:** um bloco por pessoa, campos `chave: valor`, blocos
separados por `== Nome ==`. Campos: identidade, nome_publico, nome_registro,
nascimento, falecimento, profissoes, nacionalidades, religioes, idiomas,
linhagem, relacoes, fonte (com o versículo), confiabilidade.

**Datas:** use "cerca de" para tudo — nada aqui tem data documental. Jesus:
cerca de 4 a.C. a cerca de 30 d.C., ambas disputadas. Marque como `[divergente]`.

**Confiabilidade:** tudo é `reconstruida-tradicional`. Não há documentação
primária no sentido genealógico. Não eleve nada a "documentada".

**Não faça:** não invente datas de nascimento para nomes da lista; não complete
lacunas com nomes plausíveis; não afirme grau de parentesco que o texto não dá;
não apresente a hipótese "Lucas = Maria" como se fosse consenso; não produza uma
lista única "harmonizada".

<!-- fim do prompt -->

---

## Por que o prompt é assim

Três armadilhas que ele existe para evitar:

1. **A fusão.** O reflexo de qualquer modelo (e de muitos sites) é entregar uma
   árvore só, limpa. Isso destrói a informação mais importante do material.
2. **A hipótese virando fato.** "Lucas traz a genealogia de Maria" é leitura
   tradicional desde c. 1490, mas Lucas não diz isso. Apresentar como consenso é
   erro factual.
3. **O grau inventado.** *Syngenis* significa "parenta"; "prima de Maria" é
   preenchimento posterior. O mesmo vale para os "irmãos do Senhor".

## Exigências que essa árvore impõe ao modelo de dados

- Fontes CONCORRENTES para o mesmo vínculo (Jacó x Heli como pai de José).
- Paternidade LEGAL distinta da biológica (José e Jesus).
- Grau de parentesco INDETERMINADO ("parenta", sem grau).
- Nível de certeza POR VÍNCULO, não apenas por pessoa.

Esse último item é o mais estrutural: até aqui a confiabilidade estava na
pessoa; esta árvore exige que a aresta também a tenha.
