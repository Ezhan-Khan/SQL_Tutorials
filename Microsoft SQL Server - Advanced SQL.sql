                /*   MORE 'ADVANCED' SQL   */

/* PARTITION BY */   
--DIVIDES into PARTITIONS, while 'KEEPING ROWS' (unlike 'GROUP BY' which REDUCES Number of Rows)
SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER 
(PARTITION BY Gender) AS 'Total Gender'
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
JOIN [SQL Server Tutorial].dbo.EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
--same as 'group by' but KEEPS ORIGINAL ROWS!
--COMPARE to GROUP BY (below):
SELECT Gender, COUNT(Gender)
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
JOIN [SQL Server Tutorial].dbo.EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
GROUP BY Gender;   --SAME ANSWER, but REDUCED ROWS!


/*  COMMON TABLE EXPRESSIONS (CTE)   */
--also called 'WITH' Statement!
WITH CTE_Employee AS (
SELECT FirstName, LastName, Gender, Salary, 
       COUNT(gender) OVER (PARTITION BY Gender) AS TotalGender,
	   AVG(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
JOIN [SQL Server Tutorial].dbo.EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
WHERE Salary > 45000)
SELECT *
FROM CTE_Employee;   
--Note CTE Table is NOT SAVED. ONLY as PART of CTE WHEN RUN!

/* TEMPORARY TABLE - 
(similar to CTE, but is actually SAVED as NEW TABLE to be RUN SEPARATELY!)
Done with 'CREATE TABLE', followed by '#temp_table' (HASHTAG creates the Temp Table - ONLY NEW thing!) */
DROP TABLE IF EXISTS #temp_Employee;
CREATE TABLE #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)
INSERT INTO #temp_Employee VALUES (
1001, 'HR', 45000)
--Now, Viewing the Table Contents:
SELECT *
FROM #temp_Employee  --just RUN as usual!

--Can INSERT Data FROM SUBQUERY 'SELECT' Statement (e.g. All Employee Salary):
INSERT INTO #temp_Employee 
SELECT *
FROM [SQL Server Tutorial].dbo.EmployeeSalary;

SELECT *
FROM #temp_Employee;

--More Temp Table Practice, saving Aggregate Query AS a Temp Table:
DROP TABLE IF EXISTS #temp_Employee2;
CREATE TABLE #temp_Employee2 (
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #temp_Employee2 
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
JOIN [SQL Server Tutorial].dbo.EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
GROUP BY JobTitle;

-- Can USE Temp Tables in 'STORED PROCEDURES' (Covered later below):
--e.g. Get up Stored Procedure, Run it, get Error if run again (since 'Temp Table Already Exists')
--SO? - add 'DROP TABLE IF EXISTS' at TOP of Script (as done above - cool!)


        /*  STRING FUNCTIONS - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower  */
--SIMPLE! - use these to CLEAN UP Messy/Unstructured Data. E.g.
DROP TABLE IF EXISTS EmployeeErrors;
USE [SQL Server Tutorial];
CREATE TABLE EmployeeErrors (
EmployeeID varchar(50), 
FirstName varchar(50),
LastName varchar(50)
);
INSERT INTO EmployeeErrors VALUES
('1001    ', 'Jimbo', 'Halbert'),
('    1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired');

-- TRIM, LTRIM, RTRIM (remove blank spaces in Strings)
SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors;
SELECT EmployeeID, LTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors;   --Trims any blank space on LEFT
SELECT EmployeeID, RTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors;   --no blank space on RIGHT, so NOT Trimmed

-- Replace (remove all occurances of string with something else)
SELECT LastName, REPLACE(LastName, ' - Fired', '') AS LastNameFixed
FROM EmployeeErrors;

-- Substring
SELECT SUBSTRING(FirstName, 3, 3)    --First 3 Characters Substring
FROM EmployeeErrors;

--'FUZZY-MATCHING' e.g. 'ALEX' in one table, 'ALEXANDER' in ANOTHER
--HOW can we still JOIN both TABLES, EVENTHOUGH NAMES are DIFFERENT???
SELECT ee.FirstName, ed.FirstName   
FROM EmployeeErrors ee
JOIN EmployeeDemographics ed
ON ee.FirstName = ed.FirstName;
--DOES NOT JOIN! 'FirstNames' are DIFFERENT so WONT MATCH!
--So? Just JOIN on 'SUBSTRING' from BOTH! (1-3):
SELECT ee.FirstName, SUBSTRING(ee.FirstName, 1, 3), SUBSTRING(ed.FirstName, 1, 3)
FROM EmployeeErrors ee
JOIN EmployeeDemographics ed
ON SUBSTRING(ee.FirstName,1,3) = SUBSTRING(ed.FirstName, 1, 3);
--Note - SHOULD Fuzzy Match with MORE FIELDS, ON - 'Gender', 'Age', 'LastName', 'DOB'.
--       MORE INFO Added = BETTER MATCH! Good!

--UPPER or LOWER (case) - Very Simple, no need to demonstrate!



                   /* STORED PROCEDURES */
--  = GROUP of SQL Statements, which is Created and STORED within that Database. 
CREATE PROCEDURE TEST
AS 
SELECT *
FROM EmployeeDemographics;
--RUN the Stored Procedure with 'EXEC' stored_procedure_name
EXEC TEST;    --simple!

--Example 2 (Adding a 'TEMP TABLE' into a Stored Procedure (COMMON USE!))

CREATE PROCEDURE Temp_Employee
AS
BEGIN
DROP TABLE IF EXISTS #temp_employee;
CREATE TABLE #temp_employee (
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int)
INSERT INTO #temp_employee 
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM [SQL Server Tutorial].dbo.EmployeeDemographics ed
JOIN [SQL Server Tutorial].dbo.EmployeeSalary es
ON ed.EmployeeID = es.EmployeeID
GROUP BY JobTitle;
SELECT *
FROM #temp_employee;
END
--End Stored Procedure here

EXEC Temp_Employee;



                    /*  SUBQUERIES  */
SELECT *
FROM EmployeeSalary;
--1. Subquery in 'SELECT' Statement :
SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) AS All_Average_Salary
FROM EmployeeSalary;
--(like Window Function in a way! Shows Subquery 'AVG' ALONGSIDE Other Results)
--ALSO can be DONE using 'EMPTY WINDOWS FUNCTION':
SELECT EmployeeID, Salary, AVG(Salary) OVER ()
FROM EmployeeSalary;   --Same Answer! Just another way to do this!

--2. Subquery in 'FROM' Statement (NOT RECOMMENDED):
SELECT a.EmployeeID, AllAvgSalary
FROM (SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AllAvgSalary
      FROM EmployeeSalary) AS a
--Note - here, a CTE or TEMP TABLE is MORE EFFICIENT/QUICKER and REUSABLE!

--3. Subquery in 'WHERE' (USEFUL!)
--e.g. All Employees with Age ABOVE 30. 
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID IN (SELECT EmployeeID FROM EmployeeDemographics WHERE Age > 30)
--ALTERNATIVE would be a JOIN STATEMENT (BOTH WORK WELL!!!)



