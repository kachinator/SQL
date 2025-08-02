-- ########  Detect all duplicates in a Table
DECLARE @jsonEmployees nvarchar(max)

SET @jsonEmployees ='[
		{   "EmployeeID":1,"FirstName":"Adam",    "LastName":"Owens","deparmentID":"100","Salary":"30000"},
		{	"EmployeeID":2,"FirstName":"Mark",    "LastName":"Wilis","deparmentID":"101","Salary":"85000"},
		{	"EmployeeID":3,"FirstName":"Elizabeth", "LastName":"Lee",  "deparmentID":"100","Salary":"40000"},
		{	"EmployeeID":4,"FirstName":"Adam",    "LastName":"Garcia","deparmentID":"101","Salary":"60000"},
		{	"EmployeeID":5,"FirstName":"Riley",   "LastName":"Jones","deparmentID":"100","Salary":"75000"},
		{	"EmployeeID":6,"FirstName":"Natasha", "LastName":"Smith", "deparmentID":"","Salary":"45000"}]'

--   replace empty entries by NULL
SET @jsonEmployees = REPLACE(@jsonEmployees, '""','null')

DECLARE @Employee TABLE(
		[EmployeeID] [nvarchar](50) NULL,
		[FirstName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NULL,
		[deparmentID] [nvarchar](50) NULL,
		[Salary] [nvarchar](50) NULL
		)

INSERT INTO @Employee (
		[EmployeeID],
		[FirstName],
		[LastName],
		[deparmentID],
		[Salary]
		)

SELECT * from openjson(@jsonEmployees)
WITH
(
		[EmployeeID] nvarchar(50) '$.EmployeeID',
		[FirstName] nvarchar(50) '$.FirstName',
		[LastName] nvarchar(50) '$.LastName',
		[deparmentID] nvarchar(50) '$.deparmentID',
		[Salary] nvarchar(50) '$.Salary'		
);

select * from @Employee

/*
EmployeeID	FirstName	LastName	deparmentID		Salary
-----------------------------------------------------------
1			Adam		Owens		100				30000
2			Mark		Wilis		101				85000
3			Elizabeth	Lee			100				40000
4			Adam		Garcia		101				60000
5			Riley		Jones		100				75000
6			Natasha		Smith		NULL			45000
*/


SELECT TOP 3 * FROM @Employee
ORDER BY Salary DESC;

/*
EmployeeID	FirstName	LastName	deparmentID		Salary
-----------------------------------------------------------
2			Mark		Wilis		101				85000
5			Riley		Jones		100				75000
4			Adam		Garcia		101				60000
*/