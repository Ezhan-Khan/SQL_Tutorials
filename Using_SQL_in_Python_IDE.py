
#%%                 'ACCESS DATABASES' using PYTHON:

#Will FIRST USE PYHTON to CONNECT to DATABASES
#Then CREATE TABLES, LOAD and QUERY DATA using SQL in JUPYTER NOTEBOOKS
# THEN will ANALYZE and VISUALIZE DATA using PYTHON - COOL!

#HOW can PYTHON COMMUNICATE with a 'DBMS'? 
# = 'API Calls' (Usually Performed in 'JUPYTER NOTEBOOKS'!
# 'SQL APIs' - use 'FUNCTIONS/SQL Statements' to Pass INTO the DBMS, retrieve DATA we WANT!
#Makes the SQL Statement as a TEXT STRING in a Bugger, then MAKES the API CALL to PASS ON to the DBMS.
#ENDS with an API CALL which DISCONNECTS


#PYTHON DATABASE API is called 'DB-API' (=Python's STANDARD API for Accessing RELATIONAL DATABASES, applies to ANY DATABASE!)
# 1. first 'CONNECT' PYTHON CODE to DBMS using 'DB-API' CALLS
# 2. then 'SEND' statement as TEXT STRING then PASSING this String TO the DBMS
# 3. can 'CHECK STATUS' of the API DBMS Request and ANY ERRORS
# 4. If 'OK', DBMS will send RESPONSE with REQUESTED DATA!
# 5. Then, make FINAL API Call to 'DISCONNECT' from Database

#ADVANTAGE? - DONT NEED to write SEPARATE Program for EACH - just LEARN the 'DB API' FUNCTIONS and APPLY to ANY DATABASE!

#'CONNECTION OBJECTS' = Establish/Manage Database Connections and Manage 'TRANSACTIONS'
#THEN, create 'CURSOR Objects' = Run Database 'QUERIES' 
#('SCROLL/SCAN THROUGH Query RESULTS') and GET DATA INTO Application! 
#Note - much like Web Cursor to SCROLL through 'Google Results!

.cursor()  #returns NEW Cursor Object USING the CONNECTION.
#cursors created from SAME CONNECTION are NOT ISOLATED (Any change from ONE is VISIBLE by OTHER Cursors)
.commit()  #COMMITS Any PENDING 'TRANSACTIONS' to the Database
.execute("SQL Statement")  #RUNS SQL QUERY ('CURSOR' Object!)
.rollback()  #Cause Database to ROLL BACK to START of any PENDING TRANSACTION!
.close()   #CLOSES the Database CONNECTION


#         STEPS TAKEN when USING 'DB-API' (DISPLAY ONLY!):
from dbmodule import connect     #using 'Connect' API from 'dmodule'
#Create CONNECTION OBJECT - using 'connect()' function WITH 'NECESSARY ARGUMENTS' (database_name.db, username, password...):
connection = connect('databasename', 'username', 'pswd')
#returns 'connection' OBJECT
#Create 'CURSOR OBJECT' ON the Connection Object:
cursor = connection.cursor()    #i.e. Like Python CLASS - '.cursor()' = 'method' of 'connect' 
#Can use 'Cursor RUNS QUERIES' and 'FETCHES RESULTS':
cursor.execute(''''SELECT * 
                   FROM MYTABLE''')
results = cursor.fetchall()   #FETCH 'RESULTS' of QUERY
#Keep doing this to VIEW ALL the Data we are INTERESTED IN!
#CLOSE the CONNECTION (FREES ALL Resources!)
cursor.close()
connection.close()    #MUST CLOSE once DONE!



#%%                           'SQLite' DATABASE EXAMPLE: 

import sqlite3
#1. CONNECT to SQLite:
conn = sqlite3.connect('INSTRUCTOR.db')
#2. Create NEW Cursor OBJECT using 'cursor()' method:
cursor_object = conn.cursor()
#NOW can go ahaead and RUN QUERIES HERE, IN PYTHON!
#-first, will DROP the TABLE we want, IF it ALREADY EXISTS:
cursor_object.execute("DROP TABLE IF EXISTS INSTRUCTOR")
#-now, can CREATE a TABLE Called 'INSTRUCTOR':
table = """ CREATE TABLE INSTRUCTOR (ID INTEGER PRIMARY KEY NOT NULL, 
                                     FNAME VARCHAR(20), 
                                     LNAME VARCHAR(20), 
                                     CITY VARCHAR(20), 
                                     CCODE CHAR(2));   
        """
