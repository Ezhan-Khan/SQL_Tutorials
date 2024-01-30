               /*   EASY SQL Questions   */

--Note: this is just query-writing and practice, so queries cannot be run.

--            Question 1:
--inspect cars yearly to check if legal.
--IF critical issue, FAILS inspection. OR IF 3 Minor Issues will FAIL
--query to ONLY select cars which PASS inspection 
--include OWNER Name and VEHICLE Name in results, Order BY Owner Name Alphabetically

SELECT owner_name, vehicle
FROM inspections
WHERE critical_issues = 0 
AND minor_issues <= 3
ORDER BY owner_name ASC;

--           Question 2:
--computer store, offers 25% Discount
--applies IF new customers OVER 65 years old 
--OR customer who spends ABOVE $200 on FIRST purchase.
--'HOW MANY CUSTOMERS recieved this discount?'

SELECT COUNT(customer_id)
FROM customers
WHERE age > 65 OR total_purchase > 200;

                       /*  Interview Tip:  */
--during the interview, would TALK THROUGH the Question WITH the Interviewer
--explain your thought-process, use '--' notes to help explain what is done!


                      /*  MEDIUM SQL Questions  */

--            Question 1:
--tech companies laying off employees 
--find % of Employees laid off from EACH company
--include company and % (rounded to 2dp) laid off, ordered alphabetically

SELECT company, ROUND((employee_fired/company_size)*100,2) AS 'percentage_laid_off'
FROM tech_layoffs
ORDER BY company;

--AGAIN, the MOST IMPORTANT PART in interviews is TALKING THROUGH the PROCESS!
--as done above, BREAK DOWN the QUESTION into parts, ensure ALL PARTS are ANSWERED

--            Question 2:
--Data was INCORRECTLY INPUTTED into a Database
--ID column COMBINED with First_Name (common problem when importing CSV or Excel Files)
--SEPARATE 'ID' and 'First_Name' into 2 Separate Columns
--note: EACH ID is 5 Characters Long
SELECT id, SUBSTRING(id, 1,5) AS 'ID', 
           SUBSTRING(id, 6, LEN(id)) AS 'First_Name' 
FROM bad_data;   --as usual, used LEN(id) to extract UNTIL END Characters
                 --note: Can also just do 'SUBSTRING(id, 6)' and will AUTOMATICALLY GO to END  


				     /*  HARD SQL Questions  */
--note: above questions were more for ENTRY-LEVEL Job Interviews
--THESE are more for Medium/Senior Level roles (Advanced)

--             Question 1:
--Kelly's Ice Cream Shop gives 33% Discount on EACH 3rd Purchase
--Query to Select 3rd Transaction by EACH Customer
--output customer_id, transaction_id, amount and 'amount AFTER DISCOUNT' (33% off)
--Order by 'customer_id' ascending

--Likely, need to use WINDOWS FUNCTION. 
--RANK(), ORDER BY transaction ID, PARTITION BY customer_id

WITH ranking AS (
SELECT *, RANK() OVER (
PARTITION BY customer_id
ORDER BY transaction_id ASC) AS 'transaction_numbered'
FROM purchases)
SELECT customer_id, transaction_id, amount, 
       amount*(1-0.33) AS discounted_amount
FROM ranking
WHERE transaction_numbered = 3
ORDER BY customer_id ASC;           --remember to order!
--Important Note: MUST use CTE (OR Subquery in FROM, OR temp table) since CANNOT use 'WHERE' for WINDOWS FUNCTION Column!
--THEN add 'WHERE' clause for THAT. 
--('ROW_NUMBER()' could have been used too and should get the same answer) 


--              Question 2:
--query to find ALL Dates with HIGHER TEMPERATURES than PREVIOUS DATES (Yesterday)
--'date' column and 'temperature' column

-- METHOD 1: use 'WINDOWS FUNCTION' again
--now 'LAG' (to access previous date), ORDER by date ASC, 
-- LAG(temperature, 1, 0)  - 'offset=1', so 1 row BEFORE the CURRENT one
                           --replace NULL values with '0'
WITH temperatures AS (
SELECT *, LAG(temperature, 1,0) OVER (
          ORDER BY date ASC) AS previous_temp
)
SELECT date
FROM temperatures
WHERE temperature > previous_temp;

