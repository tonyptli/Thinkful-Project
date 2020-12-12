--2. Write a query that returns the namefirst and namelast fields of the people table,
	--along with the inducted field from the hof_inducted table,
	--All rows from the people table should be returned,
	--and NULL values for the fields from hof_inducted should be returned when there is no match found.
SELECT namefirst, namelast, inducted
FROM people
LEFT OUTER JOIN hof_inducted
ON people.playerid = hof_inducted.playerid;

--3. 17 players 
SELECT namefirst, namelast, birthyear, deathyear, birthcountry
FROM people
LEFT OUTER JOIN hof_inducted
ON people.playerid = hof_inducted.playerid
WHERE yearid=2006 AND votedby='Negro League';

--4.  Keep only the records that are in both salaries and hof_inducted.  Don't use JOIN
SELECT salaries.yearid, salaries.playerid, teamid, salary, category
FROM salaries INNER JOIN hof_inducted
ON salaries.playerid=hof_inducted.playerid;

--5. Write a query that returns the playerid, yearid, teamid, lgid, and salary fields from the salaries table,
	--and the inducted field from the hof_inducted table. 
SELECT salaries.playerid, salaries.yearid, teamid, lgid, salary, inducted 
FROM salaries FULL OUTER JOIN hof_inducted
ON salaries.playerid=hof_inducted.playerid;

--6. (1)Combine these two tables by all fields. Keep all records.
SELECT *
FROM hof_inducted
UNION
SELECT *
FROM hof_not_inducted;
--6. (2)Get a distinct list of all player IDs for players who have been put up for HOF induction.
SELECT DISTINCT(playerid)
FROM hof_inducted;

--7. Write a query that returns the last name, first name (see the people table),
	--and total recorded salaries for all players found in the salaries table.
SELECT namelast, namefirst, SUM(salary) as t_salary
FROM people INNER JOIN salaries
ON people.playerid=salaries.playerid
GROUP BY namelast, namefirst;

--8. Write a query that returns all records from the hof_inducted and hof_not_inducted tables that include playerid, yearid, namefirst, and namelast.
SELECT hof_inducted.playerid, yearid, namefirst, namelast
FROM hof_inducted LEFT OUTER JOIN people
ON people.playerid=hof_inducted.playerid
UNION ALL
SELECT hof_not_inducted.playerid, yearid, namefirst, namelast
FROM hof_not_inducted LEFT OUTER JOIN people
ON people.playerid=hof_not_inducted.playerid;

--9. Include a new field, namefull, which is formatted as namelast , namefirst 
	--(in other words, the last name, followed by a comma, then a space, then the first name). 
	--yearid and inducted;  since 1980;  Sort the resulting table by yearid, then inducted, namefull field alphabetically

WITH hof AS
(
	SELECT CONCAT(namelast, ', ',namefirst) AS namefull, yearid, inducted
	FROM hof_inducted LEFT OUTER JOIN people
	ON people.playerid=hof_inducted.playerid
UNION ALL
	SELECT CONCAT(namelast, ', ',namefirst) AS namefull, yearid, inducted
	FROM hof_not_inducted LEFT OUTER JOIN people
	ON people.playerid=hof_not_inducted.playerid
)
SELECT * FROM hof
WHERE yearid>=1980
ORDER BY yearid, inducted DESC, namefull;

--10. Write a query that returns each year's highest annual salary for each team ID, 
	--ranked from high to low, along with the corresponding player ID. 
	--Bonus: Return namelast and namefirst in the resulting table. (people table)
WITH max_s AS
(
	SELECT teamid, yearid, MAX(salary) AS max_salary
	FROM salaries
	GROUP BY teamid, yearid
)
SELECT max_s.teamid, max_s.yearid, salaries.playerid, namelast, namefirst, max_salary
FROM max_s 
LEFT OUTER JOIN salaries
ON max_s.teamid = salaries.teamid AND max_s.yearid=salaries.yearid AND max_s.max_salary=salaries.salary

LEFT OUTER JOIN people
ON salaries.playerid=people.playerid

ORDER BY max_salary DESC;

--ANSWER same
WITH max AS
(SELECT MAX(salary) as max_salary, teamid, yearid
FROM salaries
GROUP BY teamid, yearid)
SELECT salaries.yearid, salaries.teamid, salaries.playerid, namelast, namefirst, max.max_salary
FROM salaries LEFT OUTER JOIN people
ON salaries.playerid = people.playerid
RIGHT OUTER JOIN max
ON salaries.teamid = max.teamid AND salaries.yearid = max.yearid AND salaries.salary = max.max_salary
ORDER BY max.max_salary DESC;

--11. Select birthyear, deathyear, namefirst, and namelast of all the players born since the birth year of Babe Ruth 
	--(whose playerid is ruthba01). Sort the results by birth year from low to high.
SELECT birthyear, deathyear, namefirst, namelast
FROM people
WHERE birthyear >= ALL
	(SELECT birthyear
	 FROM people
	 WHERE playerid = 'ruthba01')
ORDER BY birthyear;

--12. Using the people table, write a query that returns namefirst, namelast, and a field called usaborn. 
SELECT namefirst, namelast,
CASE 
	WHEN birthcountry = 'USA' THEN 'USA'
	ELSE 'non-USA'
END AS usaborn
FROM people
ORDER BY usaborn;

--13. Calculate the average height for players throwing with their right hand versus their left hand.
SELECT 
ROUND(AVG(CASE WHEN throws ='R' THEN height END),2) AS right_height,
ROUND(AVG(CASE WHEN throws ='L' THEN height END),2) AS left_height
FROM people;

--14. Get the average of each team's maximum player salary since 2010. Hint: WHERE will go outside of your CTE.
WITH max_tsalary AS
(
	SELECT teamid, yearid, MAX(salary) AS max_salary
	FROM salaries
	GROUP BY teamid, yearid
)
SELECT teamid, AVG(max_salary) AS avg_salary
FROM max_tsalary
WHERE yearid>=2010
GROUP BY teamid;