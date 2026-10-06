SELECT
    d.nome AS departamento,
    dv.nome AS divisao,
    ROUND(AVG(s.salario), 2) AS media,
    ROUND(MAX(s.salario), 2) AS maior
FROM departamento d
JOIN divisao dv
    ON d.cod_dep = dv.cod_dep
JOIN (
    SELECT
        e.matr,
        e.lotacao_div,
        COALESCE(SUM(v.valor), 0) -
        COALESCE((
            SELECT SUM(ds.valor)
            FROM emp_desc ed
            JOIN desconto ds
                ON ed.cod_desc = ds.cod_desc
            WHERE ed.matr = e.matr
        ), 0) AS salario
    FROM empregado e
    LEFT JOIN emp_venc ev
        ON e.matr = ev.matr
    LEFT JOIN vencimento v
        ON ev.cod_venc = v.cod_venc
    GROUP BY e.matr, e.lotacao_div
) s
    ON dv.cod_divisao = s.lotacao_div
GROUP BY d.nome, dv.nome
ORDER BY media DESC;