cursor_object.execute(table)
print("Table is Ready!")
#-INSERTING ROWS of DATA INTO the Table:
rows_to_insert = """INSERT INTO INSTRUCTOR VALUES (1, 'Rav', 'Ahuja', 'TORONTO', 'CA'),
                                                  (2, 'Raul', 'Chong', 'Markham', 'CA'),
                                                  (3, 'Hima', 'Vasudevan', 'Chicago', 'US')
                 """
cursor_object.execute(rows_to_insert)
#-Can 'SELECT' DATA from INSTRUCTOR Table 
statement = '''SELECT * 
               FROM INSTRUCTOR'''
cursor_object.execute(statement)
#-THEN, can FETCH/VIEW it:
output_all = cursor_object.fetchall()
output_all  #GIVEN as 'NESTED LIST', with TUPLE for EACH ROW
#Looping thorugh to PRINT OUT EACH ROW:
for row_all in output_all:
    print(row_all)

#Can EVEN CONVERT the SELECT Output to 'Pandas DataFrame'!    
import pandas as pd
output_as_df = pd.DataFrame(output_all)   
#(adding the Headers for EACH Column too)
output_as_df.columns = ['ID', 'FNAME', 'LNAME', 'CITY', 'CCODE']
output_as_df   #AWESOME!

#Also, could use  'fetchmany(num_rows)' to ONLY fetch SPECIFIED NUMBER OF ROWS:
statement = '''SELECT * FROM INSTRUCTOR'''
cursor_object.execute(statement)
output_many = cursor_object.fetchmany(2)
for row_many in output_many:
    print(row_many)   #OR, could just use 'LIMIT' IN the STATEMENT!!!

#Fetching JUST 'FNAME' Column from the Table:
statement =''' SELECT FNAME
                FROM INSTRUCTOR '''
cursor_object.execute(statement)
output_column = cursor_object.fetchall()
for fetch in output_column:
    print(fetch)   #JUST Gives us Records from 'FNAME' COLUMN!

#Writing 'UPDATE' STATEMENT (SAME STEPS APPLY - SUPER SIMPLE!!):
query_update = '''UPDATE INSTRUCTOR
                  SET CITY = 'MOOSETOWN'
                  WHERE FNAME='Rav' 
               '''
cursor_object.execute(query_update)
#(USUAL CHECK to SEE IF it has been CHANGED:)
statement = '''SELECT * FROM INSTRUCTOR'''
cursor_object.execute(statement)
output1 = cursor_object.fetchmany(3)
for row in output1:
  print(row)


#         BETTER WAY to RETRIEVE Data 'INTO DATAFRAME':
#-using '.read_sql_query("query", connection)'
output_df = pd.read_sql_query("SELECT * FROM INSTRUCTOR;", conn)
output_df   #NICE!
#Now, can INTERACT WITH it LIKE NORMAL DataFrame:
output_df.LNAME[0]  #accessing SPECIFIC VALUES
output_df.shape

#FINALLY, ONCE ALL is DONE - IMPORTANT to 'CLOSE CONNECTION':
conn.close()

#%%                      ANALYSING a REAL-WORLD DATASET with SQL and PYTHON

#Have DATASET of 'SOCIOECONOMIC INDICATORS' in CHICAGO
#Contains '6 Socioeconomic Indicators' of 'PUBLIC HEALTH' Significance 
#ALSO given 'Hardship Index' (1=Lowest Hardship, 100 = GREATEST Hardship)
#Given for EACH Chicago COMMUNITY AREA from 2008-2012

#VARIABLES 
# Community Area Number ('ca')
# 'community_area_name'
#'percent_of_housing_crowded' (=PERCENTAGE of housing units with MORE THAN 1 Person PER ROOM), 
# 'percent_households_below_poverty' (households BELOW Federal POVERTY LINE)
# percent_aged_16_unemployed (people OVER 16 who are UNEMPLOYED)
# 'percent_aged_25_without_high_school_diploma' (people OVER 25 WITHOUT High School EDUCATION)
# 'percent_aged_under-18_or_over_64' 
# 'per_capita_income' (=SUM of tract-level AGGREGATE INCOMES, DIVIDED by TOTAL POPULATION)
# 'hardship_index' (Score which incorporates the 6 Socioeconomic Indicators, given in ABOVE Variables!)


