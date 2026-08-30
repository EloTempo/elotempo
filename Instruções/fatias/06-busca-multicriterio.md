# Fatia 06 — Busca multicritério

> Item 9 do MVP (seção 9), detalhado na seção 7. Fecha o MVP.

## O que existe hoje

A barra lateral procura por nome e sobrenome, e desde a fatia 02 também pelos
outros nomes que a pessoa carregou. Só isso.

A seção 7 pede mais: **critérios combináveis** — nome, sobrenome, cidade,
país/nacionalidade, década, religião — "e, por extensão, escolaridade,
profissão e idioma".

## Por que agora ficou barato

Duas fatias anteriores prepararam o terreno sem que esse fosse o objetivo:

- **Locais (fatia 04)** tornou "cidade" um critério confiável. Antes, filtrar
  por "Campos" acertaria "Campos dos Goytacazes" e erraria "Campos-RJ" — o
  filtro pareceria funcionar e mentiria.
- **Datas ordenáveis (migration 007)** deram `ano_inicio`, sem o qual "década"
  exigiria interpretar texto livre em tempo de consulta.

## Escopo

**Filtros combináveis**, todos opcionais, todos em `E` (quem passa em todos
aparece):

| Filtro | Como casa |
|---|---|
| Texto | Nome, sobrenome, ou qualquer nome de `nomes_pessoa` |
| Sobrenome | Só o sobrenome, para agrupar linhagem |
| Cidade | Local do **nascimento** |
| Nacionalidade | País em `nacionalidades_pessoa` |
| Década | Ano de nascimento entre `X` e `X+9` |
| Religião · Profissão · Idioma · Escolaridade | Item da lista respectiva |
| Situação | Viva, falecida, ou ambas |

**Opções vindas do acervo.** Os seletores mostram só o que existe de fato: as
religiões que alguém cadastrou, as décadas em que alguém nasceu, as cidades
usadas. Oferecer a taxonomia inteira faria o usuário escolher "Budista" num
acervo sem nenhum budista e receber lista vazia — parece defeito, e não é.

**Resultado navegável**: clicar centraliza a pessoa na árvore, como a seção 7
pede.

## Duas decisões

**Cidade casa com o local de nascimento**, não com qualquer evento. É o que o
exemplo da própria seção 7 implica — "nascidos na década de 1940 em Campos" —
e é o critério que agrupa famílias. Alguém que nasceu longe e morreu na cidade
não pertence àquela linhagem local. Ampliar para qualquer evento é refinamento
posterior, não MVP.

**Década vem de `ano_inicio` do nascimento**, o campo derivado da migration 007
— nunca do texto. Quem escreveu "cerca de 1890" entra na década de 1890 porque
o interpretador de datas resolveu isso na gravação, não porque a consulta tentou
adivinhar.

## O que fica de fora

- **Estatísticas e gráficos** (seção 7). Esta fatia entrega o filtro; a seção 7
  diz que "o filtro alimenta a estatística", então a ordem é essa. O formato do
  filtro já foi pensado para ser reaproveitado lá.
- Salvar buscas.
- Busca por texto na minibiografia ou nas notas.

## Regras

1. **Filtro vazio não filtra.** Sem nenhum critério, a lista é o acervo.
2. **Zero resultado é dito.** "Ninguém com esses critérios" — e com o botão de
   limpar à mão, porque a saída de um filtro que não achou nada é desfazê-lo.
3. **Valores sempre vinculados.** A consulta é montada dinamicamente conforme
   os filtros ativos, mas nenhum valor entra por interpolação de string: só a
   *estrutura* varia, os dados vão por bind.

## Critérios de aceite

- [ ] Combinar década de nascimento e cidade devolve só quem passa nos dois.
- [ ] Os seletores listam apenas o que existe no acervo.
- [ ] Filtrar por religião acha quem tem aquela religião cadastrada.
- [ ] Sem nenhum filtro, a lista é o acervo inteiro.
- [ ] Clicar num resultado centraliza a pessoa na árvore.
- [ ] Limpar filtros restaura a lista.
- [ ] `npm run verificar` passa.