--METHOD 2: 'SELF-JOIN' Method
--JOIN Table with ITSELF, but ON PREVIOUS DAY (-1 day)
--COMPARE temperatures, WHERE current is LESS than previous

SELECT t1.date, t2.date AS date2, 
       t1.temperature, 
       t2.temperature AS temperature2
FROM temperature t1
INNER JOIN temperature t2
ON DATEDIFF(t1.date, t2.date) = 1 
AND t1.temperature > t2.temperature
ORDER BY t1.date ASC;
--JOINS where DIFFERENCE between Dates is '1' (date2 = PREVIOUS date)
--AND where CURRENT Temp (t2) is LESS THAN PREVIOUS date temp (t3)
--COULD have used 'WHERE' to compare temperatures
--Just SHOWED that CAN BE DONE as JOIN CONDITION!


--                 Question 3 (HARDEST QUESTION!!!)
--Marcie's Bakery contest
--the Dessert (Cake vs Pie) which SELLS MORE EACH Day will get DISCOUNTED TOMORROW
--IDENTIFY WHICH dessert sells MORE EACH Day
--find DIFFERENCE between Cakes vs Pies Sold EACH Day
--include 'date_sold', 'difference_in_sales', which sold more
--use ABS() to make the Difference a POSITIVE NUMBER

--used SELF-JOIN where 'date_sold is EQUAL', but 'DIFFERENT PRODUCT (NOT EQUAL !=)'
--(this way get SEPARATE COLUMN for the Different Products sold on SAME DATE!)
--put this into a CTE so can be queried!
WITH previous AS (
SELECT d1.date_sold, d2.date_sold AS date_sold2, 
       d1.product, d2.product AS product2, 
       d1.amount_sold,
       d2.amount_sold AS amount_sold2
FROM desserts d1
JOIN desserts d2
ON d1.date_sold = d2.date_sold
AND d1.product != d2.product
)    
SELECT date_sold, ABS(amount_sold2 - amount_sold) AS 'amount_sold_difference',
       CASE 
           WHEN (product = 'Pie' AND amount_sold > amount_sold2) OR (product='Cake' AND amount_sold < amount_sold2)
           THEN 'Pie sold more'
           ELSE 'Cake sold more'
      END AS 'Which Sold More'
FROM previous
ORDER BY date_sold;
--use CONDITIONAL (CASE Statement) to IDENTIFY IF Pie OR Cake sold more!
--(optional: if dont want null, can replace NULL values with '0', using ISNULL(amount_sold, 0)

--METHOD 2:  (better solution)
--ISSUE? 'Cake' and 'Pie' are NOT in SEPARATE Column
--need to make 'DIFFERENT PRODUCTS' on 'SAME DAY' be in SEPARATE COLUMNS
--Here, Solve with 'SUMS' 'CASE STATEMENTS' and 'GROUP BY date_sold'
SELECT date_sold,
      ABS(SUM(CASE WHEN product = 'Cake' THEN amount ELSE 0 END) - 
	  SUM(CASE WHEN product = 'Pie' THEN amount ELSE 0 END)) AS 'difference',
	  CASE WHEN
	     SUM(CASE WHEN product = 'Cake' THEN amount ELSE 0 END) >
	     SUM(CASE WHEN product = 'Pie' THEN amount ELSE 0 END)) THEN 'Cake'
           WHEN
		 SUM(CASE WHEN product = 'Pie' THEN amount ELSE 0 END) >
	     SUM(CASE WHEN product = 'Cake' THEN amount ELSE 0 END)) THEN 'Pie'
		 ELSE NULL
		 END AS 'Sold_More'
FROM desserts
GROUP BY date_sold
ORDER BY date_sold;
--for EACH date_sold, did (abs) TOTAL 'Cake' - TOTAL 'Pie' to find DIFFERENCE
--then used ANOTHER CASE, to see IF 'Pie' or 'Cake' SOLD MORE (>amount for a given day)


--                       More INTERVIEW Coding Questions:

--List Player for EACH Goal Scored in a Game where Stadium was 'National Stadium, Warsaw':
SELECT go.player
FROM goal AS 'go'
JOIN game AS 'ga'
ON go.matchid = ga.id
WHERE ga.stadium = 'National Stadium, Warsaw'
--For each continent, show Continent and Number of Countries with Populations of AT LEAST 10 Million:
SELECT continent, COUNT(name) AS 'Count_Countries'
FROM world
WHERE population >= 10000000
GROUP BY continent
ORDER BY 2;
--List Continents which HAVE a 'TOTAL POPULATION' of 'at least 100 million'
SELECT continent, SUM(population) AS 'total_population'
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;

