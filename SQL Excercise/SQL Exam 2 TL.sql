--SQL Self-sufficiency exam by Tony Li

--Data exploration
--1. 

SELECT *
FROM naep;

--2. 

SELECT *
FROM naep
LIMIT 50;

--3. 

SELECT ROUND(AVG(avg_math_4_score),3) AS avg_avg_math_4_score, MAX(avg_math_4_score) AS max_avg_math_4_score,
	MIN(avg_math_4_score) AS min_avg_math_4_score, COUNT(avg_math_4_score) AS year_count, state
FROM naep
GROUP BY state
ORDER BY state;

--4. 

SELECT AVG(avg_math_4_score) AS avg_avg_math_4_score, MAX(avg_math_4_score) AS max_avg_math_4_score,
	MIN(avg_math_4_score) AS min_avg_math_4_score, COUNT(avg_math_4_score) AS year_count, state
FROM naep
GROUP BY state
HAVING MAX(avg_math_4_score) - MIN(avg_math_4_score) > 30
ORDER BY state;

--Analyzing your data
--5. 

SELECT state, avg_math_4_score
FROM naep
WHERE year = 2000
ORDER BY avg_math_4_score
LIMIT 10;

--6. 

SELECT ROUND(AVG(avg_math_4_score), 2) AS average_avg_math_4_score, year
FROM naep
WHERE year = 2000
GROUP BY year;

--7. 

SELECT state AS below_average_states_y2000, avg_math_4_score
FROM naep
WHERE avg_math_4_score < ALL
	(
		SELECT AVG(avg_math_4_score)
		FROM naep
		WHERE year = 2000
	)
	AND year = 2000
GROUP BY state, avg_math_4_score;

--8. 

SELECT state AS scores_missing_y2000
FROM naep
WHERE avg_math_4_score IS NULL AND year = 2000;

--9. 

SELECT naep.state, ROUND(avg_math_4_score, 2) AS avg_math_4_score, total_expenditure
FROM naep LEFT OUTER JOIN finance
ON naep.id = finance.id
WHERE avg_math_4_score IS NOT NULL AND naep.year = 2000
ORDER BY total_expenditure DESC;