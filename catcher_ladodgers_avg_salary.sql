USE H_Baseball;

SELECT 
    year,
    position,
    FORMAT(AVG(salary), '#,##0') AS avg_salary_per_position
FROM
    players
WHERE
    team LIKE '%Dodgers'
        AND position LIKE 'Catcher'
GROUP BY year , team , position
ORDER BY year , team , position
;

