# Fatia 05 — Relatórios em PDF

> Item 8 do MVP (seção 9), detalhado na seção 6. É o último item grande do MVP.

## Por que importa

Um acervo genealógico que só existe dentro de um programa é um acervo que morre
com o programa. O relatório impresso é o que se leva para o almoço de domingo,
o que se manda para o primo que não usa computador, e o que sobra numa gaveta
daqui a trinta anos.

É também o teste mais honesto do que foi construído até aqui: se o registro em
papel sai incompleto ou confuso, o problema não é do relatório — é do modelo.

## Os três modos (seção 6)

| Modo | O que sai |
|---|---|
| **Só hierarquia** | O diagrama da árvore, com os cards. O "mapa" da família. |
| **Só texto** | Fichas corridas, do mais antigo ao mais recente. Compacto e barato de imprimir. |
| **Combinado** | O diagrama, e abaixo dele as fichas. |

## Ordenação — uma leitura que preciso declarar

A seção 6 diz duas coisas que entram em tensão quando as datas são esparsas:

> "dos membros, **do mais antigo ao mais recente**"
> "**data de nascimento ascendente**; sem data conhecida, cair para a
> profundidade geracional e depois o nome — para ninguém sumir da lista"

Ordenar estritamente por data de nascimento espalha uma família pelo documento
inteiro assim que faltam datas — e num acervo real faltam muitas. Um bisavô sem
data cairia ao lado de um neto sem data, e o parentesco desapareceria da
leitura.

**A escolha desta fatia:** ordenar por `(geração, ano de nascimento, nome)`.
Geração é o que "do mais antigo ao mais recente" significa numa genealogia; o
ano refina dentro da geração; quem não tem ano vai ao fim da própria geração,
nunca some, e fica perto de quem viveu junto dele.

Se você preferir a leitura literal — ano primeiro, geração só como desempate —
é uma linha de código. Só não quis decidir isso em silêncio.

## Conteúdo de cada ficha

A seção 6 lista: nome, apelidos, sexo, nascimento e falecimento, local,
nacionalidade, religião, pais/união e filhos.

Esta fatia inclui tudo isso **e mais** o que já está no banco e o usuário
acabou de cadastrar: profissões, escolaridade, idiomas, outros nomes e a
minibiografia. Deixar de fora dado que a pessoa digitou seria estranho — a
lista da spec é mínimo, não teto.

## Como o PDF sai

`window.print()` na webview do Tauri, que abre o diálogo do sistema com a opção
"Salvar como PDF". É o caminho que a seção 6 já indicava ("print-to-PDF do
webview"), e o mesmo botão serve para impressão direta.

O `globals.css` já tem, desde o início do projeto, as regras `@media print` que
escondem a interface e revelam `#print-container`, com `@page` A4 retrato e
margens de 18 mm. Esta fatia preenche esse contêiner.

Não há geração de PDF em Rust. Uma biblioteca para isso pesaria no binário e
duplicaria o motor de layout que o webview já tem.

## Opções

- **Escopo**: a árvore em volta de uma raiz, ou o acervo inteiro.
- **Incluir miniaturas** — fotos encarecem a impressão, e a seção 6 pede a
  opção explicitamente.
- **Quebrar página entre gerações**.
- **Ocultar pessoas vivas** — a mesma privacidade que a exportação prevê.

## O que fica de fora

- Estatísticas e linhas do tempo anexadas ao relatório (seção 6 as prevê como
  opcionais; dependem de fatias que ainda não existem).
- Formatos genealógicos de publicação — registro/Register, Ahnentafel. A
  seção 6 os marca como evolução, não MVP.
- Escolher fonte, tamanho e cor. A4 retrato, tipografia do tema.

## Regras

1. **O texto da data é o do usuário.** "cerca de 1890" sai como "cerca de
   1890", nunca como 1885–1895.
2. **Ausência de dado é dito, não omitido.** Uma ficha sem falecimento mostra
   "sem registro", não um campo em branco — em papel, campo vazio é ambíguo
   entre "não sei" e "esqueci de imprimir".
3. **Nada de rede.** Nenhuma fonte, folha de estilo ou imagem externa.
4. **Um card não se parte** entre páginas.

## Critérios de aceite

- [ ] Os três modos geram documento distinto e imprimível.
- [ ] O diálogo de impressão do sistema abre com opção de salvar em PDF.
- [ ] A ordenação é geração → ano → nome, e ninguém some da lista.
- [ ] Pessoa sem data de falecimento aparece com "sem registro".
- [ ] "Ocultar pessoas vivas" remove as vivas do documento.
- [ ] Sem miniaturas, nenhuma imagem é carregada.
- [ ] `npm run verificar` passa.
