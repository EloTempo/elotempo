> **Nota de escopo (30/08/2026).** Decidido com o autor: exportar antes de
> importar; importar aceitará 5.5.1 **e** 7.0; conflitos com as invariantes
> serão resolvidos caso a caso, num assistente. A importação está planejada em
> `09-gedcom-importacao.md`.

# Fatia 08 — Exportar GEDCOM

> Primeiro item do "depois do MVP" (seção 9), fundamentado na seção 4:
> "o SQLite é o formato de trabalho; o GEDCOM é o de transporte/backup".

---

## 1. Por que esta antes das outras

A seção 1 lista **portabilidade** como princípio inegociável: "o usuário é dono
do arquivo e deve poder exportar tudo". Hoje isso é meia verdade. O acervo é um
SQLite que a pessoa pode copiar — mas só este programa sabe lê-lo. Um formato
que outros programas entendem é o que transforma "você tem o arquivo" em "você
tem os seus dados".

É também a metade **segura** do GEDCOM: exportar só lê. O pior defeito possível
produz um arquivo torto, que ninguém é obrigado a aceitar. E os arquivos que ela
gera viram os casos de teste do importador, contra o nosso próprio modelo.

---

## 2. O que sai

**Um arquivo `.ged`** em GEDCOM 7.0, UTF-8.

**Um `.gdz` (GEDZip)** quando houver mídia: um zip com o `.ged` mais a pasta de
mídia, como a seção 4 determina. É o que faz as fotos viajarem junto.

**Escopo selecionável**: o acervo inteiro, ou a árvore em volta de uma pessoa.

**Ocultar pessoas vivas**, conforme a seção 9.

---

## 3. O mapeamento

| No acervo | Em GEDCOM |
|---|---|
| `pessoas` | `INDI` |
| nome de exibição | `NAME Dado /Sobrenome/` |
| `nomes_pessoa` | `NAME` com `TYPE` (`BIRTH`, `MARRIED`, `AKA`…) |
| `apelidos_pessoa` | `NICK` |
| `sexo` | `SEX` (M · F · X · U) |
| nascimento, batismo, falecimento, sepultamento | `BIRT` · `BAPM` · `DEAT` · `BURI` |
| casamento (da união) | `MARR` dentro do `FAM` |
| datas | `DATE`, com `ABT` · `BEF` · `AFT` · `BET…AND` |
| `locais` | `PLAC`, com o `codigo_ibge` em `_IBGE` |
| `religioes_pessoa` | `RELI` |
| `escolaridade_pessoa` | `EDUC` |
| `profissoes_pessoa` | `OCCU` |
| `nacionalidades_pessoa` | `NATI` |
| `idiomas_pessoa` | `_LANG` (extensão — não há tag padrão, conforme a seção 2.5) |
| `minibiografia` | `NOTE` |
| `documentos` | `OBJE` com `FILE` e `TITL` |
| `unioes` | `FAM` com `HUSB` e `WIFE` |
| `uniao_filhos` | `CHIL` no `FAM`, `FAMC` no `INDI`, com `PEDI` |

**Identificadores.** Os nossos são UUID, que não cabem numa `xref` de GEDCOM.
Na exportação viram `@I1@`, `@F1@` sequenciais, com o mapeamento mantido em
memória durante a escrita.

---

## 4. Duas simetrias que caem naturalmente

