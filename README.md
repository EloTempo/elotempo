# Árvore Genealógica

Software desktop **100% offline** para construir árvores genealógicas
familiares, sem limite de tamanho. Os dados ficam só na sua máquina.

> **Estado: em desenvolvimento inicial (v0.1).** O núcleo funciona — cadastro
> de pessoas, uniões, árvore desenhada com pan/zoom — mas ainda não há
> instalador publicado. Veja [o que já funciona](#o-que-já-funciona).

---

## Por que existe

Programas de genealogia tendem a virar planilhas de parentesco. Este parte de
outra ideia: **ajudar a memória**. Saber que um bisavô nasceu em 1912 diz
pouco; saber que ele tinha 18 anos na Revolução de 30, que ouvia as músicas que
tocavam então e que o dinheiro do bolso dele se chamava réis situa a pessoa
numa vida — e é isso que faz alguém lembrar de uma história para contar.

Daí três compromissos que não se negociam:

- **Local-first** — nada sai da sua máquina sem você mandar. Não há nuvem, não
  há conta, não há telemetria. O programa funciona com o cabo de rede
  arrancado.
- **Você é dono do arquivo** — o acervo é um SQLite na sua pasta de dados.
  Copie, leve para outro computador, guarde num pendrive.
- **Padrão aberto** — o modelo segue o GEDCOM 7.0, para o seu trabalho não
  ficar preso aqui dentro.

## O que já funciona

- Cadastro de pessoas com nascimento, falecimento e o indicador de vivo
- Uniões com filhos, respeitando as regras de parentesco
- **Ancestral desconhecido vira um nó de verdade** — cadastre um filho sabendo
  só o nome da mãe; quando descobrir o nome do pai, edite aquele nó e os filhos
  continuam pendurados nele
- Árvore desenhada em layout vertical clássico, com pan, zoom e zoom semântico
- Busca por nome e sobrenome
- Datas do jeito que a genealogia real exige: `1890`, `cerca de 1890`,
  `antes de 1914`, `1902-1904` — e nenhuma delas é obrigatória
- Quatro temas visuais (clássico e moderno, claro e escuro)

### Ainda não

Uniões pela interface · fotos e documentos · autocomplete de cidades ·
relatórios em PDF · estatísticas · importar/exportar GEDCOM · linhas do tempo
de contexto histórico.

---

## Rodando o projeto

Precisa de [Node.js 20+](https://nodejs.org) e do
[Rust](https://rustup.rs) (com as
[dependências do Tauri](https://tauri.app/start/prerequisites/) para o seu
sistema).

A partir da raiz do projeto:

```bash
npm install
npm run tauri dev
```

Na primeira execução o Rust compila do zero e demora vários minutos. Depois é
rápido.

### Onde ficam os seus dados

O acervo é um arquivo SQLite criado na pasta de dados do seu usuário:

| Sistema | Caminho |
|---|---|
| Windows | `%APPDATA%\com.arvore.genealogica\acervo.sqlite` |
| macOS | `~/Library/Application Support/com.arvore.genealogica/acervo.sqlite` |
| Linux | `~/.local/share/com.arvore.genealogica/acervo.sqlite` |

Fazer backup é copiar esse arquivo. Nada mais.

---

## Contribuindo

Contribuições são bem-vindas. Antes de abrir um PR:

```bash
npm run verificar   # typecheck + testes do frontend + testes do domínio
```

Leia o **[CLAUDE.md](CLAUDE.md)** — ele descreve as invariantes do modelo de
dados, que são a parte do sistema onde um erro corrompe o acervo de alguém em
silêncio. Em particular:

- Uma pessoa é filha de **no máximo uma união**
- A união tem **sempre dois slots**, um masculino e um feminino; slot sem nome
  recebe um placeholder, nunca fica vazio
- Filhos ligam-se à **união**, nunca a um pai ou mãe direto
- Ninguém é ancestral de si mesmo

Elas estão implementadas em `src-tauri/src/domain/regras.rs`, garantidas por
índices no banco, e cobertas por testes. **Mudança em regra de conexão vem com
teste.**

A especificação completa do produto está em
[`Instruções/`](Instru%C3%A7%C3%B5es/instrucoes-projeto-arvore-genealogica.md).

---

## Licença

[MIT](LICENSE) — use, modifique e redistribua à vontade.

As bibliotecas e fontes de terceiros usadas estão listadas, com suas licenças,
em [TERCEIROS.md](TERCEIROS.md). Os dados de municípios vêm da API de
Localidades do IBGE (dados abertos).
