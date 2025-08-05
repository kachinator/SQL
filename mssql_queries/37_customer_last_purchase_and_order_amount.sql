-- ########  
DECLARE @jsonOrders nvarchar(max)


SET @jsonOrders ='[
		{   "order_id":100,"customer_id":"AB_12345","region":"Chicago","volume":70,"sales":3200.25,"order_date":"2025-06-23"},
		{	"order_id":102,"customer_id":"ZD_9235", "region":"Chicago","volume":75,"sales":2571.25,"order_date":"2025-05-27"},
		{	"order_id":202,"customer_id":"ZD_9235", "region":"Will",   "volume":23,"sales":897.25, "order_date":"2025-04-26"},
		{	"order_id":402,"customer_id":"AB_12345","region":"Kane",   "volume":26,"sales":1900.25,"order_date":"2025-03-25"},
		{	"order_id":201,"customer_id":"ZD_9235", "region":"Will",   "volume":32,"sales":4900.25,"order_date":"2025-03-25"},
		{	"order_id":401,"customer_id":"AB_12345","region":"Kane",   "volume":39,"sales":760.25, "order_date":"2025-01-27"},
		{	"order_id":200,"customer_id":"NB_1820", "region":"Dupage", "volume":65,"sales":2800.75,"order_date":"2024-12-26"},
		{	"order_id":98, "customer_id":"BN_2810", "region":"Dupage", "volume":78,"sales":2800.75,"order_date":"2025-04-23"},
		{	"order_id":97, "customer_id":"BN_2810", "region":"Dupage", "volume":56,"sales":2800.75,"order_date":"2025-02-25"},
		{	"order_id":101,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":1320.5, "order_date":"2024-12-23"},
		{	"order_id":400,"customer_id":"AB_12345","region":"Dupage", "volume":60,"sales":4900.25,"order_date":"2024-12-24"},
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
	102			ZD_9235		Chicago	75		2571.25		2025-05-27
	202			ZD_9235		Will	23		897.25		2025-04-26
	402			AB_12345	Kane	26		1900.25		2025-03-25
	201			ZD_9235		Will	32		4900.25		2025-03-25
	401			AB_12345	Kane	39		760.25		2025-01-27
	200			NB_1820		Dupage	65		2800.75		2024-12-26
	98			BN_2810		Dupage	78		2800.75		2025-04-23
	97			BN_2810		Dupage	56		2800.75		2025-02-25
	101			AB_12345	Chicago	20		1320.5		2024-12-23
	400			AB_12345	Dupage	60		4900.25		2024-12-24
	600			ZD_9235		Dupage	45		1600.25		2024-11-23
*/


--== Group by customer and show order_id, sales and order date rank ( rn = 1 latest)
SELECT 	customer_id, 
		order_id,
		sales,
		ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC)  as rn
FROM @Orders;

/*
	customer_id		order_id	sales		rn
	------------------------------------------
	AB_12345		100			3200.25		1
	AB_12345		402			1900.25		2
	AB_12345		401			760.25		3
	AB_12345		400			4900.25		4
	AB_12345		101			1320.5		5
	BN_2810			98			2800.75		1
	BN_2810			97			2800.75		2
	NB_1820			200			2800.75		1
	ZD_9235			102			2571.25		1
	ZD_9235			202			897.25		2
	ZD_9235			201			4900.25		3
	ZD_9235			600			1600.25		4
*/

--==== show last purchase and order amount for each customer


WITH ranked_orders AS (
		SELECT 	customer_id, 
				order_id,
				sales,
				ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC)  as rn
		FROM @Orders
	)

SELECT 	customer_id, order_id, sales
FROM ranked_orders 
WHERE rn = 1;

/*
	customer_id		order_id	sales
	-----------------------------------
	AB_12345		100			3200.25
	BN_2810			98			2800.75
	NB_1820			200			2800.75
	ZD_9235			102			2571.25
*/