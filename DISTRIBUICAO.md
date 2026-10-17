# EloTempo — Guia de Geração e Distribuição de Instaladores

Este guia orienta como compilar e distribuir os instaladores oficiais do **EloTempo** para **Windows (`.exe` / `.msi`)** e **Linux (`.deb` / `.AppImage`)**.

---

## 0. Pre-requisito desde a v1.2.0: Perl no Windows

O banco passou a ser cifrado com **SQLCipher**, e o OpenSSL de que ele depende e
**compilado junto, a partir do fonte** (feature `bundled-sqlcipher-vendored-openssl`).
Isso dispensa OpenSSL instalado e dispensa a variavel `OPENSSL_DIR` -- de proposito,
porque o runner do Windows no CI tem OpenSSL mas nao exporta essa variavel.

O que o OpenSSL exige para se configurar e um **Perl nativo de Windows**:

- **Strawberry Perl** (`winget install StrawberryPerl.StrawberryPerl`).
- O perl que vem com o Git for Windows **nao serve**: ele e MSYS e falta o
  modulo `Locale::Maketext::Simple`, o que faz o `./Configure` abortar.
- **NASM nao e necessario**: o `openssl-src` configura com `no-asm`.

O runner `windows-latest` ja traz Perl 5.32 instalado, entao o CI nao precisa de
passo extra.

> A primeira compilacao fica bem mais lenta, porque constroi o OpenSSL inteiro
> (cerca de 10 minutos em perfil debug). Depois disso o cargo reaproveita.

### A opcao do parser do SQLite

O arquivo **`/.cargo/config.toml`**, na raiz do repositorio, define:

```toml
[env]
LIBSQLITE3_FLAGS = "-DYYSTACKDEPTH=500"
```

**Nao apague nem mova.** A expressao que normaliza acento na busca gera um
encadeamento longo de `replace()`, e com o `YYSTACKDEPTH` padrao o SQLite
responde `parser stack overflow` -- 9 testes de busca e estatisticas falham.

Ele fica na **raiz** porque o cargo procura o config subindo a partir do
diretorio de onde foi chamado: `npm run verificar` invoca o cargo com
`--manifest-path` a partir da raiz, e um config dentro de `src-tauri/` nao
seria lido nesse caso.

---

## 1. Compilação Local no Windows

Como o seu ambiente atual é Windows com Node.js, Rust (MSVC) e WebView2 já configurados, você pode gerar os instaladores de Windows diretamente pelo terminal.

### Comandos Disponíveis:

```powershell
# 1. Gera ambos os instaladores de Windows (NSIS .exe e WiX .msi)
npm run instalador

# 2. Gera apenas o instalador padrão (.exe assistido NSIS)
npm run instalador:nsis

# 3. Gera apenas o instalador corporativo (.msi)
npm run instalador:msi
```

### Onde os arquivos gerados são salvos:
Após o término do build, os instaladores finais ficam disponíveis em:
- **Instalador Executável NSIS:**  
  `src-tauri/target/release/bundle/nsis/EloTempo_1.0.3_x64-setup.exe`
- **Pacote Windows Installer MSI:**  
  `src-tauri/target/release/bundle/msi/EloTempo_1.0.3_x64_pt-BR.msi`

---

## 2. Geração Multiplataforma Automatizada (Windows + Linux na Nuvem)

Para compilar pacotes nativos de **Linux (`.deb` e `.AppImage`)** com as bibliotecas nativas de sistema (`webkit2gtk`, `gtk-3`), o projeto já conta com o fluxo de CI/CD automatizado no GitHub Actions:
[`.github/workflows/release.yml`](file:///.github/workflows/release.yml).

### Como disparar uma nova versão:

#### Opção A: Criando uma Tag Git (Recomendado)
Sempre que você criar uma nova tag de versão e enviá-la ao repositório GitHub:
```bash
git tag v1.0.3
git push origin v1.0.3
```
O GitHub Actions iniciará automaticamente duas máquinas virtuais em paralelo:
1. **Windows Runner (`windows-latest`):** Compila o `.exe` (NSIS) e o `.msi`.
2. **Ubuntu Runner (`ubuntu-22.04`):** Instala as dependências GTK/WebKit e compila o `.deb` e o `.AppImage`.

Ao finalizar, um **Release Público** é criado automaticamente no GitHub com os 4 instaladores anexados para download direto.

#### Opção B: Disparo Manual pela Interface do GitHub
1. Acesse a aba **Actions** no repositório GitHub.
2. Selecione o workflow **Release Multiplataforma (EloTempo)**.
3. Clique em **Run workflow**, digite a versão desejada (ex: `v1.0.3`) e confirme.

---

## 3. Compilação Local de Linux via Docker / WSL2

Se preferir gerar os binários Linux (`.deb` / `.AppImage`) localmente na sua máquina sem usar o GitHub:

1. Abra o **WSL2** (Ubuntu) ou um contêiner Docker:
```bash
# Instale as dependências essenciais do Tauri v2 no Linux
sudo apt-get update && sudo apt-get install -y \
  libwebkit2gtk-4.1-dev \
  libappindicator3-dev \
  librsvg2-dev \
  patchelf \
  libssl-dev \
  libgtk-3-dev \
  build-essential \
  curl wget file

# Instale Node e Rust caso ainda não tenha no WSL
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Instale dependências e compile os pacotes Linux
npm install
npx tauri build -b deb,appimage
```

Os arquivos serão gerados em:
- `src-tauri/target/release/bundle/deb/elotempo_1.0.3_amd64.deb`
- `src-tauri/target/release/bundle/appimage/elotempo_1.0.3_amd64.AppImage`

---

## 4. Como o Usuário Final Instala

### No Windows:
- **`EloTempo_1.0.3_x64-setup.exe`:**  
  O usuário clica duas vezes. O instalador assistido em português cria o atalho no Menu Iniciar e na Área de Trabalho. Não requer permissões de administrador (instalação per-user no perfil do usuário).
- **Associação de Arquivos:**  
  Ao dar dois cliques em qualquer arquivo `.ged` (GEDCOM), o sistema operacional já reconhece e oferece abrir com o EloTempo.

### No Linux:
- **Distribuições baseadas em Debian (Ubuntu, Mint, Pop!_OS):**
  ```bash
  sudo dpkg -i elotempo_1.0.3_amd64.deb
  # ou clique duplo pela interface gráfica da loja de aplicativos
  ```
- **Qualquer Distribuição Linux (AppImage portátil universal):**
  ```bash
  chmod +x elotempo_1.0.3_amd64.AppImage
  ./elotempo_1.0.3_amd64.AppImage
  ```
  *Não precisa de instalação nem de permissões de root.*
