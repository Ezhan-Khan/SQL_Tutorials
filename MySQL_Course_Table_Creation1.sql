		     /*   EVERYTHING about 'TABLE CREATION and DELETION'   */

DROP DATABASE IF EXISTS `Databases_Tutorial`;
CREATE DATABASE `Databases_Tutorial`;
USE `Databases_Tutorial`;

/*           'COMMON DATA TYPES':
 'INT'
 'DECIMAL (M-Total Digits, N=Digits AFTER Decimal)'
 'VARHAR(l =MAX LENGTH of CHARACTERS)' 
 'DATE (YYYY-MM-DD)'  or  'TIMESTAMP (YYY-MM-DD HH:MM:SS)'
 'BLOB (Binary Large Object - storing LARGE DATA, like Images, Files...)'
*/
/*          COMMON 'CONSTRAINTS' (added next to Data Type, when Creating Table Columns)
  'PRIMARY KEY (ONLY ONE Primary Key and CANNOT be NULL!)'
  'UNIQUE (EACH ROW is DISTINCT)'
   'NOT NULL (Each Row Element MUST HAVE a Value)'
   'DEFAULT "Assumed Value" (inserts "Assumed Value" IF NOTHING GIVEN i.e. when new row is inserted)'
   'AUTO_INCREMENT' (add AFTER 'Primary Key' - so AUTOMATICALLY ADDS 'NUMBERING' for Primary Key Rows (1,2,3,4,5...). NO LONGER NEED to SPECIFY when INSERTING!)
*/

/*        Create 'FOREIGN KEY' to 'REFERENCE a Column' from 'ANOTHER TABLE':
First Create the Column - 'mgr_id', then at BOTTOM of 'CREATE TABLE' Clause, write:
'FOREIGN KEY (Column) REFERENCES primary_key_table(primary_key) ON DELETE SET NULL'
*/
/*                          'ON DELETE'
ON DELETE 'SET NULL' - sets ASSOCIATED 'Foreign Key' to 'NULL' WHEN the Primary Key Row is Deleted!
ON DELETE 'CASCADE' - DELETES 'ENTIRE ROW' of the ASSOCIATED FOREIGN KEY WHEN the Primary Key Row is Deleted!

e.g. for 'SET NULL' - if we did 'DELETE FROM employee WHERE emp_id = 102', will mean MISSING 'mgr_id' (with associated emp_id=102) will become 'NULL'!
*/


#'CRUD Operations' - 'CREATE', 'READ', 'UPDATE', 'DELETE'

CREATE TABLE students (
	student_id INT PRIMARY KEY,       #specify DATATYPE NEXT to 'Column Name', and IF 'PRIMARY KEY' (HELPS if we keep Schema CLEAR!)
	name VARCHAR(20),
	major VARCHAR(20)
);

ALTER TABLE students                  #'ALTER TABLE' used to Adds 'NEW COLUMN' 
ADD COLUMN gpa DECIMAL(3,2);            

ALTER TABLE students 
DROP COLUMN gpa;                 #OR can do 'DROP COLUMN'

DESCRIBE students;                   #'DESCRIBE 'Table' - gives 'Schema' INFO on COLUMNS of a TABLE (Field Name, Type, Null or Not, Key...)

								    #Use 'INSERT INTO' ... 'VALUES' to add NEW ROWS/RECORDS of Data
INSERT INTO students (student_id, name, major) VALUES (1, 'Jack', 'Biology');
INSERT INTO students (student_id, name, major) VALUES (2, 'Kate', 'Sociology');
INSERT INTO students (student_id, major) VALUES (3, 'Chemistry');
INSERT INTO students (student_id, name, major) VALUES (4, 'Jack', 'Physics');
INSERT INTO students (student_id, name, major) VALUES (5, 'Mike', 'Computer Science');


DROP TABLE students;                    #DELETE the TABLE with 'DROP TABLE'

#RE-CREATING the TABLE, now Specifying 'MORE CONSTRAINTS' (MORE PRACTICE!):
CREATE TABLE students (
         student_id INT PRIMARY KEY AUTO_INCREMENT,       #Automatically created NUMBERED Rows for 'student_id' Column (1, 2, 3, 4)
         name VARCHAR(20) DEFAULT 'Name Not Given',       #Specifies a 'DEFAULT' Value IF a Row Value is NOT GIVEN        
         major VARCHAR(20)
);

INSERT INTO students (name, major) VALUES ('Scott', 'Biology');
INSERT INTO students (name, major) VALUES ('Jake', 'Psychology');
INSERT INTO students (name, major) VALUES ('Khabib', 'MMA'); 


#'UPDATE' - EDITS EXISTING ROWS (also called 'Records')
UPDATE students
SET major = 'Bio'
WHERE major = 'Biology';   

UPDATE students
SET major = 'Music'
WHERE student_id = '2';   

UPDATE students
SET major = 'Biochemistry'
WHERE major = 'Bio' OR major = 'Psychology';

UPDATE students 
SET name = 'Tom', major = 'Undecided'      #set for each column row element
WHERE student_id = '1';

#DELETE FROM 'Table' WHERE ....REMOVE ROWS FROM TABLE
DELETE FROM students 
WHERE student_id = '2';

SELECT *
FROM databases_tutorial.students;



























