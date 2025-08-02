-- ######## 
DECLARE @jsonProducts nvarchar(max)

SET @jsonProducts ='[
		{   "product_id":100,"description":"Arduino video"},
		{	"product_id":201,"description":"Cat Robot Kit"},
		{	"product_id":302,"description":"Arm Robot Kit"},
		{	"product_id":303,"description":"LCD Display"},
		{	"product_id":523,"description":"Raspberry PI"},
		{	"product_id":638,"description":"Connectors"}]'

--   replace empty entries by NULL
SET @jsonProducts = REPLACE(@jsonProducts, '""','null')

DECLARE @Products TABLE(
		[product_id] [nvarchar](50) NULL,
		[description] [nvarchar](50) NULL
		)

INSERT INTO @Products (
		[product_id],
		[description]
		)

SELECT * from openjson(@jsonProducts)
WITH
(
		[product_id] nvarchar(50) '$.product_id',
		[description] nvarchar(50) '$.description'		
);

select * from @Products

/*
	product_id	description
	---------------------------
	100			Arduino video
	201			Cat Robot Kit
	302			Arm Robot Kit
	303			LCD Display
	523			Raspberry PI
	638			Connectors
*/

DECLARE @jsonSales nvarchar(max)

SET @jsonSales ='[
		{   "product_id":"100","Quantity":246},
		{	"product_id":"302","Quantity":38},
		{	"product_id":"201","Quantity":457},
		{	"product_id":"523","Quantity":34}]'

DECLARE @Sales TABLE(
		[product_id] [nvarchar](50) NULL,
		[Quantity] [nvarchar](50) NULL
		)

INSERT INTO @Sales (
		[product_id],
		[Quantity]
		)

SELECT * from openjson(@jsonSales)
WITH
(
		[product_id] nvarchar(50) '$.product_id',
		[Quantity] nvarchar(50) '$.Quantity'		
);

select * from @Sales

/*
	product_id	Quantity
	-----------------------------
	100			246
	302			38
	201			457
	523			34
*/	

-- === LEFT JOIN

SELECT  *  FROM @Products p
LEFT JOIN @Sales s ON p.product_id = s.product_id

/*
	product_id 	description		product_id  Quantity
	-------------------------------------------------
	100			Arduino video	100			246
	201			Cat Robot Kit	201			457
	302			Arm Robot Kit	302			38
	303			LCD Display		NULL		NULL
	523			Raspberry PI	523			34
	638			Connectors		NULL		NULL

*/



--==== Products that were never sold

SELECT  p.product_id  FROM @Products p
LEFT JOIN @Sales s ON p.product_id = s.product_id
WHERE s.product_id is NULL;


/*
	product_id
	------------
	303
	638
*/	