--                  (slightly harder now)
--List actors alphabetically who have had AT LEAST '15 Starring' Roles:
SELECT a.name, COUNT(c.movieid)
FROM actor a
JOIN casting c
ON a.actor = c.actorid
WHERE c.ord = 1             --only STARRING roles
GROUP BY name
HAVING COUNT(movieid) >= 15
ORDER BY name ASC;
--note: hard to IMMEDIATELY know what 'starring' is 
--if in doubt, ASK INTERVIEWER for CLARIFICATION!
--here, know that 'STAR OF MOVIE' has 'ord = 1'


--HARDEST: List all people who have WORKED with 'Art Garfunkel:
-- i.e. need all 'actors names' or 'directors' who have WORKED WITH 'name = Art Garfunkel'
--JOIN Tables TOGETHER
WITH previous AS (
SELECT a.*, c.*      --(or just do '*', just showed both work!)
FROM actor a
JOIN casting c
ON a.id = c.actorid)
SELECT name
FROM previous
WHERE movieid IN (
SELECT c.movieid
FROM actor a
JOIN casting c
ON a.id = c.actorid
WHERE name = 'Art Garfunkel')
AND name != 'Art Garfunkel';
--1. Subquery FIRST finds ALL movie IDs where actor 'name = Art Garfunkel'
--2.  Use the 'JOIN CTE' ABOVE to then find ALL ACTORS (names) IN SAME MOVIES (movieid) AS 'Art Garfunkel'
--(required more thought than typical interview question!)

                       /*  COMMON SQL Inverview Questions  */

-- Primary Key? = (column) identifier which 1. UNIQUELY Identifies EACH ROW of a Table 2. Cannot be Duplicated (UNIQUE only), 3. CANNOT be NULL/BLANK 
-- What is a JOIN? = a SQL Function used to COMBINE DIFFERENT TABLES based on Primary-Forgein Key Pairs/COMMON Columns between the 2 Tables. 
--                   INNER, LEFT, RIGHT and FULL OUTER JOINS
--SQL? Structured Query Language, used to query/retrieve data stored in databases (in tables). Perform CRUD operations (Create, Read, Update and Delete Data)



                  /*  (techTFQ) MORE TECHNICAL SQL Interview Questions  */

--1. HOW to DELETE DUPLICATES using SQL? (as done in Data Cleaning Project!)
USE SQL_Interview;
SELECT *
FROM cars;          --no more duplicates in this table! model_id '2' and '6' removed!

WITH previous_table AS (
SELECT *, ROW_NUMBER() OVER 
          (PARTITION BY model_name, color, brand
		   ORDER BY model_id) AS 'duplicate_row_identifier'
FROM cars)
DELETE FROM previous_table
WHERE duplicate_row_identifier > 1;

-- ALTERNATIVE WAY (Using SUBQUERY to GROUP for MIN(model_id)):
SELECT *
FROM cars
WHERE model_id NOT IN 
(SELECT min(model_id)   -- MIN gives all UNIQUE RECORDS (non-duplicates), since MINIMUM should be FIRST OCCURANCE!
 FROM cars 
 GROUP BY model_name, brand);
 


