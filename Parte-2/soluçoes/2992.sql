WITH salarios AS (
    SELECT
        e.matr,
        e.lotacao,
        e.lotacao_div,
        COALESCE(SUM(v.valor), 0) -
        COALESCE((
            SELECT SUM(d.valor)
            FROM emp_desc ed
            JOIN desconto d ON d.cod_desc = ed.cod_desc
            WHERE ed.matr = e.matr
        ), 0) AS salario
    FROM empregado e
    LEFT JOIN emp_venc ev ON ev.matr = e.matr
    LEFT JOIN vencimento v ON v.cod_venc = ev.cod_venc
    GROUP BY e.matr, e.lotacao, e.lotacao_div
),
medias AS (
    SELECT
        lotacao,
        lotacao_div,
        ROUND(AVG(salario), 2) AS media
    FROM salarios
    GROUP BY lotacao, lotacao_div
)
SELECT
    d.nome AS departamento,
    dv.nome AS divisao,
    m.media
FROM medias m
JOIN departamento d ON d.cod_dep = m.lotacao
JOIN divisao dv ON dv.cod_divisao = m.lotacao_div
WHERE m.media = (
    SELECT MAX(m2.media)
    FROM medias m2
    WHERE m2.lotacao = m.lotacao
)
ORDER BY m.media DESC;
