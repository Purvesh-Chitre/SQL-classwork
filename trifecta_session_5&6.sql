USE H_Trifecta;
-- -------------------------------------- --
-- -------------------------------------- --
-- Session 5 - Joins with H_Trifecta      --
-- -------------------------------------- --
-- -------------------------------------- --
/*
DAT-5486: Data Management & SQL
Prof. Chase Kusterer
Hult Interntational Business School
*/
-- -------------------------------------- --
-- -------------------------------------- --
-- Part I - Understanding Tables and Keys --
-- -------------------------------------- --
-- -------------------------------------- --
/*
Q1. The following can be utlized to develop an ER Diagram.
*/
-- accessing the database
USE H_Trifecta;
-- understanding attributes and keys
DESC customer;  -- DESCRIBE / DESC --
DESC household_type;
DESC meal_plan;
DESC `order`;
DESC race;
-- ----------------------- --
-- UNDERSTANDING JOIN DATA --
-- ----------------------- --
/*
Q2. Run the following queries to observe a critical database concept.
*/
SELECT COUNT(customer_id) AS num_customers
FROM   customer;
SELECT COUNT(customer_id) AS num_customers
FROM   `order`;
-- -------------------- --
-- -------------------- --
-- Part II - INNER JOIN --
-- -------------------- --
-- -------------------- --
/*
Q3. Show the first and last names of each customer, as well as
their household type and income range.
*/
SELECT c.first_name,
       c.last_name,
       h.household_type,
       c.income_range
FROM   customer           AS c
INNER JOIN household_type AS h
        ON c.household_type_id = h.household_type_id
;
/*
Q4. Show the first and last names of each customer, as well as
their household type for customers that are NOT employed full time
and the delivery was to an office.
*/
SELECT             c.first_name,
				   c.last_name,
                   h.household_type,
                   c.income_range
FROM               customer         AS c
INNER JOIN         household_type   AS h
        ON         c.household_type_id = h.household_type_id
        WHERE      c.is_full_time_employment_status = 0
        AND        h.household_type LIKE '%office%'
;
/*
Q5. How many customers are of each household type?
    * SELECT the following:
        * household_type (AS type)
        * a count of customers (AS num_customers)
    * Use an INNER JOIN
    * Sort by type of customer (descending)
*/
-- spreading out the query below
-- --------------------------------
-- --------------------------------
-- SELECT, FROM
SELECT household_type     AS 'type',
       COUNT(customer_id) AS num_customers
FROM   household_type     AS h
-- JOIN
INNER JOIN customer       AS c
       ON  h.household_type_id = c.household_type_id
-- GROUP BY, ORDER BY
GROUP BY `type`
ORDER BY num_customers DESC
-- ending statement
;
-- --------------------------------
-- --------------------------------
/*
Q6. How many customers ordered at least one breakfast that were on the Keto meal 
plan?
    * Show the name of the meal plan (not the id)
    * Use GROUP BY and HAVING
    Tip: The correct answer is 134
*/
-- aggregating with order table customer_id
SELECT        mp.meal_plan,
              COUNT(DISTINCT(customer_id))
FROM          meal_plan    AS mp
INNER JOIN    `order`      AS o
        ON    mp.meal_plan_id = o.meal_plan_id
        WHERE mp.meal_plan LIKE '%keto%' 
		  AND breakfast >= 1
	 GROUP BY meal_plan
        ;
/*
Q7. Let's query to find how many customers only order lunch,
    as well as which meal plans they are ordereing.
*/
DESC `order`;
-- this is a good idea to better understand what results to expect
SELECT DISTINCT(meal_plan)
FROM   meal_plan;
-- meal plan types that included lunch
SELECT mp.meal_plan,
       COUNT(DISTINCT(o.customer_id)) AS num_customers
FROM          meal_plan       AS mp
INNER JOIN   `order`          AS o -- INNER is optional (but good practice)
        ON    mp.meal_plan_id = o.meal_plan_id
WHERE         o.lunch         >= 0
	   AND    o.breakfast      = 0
       AND    o.`3rd_entree`   = 0
       AND    o.dinner         = 0
GROUP BY      meal_plan
ORDER BY      num_customers   DESC;
-- ------------- --
-- ------------- --
-- Team Practice --
-- ------------- --
-- ------------- --
/*
Q8. How many customers ordered at least one breakfast,
     one lunch, one dinner, and one 3rd entree?
*/
-- make sure to write a comment here
SELECT 
       COUNT(DISTINCT(o.customer_id)) AS num_customers
FROM          meal_plan       AS mp
INNER JOIN   `order`          AS o -- INNER is optional (but good practice)
        ON    mp.meal_plan_id = o.meal_plan_id
WHERE         o.lunch         >= 1
	   AND    o.breakfast     >= 1
       AND    o.`3rd_entree`  >= 1
       AND    o.dinner        >= 1

ORDER BY      num_customers   DESC;
/*
Q9. What meal plans were the customers on from the previous query?
    * Show the name of each meal plan
*/
-- don't forget a comment here either
SELECT mp.meal_plan,
       COUNT(DISTINCT(o.customer_id)) AS num_customers
