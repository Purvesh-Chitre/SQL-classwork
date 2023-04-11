USE H_School; -- using H_School database


SELECT COUNT(*) -- counting the total number of rows
FROM   course_grade -- from course_grade table
;
-- result: 50000

DESC course_grade; -- used to find the details of the course_grade table
-- result from response shows 8 rows, which is 8 columns

SELECT COUNT(DISTINCT first_name) AS num_of_students -- counting the number of unique first name students
FROM   student -- from student table
;
-- result: 358

SELECT COUNT(*)
FROM student
WHERE birthdate IS NOT NULL;

SELECT *
FROM discipline;

SELECT COUNT(*)
FROM student AS s
INNER JOIN course_grade as cg
ON s.student_id = cg.student_id
INNER JOIN course as c
ON c.course_id = cg.course_id
INNER JOIN discipline as d
ON d.discipline_id = c.discipline_id
WHERE d.discipline LIKE ('%e%')
AND d.discipline LIKE ('%&%')
;

SELECT *
FROM course_grade
WHERE credits = (
SELECT MIN(credits)
from course_grade)
ORDER BY student_id ASC
LIMIT 1
OFFSET 3
;

SELECT COUNT(c.course_title) as cnt
FROM course AS c
LEFT JOIN discipline AS d
ON c.discipline_id = d.discipline_id
WHERE c.course_title = 'Driven'
;

SELECT COUNT( CASE
             WHEN grade IN ('A', 'AU', 'PA', 'B+', 'B') THEN 'Needs More Challenge' 
             END) AS 'Neede More Challenge',
	   COUNT(CASE
             WHEN grade IN ('C+','C','HP','P','Pass') THEN 'Hard Work is Paying Off' 
             END) AS 'Hard Work is Paying Off',
	   COUNT(CASE
             WHEN grade NOT IN ('A','AU','PA','B+','B','C+','C','HP','P','Pass') THEN 'Needs Guidance'
             END)AS 'Needs Guidance'
		FROM course_grade
        ;
SELECT *
FROM campus;

SELECT COUNT(DISTINCT s.student_id) AS unique_num_students
FROM course_grade AS cg
inner join student as s
on s.student_id = cg.student_id
INNEr join campus as cm
on cm.campus_id = cg.campus_id
inner join program as p
on p.program_id = cg.program_id
where p.program_title = 'Master of International Business'
and cm.campus_code IN ('BOS', 'LON')
;

