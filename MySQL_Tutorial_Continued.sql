USE sql_store;

				               /*   EVERYTHING about 'JOINS'!   */

SELECT o.order_id, c.first_name, c.last_name, o.customer_id
FROM orders AS o
INNER JOIN customers AS c               
ON o.customer_id = c.customer_id
ORDER BY c.customer_id;              #INNER - ONLY JOINS if 'MATCHING' customer_id is PRESENT! 

#Join 'order_items' Table WITH 'products' (on 'product_id' column):
SELECT oi.order_id, 
       oi.product_id, 
       oi.quantity, 
       oi.unit_price, 
       p.name, 
       p.quantity_in_stock, 
       p.unit_price
FROM order_items AS oi
INNER JOIN products AS p                 #Note: 'unit_price' from 'orders' = Price AT TIME of ORDER
ON oi.product_id = p.product_id;         #      'unit_price' from 'products' = CURRENT PRICE (so may have CHANGED from when it was 'ORDERED'!)

#JOINING using COLUMNS from TABLES in 'DIFFERENT DATABASES'?
#JOIN 'order_items' in 'sql_store' Database WITH 'products' from 'sql_inventory' Database:
#'SAME EXACT THING'! Just SPECIFY the 'Database.Table' we are GETTING TABLE FROM!!!
SELECT oi.order_id,
	   oi.product_id, 
       oi.quantity, 
       oi.unit_price, 
       p.name, 
       p.quantity_in_stock, 
       p.unit_price
FROM sql_store.order_items AS oi
INNER JOIN sql_inventory.products AS p                 
ON oi.product_id = p.product_id;         

#       'SELF JOINS' (just JOIN a Table with ITSELF, based on 2 Columns in SAME TABLE)
# (i.e. IF there is a Primary-Foreign Key Pair WITHIN a TABLE) - SAME EXACT THING!
#Example - for 'employees' table in 'sql_hr' Database, can JOIN with ITSELF 
#          JOIN 'employee_id' Column WITH 'reports_to' 
# (since 'reports_to' is ALSO WITHIN 'employee_id' = MANAGER who EACH specific employee RESPONDS to)
USE sql_hr;   #change Current Database to 'sql_hr' (HR Tables)
SELECT e.employee_id,
	   e.first_name, 
       e.last_name, 
       e.job_title, e.salary, 
       e2.employee_id AS Manager_id, 
       e2.first_name AS Manager_first_name, 
       e2.last_name AS Manager_last_name
FROM employees AS e
LEFT JOIN employees AS e2
ON e.reports_to = e2.employee_id;    #See WHO EACH Employee REPORTS to!
#See that 'Yovonnda Magrannell' 'REPORTS' to NO ONE (NULL) so SHE must be the MANAGER!


                   /*   JOINING 'MORE THAN 2 TABLES'   */
#Example - need to join 'order_statuses' Table TOO (on 'order_status_id' Primary Key with 'status' Foreign Key)
#JOIN 'orders' WITH 'customers' AND 'order_statuses':
USE sql_store; 
SELECT o.order_id,
       o.order_date,
       c.first_name,
       c.last_name,
       os.name
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
JOIN order_statuses AS os           #SIMPLE! - Just ADD ANOTHER 'JOIN' Statement
ON o.status = os.order_status_id;

#PRACTICE - 'sql_invoicing' Database
# - 'payments' table = payments made by each client towards 'invoice'
# - can JOIN with 'payment_methods' table (based on 'payment_method_id' column 
# - can ALSO JOIN with 'clients' table (to see WHICH CLIENTS are present)
USE sql_invoicing;
SELECT p.date, 
       p.invoice_id,
       p.amount, 
	   c.name, 
	   pm.payment_method_id,             #including only the IMPORTANT COLUMNS we WANT!
       pm.name AS 'Payment_Method'          
FROM payments AS p
JOIN clients AS c
ON p.client_id = c.client_id
JOIN payment_methods AS pm
ON p.payment_method = pm.payment_method_id;         #COOL! Created this Awesome 'JOINED' Table!


