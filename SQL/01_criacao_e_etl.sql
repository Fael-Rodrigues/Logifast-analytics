Use logifast;

 /* ==========================================================
       CRIAÇÃO DAS TABELAS E RELACIONAMENTOS
    ========================================================== */

-- 1. Tabela Dimensão: Clientes
CREATE TABLE dim_cliente (
    id_cliente INT PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL
);

-- 2. Tabela Dimensão: Vendedores
CREATE TABLE dim_vendedor (
    id_vendedor INT PRIMARY KEY,
    equipe_entrega VARCHAR(50) NOT NULL
);

-- 3. Tabela Dimensão: Cidades
CREATE TABLE dim_cidade (
    id_cidade INT PRIMARY KEY
);

-- 4. Tabela Dimensão: Canais de Entrega
CREATE TABLE dim_canal (
    canal_entrega VARCHAR(20) PRIMARY KEY
);

-- 5. Tabela Fato: Pedidos
CREATE TABLE fato_pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    id_cidade INT NOT NULL,
    canal_entrega VARCHAR(20) NOT NULL,
    data_pedido VARCHAR(100),
    data_entrega_prevista VARCHAR(100),
    data_entrega_realizada VARCHAR(100),
    status_entrega VARCHAR(20) NOT NULL,

    -- Relacionamentos (Chaves Estrangeiras)
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    CONSTRAINT fk_pedidos_vendedor FOREIGN KEY (id_vendedor) REFERENCES dim_vendedor(id_vendedor),
    CONSTRAINT fk_pedidos_cidade FOREIGN KEY (id_cidade) REFERENCES dim_cidade(id_cidade),
    CONSTRAINT fk_pedidos_canal FOREIGN KEY (canal_entrega) REFERENCES dim_canal(canal_entrega)
);

select * from fato_pedidos;

SELECT 
    COUNT(*) AS total_registros_fato
FROM fato_pedidos;

 /* ==========================================================
	CONVERTENDO AS COLUNAS DE DATA DA TABELA PEDIDOS DE VARCHAR PARA DATA
    ========================================================== */

ALTER TABLE fato_pedidos
MODIFY COLUMN data_pedido DATE;

ALTER TABLE fato_pedidos
MODIFY COLUMN data_entrega_prevista DATE;

ALTER TABLE fato_pedidos
MODIFY COLUMN data_entrega_realizada DATE;

-- TESTANDO FUNÇÃO ANTES DA VIEWS
SELECT
    data_pedido,
    YEAR(data_pedido) AS ano,
    MONTH(data_pedido) AS mes,
    MONTHNAME(data_pedido) AS nome_mes
FROM fato_pedidos
LIMIT 10;

/* ==========================================================
-- CRIANDO VIEWS COLUNA CALCULADA: vw_pedidos_completos
============================================================= */
CREATE OR REPLACE VIEW vw_pedidos_completos AS

SELECT

    /* ==========================================================
       IDENTIFICAÇÃO
    ========================================================== */

    fp.id_pedido,

    /* ==========================================================
       CLIENTE
    ========================================================== */

    fp.id_cliente,
    dc.nome_cliente,

    /* ==========================================================
       VENDEDOR
    ========================================================== */

    fp.id_vendedor,
    dv.equipe_entrega,

    /* ==========================================================
       CIDADE
    ========================================================== */

    fp.id_cidade,

    /* ==========================================================
       CANAL
    ========================================================== */

    fp.canal_entrega,

    /* ==========================================================
       DATAS
    ========================================================== */

    fp.data_pedido,
    fp.data_entrega_prevista,
    fp.data_entrega_realizada,

    /* ==========================================================
       STATUS
    ========================================================== */

    fp.status_entrega,

    /* ==========================================================
       INDICADORES LOGÍSTICOS
    ========================================================== */

    -- Dias prometidos ao cliente
    DATEDIFF(fp.data_entrega_prevista, fp.data_pedido)
        AS lead_time_previsto,

    -- Dias realmente gastos na entrega
    DATEDIFF(fp.data_entrega_realizada, fp.data_pedido)
        AS lead_time_real,

    -- Diferença entre prazo prometido e prazo realizado
    DATEDIFF(fp.data_entrega_realizada, fp.data_entrega_prevista)
        AS desvio_entrega,

    /* ==========================================================
       DIMENSÃO TEMPO
    ========================================================== */

    YEAR(fp.data_pedido)
        AS ano,

    QUARTER(fp.data_pedido)
        AS trimestre,

    MONTH(fp.data_pedido)
        AS numero_mes,

    MONTHNAME(fp.data_pedido)
        AS nome_mes,

    DAY(fp.data_pedido)
        AS dia,

    DAYNAME(fp.data_pedido)
        AS dia_semana,

    WEEK(fp.data_pedido)
        AS semana_ano,

    DAYOFYEAR(fp.data_pedido)
        AS dia_ano

FROM fato_pedidos fp

INNER JOIN dim_cliente dc
    ON fp.id_cliente = dc.id_cliente

INNER JOIN dim_vendedor dv
    ON fp.id_vendedor = dv.id_vendedor

INNER JOIN dim_cidade dci
    ON fp.id_cidade = dci.id_cidade

INNER JOIN dim_canal dca
    ON fp.canal_entrega = dca.canal_entrega;

