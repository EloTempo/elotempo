# Fatia 10 — O estúdio de linhas do tempo

Criar linhas do tempo próprias, com marcos e pessoas envolvidas, e navegá-las
como abas. Desenho proposto pelo Gabriel em 30/08/2026.

---

## 1. A observação que decide o desenho

> "A própria árvore genealógica marca acontecimentos que envolvem pessoas
> diferentes. Um casamento entraria em pelo menos 2 linhas do tempo. Um
> nascimento é um marco de 3 linhas do tempo."

Isto não é uma proposta de mudança — é a descrição do que já é verdade no
acervo, e que o programa ainda não honra. **Um acontecimento pertence a várias
vidas.** O modelo de dados sempre soube disso: a tabela `eventos` tem
`pessoa_id` **e** `uniao_id`, com um `CHECK` exigindo um dos dois. Um casamento
é evento da união, não de um dos cônjuges.

E aqui está o defeito que a observação revela: `montar_linha_pessoal` consulta
`WHERE e.pessoa_id = ?`. **Um casamento não aparece na linha pessoal de nenhum
dos dois noivos** — o dado está gravado e a tela não o mostra. Corrigir isso é o
passo zero desta fatia, e vale por si, antes de qualquer estúdio.

O nascimento é o caso mais forte da observação: é o marco inaugural da vida de
quem nasce, mas também um dia na vida da mãe e do pai. Hoje ele aparece só na
primeira. Esta fatia não resolve o nascimento nas linhas dos pais — ver a
seção 8 —, mas o modelo que ela introduz é o que tornará isso possível.

---

## 2. O modelo

Três níveis, dois deles já existentes:

```
linhas_tempo (existe)  →  eventos_linha (existe)  →  participações (NOVO)
```

**A linha do usuário não precisa de esquema novo.** `is_contexto` e
`is_bloqueada` são colunas separadas desde a migration 005, e os gatilhos da 013
disparam por `is_bloqueada`. Uma linha criada pelo usuário nasce
`is_contexto = 1, is_bloqueada = 0` — editável, sem afrouxar gatilho nenhum, e
as cinco linhas semeadas continuam tão imutáveis quanto hoje. A separação das
duas colunas foi escrita antes de haver estúdio; é o raro caso em que a decisão
antiga já cabia na nova.

O que falta é a tabela de participação:

```sql
CREATE TABLE marco_participantes (
    id                TEXT PRIMARY KEY,
    marco_id          TEXT NOT NULL,
    pessoa_id         TEXT NOT NULL,
    papel             TEXT,
    visivel_na_pessoa BOOLEAN NOT NULL DEFAULT 1,
    FOREIGN KEY (marco_id)  REFERENCES eventos_linha(id) ON DELETE CASCADE,
    FOREIGN KEY (pessoa_id) REFERENCES pessoas(id)       ON DELETE CASCADE
);
```

`papel` é texto livre — "fundador", "testemunha", "presente" — sugerido por
`datalist`, como as demais taxonomias do projeto. Índice único em
`(marco_id, pessoa_id)`: a mesma pessoa não entra duas vezes no mesmo marco.

---

## 3. Visibilidade: a solução, e por que não a outra

O Gabriel propôs duas saídas para o acontecimento que é grande na linha criada e
pequeno na vida de quem participou — a fundação de uma empresa, que importa à
empresa e é rodapé na biografia do fundador:

- **(a)** escolher, ao criar o marco, se ele aparece ou não nas linhas pessoais;
- **(b)** vincular sempre, e marcar a participação como oculta, com opção de
  exibir as ocultas.

**Fica a (b).** A razão é a mesma que já governa a `relevancia` das linhas de
contexto: uma decisão de exibição **nunca deve destruir uma relação**. Na (a), a
resposta a "quem esteve na fundação?" passa a depender de uma escolha de tela
feita meses antes; na (b) o vínculo existe sempre, e a tela decide o que mostrar.
É a mesma disciplina do marco em `relevancia = 'media'`, que não some do banco —
só não sobe à gaveta.

A (a) não está descartada: ela é o que a (b) faz quando o usuário desliga a
chave. A diferença é que na (b) o dado sobrevive à decisão.

