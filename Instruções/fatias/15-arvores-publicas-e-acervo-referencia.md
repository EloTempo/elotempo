# Fatia 15 — Árvores Públicas de Referência, Filtro "Meus Registros" vs "Públicos" e Ajuste de Espaço

## Contexto e Objetivo
Para enriquecer a experiência dos usuários, permitir cruzamento de dados e oferecer árvores canônicas conhecidas para aprendizado e comparação de linhagens (como a Família Real Brasileira, Presidentes da República e monarcas bíblicos da Antiguidade), o acervo passa a distinguir dados pessoais do usuário de dados de referência histórica pública.

Além disso, a largura do painel lateral de busca e estatísticas foi ampliada para `w-96` (384px) e o layout dos cartões de KPIs e gráficos foi reorganizado para respirar sem corte ou achatamento em resoluções padrão.

---

## O que foi construído

### 1. Migração e Modelo de Dados
- Coluna `is_publico BOOLEAN NOT NULL DEFAULT 0` adicionada a `pessoas` e `arvores` (`018__arvores_publicas_e_referencia.sql`).
- Limpeza dos registros soltos de teste prévios.
- Módulo `src-tauri/src/domain/semente_publica.rs` com carga histórica canônica:
  - **Família Imperial do Brasil**: 16 pessoas, 4 casamentos, 11 filhos, datas reais de 1767 a 1940 (D. João VI, Carlota Joaquina, D. Pedro I, Leopoldina, D. Pedro II, Teresa Cristina, Princesa Isabel, Conde d'Eu e descendência).
  - **Presidentes Históricos do Brasil**: Deodoro da Fonseca, Getúlio Vargas e Juscelino Kubitschek com pais, primeiras-damas e filhos.
  - **Linhagem Bíblica de David**: 11 pessoas conectadas desde Jessé até o Rei Asa, com datas em anos negativos formatadas como antes de Cristo (`a.C.`).
- Árvores de referência semeadas:
  - `arv_imperial_brasil`: *Família Imperial do Brasil* (raiz: Dom Pedro II).
  - `arv_presidentes_brasil`: *Presidentes do Brasil* (raiz: Getúlio Vargas).
  - `arv_biblica_david`: *Linhagem Bíblica de David* (raiz: Rei David).
- Proteção de exclusão: árvores públicas de referência não podem ser deletadas pelo usuário.

### 2. Backend Rust e Consultas Filtradas
- `FiltrosBuscaDto` com campo `origem: Option<String>` (`'todos'` | `'meus'` | `'publicos'`).
- `montar_condicoes`: aplica `p.is_publico = 0` para `'meus'` e `p.is_publico = 1` para `'publicos'`.
- `calcular_estatisticas`: agrega automaticamente segundo o filtro de origem.
- Teste unitário aprovado: `filtra_por_origem_meus_e_publicos`.

### 3. Ajuste de Layout no Painel Lateral
- Em `App.tsx`, o painel lateral foi expandido para `w-96` (384px), proporcionando quase 100px a mais de largura útil.
- Em `PainelEstatisticas.tsx`:
  - Cartões de KPIs agora utilizam `grid-cols-2` espaçoso com tipografia proporcional.
  - O cartão de "Período Histórico" ocupa a largura total inferior (`col-span-2`), permitindo datas compostas e intervalos sem corte.
  - Gráficos de rosca (Sexo e Situação de Vida) agora empilham verticalmente em `flex flex-col gap-3.5`, mantendo seus 150px confortavelmente dentro do card.
  - Sub-abas compactas com ícones e rótulos concisos.

### 4. Interface de Busca e Seleção
- No topo de `PainelBusca.tsx`: seletor de segmento `[ Todos | Meus registros | 🏛️ Públicos ]`.
- Badges sutis nas pessoas de referência: `Público` com fundo bordô/acento sutil.
- Formatação de anos com suporte a datas antes de Cristo (ex.: `n. 1040 a.C.`).
- No `SeletorDeArvore.tsx`: divisão das árvores em seções **"Minhas Árvores"** e **"🏛️ Referência Histórica"**.
- No `ModalGerenciarArvores.tsx`: destaque para árvores públicas e proteção contra exclusão.
