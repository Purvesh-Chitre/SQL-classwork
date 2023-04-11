USE H_School;
SELECT distinct(grade)
FROM course_grade
;

SELECT 
    COUNT(DISTINCT(cg.student_id)) AS num_students
FROM
    student AS s
        INNER JOIN
    course_grade AS cg ON cg.student_id = s.student_id
        INNER JOIN
    term AS t ON cg.term_id = t.term_id
        INNER JOIN
    program AS p ON cg.program_id = p.program_id
        INNER JOIN
    academic_year AS a ON a.academic_year_id = t.academic_year_id
        INNER JOIN
    campus AS cm ON cg.campus_id = cm.campus_id
WHERE
    program_code = 'MSBA'
        AND a.academic_year = 'Academic Year 2019 - 2020'
        AND cm.campus_name = 'San Francisco'
;
-- 291

SELECT COUNT(course_id)
FROM course AS c
	INNER JOIN discipline AS d 
            ON d.discipline_id = c.discipline_id
         WHERE discipline = 'Quants & Data Analytics'
;
-- 82

SELECT COUNT(student_id) AS num_student_over_30
FROM student
WHERE birthdate <= DATE_SUB(CURDATE(), INTERVAL 30 YEAR)
AND sex_at_birth = 'M';
-- 3472

SELECT first_name, last_name, count(*) AS num_names
FROM student
GROUP BY first_name, last_name
ORDER BY num_names DESC;
-- Ma, San, 19

SELECT COUNT(*)
FROM program
WHERE program_title LIKE '%Master%' OR program_title LIKE '%MBA%'
;
-- 16

SELECT COUNT(DISTINCT(c.course_title)) AS num_courses
FROM course           AS c
INNER JOIN discipline AS d
        ON c.discipline_id = d.discipline_id
     WHERE d.discipline    = 'Marketing & Advertising' 
		OR d.discipline    = 'Accounting & Finance'
	   AND c.course_title != 'Thesis'
;
-- 290

SELECT cg.grade, COUNT(DISTINCT(cg.student_id)) AS num_students
FROM course_grade AS cg
INNER JOIN course AS c
ON c.course_id = cg.course_id
WHERE course_title = 'Accounting'
AND cg.grade IN ('HP' , 'NI' , 'Pass')
GROUP BY cg.grade
ORDER BY num_students DESC
;
-- Pass 730, HP 258, NI 150

SELECT     cg.grade                       AS grade, 
           c.course_title                 AS course_title, 
           COUNT(DISTINCT(cg.student_id)) AS num_students
FROM       course_grade AS cg
INNER JOIN course       AS c
        ON c.course_id = cg.course_id
     WHERE course_title = 'Data Management & SQL'
     AND   grade = 'A'
  GROUP BY grade, course_title
  ORDER BY num_students
  ;
-- grade A course_title Data Management & SQL num_students 24

SELECT (
        SELECT
                   COUNT(DISTINCT(cg.student_id)) AS num_students
		FROM       course_grade AS cg
        INNER JOIN course       AS c
                ON c.course_id = cg.course_id
			 WHERE course_title = 'Data Management & SQL'
               AND   grade = 'A')/count(distinct(cg.student_id)) * 100 AS prop_students
FROM       course_grade AS cg
INNER JOIN course       AS c
        ON c.course_id = cg.course_id
     WHERE course_title = 'Data Management & SQL'
     ;
-- 51.0638%

SELECT SUM(
       CASE
       WHEN grade = 'A' THEN 4 * credits
       WHEN grade = 'B' THEN 3 * credits
       WHEN grade = 'C' THEN 2 * credits
       WHEN grade = 'D' THEN 1 * credits
       WHEN grade = 'F' THEN 0 * credits
       END)/SUM(credits) AS avg_gpa
FROM course_grade AS cg
INNER JOIN course AS c
ON cg.course_id = c.course_id
WHERE c.course_title = 'Data Management & SQL'
;
-- avg_gpa 3.5106

SELECT s.first_name AS first_name,
       s.last_name AS last_name,
       SUM(
       CASE
       WHEN grade = 'A' THEN 4 * credits
       WHEN grade = 'B' THEN 3 * credits
       WHEN grade = 'C' THEN 2 * credits
       WHEN grade = 'D' THEN 1 * credits
       WHEN grade = 'F' THEN 0 * credits
       END)/SUM(credits) AS score
FROM course_grade AS cg
INNER JOIN term as t
ON t.term_id = cg.term_id
INNER JOIN academic_year as a
ON a.academic_year_id = t.academic_year_id
INNER JOIN program as p
ON p.program_id = cg.program_id
INNER JOIN student as s
ON s.student_id = cg.student_id
AND a.academic_year_code = 'AY19-20'
AND p.program_code = 'MSBA'
GROUP BY first_name, last_name
ORDER BY score DESC
;

       



