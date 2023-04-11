USE H_Baseball;

SELECT 
    player_id,
    year,
    team,
    name,
    position,
    FORMAT((salary), '#,##0') AS salary
FROM
    players
WHERE
    position = 'pitcher'
        AND team = 'Boston Red Sox'
        AND name LIKE '%Pape%'
GROUP BY player_id , year , team , name , position
ORDER BY year , salary DESC
;