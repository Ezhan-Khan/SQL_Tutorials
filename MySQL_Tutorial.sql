USE sql_store;      #(select the Database we want to USE)

SELECT first_name, last_name, points, (points + 10) * 100 AS "Discount Factor"
FROM customers                    #SIMPLE ARITHMETIC can be done ON a Column's Values!
ORDER BY first_name
LIMIT 10;

#Getting the 'UNIQUE' States:
SELECT DISTINCT state
FROM customers;
#UPDATE Specific 'VALUE' WITHIN our Original Table?
UPDATE customers   #changing 'MA' to 'VA' for 'customer_id = 1'  (SIMPLE!)
SET state = 'VA'
WHERE customer_id = 1;

#   PRACTICE with 'products' Table:
# - find ALL Products, returning 'Name', 'Unit Price' and 'New Price' (unit price * 1.1)
SELECT name, unit_price, unit_price * 1.1 AS 'new price'
FROM products;

#'WHERE' Clause Practice:
SELECT *
FROM customers
WHERE state = 'CO' AND 
	 (birth_date > '1990-01-01' OR points >1000);    
#(customers in 'CO' State AND Born AFTER '1st January 1990' OR points > 1000')
#REMEMBER! - use of BRACKETS around the 'OR' Clause is IMPORTANT so is PROPERLY Executed!
#Here - MUST have 'CO' AND EITHER of the 2 Conditions for 'birth_date' OR 'points'

SELECT *
FROM orders
WHERE order_date >= '2017-01-01' AND 
	  order_date <= '2017-12-31';      #Only Orders in '2017'

#Using 'NOT' (=ANOTHER WAY do do things! Can just use USUAL Logical Operators:
SELECT *
FROM customers
WHERE NOT (state = 'CO' AND 
	 (birth_date > '1990-01-01' OR points >1000));    
#OR can do this WITHOUT 'NOT':
SELECT *
FROM customers               #Note: using 'NOT' makes 'OR' become 'AND' (and vice versa)
WHERE state !='CO' OR
	 (birth_date <= '1990-01-01' AND points <= 1000);    

#PRACTICE - from 'order_items' table, find 'order_id = 6' and 'TOTAL Order Price > 30':
SELECT order_id, product_id, quantity, unit_price, quantity * unit_price AS 'Total Price'
FROM order_items
WHERE (quantity * unit_price > 30) AND 
       order_id = 6
ORDER BY 2 DESC;           #TOTAL Price = 34.60 for 'order_id = 6'


#Using 'IN' Operator (quicker way than doing 'OR' for EACH Condition!)            
SELECT *
FROM customers WHERE state IN ('VA', 'FL', 'GA');      #IN 'Virginia', 'Florida' and 'Georgia'
#can also do 'NOT IN':
SELECT *
FROM customers WHERE state NOT IN ('VA', 'FL', 'GA');      #NOT IN 'Virginia', 'Florida' and 'Georgia'

#Practice - Return 'products' where 'quantity_in_stock' is either '49, 38, 72'
SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

#'BETWEEN' Operator (again, is a Time-Saver! Quicker and MORE READABLE!)
SELECT *
FROM customers 
WHERE points BETWEEN 1000 AND 3000;

#Practice - Customers born between '1-1-1990' and '1-1-2000'
SELECT *
FROM customers 
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

#Using 'LIKE' Operator 
SELECT *
FROM customers 
WHERE last_name LIKE "b%";   #only customers with LAST NAME beginning with 'b%'
#WILDCARD '%b' = ENDING with, 'b%' = STARTS with, '%b%' = CONTAINS   (SIMPLE!)

SELECT *
FROM customers 
WHERE last_name LIKE "%y";   #only customers with LAST NAME which END with '%y'

#can use '_' to MATCH the 'SPECIFIC  NUMBER of CHARACTERS' BEFORE, AFTER or BETWEEN a string:
SELECT *
FROM customers 
WHERE last_name LIKE "b____y";   #here, want '4 Letters BETWEEN' b and y  
                                 #-  Someone called Freddi 'Boagey' 
#Practice - Customers who have 'address' which CONTAINS 'trail' OR 'avenue', or phone numbers which end with '%9'
SELECT *
FROM customers 
WHERE (address NOT LIKE '%TRAIL%' OR address  LIKE 'AVENUE') OR phone LIKE '%9';
# (used 'NOT' LIKE, just as usual!)


# 'REGEXP' (=Better Version of 'LIKE'!)
SELECT *
FROM customers 
WHERE last_name REGEXP 'field';  #DONT need '%' for REGEXP - SAME ANSWER if using 'LIKE "%field%"!

#use '^string' = STARTS at BEGINNING, 'string$ = END of String'
#Can ALSO do 'OR' very SIMPLY - just use '|' instead: 
SELECT *
FROM customers 
WHERE last_name REGEXP 'field|mac|rose';  
#'last_names' which CONTAIN 'field' OR 'mac' OR 'rose' (SAME THING!)

