# Fatia 02 — Nomes ao longo da vida

> Fatia vertical derivada da especificação principal. Amplia a seção 2.1, que
> hoje prevê um par nome/sobrenome e uma lista de apelidos.

## O problema

Ao cadastrar **D. João VI**, não há onde pôr o nome pelo qual ele é conhecido.

"D. João VI" não é um apelido. Apelido (`NICK` no GEDCOM) é alcunha afetiva —
"Zezinho", "Nenê", "a Tia Chica". "D. João VI" é o **nome público**: o nome sob
o qual a pessoa entrou para a história, e que na maioria dos casos é o único que
alguém conhece. O nome completo dele — João Maria José Francisco Xavier de Paula
Luís António Domingos Rafael de Bragança — precisa continuar registrado, mas não
é o que se escreve num card de árvore.

O mesmo vale para casos que não têm nada de nobreza:

| Pessoa | Nome de nascimento | Nome pelo qual se conhece |
|---|---|---|
| Papa Francisco | Jorge Mario Bergoglio | Francisco |
| Madre Teresa | Anjezë Gonxhe Bojaxhiu | Teresa de Calcutá |
| Uma bisavó | Maria Aparecida Souza | Maria Aparecida Souza **Lima** (de casada) |
| Um imigrante | Giovanni Battista Rossi | João Batista Rosa |

São quatro fenômenos distintos — nome religioso, nome de casada, nome adotado na
imigração, nome público — e nenhum deles é apelido. O que têm em comum: **a
pessoa carregou mais de um nome, e às vezes em momentos diferentes da vida**.

## Por que isto importa mais do que parece

O objetivo declarado do projeto é ajudar a memória de famílias. Mas o uso
pretendido inclui **árvores de figuras públicas e históricas**, para estudos
geracionais. Nesse uso, o nome público não é um detalhe: é a chave de entrada.
Ninguém procura "Jorge Mario Bergoglio".

Um modelo de nome único empurraria o usuário a escolher entre registrar o nome
correto e registrar o nome útil. É a escolha que este trabalho elimina.

## O que entra

Uma tabela `nomes_pessoa`, com **vários nomes por pessoa**, cada um com:

- **tipo** — nascimento, público, religioso, de casada, de solteira, artístico,
  profissional, de imigração, outro
- **prefixo** — D., Dom, Dona, Papa, Madre, Frei, Sir, Dr.
- **nome** e **sobrenome**
- **sufixo** — VI, Jr., Filho, Neto, de Assis
- **período** (opcional) — "a partir de 1816", "1930–1958"
- **nota** (opcional)

E um botão **"usar este na árvore"**, que copia o nome escolhido para o campo de
exibição da pessoa.

### A relação com `pessoas.nome` / `pessoas.sobrenome`

Os campos existentes **continuam sendo o nome de exibição** — o que aparece no
card, na busca e nos relatórios. Não são removidos e nada no layout, na busca ou
no grafo precisa mudar.

`nomes_pessoa` é o registro completo. Para D. João VI:

- exibição: `nome = "D. João VI"`
- `nomes_pessoa`: um registro tipo *público* ("D. João VI") e outro tipo
  *nascimento* com o nome inteiro

Manter os dois é uma duplicação consciente: o preço é um campo copiado, e a
alternativa — derivar a exibição de `nomes_pessoa` a cada consulta — obrigaria a
mexer no grafo da árvore, na busca por nome, nos índices `NOCASE` e na sugestão
de sobrenome. Não vale, por ora.

## Correspondência com o GEDCOM

O GEDCOM admite **várias estruturas `NAME` por indivíduo**, cada uma com um
`TYPE`. É nisso que o modelo se apoia:

| Tipo aqui | `NAME.TYPE` |
|---|---|
| nascimento | `BIRTH` |
| casada | `MARRIED` |
| solteira | `MAIDEN` |
| profissional | `PROFESSIONAL` |
| imigração | `IMMIGRANT` |
| público, religioso, artístico | `AKA` (ou `OTHER` com frase) |

Prefixo e sufixo correspondem a `NPFX` e `NSFX`.

**Ponto a confirmar antes de escrever o exportador:** não tenho certeza de que o
GEDCOM 7.0 permita `DATE` dentro de `NAME` — datas pertencem a eventos na
estrutura do padrão. Se não permitir, o `período` sai como extensão ou vira
nota. Conferir na especificação oficial antes do trabalho de exportação; não é
bloqueio para esta fatia.

## O que fica de fora

- Ordenar automaticamente os nomes por período. O usuário ordena.
- Deduzir o nome de casada a partir da união. Tentador e errado: nem toda
  mulher adotou o sobrenome do marido, e a prática varia por época e região.
- Traduções e transliterações de nome (`TRAN` no GEDCOM).

## Regras

1. **Só o campo `nome` é obrigatório** num registro de nome. Prefixo, sobrenome,
   sufixo, período e nota são todos opcionais — mesma regra transversal da
   seção 2.5.
2. **Apelido continua sendo apelido.** A lista `apelidos_pessoa` não muda de
   sentido nem é absorvida: alcunha e nome são coisas diferentes.
3. **Nenhuma invariante da seção 3 é tocada.** Nome não participa das regras de
   conexão.

## Critérios de aceite

- [ ] Dá para registrar, na mesma pessoa, um nome de nascimento e um nome
      público, e os dois aparecem na ficha com o tipo indicado.
- [ ] "Usar este na árvore" muda o nome do card sem apagar os demais registros.
- [ ] Registro de nome com período em branco é aceito.
- [ ] Prefixo e sufixo compõem a exibição na ordem certa: `D.` + `João` + `VI`.
- [ ] Remover um nome não afeta o nome de exibição da pessoa.
- [ ] `npm run verificar` passa.
