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

## 2. Artefatos de distribuição

Checksums dos arquivos **publicados no release**, conforme a API do GitHub:

| Arquivo | Tipo | Tamanho | SHA-256 |
| :--- | :---: | ---: | :--- |
| `EloTempo_1.2.0_x64-setup.exe` | Windows (NSIS) | 5.062.997 | `9bacc731e2584401fbdd93082a92edd90a64a59ca61fd0c58c4e63112a41882d` |
| `EloTempo_1.2.0_x64_pt-BR.msi` | Windows (WiX) | 6.336.512 | `aff93f9442a582bfab10f0934dea5d47eadb1e33377d87daf1c30e70a4df8215` |
| `EloTempo_1.2.0_amd64.deb` | Debian/Ubuntu | 6.210.318 | `6eed39910793f267874c11d66e89150675629a1f7b307ac84e83545e4dae3a20` |
| `EloTempo_1.2.0_amd64.AppImage` | Linux portátil | 84.253.176 | `2dd5cfdf7aa4facee04f8994683181a88367afcdb7eb88f2048b54b72f72a057` |

O instalador do Windows cresceu de 3,6 MB para 4,8 MB: o OpenSSL exigido pelo
SQLCipher agora é compilado junto e linkado estaticamente dentro do executável.
Nenhuma biblioteca acompanha os pacotes — conferido com `dumpbin` no Windows e
com `objdump -p` no Linux, mais varredura dentro do instalador e do `.deb`.

> **Os binários do release vêm do runner, não de compilação local.** Uma build
> local da mesma árvore produz um arquivo de tamanho próximo mas com checksum
> diferente, porque a versão exata do toolchain difere. Confira sempre contra a
> tabela acima, que é a do arquivo que as pessoas baixam.

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
