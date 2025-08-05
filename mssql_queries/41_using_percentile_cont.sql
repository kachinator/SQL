-- ########  
DECLARE @jsonQuotes nvarchar(max)

SET @jsonQuotes ='[
		{   "ticker":"SPX","close_price":4000.78,"quote_date":"2024-12-06"},
		{	"ticker":"SPX","close_price":4017.78,"quote_date":"2024-12-07"},
		{	"ticker":"SPX","close_price":4014.78,"quote_date":"2024-12-10"},
		{	"ticker":"SPX","close_price":4034.78,"quote_date":"2024-12-11"},
		{	"ticker":"SPX","close_price":4020.78,"quote_date":"2024-12-12"},
		{	"ticker":"SPX","close_price":4012.78,"quote_date":"2024-12-13"},
		{	"ticker":"SPX","close_price":4014.78,"quote_date":"2024-12-16"},
		{	"ticker":"SPX","close_price":4005.78,"quote_date":"2024-12-17"},
		{	"ticker":"SPX","close_price":4010.78,"quote_date":"2024-12-18"},
		{	"ticker":"CFX","close_price":20.5,   "quote_date":"2024-12-24"},
		{	"ticker":"SPX","close_price":4569.78,"quote_date":"2024-11-20"},
		{	"ticker":"SPX","close_price":4020.75,"quote_date":"2024-12-21"},
		{	"ticker":"SPX","close_price":4023.75,"quote_date":"2024-12-22"},
		{	"ticker":"SPX","close_price":4014.75,"quote_date":"2024-12-23"},
		{	"ticker":"SPX","close_price":4569.78,"quote_date":"2024-11-23"},
		{	"ticker":"SPX","close_price":4569.78,"quote_date":"2024-11-24"},
		{	"ticker":"SPX","close_price":4569.78,"quote_date":"2024-11-23"}]'





--   replace empty entries by NULL
SET @jsonQuotes = REPLACE(@jsonQuotes, '""','null')

DECLARE @Quotes TABLE(
		[ticker] [nvarchar](50) NULL,
		[close_price] float NULL,
		[quote_date] DATE NULL
		)

INSERT INTO @Quotes (
		[ticker],
		[close_price],
		[quote_date]
		)

SELECT * from openjson(@jsonQuotes)
WITH
(
		[ticker] nvarchar(50) '$.ticker',
		[close_price] float '$.close_price',	
		[quote_date] DATE '$.quote_date'		
);

select * from @Quotes;

/*
	ticker	close_price	quote_date
	--------------------------------------------------------------
	SPX		4000.78		2024-12-06
	SPX		4017.78		2024-12-07
	SPX		4014.78		2024-12-10
	SPX		4034.78		2024-12-11
	SPX		4020.78		2024-12-12
	SPX		4012.78		2024-12-13
	SPX		4014.78		2024-12-16
	SPX		4005.78		2024-12-17
	SPX		4010.78		2024-12-18
	CFX		20.5		2024-12-24
	SPX		4569.78		2024-11-20
	SPX		4020.75		2024-12-21
	SPX		4023.75		2024-12-22
	SPX		4014.75		2024-12-23
	SPX		4569.78		2024-11-23
	SPX		4569.78		2024-11-24
	SPX		4569.78		2024-11-23
*/

/*
The PERCENTILE_CONT is an inverse distribution aggregate function that we can 
use to calculate percentiles.

In SQL Server, the PERCENTILE_CONT function requires both the WITHIN GROUP and
the OVER clause, and the result set is closer to the typical of a Window Function
Need to use DISTINCT, otherwise the percentile value will be repeated for every 
matching record in the quotes table

While Window Functions use the OVER clause, the Aggregate Functions use the 
WITHIN GROUP clause. Therefore, the PERCENTILE_CONT is defined as follows:

	PERCENTILE_CONT(percentage) WITHIN GROUP (ORDER BY sort_criteria)
*/


SELECT DISTINCT
    PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY ticker) AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY ticker) AS p75,
    PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY ticker) AS p95,
    PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY ticker) AS p99
FROM
    @Quotes
WHERE
    ticker = 'SPX' AND
    quote_date BETWEEN '2024-12-01' AND '2024-12-31'


/*
median		p75			p95			p99
-------------------------------------------------------
4014.78		4020.7575	4028.7135	4033.5667000000003
*/

--=== percentiles per month

SELECT DISTINCT
	MONTH(quote_date) AS month,
    PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY MONTH(quote_date)) AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY MONTH(quote_date)) AS p75,
    PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY MONTH(quote_date)) AS p95,
    PERCENTILE_CONT(0.99) WITHIN GROUP(ORDER BY close_price)
        OVER (PARTITION BY MONTH(quote_date)) AS p99
FROM
    @Quotes
WHERE
    ticker = 'SPX' AND
    quote_date BETWEEN '2024-11-01' AND '2024-12-31'
ORDER BY	month	

/*
	month	median		p75			p95			p99
	--------------------------------------------------------------
	11		4569.78		4569.78	4	569.78		4569.78
	12		4014.78		4020.7575	4028.7135	4033.5667000000003
*/