-- ########  
DECLARE @jsonEmployees nvarchar(max)

SET @jsonEmployees ='[
		{   "EmployeeID":1,"FirstName":"Adam",    "LastName":"Owens","deparmentID":"100","Salary":"30000", "hire_date": "2024-11-02"},
		{	"EmployeeID":2,"FirstName":"Mark",    "LastName":"Wilis","deparmentID":"101","Salary":"85000", "hire_date":"2023-07-24"},
		{	"EmployeeID":3,"FirstName":"Elizabeth","LastName":"Lee","deparmentID":"100","Salary":"40000", "hire_date":"2022-08-02"},
		{	"EmployeeID":4,"FirstName":"Adam",    "LastName":"Garcia","deparmentID":"101","Salary":"60000", "hire_date":"2022-05-30"},
		{	"EmployeeID":5,"FirstName":"Riley",   "LastName":"Jones","deparmentID":"100","Salary":"75000", "hire_date":"2021-04-26"},
		{	"EmployeeID":6,"FirstName":"Natasha", "LastName":"Smith","deparmentID":"","Salary":"45000", "hire_date":"2023-10-09"}]'

--   replace empty entries by NULL
SET @jsonEmployees = REPLACE(@jsonEmployees, '""','null')

DECLARE @Employee TABLE(
		[EmployeeID] [nvarchar](50) NULL,
		[FirstName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NULL,
		[deparmentID] [nvarchar](50) NULL,
		[Salary] [nvarchar](50) NULL,
		[hire_date] DATE NULL
		)

INSERT INTO @Employee (
		[EmployeeID],
		[FirstName],
		[LastName],
		[deparmentID],
		[Salary],
		[hire_date]
		)

SELECT * from openjson(@jsonEmployees)
WITH
(
		[EmployeeID] nvarchar(50) '$.EmployeeID',
		[FirstName] nvarchar(50) '$.FirstName',
		[LastName] nvarchar(50) '$.LastName',
		[deparmentID] nvarchar(50) '$.deparmentID',
		[Salary] nvarchar(50) '$.Salary',
		[hire_date] DATE '$.hire_date'
);

select * from @Employee

/*
EmployeeID	FirstName	LastName	deparmentID		Salary	hire_date
--------------------------------------------------------------------
1			Adam		Owens		100				30000	2024
2			Mark		Wilis		101				85000	2023
3			Elizabeth	Lee			100				40000	2022
4			Adam		Garcia		101				60000	2022
5			Riley		Jones		100				75000	2021
6			Natasha		Smith		NULL			45000	2023
*/


SELECT * FROM @Employee
WHERE salary BETWEEN 50000 AND 80000


/*
EmployeeID	FirstName	LastName	deparmentID		Salary	hire_date
-----------------------------------------------------------------------
4			Adam		Garcia		101				60000	2022-05-30
5			Riley		Jones		100				75000	2021-04-26
*/