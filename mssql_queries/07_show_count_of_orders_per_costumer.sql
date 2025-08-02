-- ########  Detect all duplicates in a Table
DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customers_id":100,"store_id":"100","Purchase":"70"},
		{	"Customers_id":200,"store_id":"101","Purchase":"85"},
		{	"Customers_id":100,"store_id":"100","Purchase":"40"},
		{	"Customers_id":400,"store_id":"101","Purchase":"60"},
		{	"Customers_id":400,"store_id":"101","Purchase":"32"},
		{	"Customers_id":200,"store_id":"101","Purchase":"32"},
		{	"Customers_id":400,"store_id":"101","Purchase":"26"},
		{	"Customers_id":100,"store_id":"100","Purchase":"75"},
		{	"Customers_id":600,"store_id":"102","Purchase":"45"}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[store_id] [nvarchar](50) NULL,
		[Purchase] [nvarchar](50) NULL
		)

INSERT INTO @Orders (
		[Customers_id],
		[store_id],
		[Purchase]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[Customers_id] nvarchar(50) '$.Customers_id',
		[store_id] nvarchar(50) '$.store_id',
		[Purchase] nvarchar(50) '$.Purchase'		
);

select * from @Orders

/*
	Customers_id	store_id	Purchase
	-----------------------------------------------------------
	100				100			70
	200				101			85
	100				100			40
	400				101			60
	400				101			32
	200				101			32
	400				101			26
	100				100			75
	600				102			45
*/

--==== Show the count of orders per customer

-- COUNT() function returns the number of rows that matches a specified criterion.


SELECT Customers_id, COUNT(*) AS order_count
FROM @Orders
GROUP BY Customers_id

/*
	Customers_id    order_count
	---------------------------
	100				3
	200				2
	400				3
	600				1
*/



-- You can specify a column name instead of the asterix symbol (*).
-- If you specify a column name instead of (*), NULL values will not be counted.

SELECT COUNT(Customers_id) AS order_count
FROM @Orders

/*
	order_count
	-----------
	9
*/

/*
INVALID  -- Column '@Orders.Customers_id' is invalid in the select list because 
it is not contained in either an aggregate function or the GROUP BY clause.

SELECT Customers_id, COUNT(*) AS order_count
FROM @Orders
*/

-- Find the number of Costumers whose purchases where higher than 50:

SELECT COUNT(DISTINCT Customers_id) as top_spender FROM @Orders
cccc

/*
	top_spender
	-----------
	3
*/


SELECT DISTINCT TOP 3 Customers_id 
FROM @Orders
WHERE  Purchase > 50

/*
	Customers_id
	------------
	100
	200
	400
*/