USE H_Baseball;

/*
Q17. Reverse the query above. In other words, find the proportion of:
    * players with below average salaries in 2011
    * salary of the players that earned less than the average salary in 2011
*/

SELECT (
       SELECT
              COUNT(*)
       FROM   players
       WHERE  `year` = 2011
       AND    salary < (
					  SELECT AVG(salary)
                      FROM   players
					  WHERE `year` = 2011
                      ))
                       / COUNT(*) AS prop_players,
		(
        SELECT ROUND(SUM(salary) / 1000000, 0)
        FROM   players
        WHERE  `year` = 2011
        AND    salary < (
					   SELECT AVG(salary)
                       FROM   players
                       WHERE  `year` = 2011
                       ))
                        / ROUND(SUM(salary) / 1000000, 0) AS prop_salary
	  FROM players
      WHERE `year` = 2011
      ORDER BY prop_players, prop_salary
      ;
      
USE H_Trifecta;

/* Q3. Show the first and last names of each customer, as well as
their household type and income range.
*/

SELECT c.first_name,
       c.last_name,
       h.household_type,
       c.income_range
FROM   customer AS c
    INNER JOIN household_type AS h
            ON c.household_type_id = h.household_type_id
ORDER BY first_name, last_name, household_type, income_range
;

/*
Q4. Show the first and last names of each customer, as well as
their household type for customers that are NOT employed full time
and the delivery was to an office.
*/

SELECT c.first_name,
	   c.last_name,
       h.household_type,
       mp.meal_plan
       FROM       customer        AS c
       INNER JOIN household_type  AS h
               ON c.household_type_id = h.household_type_id
	   INNER JOIN `order`       AS o
               ON c.customer_id = o.customer_id
	   INNER JOIN meal_plan       AS mp
               ON o.meal_plan_id = mp.meal_plan_id
	WHERE c.is_full_time_employment_status = 0
      AND h.household_type LIKE ('%Office%')
ORDER BY c.first_name
;

/*
Q6. How many customers ordered at least one breakfast that were on the Keto meal 
plan?
    * Show the name of the meal plan (not the id)
    * Use GROUP BY and HAVING
    Tip: The correct answer is 134
*/
-- aggregating with order table customer_id
-- Q7. Let's query to find how many customers only order lunch,
  --  as well as which meal plans they are ordereing.


--
USE H_Baseball;

SELECT `year`,
       team,
       SUM(salary)
FROM   players
GROUP BY `year`, team
ORDER BY `year` ASC, team DESC
;

SELECT team, COUNT(player_id) as num_players
FROM players
GROUP BY team
HAVING num_players > 75
;

SELECT team,
       SUM(salary) as sum_salary
FROM   players
WHERE  `year` = 2009
GROUP BY team
HAVING  sum_salary > 120000000
;

SELECT position, team
FROM   players
WHERE  `year` = 2011
  AND  salary = (
                 SELECT MIN(salary)
                 FROM   players
                 WHERE `year` = 2011
                 AND    team LIKE ('%cs')
                 )
;

USE H_School;
SELECT *
FROM academic_year;

SELECT 
    *
FROM
    course;


SELECT a.academic_year  AS academic_year, 
       t.term           AS term,
       s.first_name     AS first_name,
       s.last_name      AS last_name,
       c.course_id      AS course_id,
       cg.grade         AS grade,
       c.course_title   AS course_title
FROM   academic_year    AS a 
INNER JOIN term         AS t
        ON a.academic_year_id = t.academic_year_id
INNER JOIN course_grade AS cg
        ON cg.term_id = t.term_id
INNER JOIN student      AS s
        ON cg.student_id = s.student_id
INNER JOIN course as c
		ON cg.course_id = c.course_id
WHERE s.first_name    LIKE ('P%')
AND (cg.grade = 'A' OR cg.grade = 'F')
AND a.academic_year != ('Academic Year 2019 - 2020')
AND c.course_id = 168801
;





