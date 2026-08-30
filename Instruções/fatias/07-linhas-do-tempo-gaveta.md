# Fatia 07 — Linhas do tempo: a gaveta

> Primeira fatia da seção 8, a mais longa da especificação. Cobre a **gaveta**
> ao lado da árvore. O estúdio e o zoom semântico ficam para fatias próprias,
> por decisão de 29/08/2026.

---

## 1. Por que esta é a fatia que fecha o argumento do projeto

A seção 1 diz que o objetivo não é catalogar parentesco — é **ajudar a memória,
situando cada vida no contexto da sua época**. Tudo que foi construído até aqui
serve a esse fim indiretamente. Esta fatia é a primeira que o serve
diretamente.

Saber que um bisavô nasceu em 1912 é um dado. Ver, na mesma tela, que ele tinha
18 anos na Revolução de 30, que o dinheiro do bolso dele se chamou *mil-réis*
até os 30 anos e *cruzeiro* depois, e que a televisão chegou ao Brasil quando
ele já tinha 38 — isso é o que faz alguém lembrar de uma história para contar.

É também o teste do modelo de datas: se o eixo sair torto, o problema está em
`datas.rs`, não no desenho.

---

## 2. Escopo

### Entra

**A gaveta**, na parte de baixo da tela, dividindo espaço com a árvore por uma
alça arrastável — **split, não overlay** (a seção 8 é explícita). Recolhida,
some quase por inteiro; expandida, o usuário escolhe a proporção.

**Quatro linhas de contexto**, factuais e verificáveis (ver §7 deste documento):

| Linha | Categoria | Natureza |
|---|---|---|
| História do Brasil | `historia` | Pontos e intervalos, 1500–2020 |
| Presidentes da República | `politica` | Intervalos (entrada→saída) |
| A moeda de cada época | `moeda` | Intervalos contíguos |
| Tecnologias de acesso público | `tecnologia` | Pontos de chegada ao Brasil |

**A linha pessoal** da pessoa selecionada na árvore: a faixa da vida dela
(nascimento→falecimento) com os eventos como marcos sobre ela.

**Clicar num marco de contexto** faz duas coisas ao mesmo tempo, como a seção 8
determina: mostra o detalhe e a fonte, **e** destaca na árvore quem estava vivo
naquele ano ou período.

**Limite de camadas**: 3 linhas de contexto ativas por padrão. A vida da pessoa
selecionada **aparece sempre e não ocupa vaga**.

### Não entra

- **O estúdio** — a tela dedicada com todas as categorias e combinações livres.
- **O zoom semântico** — aglomerados virando contagens por escala. Nesta fatia,
  o filtro de relevância e o agrupamento por colisão dão conta; as quatro
  linhas escolhidas não são densas o bastante para justificar o custo.
- **Cinema, música, livros populares, literatura de Adler, Igreja, filosofia,
  arte, população, ciência** — as outras nove categorias da seção 8.
- **Pessoas fixadas para comparação** (a seção 8 prevê limite próprio de 2–3).
- **Configuração do limite de camadas até 10** — não há tela de configurações
  ainda; o limite fica em 3, constante e documentada.

---

## 3. A mecânica da gaveta

**Estados**: recolhida (só a alça e o nome das linhas ativas) e expandida.

**Altura**: arrastável pela alça. Mínimo ~180 px, máximo 80% da janela.

**Acima de ~5 camadas a gaveta rola verticalmente** em vez de espremer as
faixas — a seção 8 pede isso explicitamente, e é a diferença entre ler e
adivinhar. Com o limite de 3 desta fatia mais a linha pessoal, o caso raramente
aparece; a regra fica implementada mesmo assim, porque o custo é baixo agora e
alto depois.

**Eixo horizontal**, com pan e zoom. A proibição de layout horizontal da seção
10 vale só para a **árvore** — o eixo do tempo é horizontal por natureza.

**Faixa visível inicial**: do primeiro ao último ano com dado nas linhas
ativas, mais uma folga. Com uma pessoa selecionada, enquadra a vida dela com
margem de uma geração para cada lado — é o recorte que responde "o que estava
acontecendo enquanto ele viveu".

---

## 4. Ponto e intervalo

O modelo já distingue os dois por `ano_inicio`/`ano_fim` (migration 007):

| Forma | Quando | Desenho |
|---|---|---|
| **Ponto** | `ano_inicio = ano_fim`, ou `ano_fim` nulo | Marcador vertical com rótulo |
| **Intervalo** | `ano_fim > ano_inicio` | Barra do início ao fim |

Uma batalha e uma lei são pontos. O Estado Novo, o Brasil holandês, um mandato
presidencial e um padrão monetário são intervalos. Numa linha de moeda, os
intervalos são **contíguos** — é o que mostra a troca de dinheiro como a vida
real a sentiu.

---

## 5. Quem estava vivo — a regra que precisa ser dita

Clicar num marco destaca na árvore quem estava vivo. A regra:

> Uma pessoa estava viva no ano `A` se `ano_nascimento <= A` **e**
> (`ano_falecimento >= A` **ou** não há ano de falecimento e ela está marcada
> como viva).

Para um marco de **intervalo**, vale a sobreposição: esteve viva em qualquer
parte do período.

**Quem não tem ano de nascimento fica de fora do destaque** — não dá para
afirmar o que não se sabe. Mas a gaveta **diz quantos ficaram de fora por falta
de data**, em vez de calar. É o mesmo princípio do relatório: ausência de dado é
dita, não omitida. Sumir em silêncio faria o usuário concluir que o antepassado
não viveu naquela época, quando o programa apenas não sabe.

---

## 6. Somente leitura, de verdade