#MAKE CONNECTION to DATABASE:
con = sqlite3.connect("socioeconomic.db")
cur = con.cursor()

#OBTAIN Data as CSV FILE INTO DATAFRAME:
import csv, sqlite3
import pandas as pd
df = pd.read_csv('https://data.cityofchicago.org/resource/jcxq-k9xf.csv')
df.columns.values
df.shape
#Use '.to_sql()' to CONVERT DATAFRAME TO a SQL TABLE (SAVES TABLE INTO the SQLite DATABASE connected to above (con), called 'socioeconomic.db'):
df.to_sql("chicago_socioeconomic_data", con, if_exists='replace', index=False,method="multi")
#Now have ADDED as TABLE TO 'socioeconomic.db' in SQLite!

#             Now, can perform SIMPLE ANALYSIS on this Table:

#-How many ROWS are there?
statement = '''SELECT COUNT(*) 
               FROM chicago_socioeconomic_data'''
cur.execute(statement)
num_rows = cur.fetchall()
num_rows   #78 rows (given within List, in a Nested Tuple)

#Chicago Community Areas with HARDSHIP INDEX 'ABOVE 50'
statement = '''SELECT COUNT(community_area_name)
               FROM chicago_socioeconomic_data
               WHERE hardship_index > 50'''
cur.execute(statement)
hardship_50= cur.fetchall()
hardship_50   #38 Community Areas have hardship_index ABOVE 50

#MAXIMUM VALUE of HARDSHIP INDEX in this DATASET:
statement = '''SELECT community_area_name, hardship_index
               FROM chicago_socioeconomic_data
               WHERE hardship_index = (SELECT MAX(hardship_index) FROM chicago_socioeconomic_data)
            '''
cur.execute(statement)
max_hardship= cur.fetchall()
max_hardship  # 'Riverdale' has HIGHEST HARDSHIP INDEX of '98'

#Community Areas with 'per_capita_income' ABOVE 60,000 dollars:
statement = '''SELECT community_area_name
               FROM chicago_socioeconomic_data
               WHERE per_capita_income_ > 60000
            '''
cur.execute(statement)
capita_above_60k =  cur.fetchall()
capita_above_60k   # 'Lake View', 'Lincoln Park', 'Near North Side', 'Loop'

#         ALL SUPER SIMPLE! Could EASILY have DONE within a 'RDMS Environment' TOO!


#Creating SCATTER PLOT for 'per_capita_income_' vs 'harship_index':
import matplotlib.pyplot as plt
import seaborn as sns
capita_plot1 = sns.scatterplot(x="per_capita_income_", y="hardship_index", data=df)
plt.show()   
#'NEGATIVE CORRELATION' - AS 'per_capita_income_' INCREASES, have LOWER 'hardship_index'
    
#Now, for 'per_capita_income' and 'percent_households_below_poverty' and 'percent_aged_16_unemployed'
capita_plot2 = sns.scatterplot(x="per_capita_income_", y="percent_households_below_poverty", data=df)
plt.show()   

capita_plot3 = sns.scatterplot(x="per_capita_income_", y="percent_aged_16_unemployed", data=df)
plt.show()   
#ALL these variables appear to have NEGATIVE CORREALTION with 'per_capita_income_' 

con.close()


#%%                     ANOTHER REAL-WORLD DATASET (ACCESSING SQLite Database IN PYTHON)

#'CHICAGO PUBLIC SCHOOLS' Progress Report Cards (2011-2012)
# = ALL School-Level PERFORMANCE DATA (available from 'Chicago Data Portal')
#Dataset Columns SCHEMA - 'https://data.cityofchicago.org/api/assets/AAD41A13-BE8A-4E67-B1F5-86E711E09D5F?download=true'
#Looking at METADATA from WEBSITE, this Table has '78 COLUMNS', '566' Rows, where EACH ROW is a SCHOOL.

#Downloaded CSV (STATIC COPY) of the Dataset
#Now can STORE the DATASET IN a 'SQL DATABASE TABLE':

#MAKE CONNECTION to DATABASE:
con = sqlite3.connect("RealWorldData.db")
cur = con.cursor()
    

#-First, 'READ the CSV' INTO a 'PANDAS DATAFRAME':
import pandas as pd
school_df = pd.read_csv("ChicagoPublicSchools.csv")
school_df.to_sql("ChicagoPublicSchools", con, if_exists='replace', index=False,method="multi")


