/* PERGUNTAS DE NEGOCIO */


/* ============================================================
   PERGUNTA 01
   Tamanho da Operação
   Objetivo:
   Identificar o volume total de pedidos registrados.
============================================================ */

USE logifast;

SELECT
    COUNT(*) AS total_pedidos
FROM vw_pedidos_completos;

/* ============================================================
   PERGUNTA 02
   Esses 53 mil pedidos foram realizados por quantos clientes diferentes?
   Objetivo:
   Descobrir:
   Quantos clientes únicos existem na base.
   Quantos pedidos, em média, cada cliente realizou (vamos calcular essa média em seguida).
============================================================ */
SELECT
    COUNT(DISTINCT id_cliente) AS total_clientes,
    COUNT(*) AS total_pedidos,
    ROUND(
        COUNT(*) / COUNT(DISTINCT id_cliente),2
    ) AS media_pedidos_por_cliente
FROM vw_pedidos_completos;


/* ============================================================
   PERGUNTA 03
   Quantas equipes de entrega temos e como os 53.656 pedidos estão distribuídos entre elas?
   Objetivo:
   Descobrir:
   Quantas equipes existem;
   Quantos pedidos cada equipe recebeu;
   Qual percentual do volume total pertence a cada equipe.
============================================================ */

-- Quantas equipes existem;--
SELECT 
	COUNT(DISTINCT equipe_entrega) AS total_equipe
FROM vw_pedidos_completos;
    
-- quantos pedidos cada equipe recebeu --
SELECT
	equipe_entrega,
	COUNT(*) AS total_pedidos
FROM vw_pedidos_completos
GROUP BY equipe_entrega;

-- Qual percentual do volume total pertence a cada equipe --
SELECT
	equipe_entrega,
    COUNT(*) AS total_pedidos,
    ROUND(
			COUNT(*) / (SELECT COUNT(*) FROM vw_pedidos_completos) * 100,2)
            AS percentual_pedidos
FROM vw_pedidos_completos
GROUP BY equipe_entrega
Order BY total_pedidos DESC;

/* ============================================================
   PERGUNTA 04
   Como esta o nivel de servico?
   Objetivo:
   Identificar a distribuição dos pedidos por: status de entrega
============================================================ */

-- Quantidade pedidos por status -- 
SELECT 
	status_entrega,
	COUNT(*) AS total_pedidos,
    ROUND(
			COUNT(*) / (SELECT COUNT(*) FROM vw_pedidos_completos) * 100,2)
            AS percentual
FROM vw_pedidos_completos
GROUP BY status_entrega
ORDER BY total_pedidos desc;

 /* ============================================================
   PERGUNTA 05
   Qual é o percentual de atraso?
   Objetivo:
   Identificar Qual é o nosso índice geral de atraso
============================================================ */   

SELECT
	status_entrega,
	(SELECT COUNT(*) FROM vw_pedidos_completos) AS total_pedidos,
	COUNT(*) AS total_pedidos_atrasados,
    ROUND(
		COUNT(*) / (SELECT COUNT(*) FROM vw_pedidos_completos) * 100,2)
        AS percentual_atraso
FROM vw_pedidos_completos
WHERE status_entrega = 'Atrasado';
-- OUTRA POSSIBILIDADE DE QUERY -- 
SELECT
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado' THEN 1
            ELSE 0
        END
    ) AS total_pedidos_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2
    ) AS percentual_atraso
FROM vw_pedidos_completos;

/* ============================================================
   PERGUNTA 06
   Onde estão os atrasos?
   Objetivo:
   Identificar Qual equipe possui a maior quantidade de pedidos atrasados?
============================================================ */

SELECT
	equipe_entrega,
	COUNT(*) AS total_pedidos,
    SUM(
		CASE
			WHEN status_entrega = 'Atrasado' THEN 1
            ELSE 0
		END) AS total_pedido_atrasado,
    ROUND(
		SUM(
			CASE
				WHEN status_entrega = 'Atrasado' THEN 1
				ELSE 0
			END) / COUNT(*) * 100,2) AS percentual_atraso
FROM vw_pedidos_completos
GROUP BY equipe_entrega
ORDER BY total_pedidos DESC;

/* ============================================================
   PERGUNTA 07
   Quais equipes são responsáveis pela maior quantidade de atrasos da operação?
   Objetivo:
   Queremos a participação de cada equipe no total de 6.942 atrasos.
============================================================ */

SELECT 
	equipe_entrega,
    SUM(
		CASE
			WHEN status_entrega = 'Atrasado' 
            THEN 1 ELSE 0
		END) AS pedidos_atrasados,
   ROUND(
		SUM(
			CASE
				WHEN status_entrega = 'Atrasado'
				THEN 1 ELSE 0
			END)
         /   
        (SELECT COUNT(*)
         FROM vw_pedidos_completos
         WHERE status_entrega = 'Atrasado') * 100, 2) AS percentual_dos_atrasos
         FROM vw_pedidos_completos
         GROUP BY equipe_entrega
         ORDER BY pedidos_atrasados DESC;

