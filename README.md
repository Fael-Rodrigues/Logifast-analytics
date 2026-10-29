# 🚚 LogiFast — Análise de Performance Logística com SQL e Power BI

![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen)
![MySQL](https://img.shields.io/badge/Banco_de_Dados-MySQL-blue)
![SQL](https://img.shields.io/badge/Linguagem-SQL-blue)
![Power BI](https://img.shields.io/badge/Business_Intelligence-Power_BI-yellow)
![Domínio](https://img.shields.io/badge/Dom%C3%ADnio-Log%C3%ADstica%20%26%20Supply%20Chain-orange)

## 📌 Sobre o Projeto

A **LogiFast** é uma empresa fictícia de logística utilizada como contexto para este projeto de análise de dados.

O objetivo foi avaliar o desempenho das entregas, identificar gargalos operacionais, medir a severidade dos atrasos e transformar os resultados em informações úteis para apoiar a tomada de decisão.

O projeto foi desenvolvido de ponta a ponta, desde a estruturação dos dados e consultas SQL até a criação de um dashboard executivo interativo no Power BI.

**Problema de negócio:** como identificar onde os atrasos logísticos se concentram, compreender sua gravidade e priorizar investigações que possam melhorar o nível de serviço?

### 🎯 Objetivos

- Medir o volume de pedidos e a taxa de atraso.
- Comparar o desempenho por grupo/equipe, canal e cidade.
- Analisar a evolução mensal dos atrasos.
- Avaliar a diferença entre lead time previsto e real.
- Identificar segmentos com maior frequência e severidade de atrasos.
- Construir um dashboard interativo para apoiar decisões operacionais.
- Propor recomendações com base nos resultados encontrados.

---

## 🌐 Dashboard Interativo — Power BI

### 👉 [ACESSE AQUI O DASHBOARD ONLINE](https://app.powerbi.com/view?r=eyJrIjoiNjgxZmRlYWEtMGZhNy00YmJkLTk0ODktYjZiZThmZmZkY2E4IiwidCI6ImVhYmU2NGM1LTY4ZjUtNGE3Ni04MzAxLTk1NzdhNjc5ZTQ0OSIsImMiOjR9)

O relatório foi publicado online para permitir a exploração dos indicadores e das análises de desempenho logístico.

O dashboard contém quatro páginas:

1. **Visão Geral da Operação:** indicadores gerais, distribuição por status e evolução da taxa de atraso.
2. **Matriz de Gargalos e Risco:** detalhamento de atrasos por grupo/equipe e cidade.
3. **Severidade dos Atrasos e Lead Time:** duração dos atrasos e comparação entre prazos previstos e reais.
4. **Recomendações: Onde Agir Primeiro:** síntese dos principais achados e prioridades de investigação.

Utilize os filtros disponíveis para explorar os indicadores por período e segmento.

---

## 📊 Principais Indicadores

| Indicador | Resultado |
|---|---:|
| Total de pedidos analisados | **53.656** |
| Pedidos atrasados | **6.942** |
| Taxa geral de atraso | **12,94%** |
| Pedidos antecipados | 37.968 |
| Pedidos entregues no prazo | 8.746 |
| Lead time previsto médio | 3,96 dias |
| Lead time real médio | 2,84 dias |
| Desvio médio do lead time (real − previsto) | -1,12 dias |
| Atraso médio entre pedidos atrasados | 2,07 dias |
| Maior atraso identificado | 20 dias |

### 🔎 Principais descobertas

- **Internet:** maior taxa de atraso entre os grupos comparados, com **27,42%**, equivalente a 1.598 pedidos atrasados em 5.828.
- **Norte:** maior volume absoluto de atrasos, com **1.838 pedidos**.
- **Sul:** maior atraso médio entre os grupos comparados, aproximadamente **2,41 dias** por pedido atrasado.
- **Cidade 68:** taxa de atraso de **53,49%**, com 276 atrasos em 516 pedidos.
- **Cidade 137:** taxa de atraso de **24,60%**, com 216 atrasos em 878 pedidos.
- **Canal07:** maior volume de atrasos entre os canais identificados, com 1.978 pedidos atrasados e taxa de 21,66%.
- **Novembro de 2019:** taxa mensal de atraso de 19,86%.
- **Dezembro de 2019:** taxa mensal de atraso de 18,38%.
- **Abril de 2020:** taxa mensal de atraso de 19,11%.

Esses resultados indicam onde priorizar investigações, mas não comprovam isoladamente as causas operacionais dos atrasos.

---

## 🗃️ 1. Modelagem e Preparação dos Dados — SQL

A base operacional foi estruturada em um modelo dimensional com uma tabela fato e quatro tabelas dimensão.

### 📐 Estrutura das tabelas

| Tabela | Descrição |
|---|---|
| `fato_pedidos` | Registros dos pedidos, datas, status e chaves estrangeiras |
| `dim_cliente` | Identificadores e nomes dos clientes |
| `dim_vendedor` | Identificadores de vendedores e grupos/equipes |
| `dim_cidade` | Identificadores das cidades |
| `dim_canal` | Canais de entrega |

### 🛠️ View analítica

Foi criada a view `vw_pedidos_completos` para combinar os dados da tabela fato com as dimensões, facilitando a execução das consultas analíticas.

Entre os cálculos utilizados estão:

- **Lead Time Previsto:** diferença entre a data do pedido e a data prevista de entrega.
- **Lead Time Real:** diferença entre a data do pedido e a data de entrega realizada.
- **Desvio de Entrega:** diferença entre a data de entrega realizada e a data prevista.
- **Atributos temporais:** informações de período utilizadas nas análises, conforme as consultas desenvolvidas.

### Técnicas SQL aplicadas

- `JOIN` para combinar informações de diferentes tabelas.
- `GROUP BY` e funções de agregação para calcular indicadores.
- `CASE WHEN` para classificação e análise condicional.
- `DATEDIFF` para calcular intervalos entre datas.
- Filtros e ordenação para investigar os segmentos mais críticos.
- Views para reutilização da lógica analítica.

### 📄 Scripts SQL

- [01 — Criação do banco, modelagem e ETL](SQL/01_criacao_e_etl.sql)
- [02 — Perguntas de negócio e consultas analíticas](SQL/02_perguntas_de_negocio.sql)

---

## 🔍 2. Análise Exploratória e Perguntas de Negócio

As consultas SQL foram utilizadas para investigar o nível de serviço, a distribuição dos pedidos, os atrasos por grupo e canal, os gargalos geográficos, a evolução temporal e a severidade dos atrasos.

Abaixo estão as principais perguntas e respostas obtidas na análise.

### 1. Qual é o volume total de pedidos analisados?

**Resposta:** foram analisados **53.656 pedidos**.

Esse volume estabelece a dimensão da operação e serve de base para os demais indicadores.

### 2. Quantos pedidos foram classificados como atrasados?

**Resposta:** **6.942 pedidos**.

A quantidade absoluta permite dimensionar o impacto operacional dos atrasos.

### 3. Qual é a taxa geral de atraso?

**Resposta:** **12,94%** dos pedidos foram classificados como atrasados.

O indicador permite acompanhar o desempenho global e comparar períodos e segmentos.

### 4. Como os pedidos se distribuem por status?

| Status | Quantidade |
|---|---:|
| Antecipado | 37.968 |
| No Prazo | 8.746 |
| Atrasado | 6.942 |

A maioria dos pedidos foi registrada como antecipada. Entretanto, o percentual de atrasos continua relevante e precisa ser acompanhado por segmento.

### 5. Qual é o lead time médio previsto?

**Resposta:** aproximadamente **3,96 dias** entre a realização do pedido e a data prevista de entrega.

### 6. Qual é o lead time médio real?

**Resposta:** aproximadamente **2,84 dias** entre a realização do pedido e a entrega efetiva.

### 7. Qual é a diferença entre o lead time previsto e o real?

**Resposta:** o desvio médio entre o lead time real e o previsto foi de aproximadamente **-1,12 dias**.

Isso indica que, na média global, as entregas ocorreram antes do prazo previsto. A média, porém, não elimina a existência de pedidos atrasados nem identifica sozinha as causas desses casos.

### 8. Qual grupo apresenta a maior taxa de atraso?

**Resposta:** o grupo/canal **Internet**, com taxa de **27,42%** — 1.598 pedidos atrasados em 5.828.

Esse resultado indica a necessidade de investigar o fluxo de pedidos desse segmento.

### 9. Qual grupo concentra o maior volume absoluto de atrasos?

**Resposta:** **Norte**, com **1.838 pedidos atrasados**.

O volume absoluto ajuda a dimensionar o impacto operacional, enquanto a taxa de atraso permite comparar o desempenho proporcional entre grupos.

### 10. Qual grupo apresenta atrasos mais severos?

**Resposta:** **Sul**, com atraso médio de aproximadamente **2,41 dias** entre os pedidos atrasados.

Televendas apresentou aproximadamente 2,38 dias e Internet, 2,15 dias.

Esses resultados sugerem investigar diferenças nos processos e fluxos operacionais, sem presumir que uma causa específica tenha sido comprovada.

### 11. Qual foi o maior atraso identificado?

**Resposta:** **20 dias**.

Esse valor destaca a existência de casos extremos que podem ficar ocultos quando a análise considera somente médias.

### 12. Quais cidades merecem investigação?

Entre os resultados identificados:

| Cidade | Pedidos | Pedidos atrasados | Taxa de atraso |
|---|---:|---:|---:|
| 68 | 516 | 276 | 53,49% |
| 137 | 878 | 216 | 24,60% |

Essas cidades devem ser investigadas em conjunto com o volume de pedidos e outros fatores operacionais. Como a dimensão de cidades contém somente identificadores, não foi possível associar diretamente os resultados aos nomes dos municípios ou estados.

### 13. Quais combinações de grupo e cidade apresentam taxas críticas?

Entre as combinações destacadas nas consultas:

| Grupo | Cidade | Pedidos | Atrasados | Taxa de atraso |
|---|---:|---:|---:|---:|
| Internet | 131 | 148 | 145 | 97,97% |
| Internet | 118 | 183 | 174 | 95,08% |
| Norte | 88 | 361 | 214 | 59,28% |

Essas combinações são alertas para investigação. Taxas muito elevadas precisam ser analisadas junto ao volume absoluto e à qualidade dos registros.

### 14. Quais canais apresentam maior volume de pedidos?

Os canais com maior volume foram:

- **Canal07:** 9.132 pedidos.
- **Canal12:** 9.086 pedidos.
- **Canal11:** 8.091 pedidos.
- **Canal18:** 6.899 pedidos.
- **Canal19:** 6.268 pedidos.

Esses canais representam uma parcela importante do volume total analisado.

### 15. Quais canais apresentam maior taxa de atraso?

Entre os resultados das consultas:

- **Canal13:** 68,60%, com 59 atrasos em 86 pedidos.
- **Canal02:** 54,55%, com 6 atrasos em 11 pedidos.
- **Canal10:** 34,09%, com 15 atrasos em 44 pedidos.
- **Canal20:** 30,61%, com 15 atrasos em 49 pedidos.
- **Canal16:** 26,45%, com 137 atrasos em 518 pedidos.

Os canais com poucos pedidos exigem cautela: taxas elevadas em amostras pequenas podem não representar um padrão estável.

### 16. Qual canal apresenta o maior volume absoluto de atrasos?

**Resposta:** Canal07, com **1.978 pedidos atrasados**, correspondendo a uma taxa de atraso de **21,66%**.

Por ter volume expressivo e uma taxa relevante, o canal é um candidato para investigação operacional.

### 17. Quais períodos apresentaram as maiores taxas de atraso?

Os principais períodos destacados foram:

- Novembro de 2019: **19,86%**.
- Dezembro de 2019: **18,38%**.
- Abril de 2020: **19,11%**.

Recomenda-se verificar mudanças de demanda, capacidade operacional, sazonalidade e completude dos registros nesses períodos.

### 18. Quais ações devem ser priorizadas pela gestão?

Com base nos resultados, as principais prioridades são:

1. Investigar o grupo/canal Internet, que apresentou taxa de atraso de 27,42%.
2. Analisar o grupo Norte pelo maior volume absoluto de atrasos.
3. Investigar o grupo Sul pela maior duração média dos atrasos.
4. Avaliar as cidades e combinações de grupo/cidade com taxas críticas.
5. Investigar os picos mensais identificados.
6. Validar os canais sem atrasos registrados antes de usá-los como referência.
7. Enriquecer a dimensão de cidades com nome do município, estado e região.

Essas recomendações representam prioridades de investigação e melhoria. A análise atual não comprova as causas dos atrasos.

### 📄 Relatório detalhado

Para consultar o material complementar:

[Relatório detalhado das perguntas de negócio — PDF](Relatorio_Detalhado_Problema_de_Negocio_18_Perguntas.pdf)

---

## 📊 3. Desenvolvimento do Dashboard no Power BI

Após a análise SQL, os dados foram conectados ao Power BI Desktop para construir um relatório interativo voltado ao acompanhamento da operação logística.

### Modelagem de dados

Foram importadas as cinco tabelas do MySQL e criados relacionamentos entre a tabela fato e as dimensões.

Também foi criada a tabela `dim_calendario`, com campos como:

- Data.
- Ano.
- Número do mês.
- Nome do mês.
- Ano-mês.
- Trimestre.

O nome do mês foi configurado para seguir a ordem cronológica. A tabela calendário foi relacionada à data do pedido, permitindo análises temporais.

### Medidas DAX

Foram criadas medidas para calcular:

- Total de pedidos.
- Pedidos atrasados.
- Taxa de atraso.
- Lead time previsto.
- Lead time real.
- Desvio do lead time.
- Atraso médio entre pedidos atrasados.
- Maior atraso identificado.

Exemplos de medidas:

```DAX
Total de Pedidos =
COUNTROWS(fato_pedidos)
```

```DAX
Pedidos Atrasados =
CALCULATE(
    COUNTROWS(fato_pedidos),
    fato_pedidos[status_entrega] = "Atrasado"
)
```

```DAX
Taxa de Atraso =
DIVIDE(
    [Pedidos Atrasados],
    [Total de Pedidos],
    0
)
```

```DAX
Desvio Lead Time =
[Lead Time Real] - [Lead Time Previsto]
```

As medidas foram organizadas na tabela `Medidas` para facilitar a manutenção do modelo.

### Página 1 — Visão Geral da Operação

**Objetivo:** apresentar o diagnóstico geral da operação.

Principais elementos:
- Indicadores de total de pedidos, pedidos atrasados e taxa de atraso.
- Distribuição por status de entrega.
- Evolução mensal da taxa de atraso.
- Taxa de atraso por grupo/equipe.
- Segmentações para explorar os dados.

**Pergunta respondida:** qual é o nível geral de serviço e como a taxa de atraso varia ao longo do tempo e entre os grupos?

### Página 2 — Matriz de Gargalos e Risco

**Objetivo:** localizar segmentos com maior concentração de atrasos.

Principais elementos:
- Matriz por grupo/equipe e cidade.
- Total de pedidos, pedidos atrasados e taxa de atraso.
- Formatação condicional para destacar combinações que merecem atenção.

**Pergunta respondida:** onde estão os principais gargalos da operação?

### Página 3 — Severidade dos Atrasos e Lead Time

**Objetivo:** avaliar a duração dos atrasos e comparar os prazos previstos e reais.

Principais elementos:
- Quantidade de pedidos atrasados.
- Atraso médio e maior atraso.
- Atraso médio por grupo/equipe.
- Comparação entre lead time previsto e real.
- Filtros temporais por ano e mês.

**Pergunta respondida:** além da frequência, qual é a gravidade dos atrasos e como ela varia entre os grupos?

**Observação:** os filtros temporais usam a data do pedido. Portanto, representam o período em que o pedido foi realizado, não necessariamente o mês em que foi entregue.

### Página 4 — Recomendações: Onde Agir Primeiro

**Objetivo:** transformar os resultados em prioridades de investigação.

Principais recomendações:

1. Investigar o fluxo do grupo/canal Internet.
2. Analisar o volume de atrasos no Norte e a severidade dos atrasos no Sul.
3. Investigar os picos mensais.
4. Validar os canais sem atrasos registrados.
5. Enriquecer os dados geográficos para melhorar as análises por cidade.

**Pergunta respondida:** quais ações a gestão deve priorizar com base nos indicadores?

---

## ⚠️ 4. Limitações e Cuidados na Interpretação

Durante a análise, foram identificadas limitações importantes:

1. **Dimensão de cidades incompleta:** contém identificadores, sem nomes de municípios, estados ou regiões.
2. **Grupos heterogêneos:** a coluna `equipe_entrega` reúne valores geográficos, como Norte e Sul, e modalidades/canais, como Internet e Televendas. Por isso, os resultados devem ser interpretados conforme a estrutura da base.
3. **Volumes pequenos:** taxas elevadas baseadas em poucos pedidos podem ser instáveis; é necessário considerar também o volume absoluto.
4. **Canais sem atrasos registrados:** os canais 12 e 18 precisam de validação antes de serem tratados como benchmarks.
5. **Médias globais:** um lead time real médio inferior ao previsto não significa que todos os pedidos foram entregues antes do prazo.
6. **Causalidade:** os resultados mostram padrões e associações, mas não comprovam as causas dos atrasos.
7. **Análise temporal:** os filtros de ano e mês usam a data do pedido. Uma análise por mês de entrega exigiria considerar a data de entrega correspondente.

---

## 🚀 5. Conclusão

O projeto demonstrou como transformar dados relacionais de logística em indicadores úteis para apoiar decisões de negócio.

A análise identificou uma taxa geral de atraso de **12,94%**, além de diferenças relevantes entre grupos, canais, cidades e períodos.

O grupo/canal Internet destacou-se pela taxa de atraso, Norte pelo volume absoluto de ocorrências e Sul pela duração média dos atrasos. Os picos mensais e as combinações críticas de grupo/cidade indicam onde aprofundar a investigação.

A utilização de SQL permitiu consultar, segmentar e validar os dados. O Power BI organizou os resultados em um dashboard executivo com indicadores, filtros, análises de gargalos, severidade e recomendações.

Como evolução futura, a inclusão de dados sobre rotas, capacidade, estoque, transferências e eventos de entrega permitiria testar hipóteses e investigar as causas dos atrasos com maior precisão.

---

## 🛠️ Tecnologias Utilizadas

- **Banco de dados:** MySQL
- **Consultas e análise:** SQL
- **Business Intelligence:** Power BI Desktop
- **Linguagem de medidas:** DAX
- **Modelagem:** modelo dimensional com tabela fato e dimensões
- **Documentação:** Markdown e PDF

## 👨‍💻 Competências Demonstradas

- Análise de dados aplicada à logística e ao Supply Chain.
- Consultas SQL com junções, agregações e filtros.
- Modelagem dimensional e organização de dados.
- Criação de medidas e indicadores com DAX.
- Desenvolvimento de dashboards interativos no Power BI.
- Análise de KPIs logísticos e identificação de gargalos.
- Interpretação de resultados e elaboração de recomendações baseadas em dados.
