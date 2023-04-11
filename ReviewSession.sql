-- Query for all the unique positions from the player's table
SELECT DISTINCT position
FROM players;






-- Write a query for the given output.
SELECT ROUND(AVG(salary), 1) as 'Average_salary', SUM(salary) as 'Total_Salary', STDDEV(salary) as 'StandardDeviation'
FROM players;






-- How many teams exist in the baseball season
SELECT COUNT(DISTINCT (team))
FROM players;





-- How many null values exist in the salary column?
SELECT COUNT(salary)
FROM players
WHERE salary IS NULL;






-- Query for the sum of the salary column of San Francisco Giant teams in 2011
SELECT 
    SUM(salary)
FROM
    players
WHERE
    team = 'San Francisco Giants'
        AND year = 2011; 





-- How many players were playing in each year (team-wise)?  Sort the results from greatest count to smallest count.
SELECT year, COUNT(name)
FROM players
GROUP BY year
ORDER BY COUNT(DISTINCT name) DESC;





-- List the total salary of each team in each year. Sort the result by year ascending and teams descending.
SELECT year, team, SUM(salary) 
FROM players
GROUP BY year, team
ORDER BY year ASC, team DESC; 





-- Count the teams which more than 25 players, in each year. List the results in descending order by count of players.
SELECT year, team, COUNT(player_id) as 'Count of players'
FROM players
GROUP BY year, team
HAVING COUNT(player_id) > 25
ORDER BY COUNT(player_id) DESC;




-- In players table, which team have more than 75 players?
SELECT team, COUNT(player_id) as 'CNT_players'
FROM players
GROUP BY team
HAVING CNT_players > 75;



-- In the year 2009, which team paid gross salary more than $ 120,000,000?
SELECT team, SUM(salary)
FROM players
WHERE year = 2009
GROUP BY team
HAVING SUM(salary) >= 120000000;



-- Standardize duration of each film, return with its title and duration.
-- SELECT title, duration, (duration- (SELECT AVG(duaration) FROM films))/ (SELECT(STDDEV(duration FROM FILMS)) 




-- What is the position of the player paid the least salary in 2011 and is in a team which ends in "cs"
SELECT 
    positon, team
FROM
    players
WHERE
    year = 2011 AND team LIKE ('%cs')
        AND salary = (SELECT 
            MIN(salary)
        FROM
            players
        WHERE
            year = 2011);


-- How many players earn more than the highest paying player Minnesota Twin's team in 2011

SELECT 
    COUNT(player_id)
FROM
    players
WHERE
    year = 2011 
        AND salary > (SELECT 
            MAX(salary)
        FROM
            players
        WHERE
            team LIKE 'Minnesota%' AND year = 2011);
            
            
/*
-- Fill in the Blanks to query the total salary of players as well as salaries of players with 
salary above average in year 2011 */
SELECT ROUND(SUM( salary / 1000000 ), 0) AS tot_salary_mil,

       (SELECT ROUND(SUM( salary / 1000000 ), 0)
        FROM players
        WHERE year = 2011
        AND salary > (         
                          		SELECT AVG(salary)  
		FROM   players      
		WHERE  year = 2011  

              )                   
	   ) AS abv_avg_tot_salary_mil
FROM  players
WHERE year = 2011; 

/*
How many clients  have the meals delivered into the office and has an income range 
of '100k to 149k'
*/
SELECT 
    COUNT(c.customer_id)
FROM
    customer AS c
        INNER JOIN
    household_type AS h ON c.household_type_id = h.household_type_id
WHERE
    h.household_type LIKE ('%Office')
        AND c.income_range = '100k to 149k';
        
        
-- Fill in the blanks to know if a customers ordered more than one meal plan
SELECT COUNT(meal_plan)
FROM `order` AS o
LEFT JOIN meal_plan AS mp
	   ON o.meal_plan_id = mp.meal_plan_id
WHERE (o.customer_id =  o.customer_id)
AND (mp.meal_plan != mp.meal_plan);


-- Find out the number of customers who weigh over 250 pounds and order the 'Keto Plan' 
-- into their 'House'.

SELECT 
    COUNT(c.customer_id)
FROM
    `order` AS o
        INNER JOIN
    meal_plan AS mp ON o.meal_plan_id = mp.meal_plan_id
        INNER JOIN
    customer AS c ON o.customer_id = c.customer_id
        INNER JOIN
    household_type AS h ON c.household_type_id = h.household_type_id
WHERE
    c.weight > 250
        AND mp.meal_plan = 'Keto Plan'
        AND h.household_type = 'House';


-- Labeling Gary as 'Hello Gary' and Sandra as 'Hello Sandra' with CASE
SELECT 
    first_name,
    CASE
        WHEN first_name = 'Gary' THEN 'Hello Gary'
        WHEN first_name = 'Sandra' THEN 'Hello Sandra'
    END AS case_example
FROM
    customer
WHERE
     first_name IN ('Gary' , 'Sandra');
     
     
-- Which customers ordered on at least one weekend and on at least one weekday?
SELECT 
    customer_id,
    COUNT(CASE
        WHEN DAYOFWEEK(order_date) IN (1 , 7) THEN 'Weekend'
    END) AS 'weekends',
    COUNT(CASE
        WHEN DAYOFWEEK(order_date) NOT IN (1 , 7) THEN 'Weekday'
    END) AS 'weekdays'
FROM
    `order`
GROUP BY customer_id
HAVING (weekends > 0 AND weekdays > 0); 


