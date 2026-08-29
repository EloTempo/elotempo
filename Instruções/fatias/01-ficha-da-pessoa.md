# Fatia 01 — Ficha da pessoa

> Fatia vertical derivada da especificação principal
> (`instrucoes-projeto-arvore-genealogica.md`). Entrega dado → domínio → UI
> antes de começar a próxima, conforme a seção 11.

## Por que esta agora

O botão **"Detalhes"** aparece em todos os cards da árvore e **não faz nada**.
É a falha mais visível do programa hoje: o usuário clica e não acontece nada.

Por trás disso há uma lacuna maior. O backend já tem os comandos para religião,
escolaridade, profissões, idiomas, apelidos e nacionalidades — os **atributos de
vida em lista** da seção 2.5, que são o item 7 do MVP — e nenhum deles tem tela.
São dados que existem no schema desde a migration 003 e que ninguém consegue
cadastrar.

Isso importa para o objetivo declarado do projeto. Saber que um bisavô nasceu em
1912 diz pouco; saber que ele era ferroviário, católico, falava italiano em casa
e estudou até o quarto ano diz quem ele foi. **É esse tipo de dado que faz
alguém lembrar de uma história para contar** — e é para isso que o programa
existe (seção 1).

## O que entra

**Leitura.** Uma ficha com o registro completo: nome e apelidos, sexo, situação
de vida, eventos (nascimento, batismo, casamento, falecimento, sepultamento),
nacionalidades, religiões, escolaridade, profissões, idiomas e minibiografia.

**Escrita.** Editar os campos básicos da pessoa. Adicionar e remover cada item
das seis listas de atributos. Adicionar, editar e remover eventos de vida.

**Navegação.** Da ficha dá para saltar para pais, cônjuge e filhos — reaproveita
`obter_conexoes_pessoa`, já existente.

## O que fica de fora, e por quê

| Fora | Motivo |
|---|---|
| Fotos e documentos anexos | Exige diálogo de arquivo, pasta de mídia e miniaturas. É fatia própria. |
| Local com autocomplete | Depende do seed do IBGE, que ainda não foi rodado. Por ora o local do evento é texto livre. |
| Fontes e citações | Seção 2.7 manda preparar o modelo, não a tela. As tabelas já existem (migration 007). |

## Regras que a fatia precisa respeitar

Estas não são preferências — são invariantes já estabelecidas:

1. **Data nunca bloqueia o salvamento** (seção 2.5). Vale para eventos e para o
   período dos atributos. O que a pessoa escreve fica intacto em `data_texto`;
   os anos derivados existem só para ordenar.
2. **Tipos de evento são minúsculos e canônicos.** Usar `TIPOS_EVENTO`, nunca
   string solta — já houve o bug de `'Nascimento'` com maiúscula.
3. **Período de atributo é sempre opcional.** Grava-se a entrada só com o valor.
4. **Taxonomias são sugestão, não trava.** As listas da seção 2.5 (religiões,
   níveis de escolaridade) entram como sugestões com texto livre ao lado. Um
   acervo familiar tem casos que nenhuma taxonomia prevê.
5. **Nada de HTML montado por interpolação** com dado do usuário.

## Critérios de aceite

Cada um precisa de evidência objetiva; sem evidência, não está cumprido.

- [ ] Clicar em "Detalhes" num card abre a ficha da pessoa correspondente.
- [ ] A ficha mostra os eventos em ordem cronológica, com o texto original da
      data — não o ano derivado.
- [ ] Dá para adicionar um evento sem preencher data nenhuma.
- [ ] Dá para adicionar e remover item em cada uma das seis listas.
- [ ] Adicionar religião sem período funciona.
- [ ] Editar nome/sexo/minibiografia salva e reflete na árvore.
- [ ] Trocar o sexo de quem ocupa slot de união é recusado com a mensagem do
      domínio (não com erro cru).
- [ ] Nacionalidade lista os países com Brasil e os de imigração no topo.
- [ ] Um evento com data "cerca de 1890" mostra "cerca de 1890" na tela.
- [ ] `npm run verificar` passa.

## Notas de implementação

O protótipo `PersonDetails.tsx` já tem o desenho aprovado da ficha, com dados
fixos. Esta fatia o transforma na tela real: trocar os valores fixos por
`useQuery` sobre `src/lib/api` e apagar o aviso do topo, conforme o CLAUDE.md.

Nenhum comando novo no Rust deve ser necessário — `listar_eventos_pessoa`,
`listar_religioes`, `listar_profissoes`, `listar_idiomas`,
`listar_escolaridade`, `listar_apelidos`, `listar_nacionalidades` e
`listar_paises` já existem e estão registrados.

## Depois desta

A ordem sugerida, sem compromisso:

1. **Fotos e documentos** (item 5 do MVP) — é o que mais ajuda a memória, e a
   ficha já terá o lugar para eles.
2. **Locais com autocomplete** (item 6) — destravado assim que o seed do IBGE
   rodar.
3. **Relatórios em PDF** (item 8) — depende de a ficha estar completa, porque é
   o mesmo conteúdo em outro meio.
