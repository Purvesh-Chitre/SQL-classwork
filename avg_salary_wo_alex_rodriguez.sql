USE H_Baseball;

SELECT 
    team,
    FORMAT(AVG(salary), '#,##0') AS avg_salary_wo_alex_rodriguez
FROM
    players
WHERE
    team = 'New York Yankees'
        AND year = 2011
        AND name <> 'Alex Rodriguez'
GROUP BY team
;