--2.  Display HIGHEST and LOWEST SALARY for EACH DEPARTMENT:
--KEEP SHOWING EMPLOYEES though for each row (so? need WINDOW FUNCTION!)
SELECT *, MAX(salary) OVER (PARTITION BY dept ORDER BY salary DESC) AS Highest_Salary, 
          MIN(salary) OVER (PARTITION BY dept 
		                    ORDER BY salary DESC
							RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Lowest_Salary
FROM employees;            
--Note: for 'MIN()' ALSO need 'RANGE BETWEEN.....' Statement

/* 
Check out 'LEARN SQL' Website for GREAT PRACTICAL LEARNING to do with WINDOWS FUNCTIONS and more!
*/


--3. 'Car_Distances' given as CUMMULATIVE Distances (added up day by day)
--INSTEAD, want as ACTUAL Distances EACH Day
--done by finding CURRENT Distance - PREVIOUS for EACH DAY, EACH CAR

SELECT *, cummulative_distance - LAG(cummulative_distance, 1, 0) 
          OVER (PARTITION BY cars ORDER BY days) AS 'daily_distance'
FROM Car_Distances;
 

--4. 'city_distances' table shows DISTANCES BETWEEN CITIES, from SOURCE City to DESTINATION City
--table BASIALLY contains DUPLICATED records. So REMOVE THESE DUPLICATES!
--(e.g. 'Bangalore to Hyderbad' distance is SAME AS 'Hyderbad to Bangalore'!)
--HOW can this be done? Use 'SELF-JOIN' with 'CTE for ROW_NUMBER()'
WITH CTE AS (
SELECT *, ROW_NUMBER() OVER (ORDER BY distance) AS 'row_num'
FROM city_distances  
)
SELECT t1.source, t1.destination, t1.distance
FROM CTE t1
JOIN CTE t2
ON t1.row_num < t2.row_num
AND t1.source = t2.destination
AND t1.destination = t2.source;
--used 'ROW_NUMBER' as 'UNIQUE ROW IDENTIFIER' (since ID column NOT given here!)
--ONLY MATCHES IF 'row number of table 1' < 'row number of table 2'
--MATCH where 'source value = destination value' AND 'destination value = source value'


--5. 'UNGROUP' given data (COMPLEX, so PROBABLY WONT GET THIS!)
--instead of grouping, will go from GROUPED Data to get the UNGROUPED Data form!
SELECT *
FROM grouped_data;
--UNGROUP the COUNT to show EACH ROW entry before grouping:
--need to use 'RECURSIVE' for a CTE:
WITH RECURSIVE cte AS (
SELECT id, item_name, total_count, 1 AS 'level'
FROM grouped_data
UNION  --'RECURSIVE' is commonly used with UNION within a CTE
SELECT cte.id, cte.item_name, cte.total_count - 1, level + 1 AS 'level'
FROM cte
JOIN grouped_data t
ON t.item_name = cte.item_name 
AND t.id = cte.id
)
SELECT id, item_name, level
FROM cte
ORDER BY level;
--write 'RECURSIVE' before 'cte' name
--1st Query = BASE QUERY, which = Data AS IS, with LEVEL '1' value 
--UNION separates 1st query from:
--2nd Query = Exectues FROM 2nd ITERATION ONWARDS
--(after 1st query runs, ONLY 2nd query ONWARDS gets EXECTUED!)
--JOINS RESULT from PREVIOUS ITERATION (cte) with Main Table
--WHERE the 'total_count' in PREVIOUS ITERATION is ABOVE 1
--(i.e. CONTINUES UNTIL 'total_count' BECOMES '1', since SUBTRACT '-1' with EACH Iteration!)
--NOTE: WONT WORK in SQL Server, but WILL in PostgreSQL


--6. Have 10 Teams. 
--Part1: MATCH EACH TEAM so it PLAYS 'TWICE' with EVERY OTHER TEAM
--CROSS JOIN Method:
SELECT t1.team_name As 'team1', t2.team_name AS 'team2'
FROM teams t1
CROSS JOIN teams t2
WHERE t1.team_name != t2.team_name --dont want team playing itself of course!
ORDER BY t1.team_name;

--OR, Using ROW_NUMBER() Method, ordering by 'team_name':
WITH each_team AS (
SELECT *, ROW_NUMBER() OVER (ORDER BY team_name) AS id
FROM teams t
)
SELECT t1.team_name AS team, t2.team_name AS opponent
FROM each_team t1
JOIN each_team t2 
ON t1.id != t2.id
ORDER BY t1.team_name;

--Part2: EACH Team playing 'ONCE' with EVERY OTHER TEAM
--just change '!=' to 't1.id < t2.id'
WITH each_team AS (
SELECT *, ROW_NUMBER() OVER (ORDER BY team_name) AS id
FROM teams t
)
SELECT t1.team_name AS team, t2.team_name AS opponent
FROM each_team t1
JOIN each_team t2 
ON t1.id < t2.id      --'<' changes to ONLY ONCE 
ORDER BY t1.team_name;   



-- 7.  'PIVOT a TABLE' into a DIFFERENT FORMAT
--(could use PIVOT in Power Query, OR a CASE STATEMENT)