#Can specify WHAT LETTERS COULD BE INCLUDED 'BEFORE or AFTER' a string/letter using BRACKETS '[]':
SELECT *
FROM customers 
WHERE last_name REGEXP '[gim]e';    
#=last_name with 'e' inside, containing EITHER 'ge', 'ie' OR 'me'!! So either 'g', 'i' or 'm' BEFORE 'e'
SELECT *
FROM customers 
WHERE last_name REGEXP 'e[fmq]';    # = any last_names having 'f', 'm' or 'q' AFTER 'e' 

#Specify a RANGE of Characters (ALPHABETICALLY) within [], by using '[a-h]' = 'a,b,c,d,e,....h'  - SAVES TIME!

#'REGEXP PRACTICE':
SELECT *
FROM customers 
WHERE first_name REGEXP 'ELKA|AMBUR';     #first_names including 'ELKA' OR 'AMBUR'
SELECT *
FROM customers 
WHERE last_name REGEXP '^MY|SE';      #STARTS with 'MY' or CONTAINS 'SE'
SELECT *
FROM customers 
WHERE last_name REGEXP 'EY$|ON$';      #last_names ENDING with 'EY' or 'ON' 
SELECT *
FROM customers 
WHERE last_name REGEXP 'B[RU]';   #last_name containing 'B' FOLLOWED by 'R' or 'U'

# 'IS NULL' (or IS NOT NULL) - see all MISSING VALUES for a Column:
SELECT *
FROM customers 
WHERE phone IS NULL;

#Practice - See 'Orders' which are 'Not Shipped'
SELECT *
FROM orders
WHERE shipper_id IS NULL
ORDER BY order_id DESC;     #returns ALL orders NOT SHIPPED (i.e. NO Shipper_id)


#'ORDER BY' Practice:
SELECT *, quantity*unit_price AS 'Total Price'    
FROM order_items                #Note - can STILL add 'NEW COLUMNS' AFTER '*'!
WHERE order_id = 2 
ORDER BY quantity*unit_price DESC;    #REALLY SIMPLE!


#'LIMIT' can be used for a 'SPECIFIC RANGE' of Rows to View:
SELECT *
FROM customers
LIMIT 6, 3;     #this SKIPS FIRST 6, THEN takes first 3 Records
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;        #easily get 'Top 3 Customers'




                          /*  INSERTING NEW ROWS INTO TABLE */

INSERT INTO customers
VALUES (DEFAULT, 'John', 'Smith', '1990-01-01', NULL, 'address', 'city', 'CA', DEFAULT);
#note - specify 'DEFAULT' if DEFAULT VALUE is GIVEN when CREATING the TABLE (e.g. for 'customer_id' - is AUTO-INCREMENT, so MySQL increments the id AUTOMATICALLY from LAST)
#     - if DEFAULT VALUE is 'NULL' when Creating Table, then can say 'NULL' if NOT GIVEN (e.g. for 'birth_date' or 'phone'
#OR can SPECIFY COLUMNS after 'table' is specified:
INSERT INTO customers (first_name, last_name, birth_date, address, city, state)
VALUES ('John', 'Smith', '1990-01-01' 'address', 'city', 'CA');

#Inserting MULTIPLE ROWS in ONE GO:
INSERT INTO shippers (name)
VALUES ('Shipper1'), ('Shipper2'), ('Shipper3');     #Just ADD in 'INDIVDUAL BRACKETS'!
DELETE FROM shippers
WHERE name IN ('Shipper1', 'Shipper2', 'Shipper3');  #REMOVE these Rows AFTER!

INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Product1', 10, 1.95), ('Product2', 10, 1.95), ('Product3', 10, 1.95);


#                  INSERTING 'HIERARCHICAL ROWS' (Inserting into MULTIPLE TABLES):
# - have 'parent-child' relationship between 'orders' Table and 'order_items' Table
#  ('orders' table does NOT CONTAIN the 'ITEMS', this is in SEPARATE 'order_items' Table instead)
# - i.e. so an ACTUAL 'order' can have MULTIPLE 'ORDER ITEMS'!
#1. ADD NEW 'order' to 'orders':
INSERT INTO orders (customer_id, order_date, status)            #ONLY need for 'customer_id', 'order_date' and 'status', since REST are AUTOMATIC/DEFAULT!
VALUES (1, '2019-01-02', 1);
#AS SOON as we create this NEW ORDER, MySQL will CREATE a NEW 'order_id' FOR it!
#How can we ACCESS THIS NEW 'order_id'?
#Can use BUILT-IN FUNCTION 'LAST_INSERT_ID()' = gives ID created WHEN we LAST INSERTED a NEW ROW
SELECT LAST_INSERT_ID();    #viewing - see that LAST ROW ID we inserted was '12'
#NOW, can INSERT for our NEW 'order_id' (FROM 'orders') INTO CHILD Table 'order_items':
#2. Add NEW 'order_item(s)' FOR the 'order_id' ADDED ABOVE:
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 1, 1, 2.95),
       (LAST_INSERT_ID(), 2, 1, 3.95);               #makes sense! 



                     /*   CREATING a 'COPY of a TABLE' (TEMPORARY TABLES):   */         -- REALLY COOL!