A seção 8 e a 13 são categóricas: linhas de contexto **nunca** podem ser
editadas pelo usuário. O `is_bloqueada` não basta sozinho — uma flag que só a
interface respeita é uma flag que o próximo bug atropela.

Três camadas, na mesma disciplina das invariantes da seção 3:

1. **Não existe comando.** Nenhum `#[tauri::command]` altera `eventos_linha` ou
   `linhas_tempo` de uma linha de contexto. O que não tem porta não precisa de
   fechadura.
2. **Gatilho no banco** que recusa `UPDATE` e `DELETE` em linha com
   `is_bloqueada = 1`. Última linha de defesa, pega até um import defeituoso.
3. **Teste** que tenta o `UPDATE` cru e exige a recusa.

O conteúdo vem em **migrations versionadas**, como a seção 8 determina
("empacotadas com o app e versionadas"). Corrigir um marco é escrever uma
migration nova, o que deixa rastro — que é exatamente o que se quer de uma
referência bibliográfica.

---

## 7. O conteúdo, e o que eu garanto sobre ele

As quatro linhas somam ~120 marcos. Divido por confiança, porque isso muda o
quanto você precisa revisar:

**Alta confiança — fatos datados e de amplo consenso:**

- **História do Brasil** (~45 marcos): a semente de
  `Instruções/linha-tempo-brasil.md`, já escrita e revisada por você, virando
  migration sem alteração de conteúdo.
- **Presidentes** (11 mandatos, 1979→): também da semente. Intervalos com
  entrada e saída, incluindo os afastamentos marcados.
- **Moeda** (~9 padrões): mil-réis, cruzeiro, cruzeiro novo, cruzeiro, cruzado,
  cruzado novo, cruzeiro, cruzeiro real, real. Intervalos contíguos.

**Confiança média — precisam do seu olho:**

- **Tecnologias de acesso público** (~15 marcos): rádio, televisão, TV em
  cores, telefone, geladeira, automóvel popular, videocassete, computador
  pessoal, internet, celular, banda larga, smartphone. As datas de **chegada ao
  Brasil** diferem das mundiais, e é aí que eu erro mais. Cada marco entra com
  `fonte_especifica` preenchida ou, na falta, com `relevancia = 'media'` para
  não subir à gaveta antes de conferido.

**Nota da semente**: a linha de presidentes traz "Eleição em 04/10/2026" como
evento futuro. Hoje é 29/08/2026 — entra como está, e vira migration de
correção depois do fato.

**Só fatos.** A seção 8 é explícita: títulos, datas, movimentos, nomes — nunca
conteúdo protegido. Nenhuma das quatro linhas desta fatia chega perto disso,
mas a regra fica registrada para as linhas de cinema e música que virão.

---

## 8. Modelo de dados — nada muda

`linhas_tempo` e `eventos_linha` já têm a forma certa desde a migration 005, e
a 007 acrescentou `ano_inicio`/`ano_fim`. Os índices
`ix_eventos_linha_(linha|relevancia|ano)` já existem, e o composto
`(linha_id, relevancia)` é exatamente o filtro da gaveta.

**A linha pessoal não vira tabela.** A seção 8 já sugere que ela "pode ser uma
view sobre os eventos das pessoas", e é o certo: duplicar eventos criaria duas
verdades para o mesmo fato. Ela é montada na consulta, a partir de `eventos` e
dos anos derivados.

**Comandos novos:**

- `listar_linhas_de_contexto()` — as linhas disponíveis, com contagem de marcos
  por relevância.
- `buscar_marcos(linha_ids, ano_de, ano_ate, relevancia_minima)` — os marcos das
  linhas ativas na janela visível.
- `montar_linha_pessoal(pessoa_id)` — faixa de vida e eventos.
- `quem_estava_vivo(ano_inicio, ano_fim, pessoa_ids)` — o destaque na árvore.

---

## 9. Regras

1. **Linha de contexto é imutável** — três camadas, §6 deste documento.
2. **A vida da pessoa selecionada não ocupa vaga** de camada.
3. **Ausência de data é dita, não omitida** — no destaque de quem estava vivo.
4. **O texto do usuário manda.** Na linha pessoal, o marco mostra o
   `data_texto` que a pessoa escreveu; o ano derivado só posiciona.
5. **Nada de rede.** O conteúdo é migration versionada.
6. **A gaveta é split, não overlay.**

---

## 10. Critérios de aceite

- [ ] A gaveta abre e fecha, e a alça redimensiona entre 180 px e 80% da tela.
- [ ] As quatro linhas de contexto aparecem e podem ser ligadas e desligadas.
- [ ] Ligar uma quarta linha de contexto é recusado com aviso do limite de 3.
- [ ] A vida da pessoa selecionada aparece mesmo com 3 contextos ativos.
- [ ] Um intervalo (Estado Novo) desenha barra; um ponto (Lei Áurea) desenha
      marcador.
- [ ] Clicar num marco mostra o detalhe e a fonte.
- [ ] Clicar num marco destaca na árvore quem estava vivo, e informa quantos
      ficaram de fora por falta de data de nascimento.
- [ ] `UPDATE` cru numa linha de contexto é recusado pelo banco.
- [ ] Trocar a pessoa selecionada troca a linha pessoal sem recarregar o resto.
- [ ] Evento com data "cerca de 1890" aparece com esse texto no detalhe.
- [ ] `npm run verificar` passa.

---

## 11. Depois desta

Na ordem em que fazem sentido:

1. **Estúdio de linhas do tempo** — a segunda superfície sobre o mesmo dado.
2. **Zoom semântico** — quando houver linhas densas que o justifiquem.
3. **As outras nove categorias** — cinema, música e livros populares primeiro,
   por serem as de maior gatilho de memória, e com revisão item a item.
4. **Configurações** — para o limite de camadas ir de 3 a 10, como a seção 8
   prevê.
