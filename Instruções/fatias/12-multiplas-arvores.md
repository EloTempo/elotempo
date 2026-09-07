# Fatia 12 — Múltiplas árvores nomeadas e conexões entre elas

> Especificada na seção 5 das Instruções Gerais ("Múltiplas árvores e conexões entre elas").

## O que é

No modelo do aplicativo, o banco de dados SQLite é **único** para todo o acervo.
Uma **árvore** é uma **visão nomeada e enraizada** desse grafo familiar (ex.: *"Família Silva"*, *"Linhagem Materna"*, *"Família Imperial"*).

## Princípios da Seção 5

1. **Visão nomeada e enraizada**: Uma árvore possui `id`, `nome`, `descricao`, `raiz_pessoa_id` e carimbos de data.
2. **Sem silos e sem duplicação de pessoas**: A mesma pessoa pode pertencer a múltiplas árvores. Ao criar uma união entre pessoas de árvores diferentes, estabelece-se naturalmente uma ponte entre os ramos.
3. **Exclusão segura**: Deletar uma árvore remove a entrada em `arvores` e seus vínculos de membro em `arvore_membros`, mas **nunca** apaga pessoas, eventos, locais ou documentos da base.
4. **Inicialização suave**: Se o acervo contiver pessoas mas nenhuma árvore registrada, o sistema cria automaticamente a primeira árvore ("Árvore Principal") apontando para a primeira pessoa disponível.

## Comandos do Backend
- `listar_arvores`: Devolve todas as árvores com contagem de pessoas e nome da pessoa raiz.
- `obter_arvore`: Devolve os detalhes de uma árvore por ID.
- `criar_arvore`: Cria nova árvore com nome, descrição opcional e pessoa raiz opcional.
- `atualizar_arvore`: Atualiza metadados (nome, descrição, raiz).
- `deletar_arvore`: Remove a visão nomeada.
- `definir_raiz_arvore`: Define uma pessoa como nova raiz da árvore.

## Critérios de Aceite
- [ ] O usuário pode criar, renomear e excluir árvores nomeadas.
- [ ] A troca de árvore altera a raiz ativa da árvore na tela.
- [ ] Apagar uma árvore preserva integralmente as pessoas cadastradas no banco de dados.
- [ ] É possível definir qualquer pessoa como a raiz da árvore atual através de sua ficha.
