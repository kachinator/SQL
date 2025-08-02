-- ########  Detect all duplicates in a Table
DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customers_id":100,"store_id":"100","Purchase":70.24},
		{	"Customers_id":200,"store_id":"101","Purchase":85.13},
		{	"Customers_id":100,"store_id":"100","Purchase":40.39},
		{	"Customers_id":400,"store_id":"101","Purchase":60.00},
		{	"Customers_id":400,"store_id":"101","Purchase":32.71},
		{	"Customers_id":200,"store_id":"101","Purchase":32.51},
		{	"Customers_id":400,"store_id":"101","Purchase":26.99},
		{	"Customers_id":100,"store_id":"100","Purchase":75.89},
		{	"Customers_id":600,"store_id":"102","Purchase":45.63}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[store_id] [nvarchar](50) NULL,
		[Purchase] float NULL
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
		[Purchase] float '$.Purchase'		
);

select * from @Orders

/*
	Customers_id	store_id	Purchase
	------------------------------------
	100				100			70.24
	200				101			85.13
	100				100			40.39
	400				101			60
	400				101			32.71
	200				101			32.51
	400				101			26.99
	100				100			75.89
	600				102			45.63
*/


SELECT Customers_id, AVG(Purchase)  AS average_order_value
FROM @Orders
GROUP BY Customers_id

/*
	Customers_id	average_order_value
	-------------------------------------
	100				62.173333333333325
	200				58.81999999999999
	400				39.9
	600				45.63
*/