/* ============================================================
   PERGUNTA 08
   Em média, quantos dias estamos levando para realizar uma entrega e qual era o prazo originalmente prometido?
   Objetivo:
   Primeiro vamos fazer a análise geral da operação, sem separar por equipe.
============================================================ */

SELECT 
	ROUND(AVG(lead_time_previsto),2) AS media_leadtime_previsto,
    ROUND(AVG(lead_time_real),2) AS media_leadtime_real,
    ROUND(AVG(desvio_entrega),2) AS media_desvio_entrega
FROM vw_pedidos_completos;

/* ============================================================
   PERGUNTA 09
   Quais grupos estão apresentando os maiores desvios entre o prazo prometido e o prazo efetivamente realizado?

============================================================ */

SELECT
    equipe_entrega,
    ROUND(AVG(lead_time_previsto), 2) AS media_lead_time_previsto,
    ROUND(AVG(lead_time_real), 2) AS media_lead_time_real,
    ROUND(AVG(desvio_entrega), 2) AS media_desvio
FROM vw_pedidos_completos
GROUP BY equipe_entrega
ORDER BY media_desvio DESC;

/* ============================================================
   PERGUNTA 10
   Quando uma entrega atrasa, em média quantos dias ela ultrapassa o prazo previsto?
   Objetivo:
   Primeiro vamos fazer a análise geral da operação, sem separar por equipe.
============================================================ */

SELECT
    COUNT(*) AS total_pedidos_atrasados,
    ROUND(AVG(desvio_entrega), 2) AS media_dias_atraso,
    MAX(desvio_entrega) AS maior_atraso,
    MIN(desvio_entrega) AS menor_atraso
FROM vw_pedidos_completos
WHERE status_entrega = 'Atrasado';

use logifast;

/* ============================================================
   PERGUNTA 11
   Quais grupos apresentam os atrasos mais severos?
   Objetivo:
   analisar somente pedidos atrasados.
============================================================ */

SELECT
    equipe_entrega,
    COUNT(*) AS pedidos_atrasados,
    ROUND(
        AVG(desvio_entrega),2) AS media_dias_atraso,
    MAX(desvio_entrega) AS maior_atraso
FROM vw_pedidos_completos
WHERE status_entrega = 'Atrasado'
GROUP BY equipe_entrega
ORDER BY media_dias_atraso DESC;

/* ============================================================
   PERGUNTA 12
   Quais cidades concentram o maior volume de pedidos e quais apresentam maior quantidade de atrasos?
   Objetivo:
   analisar quantidade total de pedidos;
   analisar quantidade de pedidos atrasados;
   analisar percentual de atraso.
============================================================ */

describe dim_cidade; -- obs: apos validacao da dimencao cidade, encontramos uma limitacao no nosso dado, não possui informacao de cidade e estado--
SELECT
    id_cidade,
    COUNT(*) AS total_pedidos
FROM vw_pedidos_completos
GROUP BY id_cidade
ORDER BY total_pedidos DESC;

-- Volume + Atrasos + Taxa de atraso --

SELECT
    id_cidade,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado'
            THEN 1
            ELSE 0
        END
    ) AS pedidos_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY id_cidade
ORDER BY total_pedidos DESC;

/* ============================================================
   PERGUNTA 13
   Quais cidades realmente apresentam maior taxa de atraso?
   Objetivo:
   Considerando apenas cidades com volume relevante de pedidos, quais apresentam as maiores taxas de atraso?
   Considerar cidades com pelo menos 500 pedidos.
============================================================ */

SELECT
    id_cidade,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado'
            THEN 1
            ELSE 0
        END
    ) AS pedidos_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY id_cidade
HAVING COUNT(*) >= 500
ORDER BY taxa_atraso DESC;

/* ============================================================
   PERGUNTA 14
   Quais combinações de grupo operacional e cidade apresentam maior risco de atraso?
   Objetivo:
   ETAPA 1
   Quantos pedidos e quantos atrasos existem por combinação de grupo + cidade.
============================================================ */

SELECT
    equipe_entrega,
    id_cidade,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado'
            THEN 1
            ELSE 0
        END
    ) AS pedidos_atrasados
FROM vw_pedidos_completos
GROUP BY
    equipe_entrega,
    id_cidade
ORDER BY
    pedidos_atrasados DESC;

-- PARTE 2 --
-- Quais combinações de grupo operacional e cidade apresentam as maiores taxas de atraso? --

