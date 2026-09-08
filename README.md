# Elotempo

Software desktop **100% offline, local-first e de código aberto** para construir árvores genealógicas familiares e explorar a história de vidas através do tempo, sem limite de registros. Os dados ficam exclusivamente na sua máquina.

---

## Por que existe

Programas de genealogia tendem a virar meras planilhas de parentesco. Este software parte de outra ideia: **resgatar e situar a memória humana**. Saber que um antepassado nasceu em 1890 diz pouco; saber que ele tinha 24 anos quando estourou a Primeira Guerra Mundial, que moeda circulava no seu bolso, como a cidade dele se chamava na época e quais parentes viveram contemporaneamente a ele situa a pessoa numa vida real — e é isso que desperta histórias que valem a pena ser contadas.

### Nossos Três Compromissos Fundamentais

- **Local-first e 100% Offline** — Nada sai do seu computador sem o seu consentimento explícito. Não há nuvem obrigatória, não há cadastro, não há rastreamento ou telemetria. O programa funciona perfeitamente mesmo sem conexão à internet.
- **Soberania dos Dados** — O acervo é um banco de dados SQLite salvo localmente na sua pasta de dados. Você pode copiar o arquivo, guardá-lo em pendrive, fazer backups físicos e manter o controle total.
- **Padrão Aberto Universal** — Suporte estrito ao padrão universal **GEDCOM 7.0 e 5.5.1** (incluindo pacotes GEDZip para fotos e mídias), garantindo que seu trabalho nunca fique preso a um formato proprietário.

---

## Principais Funcionalidades

### 🌳 Árvore Genealógica Interativa
- Diagramação hierárquica clara com pan e zoom fluído via mouse, trackpad ou controles.
- **Zoom Semântico**: os cartões adaptam o nível de detalhamento automaticamente de acordo com o nível de aproximação.
- **Tratamento de Ancestrais Desconhecidos**: cadastre um filho conhecendo apenas a mãe; o pai torna-se um nó desconhecido (*placeholder*) que pode ser identificado a qualquer momento sem quebrar os vínculos.
- Vistas auxiliares: Visão Completa (ancestrais e descendentes), Apenas Ascendentes, Apenas Descendentes e tabela **Ahnentafel**.
- Exportação gráfica em alta resolução: gere **pôsteres em PNG ou vetores SVG** para impressão em gráficas.

### ⏱️ Linha do Tempo e Estúdio de Vidas
- **Comparação de Múltiplas Vidas**: adicione parentes ao mesmo eixo cronológico horizontal para visualizar contemporaneidades e intervalos de vida lado a lado.
- **Cálculo Automático de Idades**: visualização da longevidade ao falecer ou idade atual, e idade exata em cada acontecimento (casamento, nascimento de filhos, marcos históricos).
- **Guias Temporais Tracejadas e Crosshair Sincronizado**: grade de fundo para alinhamento e cursor magnético (*Snap*) que atrai o marcador com precisão para anos de nascimento, óbito ou eventos.
- **Painel Flutuante de Sincronia**: acompanhe em tempo real a idade de cada parente e os acontecimentos históricos mundiais de qualquer ano selecionado.
- Camadas temáticas de contexto histórico (Brasil Império/República, moedas, tecnologia e eventos mundiais), além de estúdio para criar suas próprias linhas cronológicas.

### 👥 Conexões Familiares e Ficha Biográfica
- Interface prática para adicionar pais, múltiplos cônjuges e filhos com respeito estrito às regras genealógicas (prevenção de ciclos e casamentos inválidos).
- **Nomes ao Longo da Vida**: suporte a múltiplos nomes (nascimento, religioso, casamento, apelidos e títulos nobres).
- Eventos de vida detalhados: nascimento, batismo, união civil/religiosa, óbito, sepultamento e eventos personalizados com datas qualificadas (*cerca de*, *antes de*, *depois de*, *faixas de anos*).
- Anexação de fotos e documentos históricos com suporte a foto de perfil principal.
- Autocomplete integrado de municípios brasileiros conectado à base oficial do **IBGE**.

### 📄 Central de Impressão e Relatórios (WYSIWYG)
- Visualização de folha real com proporções milimétricas (A4 / A3, Retrato / Paisagem), margens físicas e sombras suaves.
- **Zoom do Preview** (50% a 150%) e botão *Ajustar à Tela*.
- **Navegador de Páginas**: folheie página por página (*Página X de Y*) antes de imprimir ou salvar em PDF.
- Modos flexíveis:
  - *Combinado*: diagrama da árvore seguido das fichas biográficas.
  - *Só Hierarquia*: pôster visual das relações.
  - *Só Texto*: relatório cronológico com quebra por geração e miniaturas.