**Placeholder não vira pessoa.** Um "Desconhecido" é um nó técnico nosso, não
alguém que existiu. Exportá-lo encheria o arquivo de terceiros de fantasmas.
Um `FAM` cujo pai é placeholder simplesmente **omite o `HUSB`** — que é GEDCOM
válido, e é exatamente o que a seção 2.2 já previa ("em GEDCOM corresponde a
uma `FAM` com só um dos parceiros nomeado").

Na importação, a simetria se fecha: `FAM` com um lado só → cria o placeholder.

---

## 5. O problema que este trabalho revelou

**Dia e mês não estão guardados.**

`eventos` tem `data_texto` (livre) e `ano_inicio`/`ano_fim` (derivados). Não há
coluna para dia nem mês. Quem escreveu "12/03/1945" tem o texto preservado —
mas na hora de emitir `2 DATE`, o que o programa sabe estruturalmente é só
`1945`.

Exportar ano quando se sabe o dia é perda de fidelidade num formato cujo
propósito é justamente transportar o dado com fidelidade.

**A correção entra nesta fatia**: `datas.rs` passa a extrair dia e mês quando o
texto os traz, e a migration acrescenta `dia_inicio`/`mes_inicio`. O texto do
usuário continua sendo a verdade exibida; os campos derivados crescem para
comportar o que o GEDCOM precisa.

É barato agora e caro depois — cada acervo criado antes disso exportaria pela
metade.

---

## 6. Datas: nada se perde

O `DATE` do GEDCOM tem gramática fechada (`ABT 1890`, `12 MAR 1945`, com meses
em abreviação inglesa). O nosso `data_texto` é livre e em português.

A regra: **emitir o que a gramática comporta e preservar o resto**.

- `12/03/1945` → `2 DATE 12 MAR 1945`
- `cerca de 1890` → `2 DATE ABT 1890`
- `entre 1902 e 1904` → `2 DATE BET 1902 AND 1904`
- `na época da guerra` → sem `DATE`, e o texto vai para uma `NOTE`

Sempre que o texto original não for reproduzível pelo `DATE` emitido, ele sai
numa `NOTE` do evento. Assim o arquivo carrega tudo que a pessoa escreveu,
mesmo o que o padrão não sabe representar.

---

## 7. Privacidade: ocultar sem quebrar a árvore

A seção 9 pede "ocultar pessoas vivas na exportação". *Ocultar* não pode ser
*omitir*: apagar o `INDI` de alguém vivo desliga os filhos dela da árvore, e
quem receber o arquivo vê uma geração órfã.

A escolha desta fatia: **a pessoa continua no arquivo, sem os dados**. Nome
vira "Vivo" ou "Viva", e datas, locais, atributos, notas e mídia não são
emitidos. A estrutura de parentesco fica intacta e nada privado sai.

---

## 8. O que fica de fora

- **Importar** — fatia 09.
- **Fontes e citações** — fora de escopo por decisão de 29/08/2026. As tabelas
  existem vazias; não há `SOUR` de registro a emitir.
- **Linhas do tempo** — são material de referência do programa, não dados
  genealógicos do usuário. Não pertencem ao arquivo dele.
- **GEDCOM 5.5.1 na saída** — exportamos 7.0. Ler 5.5.1 é problema da fatia 09.

---

## 9. Regras

1. **Placeholder nunca vira `INDI`.**
2. **Nada do que o usuário escreveu se perde** — o que não couber na gramática
   sai em `NOTE`.
3. **UTF-8, sem exceção.** É o que o 7.0 exige.
4. **Nada de rede.**
5. **Ocultar vivas não pode quebrar o parentesco.**
6. O arquivo termina em `0 TRLR`, e cada registro tem `xref` única.

---

## 10. A verificar antes de fechar o exportador

Pontos em que não tenho certeza suficiente e que precisam ser conferidos contra
a especificação oficial (link na seção 12), não deduzidos:

- A estrutura exata exigida no `HEAD` do 7.0 — o que é obrigatório além de
  `GEDC.VERS`, e se `CHAR` foi removido por o formato ser UTF-8 sempre.
- Se `DATE` é permitido dentro de `NAME` (já anotado na fatia 02). Se não for,
  o período de um nome sai como `NOTE`.
- A forma canônica de extensões (`_LANG`, `_IBGE`) e se exigem declaração no
  cabeçalho em 7.0.

**Nenhum desses é bloqueio para começar** — todos afetam detalhes de emissão,
não o desenho.

---

## 11. Critérios de aceite

- [ ] Exportar o acervo produz um `.ged` que abre em outro programa de
      genealogia sem erro de leitura.
- [ ] Uma pessoa com nome, sexo, nascimento, falecimento e união volta completa.
- [ ] Um evento "12/03/1945" sai como `12 MAR 1945`, não como `1945`.
- [ ] Um evento "na época da guerra" sai sem `DATE` e com o texto numa `NOTE`.
- [ ] Um `FAM` cujo pai é placeholder sai sem `HUSB`, e não há `INDI` do
      placeholder no arquivo.
- [ ] Com "ocultar vivas", nenhuma data ou local de pessoa viva aparece no
      arquivo, e os filhos dela continuam ligados.
- [ ] Com mídia anexada, o `.gdz` contém o `.ged` e os arquivos.
- [ ] Acervo vazio gera arquivo válido, com `HEAD` e `TRLR`.
- [ ] `npm run verificar` passa.

---

## 12. Depois desta

**Fatia 09 — importar**, com as políticas já decididas. O exportador entrega de
brinde o melhor teste que o importador pode ter: exportar e reimportar deve
devolver o mesmo acervo.