**O padrão é visível, e a chave fica no marco.** Marcar alguém como envolvido é
um ato deliberado; se o ato deliberado não produz efeito visível, o usuário
conclui que a função não funciona — é o modo de falha que mata uma feature. Quem
quiser o contrário desliga uma chave no marco ("não mostrar isto nas vidas das
pessoas"), que é onde o exemplo da empresa vive: o marco inteiro é rodapé para
todos os envolvidos, não para um só. A exceção por pessoa continua disponível,
mas é exceção.

**A chave existe só para participações.** Os eventos da vida da própria pessoa —
nascimento, casamento, falecimento — não ganham interruptor de visibilidade. Um
nascimento nunca é ruído numa biografia. A linha que isto traça é limpa e fácil
de explicar: **a sua vida aparece sempre; aquilo de que você participou é
escolha.**

---

## 4. Duas origens na linha pessoal

Depois desta fatia, a linha de uma pessoa reúne:

1. os **eventos da vida dela** — `eventos`, por `pessoa_id` e pelas uniões de
   que participa (ver o passo zero da seção 1);
2. as **participações** em marcos de linhas criadas — `marco_participantes` com
   `visivel_na_pessoa = 1`.

As duas precisam ser **visualmente distintas**. Misturá-las sem distinção faria
a linha pessoal afirmar que a fundação da empresa é um evento da vida do
fundador no mesmo sentido em que o nascimento é — e não é. Proposta: os eventos
próprios sobre a faixa da vida, as participações como marcas menores acima dela,
na cor da linha de origem.

Um botão "mostrar ocultos" revela as participações desligadas, apagadas.

---

## 5. A fronteira com a prosopografia

O Gabriel observou, com razão, que esta estrutura **seria suficiente** para um
estudo prosopográfico, ainda que não seja a intenção. Como a decisão de
29/08/2026 põe prosopografia fora de escopo, a fronteira precisa estar escrita,
não subentendida:

- **Dentro:** pessoa → **marco**. "Fulano esteve na fundação." É um fato sobre
  um acontecimento datado, da mesma natureza do que a linha do tempo já guarda.
- **Fora:** pessoa → **pessoa** não familiar. "Fulano era subordinado de
  Beltrano." Nenhuma tabela, nenhuma tela.
- **Fora, e é o ponto sutil:** a rede de coocorrência. Três pessoas no mesmo
  marco significam, implicitamente, "estas três se encontraram" — matéria-prima
  de prosopografia. O programa **não deriva** esse grafo, não o desenha e não
  oferece consulta por ele. O dado permite; o produto não faz.

Se um dia essa porta for aberta, que seja por decisão registrada, não por
consequência lateral de uma feature de linha do tempo.

---

## 6. As abas

A fileira de camadas deixa de ser uma lista de interruptores e passa a se
comportar como abas: abre, fecha, e um **`+`** no fim oferece (i) abrir uma
linha já salva no acervo, (ii) criar uma nova, (iii) abrir a vida de outra
pessoa.

Consequências:

- **`LIMITE_DE_CAMADAS = 3` cai.** Foi calibrado para interruptores, onde ligar
  é barato e irrefletido. Com abas, cada linha é uma escolha explícita. A altura
  finita do eixo continua real, e a saída é a gaveta rolar na vertical, não um
  número mágico.
- **Várias vidas no mesmo eixo** deixam de ser um pedido separado: uma vida é
  mais uma aba. É a mudança de maior valor de estudo do projeto.
- **O cadeado ganha função.** Hoje ele decora todas as abas; passa a distinguir
  a linha curada da linha do usuário, que é a distinção que mais importa não
  perder.

---

## 7. Dificuldade, honestamente

**Não é uma fatia difícil; é uma fatia grande.** Não há invariante nova, nem
problema de grafo, nem algoritmo de layout que não exista. As três coisas
genuinamente difíceis deste projeto — as invariantes de conexão, o layout em
duas passadas, a busca que ignora acento dos dois lados — já foram pagas.

| Parte | Natureza | Comparável a |
|---|---|---|
| Passo zero: casamento na linha pessoal | uma cláusula a mais na consulta | correção pontual |
| Migration e índice único | trivial | migration 010 |
| Comandos de escrita (linha, marco, participação) | CRUD com testes | fatia 01 |
| Linha pessoal com duas origens | uma consulta nova, uma decisão de ordem | fatia 07 |
| Abas com `+` e o seletor | UI, monta peças que já existem | — |
| Editor de linha e de marco | a maior peça, mas reusa `CampoDeData` e a busca de pessoas | fatia 01 |

O risco real não é técnico, é **editorial**: uma linha do usuário jamais pode
ser confundida com uma curada. É o mesmo cuidado da `relevancia`, pela mesma
razão — a referência vale pela integridade, não pela quantidade.

**Recomendação: partir em duas.**

- **10a** — criar linha, criar marcos, abas com `+`. Entrega o estúdio sem tocar
  na linha pessoal, e já permite o estudo comparativo de várias linhas no mesmo
  eixo.
- **10b** — participação, visibilidade e a linha pessoal com duas origens. É a
  metade que envolve a fronteira da seção 5 e merece atenção separada.

---

## 8. O que fica de fora

- **Nascimento na linha dos pais.** A observação da seção 1 vale, mas resolvê-la
  mexe em como o acervo entende evento — não se resolve de passagem.
- **Impressão.** Fatia própria, com o zoom semântico junto.
- **Papéis como taxonomia fechada.** `papel` fica em texto livre.
- **Compartilhar linhas entre acervos.** Exportar uma linha criada para outra
  pessoa usar é assunto de outra fatia.
- **Rede de coocorrência.** Ver a seção 5. Não é "ainda não" — é "não".

---

## 9. Regras

1. Linha semeada (`is_bloqueada = 1`) permanece intocável. Nenhum comando novo
   pode alterá-la, e os gatilhos continuam sendo a última linha de defesa.
2. Toda linha criada nasce `is_bloqueada = 0` e é do usuário.
3. Apagar uma linha criada apaga seus marcos e participações em cascata; apagar
   uma pessoa apaga as participações dela, nunca os marcos.
4. Desligar a visibilidade **nunca** apaga a participação.
5. Regra de escrita vai em módulo próprio de domínio, com teste antes —
   exigência da seção 11 da especificação.

---

## 10. Critérios de aceite

- [ ] Um casamento gravado na união aparece na linha pessoal dos dois cônjuges.
- [ ] O `+` cria uma linha nova, que aparece como aba e persiste ao reabrir.
- [ ] Marcos podem ser acrescentados, editados e removidos numa linha criada.
- [ ] As cinco linhas semeadas continuam recusando alteração, por gatilho.
- [ ] Marcar uma pessoa num marco faz o marco aparecer na linha dela.
- [ ] Desligar a visibilidade tira o marco da linha da pessoa **sem** apagar o
      vínculo — e "mostrar ocultos" o traz de volta.
- [ ] Evento próprio e participação são distinguíveis a olho na linha pessoal.
- [ ] Duas vidas podem estar abertas ao mesmo tempo, no mesmo eixo.
- [ ] `npm run verificar` passa.
