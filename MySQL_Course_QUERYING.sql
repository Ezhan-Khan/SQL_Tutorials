			/*  SIMPLE QUERYING PRACTICE in MySQL Workbench  */

#Find 'ALL EMPLOYEES' ordered 'BY SALARY':
SELECT *
FROM databases_tutorial.employee
ORDER BY salary DESC;

#Order 'Employees by SEX', THEN by NAME:
SELECT *
FROM databases_tutorial.employee
ORDER BY sex, first_name, last_name;

#Names of First 5 Employees in Table:
SELECT first_name, last_name
FROM databases_tutorial.employee
LIMIT 5;

#How many Genders are there?
SELECT COUNT(DISTINCT Sex) AS Genders
FROM employee;

#ALL Clients
SELECT *
FROM client
ORDER BY client_name DESC;

#Number of Employees (ONLY employees WITH Supervisor)
SELECT COUNT(*) AS 'Employees with Supervisors'
FROM employee
WHERE super_id IS NOT NULL;     

#Male Employees Born AFTER 1980:
SELECT *
FROM employee
WHERE birth_day >= '1970-01-01' AND sex = 'M';  

#'Average' of ALL 'MALE' Employee Salaries:
SELECT AVG(salary) AS 'Average Salary'
FROM employee
WHERE sex = 'M';

#SUM of ALL Employee Salaries:
SELECT SUM(salary) AS 'Total of All Salaries'
FROM employee;

#GROUPING to find COUNT of Employees for EACH SEX:
SELECT sex AS 'Gender', COUNT(emp_id) AS 'Number of Employees'
FROM employee
GROUP BY 1;      #6 Male Employees, 1 Female

 #'Total SALES' for 'EACH Salesman':
SELECT w.emp_id, e.first_name, e.last_name, SUM(w.total_sales) AS 'Total Sales'
FROM employee AS e
LEFT JOIN works_with AS w              #('LEFT' Join - want to see who is NOT a Salesperson)
ON e.emp_id = w.emp_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC;

 
                         /*  WILDCARD with LIKE '% %'  */
 
# Any CLIENT with NAME inlcuding 'LLC':
SELECT *
FROM client 
WHERE client_name LIKE '%LLC%';        # 'John Daly Law, LLC'
 
#Any Client which is a 'School':
SELECT *
FROM client 
WHERE client_name LIKE '%School%';        # 'Dunmore Highschool'

# Find any BRANCH SUPPLIERS who are in 'LABEL' Business:
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%Label%';     #'J.T. Forms & Labels'
 
#Any Employee BORN IN 'October':
SELECT *
FROM employee
WHERE birth_day LIKE '%-10-%';        #'Jim Halpert' was born in OCTOBER

 
 
			        /*  COMBINING/Aggregating Tables with 'UNION' and 'JOIN' */
#LIST of 'employee', 'branch' and 'client' Names;
SELECT first_name AS 'List of Employee, Branch and Client Names'
FROM employee
UNION 
SELECT branch_name 
FROM branch
UNION 
SELECT client_name 
FROM client;
 
#ALL MONEY SPEND/EARNY by a Company: 
SELECT salary
FROM employee
UNION 
SELECT total_sales
FROM works_with;
 
 
#    BETTER WAY to DO ALL this is with 'JOINS': 
SELECT SUM(e.salary) AS 'Total Employee Salaries', SUM(w.total_sales) AS 'Total Sales'
FROM employee AS e
JOIN works_with AS w
ON e.emp_id = w.emp_id;     #gives Total of all Employee 'Salaries' and 'Total Sales'

#inserting a NEW 'branch' value:
INSERT INTO branch VALUES (4, 'Buffalo', NULL, NULL);

#Getting ALL BRANCHES and ALL MANAGER NAMES (even if Missing):
SELECT b.branch_name AS 'Branch', e.first_name AS 'First Name' , e.last_name AS 'Last Name' 
FROM branch b
LEFT JOIN employee e      #so gives ALL 'Branches'
ON e.emp_id = b.mgr_id;     


					  /*  'NESTED' (SUB) QUERIES  */
# 'NAMES of ALL Employees' who SOLD OVER '30,000' to 'SINGLE CLIENT':
SELECT emp_id, first_name, last_name
FROM employee
WHERE emp_id IN 
( SELECT emp_id 
  FROM works_with
  WHERE total_sales > 30000);
  
#Can EVEN have a 'SUBQUERY' INSIDE the 'SELECT' Statement:
SELECT emp_id, salary, (SELECT AVG(salary) FROM employee) AS avg_salary
FROM employee;   #COMPARES 'Average Salary' TO 'salary' in EACH ROW (for EACH Employee)
#Could do SAME for 'MAX' or 'MIN' Salaries too (put into SUBQUERY). 

#EVEN, SUBQUERY INSIDE the 'FROM' Clause:
SELECT *
FROM (SELECT emp_id, first_name, last_name, branch_id FROM employee) AS Employee4All;

/* Finding ALL CLIENTS who are HANDLED BY Branch where 'Michael Scott' is MANAGER */
SELECT client_name
FROM client
WHERE branch_id IN 
(SELECT branch_id FROM employee WHERE first_name = 'Michael' AND last_name = 'Scott');

#OR, (if we ALREADY KNOW Michael Scott's 'id'):
SELECT client.client_name
 FROM client
 WHERE client.branch_id IN (SELECT branch.branch_id FROM branch
                     WHERE branch.mgr_id = 102);
#OR, using 'WITH Statement' to do this:
WITH previous AS 
(SELECT e.emp_id, b.branch_id 
FROM employee AS e
JOIN branch AS b 
ON e.emp_id = b.mgr_id
WHERE first_name = 'Michael' AND last_name = 'Scott')
SELECT previous.branch_id, c.client_name
FROM previous
JOIN client AS c
ON previous.branch_id = c.branch_id;

#Demonstraing 'ON DELETE':
DELETE FROM employee
WHERE emp_id = 102;  #Deletes 'Michael Scott' (since he left 'The Office US')
#For OTHER TABLES with ASSOCIATED FOREIGN KEY of 'emp_id = 102' - will DELETE THESE:
SELECT *
FROM branch;  #Now 'mgr_id' (Foreign Key for 'emp_id') is SET to 'NULL' (as specified in SCHEMA Table Creation!)
#for 'works_with', SET 'emp_id' Foreign Key to 'CASCADE' = ROW REMOVED:
SELECT *
FROM works_with;   #NO LONGER HAS 'emp_id = 102'  - since SET to 'CASCADE'!
