#            JOINS when there are 'COMPOSITE PRIMARY KEYS'?
# - joining 'order_items' Table WITH 'order_item_notes' Table
USE sql_store;
SELECT *
FROM order_items AS oi
JOIN order_item_notes AS oin
ON oi.order_id = oin.order_id
AND oi.product_id = oin.product_id;    #NO MATCHING ROWS - NOTHING RETURNED!


#                   'IMPLICIT JOIN' Syntax 
# = Just ANOTHER WAY to write JOIN STATEMENTS:
SELECT *
FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id;   #This is USUAL SYNTAX, called 'EXPLICIT'

SELECT *
FROM orders AS o, customers AS c
WHERE o.customer_id = c.customer_id;   
#BEST to 'AVOID IMPLICIT JOIN'! 
#Why? - If we ACCIDENTALLY FORGET our 'WHERE' Statament, get 'CROSS JOIN':
SELECT *
FROM orders AS o, customers AS c;
# = EVERY RECORD from 'orders' Table is JOINED with EVERY RECORD in 'customers' Table!!!
#So gives MANY MANY ROWS (more than we want!!!)


#         'OUTER JOINS'
SELECT c.customer_id,
       c.first_name,
	   o.order_id
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
#Note - see how with this 'INNER' JOIN, ONLY includes MATCHING ROWS
#use 'OUTER JOIN' if we want to see ALL (EVEN MISSING)
#1. LEFT JOIN (all from 'customers' Table, even if MISSING from 'orders'!)
SELECT c.customer_id,
       c.first_name,
	   o.order_id
FROM customers c             
LEFT JOIN orders o       
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
#2. RIGHT JOIN (all from 'orders' Table, even if MISSING from 'customers'!)
SELECT c.customer_id,
       c.first_name,
	   o.order_id
FROM customers c             
RIGHT JOIN orders o       
ON c.customer_id = o.customer_id
ORDER BY o.order_id;

#Outer Join Practice - 'order_items' with 'products'
SELECT p.product_id,
	   p.name, 
       oi.quantity
FROM order_items AS oi
RIGHT JOIN products AS p     #want ALL from 'products' table, EVEN IF MISSING a MATCH (i.e. EVEN if NOT 'ordered'!)
ON oi.product_id = p.product_id    #COULD have done as 'LEFT JOIN' if REVERSED ORDER of Tables!
ORDER BY p.product_id;

#OUTER JOIN between MULTIPLE TABLES (just ADD 'ANOTHER JOIN'!):
SELECT c.customer_id,
       c.first_name,
	   o.order_id,
       s.name AS 'shipper_name'
FROM customers c             
LEFT JOIN orders o       
ON c.customer_id = o.customer_id
LEFT JOIN shippers AS s                      
ON o.shipper_id = s.shipper_id      #'Left Join' - give ALL 'ORDERS', EVEN IF they DONT HAVE 'Shipper'
ORDER BY c.customer_id;
#COULD do 'INNER JOIN' if we ONLY wanted 'MATCHING' ROWS - i.e. 'orders' WITH 'shipper_id' ONLY!
#But, a LOT of orders are MISSING 'shipper_id'! So? 'LEFT JOIN' was BETTER CHOICE!

#Note - in practice, BEST STICK to 'LEFT JOINS' ONLY! EASIER to VISUALIZE!

#          MULTIPLE Table OUTER JOINS - PRACTICE:
# -  Here will do '3 LEFT JOINS' - SIMPLE! EXACT SAME THING!
SELECT o.order_date,
       o.order_id,
       c.first_name AS 'customer',
       s.name AS 'shipper',
       os.name AS 'status'
FROM orders AS o
LEFT JOIN customers AS c               #want ALL orders, even if 'customers' not placed order
ON o.customer_id = c.customer_id
LEFT JOIN shippers AS s                #want ALL 'orders' EVEN if 'shippers' not given
ON o.shipper_id = s.shipper_id
LEFT JOIN order_statuses AS os         #want ALL 'orders' EVEN if 'status' not given
ON o.status = os.order_status_id
ORDER BY os.name;        #CLEARLY see WHICH orders are 'SHIPPED' vs. Still being 'PROCESSED'


