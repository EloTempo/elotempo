# Componentes de terceiros

Este programa é distribuído como binário e inclui software e fontes de
terceiros. Todos rodam offline e têm licença permissiva — os dois critérios que
a especificação (seção 4) exige antes de adotar qualquer dependência.

Ao adicionar uma dependência nova, registre-a aqui.

---

## Fontes embarcadas

As quatro famílias são empacotadas dentro do binário via
[Fontsource](https://fontsource.org). Antes eram carregadas do Google Fonts em
tempo de execução, o que contradizia o compromisso de funcionamento offline.

Todas estão sob a **SIL Open Font License 1.1**, que permite embarcar e
redistribuir junto de um programa, inclusive comercialmente. O texto completo
de cada licença acompanha o respectivo pacote em `node_modules/@fontsource/*/LICENSE`.

| Fonte | Autoria | Licença |
|---|---|---|
| Libre Baskerville | Impallari Type | OFL-1.1 |
| Source Serif 4 | Adobe / Google Inc. | OFL-1.1 |
| IBM Plex Sans | IBM Corp. | OFL-1.1 |
| IBM Plex Mono | IBM Corp. | OFL-1.1 |

Só o subconjunto `latin` é embarcado — cobre todo o português e mantém o
instalador enxuto (~380 KB no total).

---

## Bibliotecas do frontend

| Pacote | Uso | Licença |
|---|---|---|
| react, react-dom | Interface | MIT |
| @tanstack/react-query | Estado assíncrono e cache | MIT |
| d3 | Pan e zoom do canvas da árvore | ISC |
| lucide-react | Ícones | ISC |
| clsx, tailwind-merge | Composição de classes CSS | MIT |
| tailwindcss, postcss, autoprefixer | Estilo | MIT |
| vite, @vitejs/plugin-react | Build | MIT |
| typescript | Tipos | Apache-2.0 |
| vitest | Testes | MIT |
| @tauri-apps/api, @tauri-apps/cli | Ponte com o backend | Apache-2.0 OR MIT |

O **layout da árvore não usa biblioteca**: está em `src/lib/tree/layout.ts`. É
uma das partes que a especificação classifica como diferencial, a ser
construída sob medida em vez de comprada.

---

## Bibliotecas do backend

| Crate | Uso | Licença |
|---|---|---|
| tauri, tauri-build | Runtime desktop | Apache-2.0 OR MIT |
| sqlx | Acesso ao SQLite | Apache-2.0 OR MIT |
| serde, serde_json | Serialização | Apache-2.0 OR MIT |
| tokio | Runtime assíncrono | MIT |
| uuid | Geração de identificadores | Apache-2.0 OR MIT |

O SQLite em si é **domínio público**.

Para a lista completa e recursiva das dependências Rust, incluindo transitivas:

```bash
cargo tree --manifest-path src-tauri/Cargo.toml
```

---

## Dados

**Municípios brasileiros** — API de Localidades do
[IBGE](https://servicodados.ibge.gov.br/api/docs/localidades), dados abertos do
governo brasileiro. Baixados uma vez por `npm run seed:ibge`, convertidos em
migration SQL e versionados no repositório; o programa nunca consulta a API em
tempo de execução.

**Países** — lista escrita à mão em `src-tauri/migrations/008__seed_paises.sql`,
com códigos ISO 3166-1. A ordem de destaque privilegia os países de imigração
mais comuns no Brasil, conforme a seção 2.4 da especificação.

---

## Sobre o formato GEDCOM

O modelo de dados segue o **GEDCOM 7.0**, especificação aberta mantida pela
FamilySearch. Seguir o padrão é decisão de interoperabilidade — não há código
de terceiros envolvido nisso, e nenhuma obrigação de licença decorre daí.
