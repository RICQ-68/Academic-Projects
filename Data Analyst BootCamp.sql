USE BEAST_MODE          
GO
--table1
Create TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int, 
Gender varchar(50)
)

--table2

USE BEAST_MODE
GO
Create TABLE EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int
)

--inserting into the tables

INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')





--select statement 
/* Top, Distinct/Unique, Count, AS-(used to name), MAX, MIN, AVG
*/


--Where statement-(Specifies limit of data)

Select *
From EmployeeDemographics
Where FirstName <> 'Jim' --(<> not equal to)


Select *
From EmployeeDemographics
Where LastName Like 'S%o%'


--IN (multiple  equals)
Select *
From EmployeeDemographics
Where FirstName IN ('Jim', 'Michael')

--Group by, Order by

Select *
From EmployeeDemographics
Order by 4/*(Column number)*/,5

Select Gender , COUNT(Gender) AS CountGender
From EmployeeDemographics
Where Age > 31
Group by Gender


Select Gender,Age, COUNT(Gender)
From EmployeeDemographics
Group by Gender, Age


--JOINS.
--Inner joins, Full, Left, Right, outer joins

Select *
From EmployeeDemographics
Inner Join EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

Select *
From EmployeeSalary


--CASE statements

Select FirstName, LastName, Age,
CASE 
	WHEN Age > 30 THEN 'Old'
	ELSE 'Young'
END
From EmployeeDemographics
Where Age is NOT NULL
Order by Age


Select FirstName, LastName, JobTitle, Salary,
CASE 
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
	ELSE Salary + (Salary * .03)
END AS NewSalary
From EmployeeDemographics
Inner Join EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--Having Clause
--used after the group by statement
--(COUNT can only be used with Group By statements)

Select JobTitle, COUNT(JobTitle) AS Total
From EmployeeDemographics
Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Group By JobTitle
HAVING  AVG(Salary) > 45000


--Updating and deleting data

--insert into(creates a new row in table)
--Updating alters an existing row in table. Used together with 'SET'
--delete removes specific rows in table

Insert into EmployeeDemographics VALUES
(1010, 'Ryan', 'Howard', 26, 'Male'), 
(NULL, 'Holly', 'Flax', NULL, NULL), 
(1013, 'Daryl', 'Python', NULL, 'Male')



Update EmployeeDemographics
SET Age = 31, Gender = 'Female'
Where FirstName = 'Holly' AND LastName = 'Flax'


Select *
From EmployeeDemographics

Delete EmployeeDemographics
Where EmployeeID = 1012


--Aliasing

Select FirstName + ' ' + LastName AS FullName
From EmployeeDemographics

--aliasing table names
Select Demo.EmployeeID
From EmployeeDemographics Demo


--Partition by (divides data into partitions)

USE BEAST_MODE
GO
Select FirstName, LastName, Gender, Salary, 
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
From EmployeeDemographics ED
JOIN EmployeeSalary S
	ON ED.EmployeeID = S.EmployeeID


USE BEAST_MODE
GO
Select FirstName, LastName, Gender, Salary, COUNT(Gender) 
From EmployeeDemographics ED
JOIN EmployeeSalary S
	ON ED.EmployeeID = S.EmployeeID
GROUP BY FirstName, LastName, Gender, Salary


--CTEs (Common Table Expression)

WITH CTE_Employee as 
(
Select FirstName, LastName, Gender, Salary, 
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender,
AVG (Salary) OVER (PARTITION BY Gender) as AvgSalary
From EmployeeDemographics ED
JOIN EmployeeSalary S
	ON ED.EmployeeID = S.EmployeeID
Where Salary > '45000'
)
Select *
From CTE_Employee


--TEMP Tables
Create Table #temp_Employee(
EmployeeID int,
JobTitle varchar (100),
Salary int
)

Select *
From #temp_Employee

INSERT INTO #temp_Employee VALUES
(1001, 'HR', 45000)

--use values from other tables into our temp table

USE BEAST_MODE
GO
INSERT INTO #temp_Employee 

