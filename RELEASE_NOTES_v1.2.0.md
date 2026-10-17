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
| `EloTempo_1.2.0_x64-setup.exe` | Instalador Windows (NSIS) | 4,82 MB | `e0fc2e37107d06f26ce0daa78d5d94b365721a971c14bb848a128908301bf0dd` |

O instalador cresceu de 3,6 MB para 4,8 MB: o OpenSSL exigido pelo SQLCipher
agora é compilado junto e linkado estaticamente dentro do executável, que subiu
para 14,1 MB. Nenhuma DLL acompanha o pacote — conferido com `dumpbin` no
executável e por varredura no próprio instalador.

## 3. Correções de build que esta versão traz junto

A cifragem quebrou o release automático de duas formas, e as duas estão
resolvidas neste mesmo lote:

1. **OpenSSL.** A feature passou para `bundled-sqlcipher-vendored-openssl`, que
   compila o OpenSSL do fonte. Antes exigia OpenSSL instalado e `OPENSSL_DIR`
   apontando para ele — variável que o runner do Windows não exporta.
2. **Pilha do parser do SQLite.** A expressão que normaliza acento na busca
   estourava o `YYSTACKDEPTH` padrão. A opção foi para `/.cargo/config.toml`,
   agora versionado; antes vivia só num arquivo local que o CI nunca teve.

Verificado nas condições do runner — sem `OPENSSL_DIR` e sem config local:
typecheck limpo, 180 testes de TypeScript e 261 de Rust passando, entre eles
`validar_criptografia_real_sqlcipher` e
`migra_sqlite_texto_claro_para_sqlcipher_sem_perder_dados`.

O pré-requisito local agora é **Perl nativo de Windows** (Strawberry), detalhado
na seção 0 do `DISTRIBUICAO.md`.
