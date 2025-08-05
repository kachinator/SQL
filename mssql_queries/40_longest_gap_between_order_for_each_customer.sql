-- ########  
DECLARE @jsonOrders nvarchar(max)


SET @jsonOrders ='[
		{   "order_id":100,"customer_id":"AB_12345","region":"Chicago","volume":70,"sales":3200.25,"order_date":"2025-06-23"},
		{	"order_id":102,"customer_id":"ZD_9235", "region":"Chicago","volume":75,"sales":2571.25,"order_date":"2024-05-27"},
		{	"order_id":202,"customer_id":"ZD_9235", "region":"Will",   "volume":23,"sales":897.25, "order_date":"2023-04-26"},
		{	"order_id":402,"customer_id":"AB_12345","region":"Kane",   "volume":26,"sales":1900.25,"order_date":"2022-03-25"},
		{	"order_id":201,"customer_id":"ZD_9235", "region":"Will",   "volume":32,"sales":4900.25,"order_date":"2023-03-25"},
		{	"order_id":401,"customer_id":"AB_12345","region":"Kane",   "volume":39,"sales":760.25, "order_date":"2024-01-27"},
		{	"order_id":200,"customer_id":"NB_1820", "region":"Dupage", "volume":65,"sales":2800.75,"order_date":"2025-12-26"},
		{	"order_id":110,"customer_id":"AB_12345","region":"Chicago","volume":40,"sales":320.5, "order_date":"2022-12-24"},
		{	"order_id":111,"customer_id":"AB_12345","region":"Chicago","volume":30,"sales":120.5, "order_date":"2023-12-24"},
		{	"order_id":112,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":220.5, "order_date":"2024-12-24"},
		{	"order_id":113,"customer_id":"AB_12345","region":"Chicago","volume":10,"sales":20.5, "order_date":"2025-12-24"},
		{	"order_id":1114,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":1320.5, "order_date":"2022-12-23"},
		{	"order_id":980,"customer_id":"BN_2810", "region":"Dupage", "volume":24,"sales":2800.75,"order_date":"2024-04-23"},
		{	"order_id":98, "customer_id":"BN_2810", "region":"Dupage", "volume":13,"sales":2800.75,"order_date":"2024-04-23"},
		{	"order_id":97, "customer_id":"BN_2810", "region":"Dupage", "volume":56,"sales":2800.75,"order_date":"2023-02-25"},
		{	"order_id":101,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":1320.5, "order_date":"2022-12-23"},
		{	"order_id":400,"customer_id":"AB_12345","region":"Dupage", "volume":60,"sales":4900.25,"order_date":"2023-12-24"},
		{	"order_id":600,"customer_id":"ZD_9235", "region":"Dupage", "volume":45,"sales":1600.25,"order_date":"2024-11-23"}]'

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
	order_id	customer_id	region	volume	sales		order_date
	--------------------------------------------------------------
	100			AB_12345	Chicago	70		3200.25		2025-06-23
	102			ZD_9235		Chicago	75		2571.25		2024-05-27
	202			ZD_9235		Will	23		897.25		2023-04-26
	402			AB_12345	Kane	26		1900.25		2022-03-25
	201			ZD_9235		Will	32		4900.25		2023-03-25
	401			AB_12345	Kane	39		760.25		2024-01-27
	200			NB_1820		Dupage	65		2800.75		2025-12-26
	110			AB_12345	Chicago	40		320.5		2022-12-24
	111			AB_12345	Chicago	30		120.5		2023-12-24
	112			AB_12345	Chicago	20		220.5		2024-12-24
	113			AB_12345	Chicago	10		20.5		2025-12-24
	1114		AB_12345	Chicago	20		1320.5		2022-12-23
	980			BN_2810		Dupage	24		2800.75		2024-04-23
	98			BN_2810		Dupage	13		2800.75		2024-04-23
	97			BN_2810		Dupage	56		2800.75		2023-02-25
	101			AB_12345	Chicago	20		1320.5		2022-12-23
	400			AB_12345	Dupage	60		4900.25		2023-12-24
	600			ZD_9235		Dupage	45		1600.25		2024-11-23
*/

-- get order date and previous order date
SELECT 	customer_id,
		order_date,
		LAG(order_date)  OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
FROM @Orders;

/*

	customer_id		order_date		prev_order_date
	-----------------------------------------------
	AB_12345		2022-03-25		NULL
	AB_12345		2022-12-23		2022-03-25
	AB_12345		2022-12-23		2022-12-23
	AB_12345		2022-12-24		2022-12-23
	AB_12345		2023-12-24		2022-12-24
	AB_12345		2023-12-24		2023-12-24
	AB_12345		2024-01-27		2023-12-24
	AB_12345		2024-12-24		2024-01-27
	AB_12345		2025-06-23		2024-12-24
	AB_12345		2025-12-24		2025-06-23
	BN_2810			2023-02-25		NULL
	BN_2810			2024-04-23		2023-02-25
	BN_2810			2024-04-23		2024-04-23
	NB_1820			2025-12-26		NULL
	ZD_9235			2023-03-25		NULL
	ZD_9235			2023-04-26		2023-03-25
	ZD_9235			2024-05-27		2023-04-26
	ZD_9235			2024-11-23		2024-05-27

*/

WITH cte AS (
	SELECT 	customer_id,
			order_date,
			LAG(order_date)  OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
	FROM @Orders
)
SELECT customer_id, MAX(DATEDIFF(DAY, prev_order_date, order_date))  AS max_gap
FROM cte 
WHERE prev_order_date IS NOT NULL
GROUP BY customer_id


/*
	customer_id		max_gap
	-----------------------
	AB_12345		365
	BN_2810			423
	ZD_9235			397

*/