SELECT
    equipe_entrega,
    id_cidade,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado'
            THEN 1
            ELSE 0
        END
    ) AS pedidos_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY
    equipe_entrega,
    id_cidade
HAVING COUNT(*) >= 100
ORDER BY taxa_atraso DESC;

/* ============================================================
   PERGUNTA 15
   O canal de entrega influencia o atraso?
   Objetivo:
   ETAPA 1
   Existe diferença significativa no desempenho dos pedidos dependendo do canal de entrega?
============================================================ */

SELECT
    canal_entrega,
    COUNT(*) AS total_pedidos
FROM vw_pedidos_completos
GROUP BY canal_entrega
ORDER BY total_pedidos DESC;

-- ETAPA 2 --
-- Qual canal apresenta maior taxa de atraso? -- 

SELECT
    canal_entrega,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado'
            THEN 1
            ELSE 0
        END
    ) AS pedidos_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY canal_entrega
ORDER BY taxa_atraso DESC;

-- PARTE 3 --
-- Os canais com melhor desempenho possuem características diferentes de prazo de entrega? --

SELECT
    canal_entrega,
    ROUND(
        AVG(lead_time_previsto),2
    ) AS media_lead_time_previsto,
    ROUND(
        AVG(lead_time_real),2
    ) AS media_lead_time_real,
    ROUND(
        AVG(desvio_entrega),2
    ) AS media_desvio
FROM vw_pedidos_completos
GROUP BY canal_entrega
ORDER BY media_desvio DESC;

use logifast;
/* ============================================================
   PERGUNTA 16
   O problema está relacionado ao tempo?
   Objetivo:
   Identificar se os atrasos estão concentrados em determinados períodos?
============================================================ */

SELECT
    YEAR(data_pedido) AS ano,
    MONTH(data_pedido) AS mes,
    COUNT(*) AS total_pedidos
FROM vw_pedidos_completos
GROUP BY
    YEAR(data_pedido),
    MONTH(data_pedido)
ORDER BY
    ano,
    mes;
    
-- parte 2 --
-- A taxa de atraso varia de acordo com o mês? Existem períodos em que a operação apresenta maior risco de atrasos?--

SELECT
    YEAR(data_pedido) AS ano,
    MONTH(data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado' THEN 1
            ELSE 0
        END
    ) AS total_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY
    YEAR(data_pedido),
    MONTH(data_pedido)
ORDER BY
    ano,
    mes;
    
/* ============================================================
   PERGUNTA 17
   Quais equipes apresentam maior taxa de atraso nos períodos analisados

============================================================ */

SELECT
    equipe_entrega,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado' THEN 1
            ELSE 0
        END
    ) AS total_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY equipe_entrega
ORDER BY taxa_atraso DESC;

-- parte 2 -- 
-- Essas equipes apresentam atrasos constantemente ou existem meses específicos responsáveis pela pior performance?--
SELECT
    equipe_entrega,
    YEAR(data_pedido) AS ano,
    MONTH(data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado' THEN 1
            ELSE 0
        END
    ) AS total_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS taxa_atraso
FROM vw_pedidos_completos
GROUP BY
    equipe_entrega,
    YEAR(data_pedido),
    MONTH(data_pedido)
HAVING COUNT(*) >= 50
ORDER BY
    taxa_atraso DESC;
    
 /* ============================================================
   PERGUNTA 18
   Existe relação entre o lead time previsto e a ocorrência de atrasos?
   Objetivo:
   
============================================================ */   

SELECT
    CASE
        WHEN lead_time_previsto <= 2 THEN 'Até 2 dias'
        WHEN lead_time_previsto <= 4 THEN '3 a 4 dias'
        WHEN lead_time_previsto <= 6 THEN '5 a 6 dias'
        ELSE '7 dias ou mais'
    END AS faixa_lead_time,
    COUNT(*) AS total_pedidos,
    SUM(
        CASE
            WHEN status_entrega = 'Atrasado' THEN 1
            ELSE 0
        END
    ) AS total_atrasados,
    ROUND(
        SUM(
            CASE
                WHEN status_entrega = 'Atrasado' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,2) AS taxa_atraso,
    ROUND(
        AVG(lead_time_previsto),2) AS media_lead_time_previsto,
    ROUND(
        AVG(lead_time_real),2) AS media_lead_time_real
FROM vw_pedidos_completos
GROUP BY
    CASE
        WHEN lead_time_previsto <= 2 THEN 'Até 2 dias'
        WHEN lead_time_previsto <= 4 THEN '3 a 4 dias'
        WHEN lead_time_previsto <= 6 THEN '5 a 6 dias'
        ELSE '7 dias ou mais'
    END
ORDER BY
    taxa_atraso DESC;
