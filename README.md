# 🚚 LogiFast - Análise de Performance Logística e Nível de Serviço com SQL

![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen)
![Tecnologia](https://img.shields.io/badge/SQL-MySQL_Workbench-blue)
![Domínio](https://img.shields.io/badge/Dom%C3%ADnio-Log%C3%ADstica_&_Supply_Chain-orange)

## 📌 Visão Geral do Projeto
A **LogiFast** é uma empresa de logística que processou **53.656 pedidos**. O objetivo deste projeto foi avaliar a eficiência das entregas, diagnosticar gargalos na operação, entender a severidade dos atrasos e fornecer insights estratégicos para a tomada de decisão.

Este projeto foi desenvolvido em 2 etapas principais utilizando **MySQL**:
1. **Modelagem Dimensional & ETL:** Criação do banco de dados relacional (Star Schema / Fato e Dimensões) e construção de VIEWs otimizadas.
2. **Análise Exploratória & Perguntas de Negócio:** Investigação profunda respondendo a 18 perguntas de negócio focadas em nível de serviço, volume, taxa de atraso e *lead times*.

---

## 📐 1. Arquitetura e Modelagem dos Dados

A base operacional bruta foi estruturada em um modelo **Star Schema** contendo 1 Tabela Fato e 4 Tabelas Dimensão:

- **`fato_pedidos`**: Contém o registro granular dos pedidos, chaves estrangeiras e datas (pedido, prevista, realizada).
- **`dim_cliente`**: Informações dos clientes.
- **`dim_vendedor`**: Vendedores e a correspondente `equipe_entrega`.
- **`dim_cidade`**: Identificação geográfica das entregas (`id_cidade`).
- **`dim_canal`**: Canais de entrega (ex: Canal05, Canal07).

### 🛠️ Processamento e Enriquecimento dos Dados (ETL)
Para otimizar as consultas e unificar o cálculo dos indicadores logísticos, foi criada a View `vw_pedidos_completos`, que realiza o cálculo automático dos seguintes KPIs:
- **Lead Time Previsto:** `DATEDIFF(data_entrega_prevista, data_pedido)`
- **Lead Time Real:** `DATEDIFF(data_entrega_realizada, data_pedido)`
- **Desvio de Entrega:** `DATEDIFF(data_entrega_realizada, data_entrega_prevista)`
- **Atributos Temporais:** Extração de ano, trimestre, mês e dia da semana.

📄 *Consulte o script completo de modelagem na pasta [SQL/01_criacao_e_etl.sql](SQL/01_criacao_e_etl.sql).*

---

## 📊 2. Principais Indicadores e Descobertas (KPIs)

| Indicador Logístico | Valor Identificado |
| :--- | :--- |
| **Total de Pedidos Processados** | **53.656** |
| **Total de Entregas Atrasadas** | **6.942** |
| **Taxa Geral de Atraso (OTD Risk)** | **12,94%** |
| **Lead Time Previsto Médio** | **3,96 dias** |
| **Lead Time Real Médio** | **2,84 dias** |
| **Atraso Médio (Apenas Atrasados)** | **2,07 dias** *(Com pico máximo de 20 dias)* |

---

## 🔍 3. Principais Insights da Análise (As 18 Perguntas)

1. **Volume Absoluto vs. Taxa de Atraso:** 
   - A equipe **Norte** possui o maior volume de atrasos em números absolutos (**1.838 pedidos atrasados**).
   - O canal/equipe **Internet** possui a maior taxa proporcional de atrasos (**27,42%**).
2. **Severidade dos Atrasos:** 
   - Embora a região **Norte** tenha mais frequência de atrasos, a região **Sul** apresenta a maior **severidade média** (atraso médio de **2,41 dias** por pedido atrasado, atingindo até 20 dias de atraso).
3. **Cidades Críticas:**
   - Entre as cidades com volume relevante (>= 500 pedidos), a **Cidade 68** apresentou uma taxa crítica de atraso de **53,49%**, seguida pela **Cidade 137** com **24,60%**.
4. **Análise de Canais:**
   - O **Canal07** é o gargalo operacional em volume, acumulando **1.978 atrasos** (taxa de 21,66%).
5. **Comportamento Temporal:**
   - O pico de insatisfação e falha operacional ocorreu nos meses de **Novembro/2019 (19,86% de atraso)** e **Dezembro/2019 (18,38%)**, indicando forte sensibilidade ao aumento sazonal de demanda.

📄 *Consulte todas as 18 queries analíticas no arquivo [SQL/02_perguntas_de_negocio.sql](SQL/02_perguntas_de_negocio.sql).*

---

## 📁 Documentação Completa
O relatório analítico detalhado com todas as 18 perguntas e diagnósticos pode ser visualizado no arquivo:
👉 [Relatório Detalhado de Negócio (PDF)](Documentos/Relatorio_Detalhado_Problema_de_Negocio_18_Perguntas.pdf)

---

## ⚠️ 4. Limitações dos Dados e Próximos Passos

Durante a exploração SQL, foram identificadas as seguintes limitações:
1. **Dimensão Cidade Incompleta:** A tabela `dim_cidade` possui apenas o ID da cidade, sem o nome do município ou estado (UF).
2. **Heterogeneidade na Equipe:** A coluna `equipe_entrega` mistura regiões (Norte, Sul) com canais/modalidades (Internet, Televendas).

### 🚀 Próxima Etapa (Power BI)
- Desenvolver um **Dashboard Executivo e Interativo no Power BI** com filtros dinâmicos, matrizes de risco (Equipe x Cidade) e análise de tendências temporais.

---

## 🛠️ Tecnologias Utilizadas
- **SGBD:** MySQL Workbench
- **Linguagem:** SQL (DDL, DML, DQL, Joins, Aggregations, Window/Case Functions, Views)
- **Documentação:** Markdown, PDF