/* ==================================================== */    
-- VALIDANDO A VIEWS
SELECT *
FROM vw_pedidos_completos
LIMIT 10;

/* ==================================================== */
-- ANALISE EXPLORATORIA
-- 1) A quantidade de registros está correta?

-- analisando registros na view
SELECT COUNT(*) AS total_registros
FROM vw_pedidos_completos;
-- a views retornou um total de 53656 de registros

-- analisando registros da fato_pedido
SELECT COUNT(*) AS total_registros
FROM fato_pedidos;
-- retornou 53656 de registros, isso demontra que todos os registros estao na views e corretos.

-- 1.2) VALIDACAO DAS COLUNAS CALCULADAS - verificar se os calculos das colunas estão corretos
SELECT
	id_pedido,
    data_pedido,
    data_entrega_prevista,
    data_entrega_realizada,
    lead_time_previsto,
    lead_time_real,
    desvio_entrega
FROM vw_pedidos_completos
LIMIT 20;
-- Os calculos das colunas lead_time_precisto x lead_time_real estao corretos na coluna desvio_entrega

-- 1.3) VERIFICAÇÃO SE EXISTE PEDIDOS DUPLICADOS
SELECT
	id_pedido,
    COUNT(*) AS quantidade
FROM vw_pedidos_completos
GROUP BY id_pedido
HAVING COUNT(*) > 1;
-- A verificação retornou zero, o que significa que não temos dados duplicados em nossa view

-- 1.4) VERIFICAÇÃO DE HA VALORES NULOS 
SELECT
	SUM(id_cliente IS NULL) AS cliente_nulo,
    SUM(id_vendedor IS NULL) AS vendedor_nulo,
    SUM(id_cidade IS NULL) AS cidade_nula,
    SUM(canal_entrega IS NULL) AS canal_nulo,
    SUM(data_pedido IS NULL) AS pedido_nulo,
    SUM(data_entrega_prevista IS NULL) AS prevista_nula,
    SUM(data_entrega_realizada IS NULL) AS realizada_nula,
    SUM(status_entrega IS NULL) AS status_nulo
FROM vw_pedidos_completos;
-- A verificação retornou zero, o que significa que não ha valores nulos na view

-- 1.5) VALIDAÇÃO DAS REGRAS DE NEGOCIO - os dados devem respeitar as regras da operação.
-- REGRA 1 - A entrega nunca pode ocorrer antes do pedido:
SELECT *
FROM vw_pedidos_completos
WHERE data_entrega_realizada < data_pedido;
-- Retornou zero, o que significa que a regra 1 esta sendo respeitada

-- REGRA 2 - A data prevista nao pode ser anterior ao pedido:
SELECT *
FROM vw_pedidos_completos
WHERE data_entrega_prevista < data_pedido;
-- Retornou zero, o que significa que a regra 2 esta sendo respeitada

-- REGRA 3 - O status(Atrasado, Antecipado e No prazo) deve ser coerente com o desvio da entrega:
SELECT * 
FROM vw_pedidos_completos
WHERE status_entrega = "Atrasado"
AND desvio_entrega <= 0;
-- Retornou zero, o que significa que a regra 3 esta sendo respeitada

SELECT * 
FROM vw_pedidos_completos
WHERE status_entrega = "Antecipado"
AND desvio_entrega >= 0;
-- Retornou zero, o que significa que a regra 3 esta sendo respeitada

SELECT * 
FROM vw_pedidos_completos
WHERE status_entrega = "No Prazo"
AND desvio_entrega <> 0;
-- Retornou zero, o que significa que todos os testes mostram que a regra 3 esta sendo respeitada
-- OBS: essa regra depende da lógica utilizada para classificar "No Prazo". Se a empresa considerar como "No Prazo" qualquer entrega até a data prevista (inclusive antecipadas), ajustaremos essa validação depois de analisar os resultados.

-- 1.6) ESTATISTICAS DOS LEAD TIMES (REAL, PREVISTO E DESVIO ENTREGA)
SELECT
    MIN(lead_time_real) AS menor_lead_time,
    MAX(lead_time_real) AS maior_lead_time,
    ROUND(AVG(lead_time_real),2) AS media_lead_time
FROM vw_pedidos_completos;

SELECT
    MIN(lead_time_previsto) AS menor_lead_time,
    MAX(lead_time_previsto) AS maior_lead_time,
    ROUND(AVG(lead_time_previsto),2) AS media_lead_time
FROM vw_pedidos_completos;

SELECT
    MIN(desvio_entrega) AS menor_lead_time,
    MAX(desvio_entrega) AS maior_lead_time,
    ROUND(AVG(desvio_entrega),2) AS media_lead_time
FROM vw_pedidos_completos;

-- 1.7) VERIFICANDO AS CATTEGORIAS

SELECT
    status_entrega,
    COUNT(*) AS quantidade
FROM vw_pedidos_completos
GROUP BY status_entrega;

SELECT
    canal_entrega,
    COUNT(*) AS quantidade
FROM vw_pedidos_completos
GROUP BY canal_entrega;

SELECT
    equipe_entrega,
    COUNT(*) AS quantidade
FROM vw_pedidos_completos
GROUP BY equipe_entrega;