Select *
FROM EmployeeSalary

Update #temp_Employee
SET EmployeeID = 999
Where EmployeeID = 1001 AND JobTitle = 'HR'


--temp table2

DROP TABLE IF EXISTS #temp_Employee2
Create Table #temp_Employee2(
JobTitle varchar (50), 
EmployeesPerJob int, 
AvgAge int, 
AvgSalary int
)
Select *
From #temp_Employee2


USE BEAST_MODE
GO
INSERT INTO #temp_Employee2
Select JobTitle, COUNT(JobTitle), Avg(Age), AVG(Salary)
From EmployeeDemographics ED
JOIN EmployeeSalary S
	ON ED.EmployeeID = S.EmployeeID
GROUP BY JobTitle

Select *
From #temp_Employee2


--String FUnctions -(trim, LTRIM, RLTRIM, replace, Substring, Upper, Lower)

Create Table EmployeeErrors(
EmployeeID varchar(50),
FirstName varchar (50), 
LastName varchar (50)
)
INSERT INTO EmployeeErrors Values
('1001 ', 'Jimbo', 'Halbert'), 
('  1002', 'Pamela', 'Beasley'), 
('1003', 'TOby', 'Flenderson-Fired')

Select *
From EmployeeErrors

--Using TRIM, LTRIM, RTRIM (Gets rid of line spaces)

Select EmployeeID, TRIM (EmployeeID) as IDTRIM
From EmployeeErrors

Select EmployeeID, LTRIM (EmployeeID) as IDTRIM
From EmployeeErrors

Select EmployeeID, RTRIM (EmployeeID) as IDTRIM
From EmployeeErrors

--Using REPLACE

Select LastName, REPLACE (LastName, '-Fired', '') as LastNameFixed
From EmployeeErrors

--Using Substring

Select *
From EmployeeErrors

Select SUBSTRING (FirstName,3,3)
From EmployeeErrors

--Fuzzy matching (eg. ALEX and ALEXANDER)
USE BEAST_MODE
GO
Select ER.FirstName,SUBSTRING (ER.FirstName,1,3), ED.FirstName, SUBSTRING (ED.FirstName,1,3)
From EmployeeErrors ER
JOIN EmployeeDemographics ED
	ON SUBSTRING (ER.FirstName,1,3) = SUBSTRING (ED.FirstName,1,3)

	--Fuzzy matching on gender, lastname, age, DOB etc


--Using UPPER and LOWER (upper & lower case)

Select FirstName, LOWER (FirstName)
From EmployeeErrors

Select FirstName, UPPER (FirstName) 
From EmployeeErrors


--Stored Procedures
USE BEAST_MODE
GO
Create Procedure TEST
AS
Select *
From EmployeeDemographics

EXEC TEST


Create PROCEDURE Temp_Employee
AS
Create Table #temp_Employee2(
JobTitle varchar (100), 
EmployeesPerJob int, 
AvgAge int, 
AvgSalary int
)
INSERT INTO #temp_Employee2
Select JobTitle, COUNT(JobTitle), Avg(Age), AVG(Salary)
From EmployeeDemographics ED
JOIN EmployeeSalary S
	ON ED.EmployeeID = S.EmployeeID
GROUP BY JobTitle
Select *
From #temp_Employee

EXEC Temp_Employee


Exec Temp_Employee


--Subqueries

Select *
From EmployeeSalary

--Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

--How to do it in Partition by
 
Select EmployeeID, Salary, AVG(Salary) OVER () as AllAvgSalary
From EmployeeSalary

--Why Group by doesnt work

Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
Order by 1

--Subquery in from

Select A.EmployeeID, AllAvgSalary
From	(Select EmployeeID, Salary, AVG(Salary) OVER () as AllAvgSalary
		From EmployeeSalary) A

--Suquery in Where

Select EmployeeID, JobTitle, Salary
from EmployeeSalary
Where EmployeeID IN (
		Select EmployeeID
		from EmployeeDemographics
		Where Age > 30
)