#                   'RETRIEVE METADATA' (By QUERYING the Database System Catalog)
#Here 'in SQLite3', METADATA is GIVEN in TABLE 'sqlite_master'
statement = '''SELECT name
               FROM sqlite_master 
               WHERE type = "table"
            '''
cur.execute(statement)
metadata_name = cur.fetchall()
metadata_name  #ChicagoPublicSchools Table is WITHIN the DATABASE only!

#QUERYING for 'Number of COLUMNS' in 'ChicagoPublicSchools' Table:
statement = '''SELECT count(name)
               FROM PRAGMA_TABLE_INFO('ChicagoPublicSchools')
               
            '''
cur.execute(statement)
column_names= cur.fetchall()
column_names  #ChicagoPublicSchools Table Column Names

#Retrieving All 'COLUMN NAMES', 'DATA TYPES' and 'LENGTH':
statement = '''SELECT name, type, Length(type)
               FROM PRAGMA_TABLE_INFO('ChicagoPublicSchools')               
            '''
cur.execute(statement)
column_data = cur.fetchall()
column_data   #ChicagoPublicSchools Table Metadata

#SAVING this Metadata INTO a DATAFRAME:
metadata_df = pd.read_sql_query('''SELECT name, type, Length(type) FROM PRAGMA_TABLE_INFO('ChicagoPublicSchools')''', con)

#e.g. 'School_ID' is in MIXED CASE, so must use "" when QUERYING it!
#COMMUNITY_AREA_NAME... have SPACES replaced with '_' (cleaner!)


#                NOW ANSWERING some QUESTIONS with QUERYING:

#1. How many Elementary Schools are in the Dataset?
cur.execute("""SELECT COUNT(*) 
               FROM ChicagoPublicSchools
               WHERE "Elementary, Middle, or High School" = "ES";  
            """)
elementary_schools = cur.fetchall()
elementary_schools   # =  '462' Elementary Schools

#2. What is HIGHEST SAFETY SCORE?
cur.execute("""SELECT MAX(SAFETY_SCORE)
               FROM ChicagoPublicSchools;
            """)
highest_safety_score = cur.fetchall()
highest_safety_score # MAX Safety Score = '99'


#3. Which SCHOOLS have HIGHEST Safety Score?
cur.execute("""SELECT NAME_OF_SCHOOL, SAFETY_SCORE
               FROM ChicagoPublicSchools
               WHERE SAFETY_SCORE = (SELECT MAX(SAFETY_SCORE) FROM ChicagoPublicSchools);
            """)
schools_with_highest_score = cur.fetchall()
schools_with_highest_score # MAX Safety Score = '99'
#(great use of SUBQUERY! Nice!)

#4. TOP 10 SCHOOLS with HIGHEST 'Average Student Attendance'?
cur.execute("""SELECT NAME_OF_SCHOOL, AVERAGE_STUDENT_ATTENDANCE
               FROM ChicagoPublicSchools
               ORDER BY AVERAGE_STUDENT_ATTENDANCE DESC
               LIMIT 10;
            """)
schools_with_highest_attendance = cur.fetchall()
schools_with_highest_attendance  

#5. 'Top 5 SCHOOLS' with 'LOWEST AVERAGE ATTENDANCE'?
cur.execute("""SELECT NAME_OF_SCHOOL, AVERAGE_STUDENT_ATTENDANCE
               FROM ChicagoPublicSchools
               ORDER BY AVERAGE_STUDENT_ATTENDANCE 
               LIMIT 5;
            """)
schools_with_lowest_attendance = cur.fetchall()
schools_with_lowest_attendance   

#6. REPEATING, but NOW REMOVING '%' CHARACTER FROM 'Average_Student_Attendance'
cur.execute("""SELECT NAME_OF_SCHOOL, REPLACE(AVERAGE_STUDENT_ATTENDANCE, "%", '')
               FROM ChicagoPublicSchools
               ORDER BY AVERAGE_STUDENT_ATTENDANCE 
               LIMIT 5;
            """)
schools_with_lowest_attendance = cur.fetchall()
schools_with_lowest_attendance   

#7. WHICH Schools have AVERAGE_STUDENT_ATTENDANCE lower than '70%'?
cur.execute("""SELECT NAME_OF_SCHOOL, AVERAGE_STUDENT_ATTENDANCE
               FROM ChicagoPublicSchools
               WHERE AVERAGE_STUDENT_ATTENDANCE < '70%'
               ORDER BY 2 DESC
            """)
