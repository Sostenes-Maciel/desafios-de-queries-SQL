SELECT
    t.name,
    COUNT(m.id) AS matches,
    SUM(CASE
        WHEN (t.id = m.team_1 AND m.team_1_goals > m.team_2_goals)
          OR (t.id = m.team_2 AND m.team_2_goals > m.team_1_goals)
        THEN 1 ELSE 0
    END) AS victories,
    SUM(CASE
        WHEN (t.id = m.team_1 AND m.team_1_goals < m.team_2_goals)
          OR (t.id = m.team_2 AND m.team_2_goals < m.team_1_goals)
        THEN 1 ELSE 0
    END) AS defeats,
    SUM(CASE
        WHEN m.team_1_goals = m.team_2_goals
        THEN 1 ELSE 0
    END) AS draws,
    SUM(CASE
        WHEN (t.id = m.team_1 AND m.team_1_goals > m.team_2_goals)
          OR (t.id = m.team_2 AND m.team_2_goals > m.team_1_goals)
        THEN 3
        WHEN m.team_1_goals = m.team_2_goals
        THEN 1
        ELSE 0
    END) AS score
FROM teams t
LEFT JOIN matches m
    ON t.id = m.team_1 OR t.id = m.team_2
GROUP BY t.id, t.name
ORDER BY score DESC;
