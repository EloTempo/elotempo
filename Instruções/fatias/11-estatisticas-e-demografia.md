# Fatia 11 — Estatísticas e Demografia da Família

> Especificada na seção 7 das Instruções Gerais ("Pesquisa e estatísticas").

## O que é

Um painel analítico e demográfico sobre as pessoas da árvore genealógica.
As estatísticas cobrem tanto o **acervo total** quanto qualquer **subconjunto filtrado**
pela busca multicritério (*"o filtro alimenta a estatística"*).

## Regras da Especificação (Seção 7)

1. **O filtro alimenta a estatística**: os gráficos refletem o filtro ativo.
   Ex.: filtrar "nascidos na década de 1940" e ver a distribuição de religiões desse recorte específico.
2. **Contagem absoluta sempre junto do percentual**: cada dado exibe formato como *"6 de 12 · 50%"*
   para que o número não engane em amostras pequenas.
3. **Agrupamentos estruturados**:
   - **Década de nascimento**: derivada de `ano_inicio` de eventos de nascimento (agrupada por `(ano / 10) * 10`).
   - **Cidades**: baseada no município estruturado (`locais.codigo_ibge` ou identificador).
   - **Países**: baseada em `nacionalidades_pessoa.pais_id`.
   - **Sobrenome**: linhagens baseadas no sobrenome da pessoa.
   - **Atributos culturais**: religião, profissão, escolaridade, idioma.
   - **Sexo e Situação**: distribuição por gênero (M, F, X, U) e proporção de vivas vs falecidas.
4. **Indicadores Demográficos Globais**:
   - Total de pessoas no recorte.
   - Idade média ao falecer (longevidade), calculada para quem possui ano de nascimento e falecimento registrados.
   - Período histórico coberto (ano do nascimento mais antigo ao mais recente).

## Gráficos
- **Gráfico de Rosca (Donut Chart)**: proporções de categorias (sexo, situação de vida, religiões, países).
- **Gráfico de Barras**: distribuições ordenadas e temporais (décadas de nascimento, top sobrenomes, cidades).
- Construídos em SVG vetorial leve e nítido, perfeitamente integrados às variáveis de tema e modo de impressão.

## Critérios de Aceite
- [ ] O comando de backend calcula as agregações sem filtros e com filtros da busca combinados.
- [ ] A contagem absoluta sempre acompanha o percentual (ex: "X de Y · Z%").
- [ ] O painel de busca permite alternar entre a lista de pessoas e a visualização de estatísticas do resultado.
- [ ] Casos especiais (amostra vazia, pessoas sem data de nascimento) são tratados com clareza visual.
