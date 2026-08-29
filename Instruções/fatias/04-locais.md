# Fatia 04 — Locais

> Item 6 do MVP (seção 9), detalhado na seção 2.4. Destravado pelo seed do
> IBGE, rodado em 29/08/2026: 5.571 municípios versionados na migration 009.

## O problema

Hoje o local de um evento é texto livre, guardado em
`eventos.rotulo_historico_livre`. A coluna `eventos.local_id`, que aponta para a
tabela `locais`, nunca é preenchida — e a tabela, agora com 5.571 municípios,
não é usada por nada.

Texto livre em campo de local tem um custo específico: **"Campos dos
Goytacazes", "Campos-RJ", "campos dos goytacazes" e "Campos" são a mesma cidade
e quatro strings diferentes.** Enquanto for assim, a estatística por cidade da
seção 7 conta quatro lugares onde existe um, e ninguém percebe o erro porque
cada linha parece certa sozinha.

## O que entra

**Autocomplete de município brasileiro.** Digitar "campos" e escolher na lista;
o evento passa a apontar para a linha de `locais` com o `codigo_ibge` do IBGE.

**Local no exterior.** Escolher o país da lista (Brasil e os de imigração no
topo, como a seção 2.4 pede) e escrever a cidade como texto livre. Sem
autocomplete e sem `codigo_ibge` — só o país é padronizado. A cidade estrangeira
é criada em `locais` no momento do uso, e reaproveitada se alguém a digitar de
novo.

**Rótulo histórico.** Um campo à parte para "nascido em Vila de São Salvador,
hoje Campos dos Goytacazes". O `codigo_ibge` continua sendo a chave; o rótulo é
o que se lê na tela. É o que a seção 2.4 chama de não enrijecer o dado
histórico — nomes de cidade mudam, o lugar não.

**Busca sem acento.** "sao paulo" tem de encontrar "São Paulo". Ninguém digita
acento procurando, e um autocomplete que exige acento é pior do que nenhum.

## Decisões

**Coluna `nome_busca` com acentos removidos**, preenchida na migration para os
5.571 existentes e no Rust para as cidades estrangeiras criadas depois. O
`COLLATE NOCASE` do SQLite só entende ASCII: sem essa coluna, "Sao" não casa com
"São" e o autocomplete falha justamente nos nomes brasileiros.

A alternativa seria regerar o seed com a coluna já pronta, mas isso exigiria
rede — e o dado já está versionado. O preenchimento vai numa migration, com
`REPLACE` encadeado. É verboso e é offline, que é o critério que vale aqui.

**A cidade estrangeira vira linha em `locais`.** Poderia ser só texto no evento,
mas aí o agrupamento por país da seção 7 não teria como funcionar — e é
exatamente o que a spec pede para o exterior.

**Prefixo ordena antes de contém.** Quem digita "campos" quer "Campos dos
Goytacazes" antes de "Bom Jesus do Itabapoana"; ambos casam, mas só um começa
com o que foi digitado.

## O que fica de fora

- Coordenadas geográficas (a seção 2.4 já as marca como opcionais) e mapa.
- Distritos e bairros: o IBGE tem essa granularidade, o acervo familiar
  raramente precisa dela, e ela multiplicaria a lista por dez.
- Corrigir retroativamente os locais já digitados como texto livre. Eles
  continuam válidos no rótulo histórico; quem quiser, reabre o evento e
  escolhe o município.
- Estatística por cidade — é da fatia de estatísticas, e esta é a que torna
  aquela possível.

## Regras

1. **Local nunca é obrigatório.** Mesma regra transversal das datas: evento sem
   local é evento válido.
2. **Texto livre continua aceito.** Se a pessoa não achar o município, ou o
   lugar não existir mais, o rótulo histórico sozinho basta. O programa não
   pode exigir uma escolha de lista para deixar salvar.
3. **`codigo_ibge` é a chave, o rótulo é a exibição.** Nunca agrupar pelo texto.
4. **Nenhuma rede.** O seed já está no repositório; o app não consulta o IBGE.

## Critérios de aceite

- [ ] Digitar "campos" no local de um evento sugere "Campos dos Goytacazes, RJ".
- [ ] Digitar "sao paulo", sem acento, encontra "São Paulo, SP".
- [ ] Escolher um município grava `eventos.local_id` apontando para ele.
- [ ] Dá para registrar "Lisboa, Portugal" pelo modo exterior, e a mesma Lisboa
      é reaproveitada na segunda vez.
- [ ] Salvar um evento sem local nenhum funciona.
- [ ] O rótulo histórico aparece na lista de eventos quando preenchido.
- [ ] `npm run verificar` passa.

## Depois desta

Restam do MVP: **relatórios em PDF nos três modos** (item 8) e **busca
multicritério** (item 9). A busca fica mais interessante depois desta fatia,
porque "cidade" passa a ser um critério confiável.
