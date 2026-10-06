SELECT
    dep.nome AS "Nome Departamento",
    COUNT(emp.matr) AS "Numero de Empregados",
    CASE
        WHEN AVG(v.salario - d.descontos) = 0 THEN 0
        ELSE ROUND(AVG(v.salario - d.descontos), 2)
    END AS "Media Salarial",
    CASE
        WHEN MAX(v.salario - d.descontos) = 0 THEN 0
        ELSE ROUND(MAX(v.salario - d.descontos), 2)
    END AS "Maior Salario",
    CASE
        WHEN MIN(v.salario - d.descontos) = 0 THEN 0
        ELSE ROUND(MIN(v.salario - d.descontos), 2)
    END AS "Menor Salario"
FROM departamento dep
JOIN empregado emp
    ON dep.cod_dep = emp.lotacao
JOIN (
    SELECT
        emp.matr,
        COALESCE(SUM(v.valor), 0) AS salario
    FROM empregado emp
    LEFT JOIN emp_venc ev
        ON emp.matr = ev.matr
    LEFT JOIN vencimento v
        ON ev.cod_venc = v.cod_venc
    GROUP BY emp.matr
) v
    ON emp.matr = v.matr
JOIN (
    SELECT
        emp.matr,
        COALESCE(SUM(d.valor), 0) AS descontos
    FROM empregado emp
    LEFT JOIN emp_desc ed
        ON emp.matr = ed.matr
    LEFT JOIN desconto d
        ON ed.cod_desc = d.cod_desc
    GROUP BY emp.matr
) d
    ON emp.matr = d.matr
GROUP BY dep.cod_dep, dep.nome
ORDER BY AVG(v.salario - d.descontos) DESC;
