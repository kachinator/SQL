-- ########  
DECLARE @jsonOrders nvarchar(max)


SET @jsonOrders ='[
		{   "order_id":100,"customer_id":"AB_12345","region":"Chicago","volume":70,"sales":3200.25,"order_date":"2025-06-23"},
		{	"order_id":102,"customer_id":"ZD_9235","region":"Chicago","volume":75,"sales":2571.25,"order_date":"2025-06-27"},
		{	"order_id":202,"customer_id":"ZD_9235","region":"Will","volume":23,"sales":897.25,"order_date":"2025-06-26"},
		{	"order_id":402,"customer_id":"AB_12345","region":"Kane","volume":26,"sales":1900.25,"order_date":"2025-06-25"},
		{	"order_id":201,"customer_id":"ZD_9235","region":"Will","volume":32,"sales":4900.25,"order_date":"2025-06-25"},
		{	"order_id":401,"customer_id":"AB_12345","region":"Kane","volume":39,"sales":760.25,"order_date":"2025-06-27"},
		{	"order_id":200,"customer_id":"NB_1820","region":"Dupage","volume":65,"sales":2800.75,"order_date":"2025-06-26"},
		{	"order_id":98,"customer_id":"BN_2810","region":"Dupage","volume":78,"sales":2800.75,"order_date":"2025-06-23"},
		{	"order_id":97,"customer_id":"BN_2810","region":"Dupage","volume":56,"sales":2800.75,"order_date":"2025-06-25"},
		{	"order_id":101,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":1320.5,"order_date":"2025-06-23"},
		{	"order_id":400,"customer_id":"AB_12345","region":"Dupage","volume":60,"sales":4900.25,"order_date":"2025-06-24"},
		{	"order_id":600,"customer_id":"ZD_9235","region":"Dupage","volume":45,"sales":1600.25,"order_date":"2025-06-24"}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[order_id] [nvarchar](50) NULL,
		[customer_id] [nvarchar](50) NULL,
		[region] [nvarchar](50) NULL,
		[volume] int NULL,
		[sales] float NULL,
		[order_date] DATE NULL

		)

INSERT INTO @Orders (
		[order_id],
		[customer_id],
		[region],
		[volume],
		[sales],
		[order_date]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[order_id] nvarchar(50) '$.order_id',
		[customer_id] nvarchar(50) '$.customer_id',
		[region] nvarchar(50) '$.region',
		[volume] int '$.volume',
		[sales] float '$.sales',	
		[order_date] DATE '$.order_date'		
);

select * from @Orders;

/*
	order_id	customer_id	region	volume	sales	order_date
	----------------------------------------------------------
	100			AB_12345	Chicago	70		3200.25	2025-06-23
	102			ZD_9235		Chicago	75		2571.25	2025-06-27
	202			ZD_9235		Will	23		897.25	2025-06-26
	402			AB_12345	Kane	26		1900.25	2025-06-25
	201			ZD_9235		Will	32		4900.25	2025-06-25
	401			AB_12345	Kane	39		760.25	2025-06-27
	200			NB_1820		Dupage	65		2800.75	2025-06-26
	98			BN_2810		Dupage	78		2800.75	2025-06-23
	97			BN_2810		Dupage	56		2800.75	2025-06-25
	101			AB_12345	Chicago	20		1320.5	2025-06-23
	400			AB_12345	Dupage	60		4900.25	2025-06-24
	600			ZD_9235		Dupage	45		1600.25	2025-06-24
*/


--==== purchases made in consecutive days

/*
The LAG() function is especially useful when we need to compare the current row's value 
with a previous row's value. 
	* partition_by_clause: An optional clause that divides the result set into partitions. 
	The LAG() function is applied to each partition separately.
	* order_by_clause: The order of the rows within each partition. This is mandatory 
	and must be specified.

*/

SELECT 	customer_id, 
			order_date,
			LAG(order_date,1) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_odate1,
			LAG(order_date,2) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_odate2
FROM @Orders;

/*
	customer_id		order_date		prev_odate1		prev_odate2
	-----------------------------------------------------------
	AB_12345		2025-06-23		NULL			NULL
	AB_12345		2025-06-23		2025-06-23		NULL
	AB_12345		2025-06-24		2025-06-23		2025-06-23
	AB_12345		2025-06-25		2025-06-24		2025-06-23
	AB_12345		2025-06-27		2025-06-25		2025-06-24
	BN_2810			2025-06-23		NULL			NULL
	BN_2810			2025-06-25		2025-06-23		NULL
	NB_1820			2025-06-26		NULL			NULL
	ZD_9235			2025-06-24		NULL			NULL
	ZD_9235			2025-06-25		2025-06-24		NULL
	ZD_9235			2025-06-26		2025-06-25		2025-06-24
	ZD_9235			2025-06-27		2025-06-26		2025-06-25

*/


WITH cte AS (
	SELECT 	customer_id, 
			order_date,
			LAG(order_date,1) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_odate1,
			LAG(order_date,2) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_odate2
	FROM @Orders)
SELECT customer_id, order_date, prev_odate1, prev_odate2  
FROM cte
WHERE  DATEDIFF(DAY, prev_odate1, order_date) = 1 and DATEDIFF(DAY, prev_odate2, order_date) = 2


/*
	customer_id		order_date		prev_odate1		prev_odate2
	-----------------------------------------------------------
	AB_12345		2025-06-25		2025-06-24		2025-06-23
	ZD_9235			2025-06-26		2025-06-25		2025-06-24
	ZD_9235			2025-06-27		2025-06-26		2025-06-25

*/