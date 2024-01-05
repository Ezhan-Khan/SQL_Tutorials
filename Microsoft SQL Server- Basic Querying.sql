
--                     BASICS:
/*
Demonstrate use of
'TOP', 'DISTINCT', 'AS', 'MAX', 'MIN', 'AVG'
*/
--Top 3 Employees from Demographics Table:
SELECT TOP(3) *
FROM [SQL Server Tutorial].dbo.EmployeeDemographics;

--Distinct Genders in the Table:
SELECT DISTINCT(Gender) AS 'Genders'
FROM [SQL Server Tutorial].dbo.EmployeeDemographics;

--COUNT all Non-Null Values for 'LastName':
SELECT COUNT(LastName) AS 'Count of Last Names'
FROM [SQL Server Tutorial].dbo.EmployeeDemographics
--(also used 'AS' to ALIAS the Column with New Name)

--What are the MINIMUM, MAXIMUM and AVERAGE Salaries?
SELECT MIN(Salary) AS 'Minimum Salary'
FROM EmployeeSalary;  -- $36,000 is lowest salary
SELECT MAX(Salary) AS 'Maximum Salary'
FROM EmployeeSalary;  -- $65,000 is highest salary
SELECT AVG(Salary) AS 'Average Employee Salary'
FROM EmployeeSalary;  -- $48,555 is Average Employee Salary


/*Where Statement*/
SELECT *
FROM EmployeeDemographics
WHERE FirstName != 'Jim';

SELECT *
FROM EmployeeDemographics 
WHERE Age <= 31 AND Gender = 'Male';

--Just Last Names Starting with 'S':
SELECT *
FROM EmployeeDemographics 
WHERE LastName LIKE 'S%';  
--Just Last Names with 'o' WITHIN TOO:
SELECT *
FROM EmployeeDemographics 
WHERE LastName LIKE 'S%o%';  

--Where ... IS NULL (or 'NOT NULL')

-- Where ... IN (specific values)
SELECT *
FROM EmployeeSalary
WHERE JobTitle IN ('Salesman', 'Receptionist');


/*Group By, Order By */
SELECT Gender, COUNT(*) AS 'Count'
FROM EmployeeDemographics
GROUP BY Gender   --How many employees for each gender?
ORDER BY Count DESC;  

--How many with Salary above 40k?
SELECT JobTitle, COUNT(*) AS 'Count'
FROM EmployeeSalary
WHERE Salary > 40000
GROUP BY JobTitle;
-- Trying out PARTITION BY (Windows Function):
SELECT JobTitle, SUM(SALARY) OVER
(ORDER BY JobTitle)
AS 'Total Salary'
FROM EmployeeSalary;

--Ordering by 'Age' AND 'Gender':
SELECT *
FROM EmployeeDemographics
ORDER BY Age, Gender;




















