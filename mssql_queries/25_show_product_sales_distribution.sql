-- ########  
DECLARE @jsonSales nvarchar(max)


SET @jsonSales ='[
		{   "product_id":"AB_12345","region":"Chicago","quantity":70,"price":32.25,"order_date":"2025-06-23"},
		{	"product_id":"ZD_9235","region":"Chicago","quantity":75,"price":25.25,"order_date":"2025-06-27"},
		{	"product_id":"ZD_9235","region":"Will","quantity":23,"price":8.25,"order_date":"2025-06-26"},
		{	"product_id":"AB_12345","region":"Kane","quantity":26,"price":19.25,"order_date":"2025-06-25"},
		{	"product_id":"ZD_9235","region":"Will","quantity":32,"price":49.25,"order_date":"2025-06-25"},
		{	"product_id":"AB_12345","region":"Kane","quantity":39,"price":7.25,"order_date":"2025-06-27"},
		{	"product_id":"NB_1820","region":"Dupage","quantity":65,"price":28.75,"order_date":"2025-06-26"},
		{	"product_id":"BN_2810","region":"Dupage","quantity":78,"price":28.75,"order_date":"2025-06-23"},
		{	"product_id":"BN_2810","region":"Dupage","quantity":56,"price":24.75,"order_date":"2025-06-25"},
		{	"product_id":"AB_12345","region":"Chicago","quantity":20,"price":13.5,"order_date":"2025-06-23"},
		{	"product_id":"AB_12345","region":"Dupage","quantity":60,"price":49.75,"order_date":"2025-06-24"},
		{	"product_id":"ZD_9235","region":"Dupage","quantity":45,"price":16.5,"order_date":"2025-06-23"}]'

--   replace empty entries by NULL
SET @jsonSales = REPLACE(@jsonSales, '""','null')

DECLARE @Sales TABLE(
		[product_id] [nvarchar](50) NULL,
		[region] [nvarchar](50) NULL,
		[quantity] int NULL,
		[price] float NULL,
		[order_date] DATE NULL
		)

INSERT INTO @Sales (
		[product_id],
		[region],
		[quantity],
		[price],
		[order_date]
		)

SELECT * from openjson(@jsonSales)
WITH
(
		[product_id] nvarchar(50) '$.product_id',
		[region] nvarchar(50) '$.region',
		[quantity] int '$.quantity',
		[price] float '$.price',	
		[order_date] DATE '$.order_date'		
);

select * from @Sales;

/*
	order_id	product_id	region	quantity	price	order_date
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
	600			ZD_9235		Dupage	45		1600.25	2025-06-23
*/


--==== first and last day Sales per costumer
/*
A cross join, also known as a Cartesian product, combines each row from one table 
with every row from another table, resulting in all possible combinations. 
This operation doesn't require a join condition and can generate a large result set
*/




WITH TotalRevenue AS (
	SELECT	SUM(quantity * price) AS Total from @Sales
)
SELECT 	s.product_id, 
		SUM(quantity * price) AS Revenue, 
		ROUND(SUM(quantity * price)*100/t.Total, 2) AS revenue_pct
FROM @Sales s
CROSS JOIN TotalRevenue t 
GROUP BY s.product_id, t.Total;


/*
	product_id		first_order		last_order
	------------------------------------------
	AB_12345		2025-06-23		2025-06-27
	BN_2810			2025-06-23		2025-06-25
	NB_1820			2025-06-26		2025-06-26
	ZD_9235			2025-06-23		2025-06-27
*/