attendance_below_70 = cur.fetchall()
attendance_below_70

#8. 'TOTAL COLLEGE ENROLLMENT' for 'EACH Community Area'?
cur.execute("""SELECT COMMUNITY_AREA_NAME, SUM(COLLEGE_ENROLLMENT)
               FROM ChicagoPublicSchools
               GROUP BY COMMUNITY_AREA_NAME
               ORDER BY 2 DESC;
                """)
total_college_enrollment = cur.fetchall()
total_college_enrollment

#9. The 5 'COMMUNITY AREAS' with LOWEST 'TOTAL COLLEGE ENROLLMENT'?
cur.execute("""SELECT COMMUNITY_AREA_NAME, SUM(COLLEGE_ENROLLMENT)
               FROM ChicagoPublicSchools
               GROUP BY COMMUNITY_AREA_NAME
               ORDER BY 2 ASC
               LIMIT 5;
                """)
total_college_enrollment = cur.fetchall()
total_college_enrollment 

#10. What are 5 Schools with LOWEST 'SAFETY_SCORE'?
cur.execute("""SELECT NAME_OF_SCHOOL, SAFETY_SCORE
               FROM ChicagoPublicSchools
               WHERE SAFETY_SCORE IS NOT NULL
               ORDER BY 2 ASC
               LIMIT 5;
            """)
schools_with_lowest_score = cur.fetchall()
schools_with_lowest_score 

#11. 'HARDSHIP INDEX' for 'COMMUNITY AREA' with 'COLLEGE ENROLLMENT' of '4368'?
# ('hardship_index' column is from ANOTHER TABLE 'CENSUS_DATA' which we can LOAD NOW:)
census_df = pd.read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-DB0201EN-SkillsNetwork/labs/FinalModule_Coursera_V5/data/ChicagoCensusData.csv")
census_df.to_sql("CENSUS_DATA", con, if_exists='replace', index=False,method="multi")

cur.execute("""SELECT cd.hardship_index, cps.COMMUNITY_AREA_NAME, cps.COLLEGE_ENROLLMENT
               FROM ChicagoPublicSchools AS cps
               JOIN CENSUS_DATA AS cd
               ON cps.COMMUNITY_AREA_NUMBER = cd.COMMUNITY_AREA_NUMBER               
               WHERE COLLEGE_ENROLLMENT = 4368
            """)
hardship_index= cur.fetchall()
hardship_index    #'NORTH CENTER', with 'hardship_index' of '6'

#12. 'HARDSHIP INDEX' for 'COMMUNITY AREA' with 'HIGHEST VALUE of COLLEGE ENROLLMENT'?
cur.execute("""SELECT cd.hardship_index, cps.COMMUNITY_AREA_NUMBER, cps.COMMUNITY_AREA_NAME, cps.COLLEGE_ENROLLMENT
               FROM ChicagoPublicSchools AS cps
               JOIN CENSUS_DATA AS cd
               ON cps.COMMUNITY_AREA_NUMBER = cd.COMMUNITY_AREA_NUMBER               
               ORDER BY COLLEGE_ENROLLMENT DESC
               LIMIT 1;
            """)
highest_hardship_index= cur.fetchall()
highest_hardship_index    #'NORTH CENTER', with 'hardship_index' of '6'


con.close()


#%%                      'JOIN' STATEMENT PRACTICE in SQLite (in PYTHON)
import sqlite3
con = sqlite3.connect("HR.db")
cur = con.cursor()

#-First, 'READ the CSV' INTO a 'PANDAS DATAFRAME' (Here, need to ADD HEADER Columns in Python!):
import pandas as pd
departments_df = pd.read_csv("Departments.csv", header=None)
departments_df.columns = ['DEPT_ID_DEP', 'DEP_NAME', 'MANAGER_ID', 'LOC_ID']
departments_df.head()
employees_df= pd.read_csv("employees.csv", header=None)
employees_df.columns = ['EMP_ID', 'F_NAME', 'L_NAME', 'SSN', 'B_DATE', 'SEX', 'ADDRESS', 'JOB_ID', 'SALARY', 'MANAGER_ID', 'DEP_ID']
employees_df.head()
jobs_df= pd.read_csv("Jobs.csv", header=None)
jobs_df.columns = ['JOB_IDENT', 'JOB_TITLE', 'MIN_SALARY', 'MAX_SALARY']
jobs_df.head()
history_df= pd.read_csv("JobsHistory.csv", header=None)
history_df.columns = ['EMP_ID', 'START_DATE', 'JOBS_ID', 'DEPT_ID']
history_df.head()
locations_df= pd.read_csv("Locations.csv", header=None)
locations_df.columns = ['LOCT_ID', 'DEP_ID_LOC']
locations_df.head()

