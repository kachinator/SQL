-- ######## 

DECLARE @jsonSales nvarchar(max)

SET @jsonSales ='[
		{"order_id":1,"product_id":"100","Quantity":17},
		{"order_id":10,"product_id":"302","Quantity":38},
		{"order_id":21,"product_id":"201","Quantity":34},
		{"order_id":300,"product_id":"201","Quantity":29},
		{"order_id":23,"product_id":"302","Quantity":51},
		{"order_id":89,"product_id":"100","Quantity":12},
		{"order_id":101,"product_id":"523","Quantity":34}]'

DECLARE @Sales TABLE(
		[order_id] [nvarchar](50) NULL,
		[product_id] [nvarchar](50) NULL,
		[Quantity] int NULL
		)

INSERT INTO @Sales (
		[order_id],
		[product_id],
		[Quantity]
		)

SELECT * from openjson(@jsonSales)
WITH
(
		[order_id] nvarchar(50) '$.order_id',
		[product_id] nvarchar(50) '$.product_id',
		[Quantity] int '$.Quantity'		
);

select * from @Sales

/*
	order_id	product_id	Quantity
	--------------------------------
	1			100			17
	10			302			38
	21			201			34
	300			201			29
	23			302			51
	89			100			12
	101			523			34
*/	

--==== Identify the most selling product

SELECT  TOP 1 product_id, SUM(Quantity) as total_quantity  FROM @Sales
GROUP BY product_id
ORDER BY total_quantity DESC;

/*
	product_id		total_quantity
	---------------------------------
	302				89
*/	
