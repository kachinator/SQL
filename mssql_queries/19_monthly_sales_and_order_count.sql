-- ########  
DECLARE @jsonOrders nvarchar(max)


SET @jsonOrders ='[
		{   "order_id":100,"region":"Chicago","volume":70,"sales":3200.25,"order_date":"2025-05-23"},
		{	"order_id":102,"region":"Chicago","volume":75,"sales":2571.25,"order_date":"2025-04-27"},
		{	"order_id":202,"region":"Will","volume":23,"sales":897.25,"order_date":"2025-02-12"},
		{	"order_id":402,"region":"Kane","volume":26,"sales":1900.25,"order_date":"2025-01-30"},
		{	"order_id":201,"region":"Will","volume":32,"sales":4900.25,"order_date":"2025-06-12"},
		{	"order_id":401,"region":"Kane","volume":39,"sales":760.25,"order_date":"2025-02-28"},
		{	"order_id":200,"region":"Dupage","volume":65,"sales":2800.75,"order_date":"2025-04-23"},
		{	"order_id":101,"region":"Chicago","volume":20,"sales":1320.5,"order_date":"2025-04-13"},
		{	"order_id":400,"region":"Dupage","volume":60,"sales":4900.25,"order_date":"2025-03-03"},
		{	"order_id":600,"region":"Dupage","volume":45,"sales":1600.25,"order_date":"2025-02-11"}]'

--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[order_id] [nvarchar](50) NULL,
		[region] [nvarchar](50) NULL,
		[volume] int NULL,
		[sales] float NULL,
		[order_date] DATE NULL

		)

INSERT INTO @Orders (
		[order_id],
		[region],
		[volume],
		[sales],
		[order_date]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[order_id] nvarchar(50) '$.order_id',
		[region] nvarchar(50) '$.region',
		[volume] int '$.volume',
		[sales] float '$.sales',	
		[order_date] DATE '$.order_date'		
);

select * from @Orders

/*
	order_id	region	volume	sales	order_date
	----------------------------------------------
	100			Chicago	70		3200.25	2025-05-23
	102			Chicago	75		2571.25	2025-04-27
	202			Will	23		897.25	2025-02-12
	402			Kane	26		1900.25	2025-01-30
	201			Will	32		4900.25	2025-06-12
	401			Kane	39		760.25	2025-02-28
	200			Dupage	65		2800.75	2025-04-23
	101			Chicago	20		1320.5	2025-04-13
	400			Dupage	60		4900.25	2025-03-03
	600			Dupage	45		1600.25	2025-02-11
*/


--==== monthly sales and order count

SELECT FORMAT(order_date, 'yyyy-MM') AS month,
		SUM(sales) AS total_revenue,
		COUNT(order_id) AS order_count
FROM @Orders
GROUP BY   FORMAT(order_date, 'yyyy-MM')

/*
	month		total_revenue	order_count
	------------------------------------------
	2025-01		1900.25			1
	2025-02		3257.75			3
	2025-03		4900.25			1
	2025-04		6692.5			3
	2025-05		3200.25			1
	2025-06		4900.25			1
*/