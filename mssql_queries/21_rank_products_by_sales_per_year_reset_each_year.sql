-- ########  
DECLARE @jsonSales nvarchar(max)

SET @jsonSales ='[
		{   "product":"Marketing Training","sale_amount":2389.75, "sale_date": "2024-11-02"},
		{	"product":"Engineering Update","sale_amount":1428.98, "sale_date":"2023-07-24"},
		{	"product":"Marketing Conference","sale_amount":4013, "sale_date":"2022-08-02"},
		{	"product":"Engineering Conference","sale_amount":6200, "sale_date":"2021-05-30"},
		{	"product":"Marketing Training","sale_amount":7500, "sale_date":"2021-04-26"},
		{	"product":"Sales To Bussines","sale_amount":4546.67, "sale_date":"2024-04-26"},
		{	"product":"Custoner Services Consulting","sale_amount":3506.23, "sale_date":"2023-04-26"},
		{	"product":"Marketing Training","sale_amount":3761.780, "sale_date":"2023-04-26"},
		{	"product":"Sales To Public","sale_amount":2500, "sale_date":"2022-10-09"}]'

--   replace empty entries by NULL
SET @jsonSales = REPLACE(@jsonSales, '""','null')

DECLARE @Sales TABLE(
		[product] [nvarchar](50) NULL,
		[sale_amount] float NULL,
		[sale_date] DATE NULL
		)

INSERT INTO @Sales (
		[product],
		[sale_amount],
		[sale_date]
		)

SELECT * from openjson(@jsonSales)
WITH
(
		[product] nvarchar(50) '$.product',
		[sale_amount] float '$.sale_amount',
		[sale_date] DATE '$.sale_date'
);

select * from @Sales

/*
	product							sale_amount	sale_date
	--------------------------------------------------------------------------
	Marketing Training				2389.75		2024-11-02
	Engineering Update				1428.98		2023-07-24
	Marketing Conference			4013		2022-08-02
	Engineering Conference			6200		2021-05-30
	Marketing Training				7500		2021-04-26
	Sales To Bussines				4546.67		2024-04-26
	Custoner Services Consulting	3506.23		2023-04-26
	Marketing Training				3761.78		2023-04-26
	Sales To Public					2500		2022-10-09
*/


SELECT 
		RANK() OVER  ( PARTITION BY FORMAT(sale_date, 'yyyy') ORDER BY sale_amount DESC) AS sale_rk,
		FORMAT(sale_date, 'yyyy') as year,
		product, 
		sale_amount
FROM @Sales


/*
sale_rk		year		product							sale_amount	
-----------------------------------------------------------------------
1			2021		Marketing Training				7500
2			2021		Engineering Conference			6200
1			2022		Marketing Conference			4013
2			2022		Sales To Public					2500
1			2023		Marketing Training				3761.78
2			2023		Custoner Services Consulting	3506.23
3			2023		Engineering Update				1428.98
1			2024		Sales To Bussines				4546.67
2			2024		Marketing Training				2389.75
*/