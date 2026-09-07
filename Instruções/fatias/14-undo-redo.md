# Fatia 14 — Sistema de Desfazer/Refazer (Undo/Redo) e Histórico de Ações

> Especificada na seção 9 e 10 das Instruções Gerais ("Depois do MVP" e "Design / UI").

## O que é

Permite desfazer (`Ctrl+Z`) e refazer (`Ctrl+Y` / `Ctrl+Shift+Z`) as operações de alteração genealógica (criação/edição de pessoas, uniões, vínculos de filhos e eventos), além de inspecionar a trilha cronológica das ações da sessão atual.

## Princípios de Projeto

1. **Atômico e Reversível**: Cada operação que altera dados registra sua contrapartida reversa exata.
2. **Preservação de Identidade**: Ao restaurar uma pessoa ou união previamente desfeita, seu `id` UUID original é preservado, mantendo a integridade de todas as referências no grafo.
3. **Respeito à Digitação Nativa**: Se o foco estiver dentro de campos de formulário (`<input>`, `<textarea>`), o atalho nativo de desfazer texto do navegador não é interceptado. Fora de campos de edição, o atalho aciona o histórico genealógico.
4. **Transparência para o Usuário**: Botões no cabeçalho exibem tooltips descritivos (*"Desfazer: Criou Joaquim Silva"*), e um aviso flutuante (*toast*) confirma cada ação executada.

## Comandos do Backend
- `restaurar_pessoa`: Recria ou restaura uma pessoa com ID fixo prévio e todos os seus campos.
- `restaurar_uniao`: Recria uma união com ID fixo prévio e os mesmos parceiros.

## Critérios de Aceite
- [ ] O usuário pode desfazer e refazer a criação e a edição de pessoas via botões e atalhos de teclado.
- [ ] O usuário pode desfazer e refazer o vínculo e desvínculo de filhos em uniões.
- [ ] As pilhas de Undo e Redo mantêm a consistência e respeitam o limite máximo de ações.
- [ ] Um modal ou menu lista as ações executadas na sessão.
