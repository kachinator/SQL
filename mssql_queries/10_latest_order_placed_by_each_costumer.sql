-- ########  Detect all duplicates in a Table
DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customers_id":100,"store_id":"100","Purchase":70.24, "purchase_date":"2025-06-20"},
		{	"Customers_id":200,"store_id":"101","Purchase":85.13, "purchase_date":"2025-06-29"},
		{	"Customers_id":100,"store_id":"100","Purchase":40.39, "purchase_date":"2025-06-21"},
		{	"Customers_id":400,"store_id":"101","Purchase":60.00, "purchase_date":"2025-06-25"},
		{	"Customers_id":400,"store_id":"101","Purchase":32.71, "purchase_date":"2025-06-30"},
		{	"Customers_id":200,"store_id":"101","Purchase":32.51, "purchase_date":"2025-06-15"},
		{	"Customers_id":400,"store_id":"101","Purchase":26.99, "purchase_date":"2025-06-26"},
		{	"Customers_id":100,"store_id":"100","Purchase":75.89, "purchase_date":"2025-06-22"},
		{	"Customers_id":600,"store_id":"102","Purchase":45.63, "purchase_date":"2025-06-18"}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[store_id] [nvarchar](50) NULL,
		[Purchase] float NULL,
		[purchase_date] DATE NULL
		)

INSERT INTO @Orders (
		[Customers_id],
		[store_id],
		[Purchase],
		[purchase_date]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[Customers_id] nvarchar(50) '$.Customers_id',
		[store_id] nvarchar(50) '$.store_id',
		[Purchase] float '$.Purchase',
		[purchase_date] DATE '$.purchase_date'

);

select * from @Orders

/*
	Customers_id	store_id	Purchase	purchase_date
	------------------------------------
	100				100			70.24		2025-06-20
	200				101			85.13		2025-06-29
	100				100			40.39		2025-06-21
	400				101			60			2025-06-25
	400				101			32.71		2025-06-30
	200				101			32.51		2025-06-15
	400				101			26.99		2025-06-26
	100				100			75.89		2025-06-22
	600				102			45.63		2025-06-18
*/


SELECT Customers_id, MAX(purchase_date)  AS latest_order_date
FROM @Orders
GROUP BY Customers_id

/*
	Customers_id	latest_order_date
	-------------------------------------
	100				2025-06-22
	200				2025-06-29
	400				2025-06-30
	600				2025-06-18
*/