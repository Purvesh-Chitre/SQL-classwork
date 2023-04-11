USE H_Baseball;

SELECT 
    year, COUNT(*) AS num_of_player
FROM
    players
GROUP BY year DESC
;