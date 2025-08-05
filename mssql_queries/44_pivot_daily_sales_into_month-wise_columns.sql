-- ########  
DECLARE @jsonOrders nvarchar(max)


SET @jsonOrders ='[
		{   "order_id":100,"sales":3200.25,"order_date":"2025-04-23"},
		{	"order_id":102,"sales":2571.25,"order_date":"2025-04-27"},
		{	"order_id":202,"sales":897.25,"order_date":"2025-04-25"},
		{	"order_id":402,"sales":1900.25,"order_date":"2025-04-25"},
		{	"order_id":201,"sales":4900.25,"order_date":"2025-05-23"},
		{	"order_id":401,"sales":760.25,"order_date":"2025-05-27"},
		{	"order_id":200,"sales":2800.75,"order_date":"2025-05-26"},
		{	"order_id":98,"sales":2800.75,"order_date":"2025-05-23"},
		{	"order_id":97,"sales":2800.75,"order_date":"2025-06-25"},
		{	"order_id":101,"sales":1320.5,"order_date":"2025-06-23"},
		{	"order_id":400,"sales":4900.25,"order_date":"2025-06-24"},
		{	"order_id":600,"sales":1600.25,"order_date":"2025-06-23"}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[order_id] [nvarchar](50) NULL,
		[sales] float NULL,
		[order_date] DATE NULL

		)

INSERT INTO @Orders (
		[order_id],
		[sales],
		[order_date]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[order_id] nvarchar(50) '$.order_id',
		[sales] float '$.sales',	
		[order_date] DATE '$.order_date'		
);

select * from @Orders;

/*
	order_id	sales		order_date
	-----------------------------------
	100			3200.25		2025-04-23
	102			2571.25		2025-04-27
	202			897.25		2025-04-25
	402			1900.25		2025-04-25
	201			4900.25		2025-05-23
	401			760.25		2025-05-27
	200			2800.75		2025-05-26
	98			2800.75		2025-05-23
	97			2800.75		2025-06-25
	101			1320.5		2025-06-23
	400			4900.25		2025-06-24
	600			1600.25		2025-06-23
*/

SELECT FORMAT(order_date, 'MM') AS month_, SUM(sales) as total_sales
FROM @Orders
GROUP BY FORMAT(order_date, 'MM')

/*
	month_  total_sales
	------------------
	04		8569
	05		11262
	06		10621.75

*/





SELECT  'total_sales' AS MONTHS, [04] AS April, [05] AS May, [06] AS June
FROM
	(
		SELECT FORMAT(order_date, 'MM') AS month_, SUM(sales) as total_sales
		FROM @Orders
		GROUP BY FORMAT(order_date, 'MM')
	) x 
PIVOT
( 
	max(total_sales)  
	for month_ in ([04], [05], [06])
) p

/*

	MONTHS			April	May		June
	----------------------------------------
	total_sales		8569	11262	10621.75

*/