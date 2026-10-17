# Notas de Lançamento: EloTempo v1.2.0

Data: **17 de outubro de 2026**
Versão: **v1.2.0**
Licença: **GNU General Public License v3.0 ou posterior**
Autor: **Gabriel Nascimento**

---

## 1. O que mudou

**Acervo cifrado com SQLCipher.** O banco deixa de ser um SQLite legível por
qualquer programa e passa a ser aberto por chave (`domain::seguranca::chave_acervo`).
A cifragem agora alcança o arquivo inteiro, não só o cofre.

**Minimapa e localizador na árvore.** Um radar flutuante mostra onde você está
dentro da árvore, e o localizador leva a qualquer membro com foco suave.

**Painel de busca e seletor de árvore ampliados.**

**Refino do layout da árvore**, com testes novos cobrindo os casos corrigidos.

**Semente pública e saneamento estrutural** do acervo canônico.

## 2. Artefato de distribuição

| Arquivo | Tipo | Tamanho | SHA-256 |
| :--- | :---: | :---: | :--- |
| `EloTempo_1.2.0_x64-setup.exe` | Instalador Windows (NSIS) | 5,27 MB | `88a7bb06d10254f9d24d2f8317f0cbd5886c3f3ec48d48c86f72def12b0d3d04` |

O instalador cresceu de 3,6 MB para 5,3 MB porque passa a embarcar a
`libcrypto-4-x64.dll` do OpenSSL, exigida pelo SQLCipher.

**Esta versão sai só para Windows.** O `.msi`, o `.deb` e o `.AppImage` dependem
do release automático, que está quebrado — ver abaixo. Usuários de Linux
continuam na v1.0.3.

## 3. Antes de publicar: o CI não compila esta versão

O `release.yml` roda `npm run verificar` e **não configura OpenSSL no runner do
Windows**. Como a v1.2.0 passou a compilar o SQLCipher a partir do fonte, a
build falha com `Missing environment variable OPENSSL_DIR`. Empurrar a tag
`v1.2.0` hoje produz um release vazio.

Três coisas precisam ser resolvidas antes:

1. **OpenSSL no runner do Windows**, com `OPENSSL_DIR` exportado para o passo
   de testes e para o de build.
2. **`npm run verificar` lê o config errado.** O script chama
   `cargo test --manifest-path src-tauri/Cargo.toml` a partir da raiz, e o cargo
   só lê `src-tauri/.cargo/config.toml` quando é invocado de dentro de
   `src-tauri/`. Enquanto não for corrigido, o comando falha em qualquer máquina
   que dependa daquele arquivo — inclusive nesta.
3. **O resource da DLL não tem condicional de plataforma.** O `tauri.conf.json`
   declara `bin/libcrypto-4-x64.dll` para todos os alvos; no runner do Linux
   esse caminho existe no repositório, mas empacotar uma DLL de Windows num
   `.deb` é lixo no pacote.

Os detalhes do pré-requisito local estão em `DISTRIBUICAO.md`, seção 0.
