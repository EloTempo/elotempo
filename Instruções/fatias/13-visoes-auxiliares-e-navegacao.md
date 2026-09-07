# Fatia 13 — Visões Auxiliares e Navegação Avançada da Árvore

> Especificada nas seções 6, 9 e 10 das Instruções Gerais ("Visões auxiliares de ancestrais e descendentes", "Design / UI" e "Depois do MVP").

## O que é

Permite ao usuário explorar a árvore genealógica com focos direcionados, profundidade controlável, colapso de ramos densos e a visão clássica numerada de ancestrais (**Ahnentafel**).

## Recursos da Fatia

1. **Três Modos de Visão no Canvas**:
   - **Completa (Padrão)**: Ancestrais e descendentes a partir da raiz.
   - **Só Ancestrais**: Foco vertical estrito nos progenitores (pais, avós, bisavós...).
   - **Só Descendentes**: Foco vertical estrito nos filhos, netos e bisnetos.
2. **Controle Dinâmico de Gerações**:
   - Botões `−` e `+` para ajustar a quantidade de gerações buscadas no backend (de 2 a 12 gerações).
3. **Colapsar / Expandir Ramos**:
   - Interação rápida em nós de união para recolher os descendentes.
   - O layout recalcula a largura e os nós filhos ocultos exibem uma badge sutil `[+ N]`.
4. **Barra Flutuante de Ferramentas (Tree Toolbar)**:
   - Seletor de visão: Completa, Só Ancestrais, Só Descendentes.
   - Controle de profundidade de gerações.
   - Controles de Pan/Zoom imperativos: Zoom In (`+`), Zoom Out (`−`), Ajustar à Tela (Fit), Centralizar na Raiz.
5. **Visão Auxiliar Ahnentafel (Sosa-Stradonitz)**:
   - Tabela/lista genealógica universal numerada:
     - 1 = Pessoa raiz
     - 2 = Pai (1 × 2)
     - 3 = Mãe (1 × 2 + 1)
     - 4 = Avô paterno (2 × 2)
     - 5 = Avó paterna (2 × 2 + 1)
     - 6 = Avô materno (3 × 2)
     - 7 = Avó materna (3 × 2 + 1)
   - Agrupada por geração (Geração I, II, III, IV...).
   - Permite navegar para a ficha ou definir como raiz.

## Critérios de Aceite
- [ ] O usuário pode alternar instantaneamente entre Árvore Completa, Só Ancestrais e Só Descendentes.
- [ ] O controle de gerações expande e contrai o nível de profundidade histórico.
- [ ] É possível colapsar e reexpandir qualquer união com filhos no canvas.
- [ ] A barra flutuante permite zoom in, zoom out, fit e recentralização da raiz.
- [ ] O modal Ahnentafel lista os antepassados na numeração genealógica canônica de Sosa-Stradonitz.
