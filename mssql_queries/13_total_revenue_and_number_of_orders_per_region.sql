-- ########  
DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customers_id":100,"region":"Chicago","volume":70,"sales":3200.25},
		{	"Customers_id":200,"region":"Dupage","volume":65,"sales":2800.75},
		{	"Customers_id":100,"region":"Chicago","volume":20,"sales":1320.5},
		{	"Customers_id":400,"region":"Dupage","volume":60,"sales":4900.25},
		{	"Customers_id":400,"region":"Kane","volume":39,"sales":760.25},
		{	"Customers_id":200,"region":"Will","volume":32,"sales":4900.25},
		{	"Customers_id":400,"region":"Kane","volume":26,"sales":1900.25},
		{	"Customers_id":200,"region":"Will","volume":23,"sales":897.25},
		{	"Customers_id":100,"region":"Chicago","volume":75,"sales":2571.25},
		{	"Customers_id":600,"region":"Dupage","volume":45,"sales":1600.25}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[Customers_id] [nvarchar](50) NULL,
		[region] [nvarchar](50) NULL,
		[volume] int NULL,
		[sales] float NULL
		)

INSERT INTO @Orders (
		[Customers_id],
		[region],
		[volume],
		[sales]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[Customers_id] nvarchar(50) '$.Customers_id',
		[region] nvarchar(50) '$.region',
		[volume] int '$.volume',
		[sales] float '$.sales'		
);

select * from @Orders

/*
	Customers_id	region	volume		sales
	--------------------------------------------
	100				Chicago	70			3200.25
	200				Dupage	65			2800.75
	100				Chicago	20			1320.5
	400				Dupage	60			4900.25
	400				Kane	39			760.25
	200				Will	32			4900.25
	400				Kane	26			1900.25
	200				Will	23			897.25
	100				Chicago	75			2571.25
	600				Dupage	45			1600.25
*/


--==== total revenuw and orders per region



SELECT region, SUM(sales)  AS total_revenue, COUNT(*) AS order_count
FROM @Orders
GROUP BY region

/*
	region    	total_revenue	order_count
	---------------------------------------
	Chicago		7092			3
	Dupage		9301.25			3
	Kane		2660.5			2
	Will		5797.5			2
*/