- Filtros de privacidade integrados: opção de ocultar parentes vivos para preservação de dados confidenciais.

### 🔄 Importação e Exportação GEDCOM
- Importação completa de arquivos `.ged` (v5.5.1 e v7.0) com assistente de resolução de conflitos e conferência passo a passo.
- Exportação nos formatos GEDCOM 7.0 universal e GEDZip (pacote com arquivo de dados e pasta de mídias compactados).

### 🔍 Busca Multicritério, Estatísticas e Ferramentas
- Busca em tempo real por nome e sobrenome, com normalização de acentos e busca fonética/apelidos.
- Filtros avançados por década de nascimento, cidade, país, religião, profissão, escolaridade e condição de vida.
- Painel analítico de estatísticas: distribuição por sexo, longevidade média, pirâmide de gerações e século de maior concentração.
- **Calculadora de Parentesco**: calcula e explica em português claro o grau exato de parentesco entre quaisquer duas pessoas da árvore.
- **Fusão de Pessoas**: ferramenta para unir cadastros duplicados sem perder fotos ou anotações.

### 🌐 Acessibilidade e Multilíngue
- **Internacionalização (i18n)**: alterne instantaneamente entre **Português (`pt-BR`)** e **Inglês (`en-US`)**.
- Quatro temas visuais integrados (Clássico Claro, Clássico Escuro, Moderno Claro, Moderno Escuro).
- Controle global de tamanho de fonte para acessibilidade visual.
- Histórico completo de ações com suporte a Desfazer (*Undo* - `Ctrl+Z`) e Refazer (*Redo* - `Ctrl+Y`).

---

## Onde ficam os seus dados

O seu acervo genealógico é armazenado em formato SQLite na pasta de dados do seu sistema operacional:

| Sistema | Caminho dos Dados |
|---|---|
| **Windows** | `%APPDATA%\com.elotempo.app\acervo.sqlite` |
| **Linux** | `~/.local/share/com.elotempo.app/acervo.sqlite` |
| **macOS** | `~/Library/Application Support/com.elotempo.app/acervo.sqlite` |

As fotos e documentos anexados residem na subpasta `midia/` dentro do mesmo diretório. Fazer backup da sua história consiste simplesmente em copiar esse arquivo e pasta para o seu armazenamento de confiança.

---

## Rodando o Projeto Localmente

### Pré-requisitos
- [Node.js 20+](https://nodejs.org)
- [Rust & Cargo](https://rustup.rs) (com as dependências do [Tauri v2](https://tauri.app/start/prerequisites/))

### Instalação e Desenvolvimento

```bash
# Instalar dependências do frontend
npm install

# Iniciar em modo de desenvolvimento (Vite + Tauri)
npm run tauri dev
```

### Atalho de Execução Rápida (Windows)
Após a primeira compilação, você pode iniciar o aplicativo diretamente dando um duplo clique em **`abrir-arvore.cmd`** ou rodando:
```bash
npm run abrir
```

### Gerando o Instalador de Produção
Para compilar o binário otimizado e gerar os instaladores nativos:
```bash
npm run instalador
```
* No **Windows**: gera instaladores `.msi` e `.exe` (NSIS).
* No **Linux**: gera `.AppImage` (universal) e pacote `.deb`.

---

## Verificação e Qualidade de Código

Para executar a bateria de validações antes de commits ou lançamentos:

```bash
npm run verificar
```
Este comando executa em sequência:
1. `npm run typecheck`: Validação estrita de tipos TypeScript (zero erros).
2. `npm run test`: Suíte de testes unitários do frontend (Vitest).
3. `npm run test:rust`: 240+ testes unitários das regras de domínio e invariantes genealógicas no backend Rust.

---

## Autores e Contribuições

- **Gabriel Nascimento** — Concepção, design, arquitetura e desenvolvimento principal.
- **Gemini 3.8 Flash (Google DeepMind)** — Parceria de engenharia de software e inteligência artificial: auxílio na implementação de regras de domínio genealógico, algoritmos de layout, auditoria de integridade e consistência histórica, testes automatizados e compilação multiplataforma.

---

## Licença

Distribuído sob a licença **[GNU General Public License v3.0 or later (GPL-3.0-or-later)](LICENSE)**.

### Propriedade dos Dados do Usuário
A licença GPL aplica-se estritamente ao código-fonte do software. Todos os dados genealógicos, árvores familiares, biografias, fotografias e documentos cadastrados ou exportados pertencem **exclusiva e privadamente ao usuário**, sem qualquer reivindicação ou ingerência da licença sobre as suas informações familiares.

Copyright (C) 2026 Gabriel Nascimento.