#-Converting Dataframes into SQL Tables (stored IN 'HR.db' Database)
departments_df.to_sql("DEPARTMENTS", con, if_exists='replace', index=False,method="multi")
employees_df.to_sql("EMPLOYEES", con, if_exists='replace', index=False,method="multi")
jobs_df.to_sql("JOBS", con, if_exists='replace', index=False,method="multi")
history_df.to_sql("JOB_HISTORY", con, if_exists='replace', index=False,method="multi")
locations_df.to_sql("LOCATIONS", con, if_exists='replace', index=False,method="multi")


#                   Using 'JOINS' to GATHER INSIGHTS

#1. What are 'names', 'job start dates' of ALL Employees in 'department 5'?
cur.execute("""SELECT F_NAME, L_NAME, START_DATE, E.DEP_ID 
               FROM EMPLOYEES E 
               JOIN JOB_HISTORY H 
               ON E.EMP_ID = H.EMPL_ID 
               WHERE E.DEP_ID = 5;
            """)
query1 = cur.fetchall()
#(storing in DataFrame with 'pd.read_sql_query')
query1_df = pd.read_sql_query("SELECT F_NAME, L_NAME, START_DATE, E.DEP_ID FROM EMPLOYEES E JOIN JOB_HISTORY H ON E.EMP_ID = H.EMPL_ID WHERE E.DEP_ID = 5", con)
query1_df 

#2. What are names, start_dates AND 'job_titles' of ALL Employees who work for 'department 5'?
cur.execute(""" SELECT F_NAME, L_NAME, START_DATE, J.JOB_TITLE, E.DEP_ID 
                FROM EMPLOYEES E 
                JOIN JOB_HISTORY H 
                ON E.EMP_ID = H.EMPL_ID 
                JOIN JOBS J
                ON E.JOB_ID = J.JOB_IDENT
                WHERE E.DEP_ID = 5;
            """)
query2 = cur.fetchall()
query2_df = pd.read_sql_query(""" SELECT F_NAME, L_NAME, START_DATE, J.JOB_TITLE, E.DEP_ID FROM EMPLOYEES E JOIN JOB_HISTORY H ON E.EMP_ID = H.EMPL_ID JOIN JOBS J ON E.JOB_ID = J.JOB_IDENT WHERE E.DEP_ID = 5""", con)
query2_df 

#3. With 'LEFT JOIN', what is employee id, last name, department id and 'department name'?
cur.execute(""" SELECT EMP_ID, L_NAME, DEP_ID, D.DEP_NAME 
                FROM EMPLOYEES E 
                LEFT JOIN DEPARTMENTS D 
                ON E.DEP_ID = D.DEPT_ID_DEP;
            """)
query3 = cur.fetchall()
query3_df = pd.read_sql_query(""" SELECT EMP_ID, L_NAME, DEP_ID, D.DEP_NAME FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D ON E.DEP_ID = D.DEPT_ID_DEP""", con)
query3_df 

#4. Limit Previous Query, only for Employees Born BEFORE 1980
cur.execute(""" SELECT EMP_ID, L_NAME, E.B_DATE, DEP_ID, D.DEP_NAME 
                FROM EMPLOYEES E 
                LEFT JOIN DEPARTMENTS D 
                ON E.DEP_ID = D.DEPT_ID_DEP
                WHERE E.B_DATE < '1980-01-01';
            """)
query4 = cur.fetchall()
query4_df = pd.read_sql_query("""SELECT EMP_ID, L_NAME, E.B_DATE, DEP_ID, D.DEP_NAME 
                FROM EMPLOYEES E 
                LEFT JOIN DEPARTMENTS D 
                ON E.DEP_ID = D.DEPT_ID_DEP
                WHERE E.B_DATE < '1980-01-01'; """, con)
query4_df 