FROM          meal_plan       AS mp
INNER JOIN   `order`          AS o -- INNER is optional (but good practice)
        ON    mp.meal_plan_id = o.meal_plan_id
WHERE         o.lunch         >= 1 -- lunch
	   AND    o.breakfast     >= 1 -- breakfast
       AND    o.`3rd_entree`  >= 1 -- 3rd_entree
       AND    o.dinner        >= 1 -- dinner
GROUP BY      meal_plan
ORDER BY      num_customers   DESC;
-- -------------------- --
-- -------------------- --
-- Part III - LEFT JOIN --
-- -------------------- --
-- -------------------- --
/*
Q10. Run the following queries to experience the following:
    * INNER JOIN
    * LEFT OUTER JOIN
    * RIGHT OUTER JOIN
*/
-- 856 customers
SELECT COUNT(*)
FROM   customer;
-- 14516 customer orders
SELECT      COUNT(*)
FROM        customer AS c
INNER JOIN `order`   AS o
        ON  c.customer_id = o.customer_id;
-- 14516 customer orders
SELECT           COUNT(*)
FROM             customer AS c
LEFT OUTER JOIN `order`   AS o
             ON  c.customer_id = o.customer_id;
-- 14516 customer orders
SELECT      COUNT(*)
FROM        customer AS c
RIGHT JOIN `order`   AS o                 -- OUTER is optional
		ON  c.customer_id = o.customer_id;
-- 14516 customer orders
-- ---------- --
-- ---------- --
-- CASE STUDY --
-- ---------- --
-- ---------- --
/*
Trifecta would like to run a special promotion for all clients that are
at least 60 years old (from today's date). They estimate that this is approximately
10% of their
customers.
*/
/*
Q11. Check to see if this audience is approximately 10% of all customers.
     (Use a join and a subquery.)
The folowing SQL syntax will help in finding the target audience:
    * DATE_SUB(CURDATE(), INTERVAL ____ YEAR)
    * Useful date/time documentation:
        * https://dev.mysql.com/doc/refman/8.0/en/expressions.html#temporal-
intervals
*/
SELECT '1992-12-30';
SELECT DATE_SUB(CURDATE(), INTERVAL 60 YEAR);
-- connecting to the database (optional)
USE H_Trifecta;
SELECT *
FROM   customer;
-- Step 1 of 3: Count of all customers
SELECT COUNT(DISTINCT(customer_id))
FROM   customer;
-- result 856
-- Step 2 of 3: Count of customers over 60 years old
SELECT COUNT(DISTINCT(customer_id))
FROM customer
WHERE date_of_birth <= (SELECT DATE_SUB(CURDATE(), INTERVAL 60 YEAR));
-- result 86
-- Step 3 of 3: Putting these together with a subquery
SELECT (
        SELECT COUNT(DISTINCT(customer_id))
		FROM   customer
		WHERE  date_of_birth <= (SELECT DATE_SUB(CURDATE(), INTERVAL 60 YEAR))
        )
	    / COUNT(DISTINCT(customer_id)) AS percent_customer
FROM customer
;
-- reuslt 0.1016 = 10.16%
/*
Q12. Let's refine the target audience to better fit with the goals of Trifecta.
     Filter out free trials in both the subqery and the main query.
         * Is this still 10% of the customers?
         * What other insights can we gain from this query?
Tip: This is an extension of the previous query.
*/
SELECT    is_free_trial,
          COUNT(DISTINCT(customer_id))
FROM      `order`
WHERE     is_free_trial = 0
GROUP BY  is_free_trial;
-- result 495
SELECT       COUNT(DISTINCT(c.customer_id)) AS total_customers
FROM         customer                       AS c
     JOIN   `order`                         AS o
       ON    c.customer_id = o.customer_id
    WHERE    c.date_of_birth < DATE_SUB(CURDATE(), INTERVAL 60 YEAR)
      AND    o.is_free_trial = 0
;
-- result 25
SELECT   (SELECT       COUNT(DISTINCT(c.customer_id))
		 FROM          customer AS c
		 INNER JOIN    `order` AS o
				 ON    c.customer_id = o.customer_id
			  WHERE    date_of_birth < DATE_SUB(CURDATE(), INTERVAL 60 YEAR)
				AND    o.is_free_trial = 0
		  )
			/ COUNT(DISTINCT(c.customer_id)) AS total_customers  -- all customers NOT on FT
FROM     customer     AS c
JOIN     `order`      AS o
  ON     c.customer_id = o.customer_id
WHERE    o.is_free_trial = 0  -- NOT free trial
; 
-- result 0.0505 = 5.05%
/*
Q13. Explain how you would present your results to someone
     that was confident this age group made up 10% of customers
     and wanted to develop a new strategy for them.
     
     Note that there is no query needed for this question.
     -- As this is regarding the number of people on the free trial we got the number down by half for the  
     total number of people not in the free trial. After which we narrow down the number to people who are over 
     the age of 60 but not part of the free trial. After getting this we were able to get a percentage of the
     people over 60 not part of free trial and we can conclude that they are at 5.05% which is less than 10%. --
