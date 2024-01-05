           /*   INTERMEDIATE SQL   */

-- Inner Joins, Full/Left/Right Outer Joins:

SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics AS ed
INNER JOIN EmployeeSalary AS es
ON ed.EmployeeID = es.EmployeeID;  
--Joins MATCHING Rows ONLY!
--'FULL OUTER' Joins returns ALL from BOTH TABLES:
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
FULL OUTER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID;

--LEFT Outer Join returns ALL from LEFT Table:
--(Unmatched records from RHS Table are given 'NULL')
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
LEFT OUTER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID;
--see ALL from 'EmployeeDemographics' here.

--Selecting SPECIFIC Joined Columns only:
SELECT ed.EmployeeID, FirstName, LastName, JobTitle, Salary
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
LEFT OUTER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
WHERE FirstName != 'Michael'
ORDER BY Salary DESC;

--Average Salary for 'Salesman':
SELECT JobTitle, AVG(Salary) AS 'Average Salary'
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
INNER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle;   -- Average Salesman Salary of '52000'
--Below, WITHOUT Joining:
SELECT JobTitle, AVG(Salary) OVER (
ORDER BY JobTitle) AS Average_Salary
FROM [SQL Server Tutorial].dbo.EmployeeSalary
WHERE JobTitle = 'Salesman' AND EmployeeID IS NOT NULL;  
-- (ignored the Salesman with NULL EmployeeID, so is SAME as when 'INNER JOINED'!)


/* UNION - Combining/STACKING (not by column) */
--First, Outer Join 'EmployeeDemographics' and 'WarehouseEmployeeDemographics'
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics e
FULL OUTER JOIN [SQL Server Tutorial].dbo.WarehouseEmployeeDemographics w
ON e.EmployeeID = w.EmployeeID;
--BOTH Tables have SAME COLUMNS. 
-- HOW can we get ALL the Same INFO into SAME COLUMNS?
--Use UNION to STACK the Columns VERTICALLY:
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics
UNION
SELECT *
FROM [SQL Server Tutorial].dbo.WarehouseEmployeeDemographics 
ORDER BY EmployeeID;
--Using 'UNION ALL' will KEEP DUPLICATES (here, for 'Daryl Philbin', he is in BOTH TABLES, so UNION ALL would KEEP BOTH of his SAME Records!)
--But, USUALLY WONT WANT any DUPLICATES!


             /* CASE Statement */
SELECT FirstName, LastName, Age,
CASE
    WHEN Age = 38 THEN 'Did I Stutter?'
    WHEN Age > 30 THEN 'Senior Employee'
	WHEN Age BETWEEN 27 AND 30 THEN 'Junior Employee'
	ELSE 'Intern'
	END AS 'Company Experience'
FROM [SQL Server Tutorial].dbo.EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

--Each Employee will get a different Raise, depending on Job Title:
SELECT FirstName, LastName, JobTitle, Salary,
CASE 
    WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
    WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * 0.0001)
	ELSE Salary + (Salary * 03)
	END AS 'New Salary (after raise)'
FROM EmployeeDemographics ed
INNER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID


/* HAVING Clause (after GROUP)*/
SELECT JobTitle, COUNT(JobTitle) AS 'Count'
FROM EmployeeDemographics ed
INNER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1;
--'HAVING' selects Employee JobTitle Count GREATER THAN 1 - SIMPLE!

--repeating, now for 'Average Salary' ABOVE 45000
SELECT JobTitle, AVG(Salary) AS 'Average'
FROM EmployeeDemographics ed
INNER JOIN EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000;


           /* UPDATING and DELETING Data */
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics
--UPDATE EmployeeDemographics to FILL IN the 'NULL' Values:
UPDATE EmployeeDemographics 
SET EmployeeID = 1012, Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax';

--OR, can DELETE an ENTIRE ROW (USE WITH CAUTION!):
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics
WHERE EmployeeID = 1005;  --First, CHECK WHAT we are DELETING, so it isnt permenantly deleted by accident!
DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1005;
INSERT INTO EmployeeDemographics VALUES
(1005, 'Toby', 'Flenderson', 32, 'Male')

--Quick Example to Demonstrate HOW USEFUL 'Aliasing' is:
--JOIN all 3 Tables 'EmployeeDemographics', 'WarehouseEmployeeDemographics' and 'EmployeeSalary'
SELECT ed.EmployeeID, ed.FirstName,
       wd.FirstName, es.JobTitle, 
	   wd.Age
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
LEFT JOIN [SQL Server Tutorial].dbo.EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
LEFT JOIN [SQL Server Tutorial].dbo.WarehouseEmployeeDemographics wd
ON ed.EmployeeID = wd.EmployeeID;





