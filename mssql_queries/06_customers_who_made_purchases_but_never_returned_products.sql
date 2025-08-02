-- ########  Detect all duplicates in a Table
DECLARE @jsonCustomers nvarchar(max)

SET @jsonCustomers ='[
		{   "Customers_id":1,"FirstName":"Adam",    "LastName":"Owens","store_id":"100","Purchase":"300"},
		{	"Customers_id":2,"FirstName":"Mark",    "LastName":"Wilis","store_id":"101","Purchase":"850"},
		{	"Customers_id":3,"FirstName":"Elizabeth", "LastName":"Lee",  "store_id":"100","Purchase":"400"},
		{	"Customers_id":4,"FirstName":"Adam",    "LastName":"Garcia","store_id":"101","Purchase":"60"},
		{	"Customers_id":5,"FirstName":"Riley",   "LastName":"Jones","store_id":"100","Purchase":"750"},
		{	"Customers_id":6,"FirstName":"Natasha", "LastName":"Smith", "store_id":"","Purchase":"45"}]'

--   replace empty entries by NULL
SET @jsonCustomers = REPLACE(@jsonCustomers, '""','null')

DECLARE @Customers TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[FirstName] [nvarchar](50) NULL,
		[LastName] [nvarchar](50) NULL,
		[store_id] [nvarchar](50) NULL,
		[Purchase] [nvarchar](50) NULL
		)

INSERT INTO @Customers (
		[Customers_id],
		[FirstName],
		[LastName],
		[store_id],
		[Purchase]
		)

SELECT * from openjson(@jsonCustomers)
WITH
(
		[Customers_id] nvarchar(50) '$.Customers_id',
		[FirstName] nvarchar(50) '$.FirstName',
		[LastName] nvarchar(50) '$.LastName',
		[store_id] nvarchar(50) '$.store_id',
		[Purchase] nvarchar(50) '$.Purchase'		
);

select * from @Customers

/*
Customers_id	FirstName	LastName	store_id		Purchase
-----------------------------------------------------------
1			Adam		Owens		100				30000
2			Mark		Wilis		101				85000
3			Elizabeth	Lee			100				40000
4			Adam		Garcia		101				60000
5			Riley		Jones		100				75000
6			Natasha		Smith		NULL			45000
*/

DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customers_id":"1","Description":"Clothing"},
		{	"Customers_id":"4","Description":"Electronics"},
		{	"Customers_id":"2","Description":"Furniture"},
		{	"Customers_id":"5","Description":"Clothing"}]'

DECLARE @Orders TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[Description] [nvarchar](50) NULL
		)

INSERT INTO @Orders (
		[Customers_id],
		[Description]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[Customers_id] nvarchar(50) '$.Customers_id',
		[Description] nvarchar(50) '$.Description'		
);

select * from @Orders

/*
	Customers_id	Description
	-----------------------------
	1				Clothing
	4				Electronics
	2				Furniture
	5				Clothing
*/	


DECLARE @jsonReturns nvarchar(max)

SET @jsonReturns ='[
		{   "Customers_id":"1","Description_return":"Clothing"},
		{	"Customers_id":"2","Description_return":"Furniture"},
		{	"Customers_id":"5","Description_return":"Clothing"}]'

DECLARE @Returns TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[Description_return] [nvarchar](50) NULL
		)

INSERT INTO @Returns (
		[Customers_id],
		[Description_return]
		)

SELECT * from openjson(@jsonReturns)
WITH
(
		[Customers_id] nvarchar(50) '$.Customers_id',
		[Description_return] nvarchar(50) '$.Description_return'		
);

select * from @Returns

/*
	Customers_id	Description_return
	-------------------------------------
	1				Clothing
	2				Furniture
	5				Clothing

*/

--==== Customers who made purchases but never returned products

SELECT DISTINCT c.Customers_id  FROM @Customers c 
JOIN @Orders o ON c.Customers_id = o.Customers_id
WHERE c.Customers_id NOT IN (SELECT Customers_id FROM @Returns);


/*
	Customers_id
	------------
	4
*/	
