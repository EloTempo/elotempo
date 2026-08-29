# Fatia 03 — Fotos e documentos

> Item 5 do MVP (seção 9). Fatia vertical: dado → domínio → UI.

## Por que esta agora

A foto é o gatilho de memória mais forte que existe. Um card com rosto conta
mais em um segundo do que três campos de texto — e o objetivo declarado do
projeto é ajudar a memória, não catalogar parentesco (seção 1).

Além disso, é o que uma família de fato tem guardado: a certidão de casamento
dos bisavós, o retrato 3x4 do passaporte, a foto do casamento. Hoje esse
material não tem para onde ir.

## Escopo

**Anexar.** Escolher um arquivo do computador e vinculá-lo a uma pessoa. Tipos
aceitos: imagens (JPEG, PNG, WebP, GIF), PDF e texto. Cada anexo pode ter
título e uma data em texto livre.

**Foto principal.** Marcar uma das imagens como o retrato da pessoa. É ela que
aparece no card da árvore e no topo da ficha.

**Ver e remover.** Miniaturas na ficha; clicar abre em tamanho maior. Remover
apaga o vínculo, o registro e o arquivo copiado.

## Onde os arquivos ficam

Copiados para `<pasta de dados do app>/midia/`, com nome gerado (o `id` do
documento mais a extensão original). No banco guarda-se só o **caminho
relativo** — nunca o absoluto.

Três razões:

1. **O acervo continua portátil.** Caminho absoluto quebra ao mudar de máquina
   ou de usuário; relativo sobrevive a uma cópia da pasta inteira.
2. **O arquivo original não é tocado.** O usuário apaga, move ou renomeia o que
   está em Downloads sem quebrar o acervo.
3. **Nome gerado evita colisão** entre duas fotos chamadas `IMG_0001.jpg`.

Nada de BLOB no SQLite: a especificação (seção 4) já decidiu por arquivos em
pasta, e um banco de 4 GB de fotos seria lento para tudo o mais.

## Decisões técnicas

**Seleção do arquivo** via `tauri-plugin-dialog`. A alternativa — `<input
type="file">` no webview — não entrega o caminho real por segurança do
navegador, o que obrigaria a trafegar os bytes da imagem pela ponte IPC
serializados em JSON. Para uma foto de 5 MB isso é lento e desnecessário. Com o
caminho em mãos, o Rust copia o arquivo direto no sistema de arquivos.

**Exibição** via protocolo `asset:` do Tauri, com escopo limitado à pasta de
dados do app. A CSP já prevê `asset:` em `img-src` desde a configuração inicial.
Ler os bytes e devolver base64 seria mais simples de configurar e pior de usar:
cada rolagem da árvore recarregaria megabytes pela IPC.

**Permissão** `dialog:allow-open` apenas. Nada de `fs:` — o frontend nunca toca
o sistema de arquivos; quem copia, lê e apaga é o Rust, dentro da pasta do app.

## O que fica de fora

- Miniaturas geradas (redimensionamento). A imagem é exibida no tamanho que o
  CSS pedir. Se a lentidão aparecer com acervos grandes, vira fatia própria.
- Recorte e rotação.
- Vincular documento a um **evento** — a tabela `documento_vinculos` já suporta
  (coluna `evento_id`), mas a tela desta fatia só vincula a pessoas.
- Transcrição de documentos.
- GEDZip com a pasta de mídia — é da fatia de exportação.

## Regras

1. **Data do documento nunca é obrigatória** — mesma regra transversal.
2. **Remover o documento apaga o arquivo.** Deixar órfão encheria a pasta de
   lixo invisível, do mesmo jeito que os placeholders enchiam o acervo antes da
   fatia de exclusão.
3. **Apagar a pessoa leva os documentos dela.** O `ON DELETE CASCADE` já cuida
   das linhas; o domínio precisa cuidar dos arquivos.
4. **Só a pasta do app.** Nenhum comando aceita caminho de destino vindo do
   frontend.

## Critérios de aceite

- [ ] Anexar uma imagem a uma pessoa e vê-la na ficha.
- [ ] Marcar como foto principal e vê-la no card da árvore.
- [ ] Anexar um PDF: aparece na lista, sem tentar renderizar como imagem.
- [ ] Anexar sem preencher data funciona.
- [ ] Remover um documento tira o arquivo da pasta de mídia.
- [ ] Excluir a pessoa remove os arquivos dela.
- [ ] Fechar e reabrir o app: as imagens continuam aparecendo.
- [ ] `npm run verificar` passa.
