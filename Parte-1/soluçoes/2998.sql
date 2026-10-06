WITH acumulado AS (
    SELECT
        c.name,
        c.investment,
        o.month,
        SUM(o.profit) OVER (
            PARTITION BY c.id
            ORDER BY o.month
        ) AS total
    FROM clients c
    JOIN operations o ON o.client_id = c.id
)
SELECT
    name,
    investment,
    MIN(month) AS month_of_payback,
    MIN(total) - investment AS return
FROM acumulado
WHERE total >= investment
GROUP BY name, investment
ORDER BY return DESC;
