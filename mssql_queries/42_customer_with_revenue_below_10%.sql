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
		{	"order_id":220,"customer_id":"NB_1820", "region":"Dupage", "volume":65,"sales":2800.75,"order_date":"2025-12-26"},
		{	"order_id":110,"customer_id":"AB_12345","region":"Chicago","volume":40,"sales":320.5, "order_date":"2022-12-24"},
		{	"order_id":111,"customer_id":"AB_12345","region":"Chicago","volume":30,"sales":120.5, "order_date":"2023-12-24"},
		{	"order_id":112,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":220.5, "order_date":"2024-12-24"},
		{	"order_id":113,"customer_id":"AB_12345","region":"Chicago","volume":10,"sales":20.5, "order_date":"2025-12-24"},
		{	"order_id":114,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":1320.5, "order_date":"2022-12-23"},
		{	"order_id":980,"customer_id":"BN_2810", "region":"Dupage", "volume":24,"sales":2800.75,"order_date":"2024-04-23"},
		{	"order_id":98, "customer_id":"BN_2810", "region":"Dupage", "volume":13,"sales":1400.75,"order_date":"2024-04-23"},
		{	"order_id":97, "customer_id":"BN_2810", "region":"Dupage", "volume":56,"sales":4600.75,"order_date":"2023-02-25"},
		{	"order_id":101,"customer_id":"AB_12345","region":"Chicago","volume":20,"sales":1320.5, "order_date":"2022-12-23"},
		{	"order_id":400,"customer_id":"AB_12345","region":"Dupage", "volume":60,"sales":3990.25,"order_date":"2023-12-24"},
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
	220			NB_1820		Dupage	65		2800.75		2025-12-26
	110			AB_12345	Chicago	40		320.5		2022-12-24
	111			AB_12345	Chicago	30		120.5		2023-12-24
	112			AB_12345	Chicago	20		220.5		2024-12-24
	113			AB_12345	Chicago	10		20.5		2025-12-24
	114			AB_12345	Chicago	20		1320.5		2022-12-23
	980			BN_2810		Dupage	24		2800.75		2024-04-23
	98			BN_2810		Dupage	13		1400.75		2024-04-23
	97			BN_2810		Dupage	56		4600.75		2023-02-25
	101			AB_12345	Chicago	20		1320.5		2022-12-23
	400			AB_12345	Dupage	60		3990.25		2023-12-24
	600			ZD_9235		Dupage	45		1600.25		2024-11-23
*/


SELECT customer_id, MIN(sales) as min_sales, AVG(sales) as avg, MAX(sales) as max_sales
from @Orders
GROUP by customer_id;

/*
	customer_id		min_sales	avg					max_sales
	--------------------------------------------------------
	AB_12345		20.5		1317.4				3990.25
	BN_2810			1400.75		2934.0833333333335	4600.75
	NB_1820			2800.75		2800.75				2800.75
	ZD_9235			897.25		2492.25				4900.25
*/



SELECT DISTINCT customer_id, PERCENTILE_CONT(0.1) WITHIN GROUP 
								(ORDER BY sales) 
								OVER (PARTITION BY customer_id)  as p10	
							, PERCENTILE_CONT(0.5) WITHIN GROUP 
								(ORDER BY sales) 
								OVER (PARTITION BY customer_id)  as p50													
							, PERCENTILE_CONT(0.9) WITHIN GROUP 
								(ORDER BY sales) 
								OVER (PARTITION BY customer_id)  as p90									
								FROM @Orders;


/*
	customer_id		p10					avg			p90
	-------------------------------------------------------
	AB_12345		110.49999999999999	1040.375	3279.25
	BN_2810			1680.75				2800.75		4240.75
	NB_1820			2800.75				2800.75		2800.75
	ZD_9235			1108.15				2085.75	4	201.550000000001

*/

/*
PERCENTILE_CONT is an inverse distribution function. It assumes a
continuous distribution between values of the expression in the
sort specification. Then, it interpolates the value of that
expression at the given percentile, performing a linear interpolation

PERCENTILE_CONT(percentile)
WITHIN GROUP (ORDER BY (col | expr))
[OVER (
    [PARTITION BY (col | expr), ...]
    [frame_clause]
)]

percentile -- A numeric value between 0 and 1.
col -- A column of a numeric data type.
expr -- An expression that evaluates to a numeric data type.

*/

WITH p10 AS (SELECT DISTINCT customer_id, PERCENTILE_CONT(0.1) WITHIN GROUP 
								(ORDER BY sales) 
								OVER (PARTITION BY customer_id)  as p10					
								FROM @Orders)
SELECT o.customer_id, order_id, sales, order_date, p.p10 
FROM @Orders o JOIN p10 p
on p.customer_id = o.customer_id
where o.sales < p.p10;

/*
	customer_id		order_id	sales		order_date	p10
	------------------------------------------------------------------------
	AB_12345		113			20.5		2025-12-24	110.49999999999999
	BN_2810			98			1400.75		2024-04-23	1680.75
	ZD_9235			202			897.25	2	023-04-26	1108.15

/*
PERCENTILE_DISC(): Similar to PERCENTILE_CONT(), but it calculates the
percentile based on a discrete distribution, returning an actual value
from the dataset rather than an interpolated one

*/


WITH p10d AS (SELECT DISTINCT customer_id, PERCENTILE_DISC(0.2) WITHIN GROUP 
								(ORDER BY sales) 
								OVER (PARTITION BY customer_id)  as p20					
								FROM @Orders)
SELECT o.customer_id, order_id, sales, order_date, p.p20 
FROM @Orders o JOIN p10d p
on p.customer_id = o.customer_id
where o.sales < p.p20


/*
	customer_id		order_id	sales	order_date	p20
	-----------------------------------------------------
	AB_12345		113			20.5	2025-12-24	120.5

*/