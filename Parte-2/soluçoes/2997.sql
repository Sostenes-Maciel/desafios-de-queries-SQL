SELECT
    d.nome AS "Departamento",
    e.nome AS "Empregado",
    COALESCE(v.total, 0) AS "Salario Bruto",
    COALESCE(des.total, 0) AS "Total Desconto",
    COALESCE(v.total, 0) - COALESCE(des.total, 0) AS "Salario Liquido"
FROM empregado e
JOIN departamento d
    ON e.lotacao = d.cod_dep
LEFT JOIN (
    SELECT
        ev.matr,
        SUM(v.valor) AS total
    FROM emp_venc ev
    JOIN vencimento v
        ON ev.cod_venc = v.cod_venc
    GROUP BY ev.matr
) v
    ON e.matr = v.matr
LEFT JOIN (
    SELECT
        ed.matr,
        SUM(d.valor) AS total
    FROM emp_desc ed
    JOIN desconto d
        ON ed.cod_desc = d.cod_desc
    GROUP BY ed.matr
) des
    ON e.matr = des.matr
ORDER BY "Salario Liquido" DESC;