#Create a COPY of 'orders' table. Call it 'orders_archived'
#'CREATE TABLE AS' Statement:     - AFTER 'AS' just write a SUBQUERY of TABLE we WANT!
CREATE TABLE orders_archived AS
SELECT * FROM orders;         # = NEW TABLE with ALL Data FROM 'orders'!
#Note - 'order_id' is NOT 'PRIMARY KEY' for COPY Table

#Right-Click 'orders_archived' and 'TRUNCATE TABLE' to RESET/REMOVE ALL ROWS (RESTART!)
#Can EVEN use 'SUBQUERY' in an 'INSERT' Statement TOO (INSERT SUBQUERY of VALUES INTO EXISTING TABLE)
INSERT INTO orders_archived        #dont need 'VALUES' - JUST write Subquery AFTER specifying the Table we want to 'INSERT INTO'!
SELECT *
FROM orders
WHERE order_date < '2019-01-01';   
#ADDS ROWS from this SUBQUERY INTO 'orders_archived' (=All Dates BEFORE 2019) - SIMPLE!

#                              COOL PRACTICE EXAMPLE: 
# - create COPY of 'invoices' Table called 'invoices_archived'
# - make the SUBQUERY a JOIN with 'clients' Table, to get 'client NAME' (instead of just 'client_id'!)
# - also FILTER so ONLY for Rows where 'payment' IS made (i.e. NOT NULL)
USE sql_invoicing;
CREATE TABLE invoices_archived AS
SELECT i.invoice_id, 
       i.number,
       c.name AS 'client',
       i.invoice_total,
       i.payment_total,
       i.invoice_date,
       i.payment_date,
       i.due_date
FROM invoices AS i
JOIN clients AS c
ON i.client_id = c.client_id
WHERE payment_date IS NOT NULL;         #BEAUTIFUL - really cool


						 /*  UPDATE DATA within TABLE  */
UPDATE invoices
SET payment_total = 10, payment_date = '2019-03-01'       #Updating for MULTIPLE Variables - just SEPARATE by 'COMMA ,'
WHERE invoice_id = 1;
#Can use 'NULL' if we want VALUE to be SET to 'NULL' and 'DEFAULT' to set to DEFAULT VALUE:
UPDATE invoices
SET payment_total = DEFAULT, payment_date = NULL       #set BACK to NULL!
WHERE invoice_id = 1;           
# ALL REALLY SIMPLE!!!
#Another Example - for 'invoice_id = 3':
UPDATE invoices
SET payment_total = invoice_total * 0.5,
    payment_date = due_date                     
WHERE invoice_id = 3;            #'Warning - Data Truncated'. IGNORE THIS (just means DATA TYPE has been CHANGED)

#More UPDATE Practice:
# - give ANY 'cusotmers' born BEFORE 1990 '50 EXTRA Points'
USE sql_store;
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';        #SIMPLE!


#                     Using 'SUBQUERIES' WITHIN 'UPDATE' Statments:
USE sql_invoicing;
UPDATE invoices 
SET payment_total = invoice_total * 0.5,
    payment_date = due_date                     
WHERE client_id IN (SELECT client_id      #NOTE - need 'IN' Operator, because have 'MULTIPLE OUTPUTS'
FROM clients 
WHERE state IN ('CA', 'NY'));        #SIMPLE 'SUBQUERY' within 'WHERE' Statement!

#'PRACTICE EXERCISE':
#- for 'customers' with MORE THAN 3000 points,
# - within 'orders' Table, UPDATE to write 'comments' saying THESE are 'Gold Customers'
USE sql_store;
UPDATE orders
SET comments = 'Gold Customer'
WHERE customer_id IN                              #REALLY SIMPLE!
(SELECT customer_id 
FROM customers
WHERE points > 3000);      #added 'Comment' next to 'orders' from 'GOLD' Customers!

#IMPORTANT TIP - WRITE 'SUBQUERY' FIRST and VIEW IT to make sure it is CORRECT!
#(SUBQUERY is always RUN FIRST!)

#When DELETING ROWS, can ALSO INCLUDE 'SUBQUERY' in the 'WHERE' Statement! (AS USUAL!)
USE sql_invoicing;
DELETE FROM invoices
WHERE client_id = (
SELECT client_id
FROM clients
 WHERE name = 'Myworks');
 
 
#HOW can we RESTORE DATABASES to ORIGINAL FORM? 
#  - Just RUN our 'CREATE_DATABASES' FILE AGAIN!!! SIMPLE!

















