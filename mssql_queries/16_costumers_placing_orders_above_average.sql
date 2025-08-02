-- ########  
DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customers_id":100,"region":"Chicago","volume":70,"sales":3200.25},
		{	"Customers_id":200,"region":"Dupage","volume":65,"sales":2800.75},
		{	"Customers_id":101,"region":"Chicago","volume":20,"sales":1320.5},
		{	"Customers_id":400,"region":"Dupage","volume":60,"sales":4900.25},
		{	"Customers_id":401,"region":"Kane","volume":39,"sales":760.25},
		{	"Customers_id":201,"region":"Will","volume":32,"sales":4900.25},
		{	"Customers_id":402,"region":"Kane","volume":26,"sales":1900.25},
		{	"Customers_id":202,"region":"Will","volume":23,"sales":897.25},
		{	"Customers_id":102,"region":"Chicago","volume":75,"sales":2571.25},
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
	101				Chicago	20			1320.5
	400				Dupage	60			4900.25
	401				Kane	39			760.25
	201				Will	32			4900.25
	402				Kane	26			1900.25
	202				Will	23			897.25
	102				Chicago	75			2571.25
	600				Dupage	45			1600.25
*/


--==== how many costumers placed more than 2 orders



SELECT  *  FROM @Orders
WHERE sales > (SELECT AVG(sales) FROM @Orders)

/*
	Customers_id	region	volume	sales
	----------------------------------------
	100				Chicago	70		3200.25
	200				Dupage	65		2800.75
	400				Dupage	60		4900.25
	201				Will	32		4900.25
	102				Chicago	75		2571.25

*/