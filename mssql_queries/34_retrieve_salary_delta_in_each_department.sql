-- ########  
DECLARE @jsonEmployees nvarchar(max)

SET @jsonEmployees ='[
		{   "employee_id":12,"FirstName":"Adam",    "LastName":"Owens","department_id":"Marketing","Salary":"30000", "hire_date": "2024-11-02"},
		{	"employee_id":23,"FirstName":"Mark",    "LastName":"Wilis","department_id":"Engineering","Salary":"85000", "hire_date":"2023-07-24"},
		{	"employee_id":34,"FirstName":"Elizabeth","LastName":"Lee","department_id":"Marketing","Salary":"40000", "hire_date":"2022-08-02"},
		{	"employee_id":45,"FirstName":"Adam",    "LastName":"Garcia","department_id":"Engineering","Salary":"60000", "hire_date":"2022-05-30"},
		{	"employee_id":51,"FirstName":"Riley",   "LastName":"Jones","department_id":"Marketing","Salary":"75000", "hire_date":"2021-04-26"},
		{	"employee_id":52,"FirstName":"John",   "LastName":"Colapinto","department_id":"Sales","Salary":"45000", "hire_date":"2021-04-26"},
		{	"employee_id":53,"FirstName":"Juan",   "LastName":"Perez","department_id":"Custoner_Services","Salary":"35000", "hire_date":"2021-04-26"},
		{	"employee_id":61,"FirstName":"Natasha", "LastName":"Smith","department_id":"Sales","Salary":"45000", "hire_date":"2023-10-09"}]'

--   replace empty entries by NULL
SET @jsonEmployees = REPLACE(@jsonEmployees, '""','null')

DECLARE @Employee TABLE(
		[employee_id] [nvarchar](50) NULL,
		[FirstName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NULL,
		[department_id] [nvarchar](50) NULL,
		[Salary] float NULL,
		[hire_date] DATE NULL
		)

INSERT INTO @Employee (
		[employee_id],
		[FirstName],
		[LastName],
		[department_id],
		[Salary],
		[hire_date]
		)

SELECT * from openjson(@jsonEmployees)
WITH
(
		[employee_id] nvarchar(50) '$.employee_id',
		[FirstName] nvarchar(50) '$.FirstName',
		[LastName] nvarchar(50) '$.LastName',
		[department_id] nvarchar(50) '$.department_id',
		[Salary] float '$.Salary',
		[hire_date] DATE '$.hire_date'
);

select * from @Employee

/*
	employee_id	FirstName	LastName	department_id		Salary	hire_date
	--------------------------------------------------------------------------
	12			Adam		Owens		Marketing			30000	2024-11-02
	23			Mark		Wilis		Engineering			85000	2023-07-24
	34			Elizabeth	Lee			Marketing			40000	2022-08-02
	45			Adam		Garcia		Engineering			60000	2022-05-30
	51			Riley		Jones		Marketing			75000	2021-04-26
	52			John		Colapinto	Sales				45000	2021-04-26
	53			Juan		Perez		Custoner_Services	35000	2021-04-26
	61			Natasha	S	mith		Sales				45000	2023-10-09
*/


SELECT 	department_id, 
		MAX(Salary) - MIN(Salary)  AS salary_diff
FROM @Employee
GROUP BY department_id

/*
	department_id		salary_diff	pct
	------------------------------------------------
	Custoner_Services	0
	Engineering			25000
	Marketing			45000
	Sales				0
*/