#                 'SELF OUTER' JOIN
#SAME Applies for 'LEFT JOIN' for a Table with ITSELF:
USE sql_hr;   #back to our HR 'employees' Table
SELECT e.employee_id,
	   e.first_name, 
       e.last_name, 
       e.job_title, e.salary, 
       e2.employee_id AS Manager_id, 
       e2.first_name AS Manager_first_name, 
       e2.last_name AS Manager_last_name
FROM employees AS e
LEFT JOIN employees AS e2      #include ALL 'employees' EVEN IF they DONT have a MANAGER!
ON e.reports_to = e2.employee_id;    
#Now, can see the record for the MANAGER 'Yovonnda' too (since they are Manager, they DONT HAVE a Manager!)


#'USING ()'  -  ALTERNATIVE to 'ON' Statement in JOIN Clause:
# - can use 'USING (column_name)'  -  works if joining columns have SAME NAME!
USE sql_store;
SELECT c.customer_id,
       c.first_name,
	   o.order_id
FROM customers c             
JOIN orders o       
USING (customer_id);   #works EXACT SAME as 'ON' Statement! 'USING' can be CLEARER sometimes!
#Another Example (works JUST SAME for 'COMPOSITE' Keys)
SELECT *
FROM order_items oi
JOIN order_item_notes oin
USING (order_id, product_id);   #just LOOKS NICER!

#More Practice:
USE sql_invoicing;
SELECT p.date,
       c.name AS 'client',
       p.amount,
       pm.name AS 'payment_method'
FROM payments AS p
JOIN clients AS c
USING (client_id)              #just used 'USING' (much clearer, less messy!)
JOIN payment_methods AS pm
ON p.payment_method = pm.payment_method_id;   #different column names - CANNOT use 'USING' here!


#'NATURAL' JOIN - tables are JOINED 'Automatically' WITHOUT SPECIFYING 'columns' to 'JOIN ON'
# = NOT RECOMMENDED though! - can lead to UNWANTED RESULTS!


#            'CROSS JOINS' - EVERY Record in EACH TABLE is JOINED/MATCHED TOGETHER!
USE sql_store;
SELECT c.first_name AS 'customer',
       p.name AS 'product'
FROM customers AS c
CROSS JOIN products p;        #this is the 'EXPLICIT' Syntax
#This is NOT GOOD EXAMPLE of using CROSS JOIN though! USELESS to us!
# GOOD USE of 'CROSS JOIN'?
# e.g. 1 Table of 'Sizes' (Small, Medium, Large..), 2nd Table of 'Colours' (red, blue, green...)
#With 'CROSS JOIN', can see ALL POSSIBLE COMBINATIONS for EACH SIZE with EACH COLOUR
#
SELECT s.name, p.name
FROM shippers AS s, products AS p   # this is just the 'INPLICIT' Syntax (SAME as doing 'CROSS JOIN')
ORDER BY 1;


#                'UNION' Practice  (combining ROWS from Multiple Tables)
# - want to get 'orders' by DATE. IF Date is during '2019', add LABEL 'active'
# - IF 'orders' DATE is BEFORE 2019, can LABEL as 'archived'
SELECT  order_id, 
		order_date,
        'Active'  as 'Status'  #add STRING Column - 'Active' Label. EACH ROW will say 'Active'
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT  order_id, 
		order_date,
        'Archived'  as 'Status'  #add STRING Column - 'Active' Label. EACH ROW will say 'Active'
FROM orders
WHERE order_date < '2019-01-01';

#Works JUST SAME if COMBINING ROWS of MULTIPLE TABLES!
#Note: can use 'CASE STATEMENT' to do 'EXACT SAME THING':
SELECT customer_id,
       first_name, 
       points, 
       CASE 
	   WHEN points < 2000 THEN 'Bronze'
	   WHEN points BETWEEN 2000 AND 3000 THEN 'Silver'
	   WHEN points > 3000 THEN 'Gold'
	   END AS 'type'
FROM customers
ORDER BY first_name;       #COULD do ALL this with 'UNION' TOO. But 'CASE' is BETTER!

#IMPORTANT!!! - 'UNION' ONLY WORKS if 'SAME NUMBER OF COLUMNS' and 'SAME DATA TYPES' of Columns in EACH TABLE being STACKED!!




