#5. Including 'ALL EMPLOYEES', but ONLY SHOWING 'Department Names' for Employees BORN BEFORE 1980;
cur.execute(""" SELECT EMP_ID, L_NAME, E.B_DATE, DEP_ID, D.DEP_NAME 
                FROM EMPLOYEES E 
                LEFT JOIN DEPARTMENTS D 
                ON E.DEP_ID = D.DEPT_ID_DEP 
                AND E.B_DATE < '1980-01-01';
            """)
query5 = cur.fetchall()
query5_df = pd.read_sql_query("""SELECT EMP_ID, L_NAME, E.B_DATE, DEP_ID, D.DEP_NAME 
                FROM EMPLOYEES E 
                LEFT JOIN DEPARTMENTS D 
                ON E.DEP_ID = D.DEPT_ID_DEP
                AND E.B_DATE < '1980-01-01'; """, con)
query5_df 

#6. Perform FULL JOIN on EMPLOYEES and DEPARTMENT Tables, selecting first_name, last_name and Department_name
cur.execute(""" SELECT F_NAME, L_NAME, D.DEP_NAME
                FROM EMPLOYEES E
                LEFT JOIN DEPARTMENTS D
                ON E.DEP_ID = D.DEPT_ID_DEP
                UNION
                SELECT F_NAME, L_NAME, D.DEP_NAME
                FROM EMPLOYEES E
                RIGHT JOIN DEPARTMENTS D
                ON E.DEP_ID = D.DEPT_ID_DEP
            """)
query6 = cur.fetchall()
query6_df = pd.read_sql_query("""SELECT F_NAME, L_NAME, D.DEP_NAME
                                FROM EMPLOYEES E
                                FULL OUTER JOIN DEPARTMENTS D
                                ON E.DEP_ID = D.DEPT_ID_DEP
                                """, con)
query6_df  #NOTE - FULL OUTER JOINS MAY NOT be SUPPORTED - so MAY NOT WORK!

#7. Include ALL EMPLOYEES, but ONLY MALE Employees for department_id and department_names
cur.execute(""" SELECT F_NAME, L_NAME, D.DEP_NAME, E.SEX
                FROM EMPLOYEES E
                LEFT JOIN DEPARTMENTS D
                ON E.DEP_ID = D.DEPT_ID_DEP AND E.SEX = 'M'
                ORDER BY E.SEX;
            """)
query7 = cur.fetchall()
query7_df = pd.read_sql_query("""SELECT F_NAME, L_NAME, D.DEP_NAME, E.SEX
                                 FROM EMPLOYEES E
                                 LEFT JOIN DEPARTMENTS D
                                 ON E.DEP_ID = D.DEPT_ID_DEP AND E.SEX = 'M' 
                                 ORDER BY E.SEX""", con)
query7_df 




#%%
#            CONNECTING to DATABASE using 'ibm_db' API:
#             (ALL STEPS are GIVEN IN WORD FILE NOTES!!)

#    SQL MAGIC also covered in Word File (ALTERNATIVE WAY to write SQL in JUPYTER NOTEBOOKS!)


#%%                    ANALYSIS on DATABASE DATA IN PYTHON:

#McDonalds Menu Nutritional Facts Data (CSV from Kaggle)

#FOUR STEPS for LOADING DATA INTO Table (SOURCE - TARGET - DEFINE - FINALIZE)
#1. SOURCE - LOAD CSV File INTO 'Db2 on CLOUD'
#2. Select TARGET SCHEMA
#3. DEFINE Table (also lets us modify a Table NAME, COLUMNS and DATA TYPES)
#4. FINALIZE - REVIEW Settings and LOAD

#Now can USE PYTHON to ACCESS the DATA FROM the DATABASE!
#CONVERT into DATAFRAME, THEN can perform EXPLORATORY DATA ANALYSIS (ALL Covered in Separate Notes!)

#e.g. use '.describe()' to view summary stats
#"Which Foods has MAX Sodium Content?"
#-PLOT a 'SWARMPLOT' (=CATEGORICAL SCATTER PLOT)
#now, doing 'df['Sodium'].describe()' - can find 'MAX' Sodium Value, which is '3600'
#can find df['Sodium'] where 'Sodium' value = this MAX Value (3600)
#one way - find INDEX of MAX Value:  df['Sodium'].idxmax()' - gives INDEX '82'
#NOW can do df.at[82, 'Item']
# 'df.at[index, column]' ACCESSING RECORD Value at SPECIFIC INDEX, for SPECIFIC COLUMN!

#NOTHING NEW! Just see Data Analysis Notes for WHAT to DO!


#%%











