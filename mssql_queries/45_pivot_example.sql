-- ########  
DECLARE @jsonOrders nvarchar(max)

SET @jsonOrders ='[
		{   "Customer":"Fred","product":"beer","quantity":24},
		{	"Customer":"Fred","product":"milk","quantity":3},
		{	"Customer":"Kate","product":"beer","quantity":12},
		{	"Customer":"Kate","product":"milk","quantity":1},
		{	"Customer":"Kate","product":"milk","quantity":5},
		{	"Customer":"Kate","product":"soda","quantity":6},
		{	"Customer":"Kate","product":"veggies","quantity":2},
		{	"Customer":"Kate","product":"veggies","quantity":3}]'


--   replace empty entries by NULL
SET @jsonOrders = REPLACE(@jsonOrders, '""','null')

DECLARE @Orders TABLE(
		[Customer] [nvarchar](50) NULL,
		[product] [nvarchar](50) NULL,
		[quantity] int NULL
		)

INSERT INTO @Orders (
		[Customer],
		[product],
		[quantity]
		)

SELECT * from openjson(@jsonOrders)
WITH
(
		[Customer] nvarchar(50) '$.Customer',
		[product] nvarchar(50) '$.product',	
		[quantity] int '$.quantity'		
);

select * from @Orders;

/*
	Customer	product		quantity
	-----------------------------------
	Fred		beer		24
	Fred		milk		3
	Kate		beer		12
	Kate		milk		1
	Kate		milk		5
	Kate		soda		6
	Kate		veggies		2
	Kate		veggies		3
*/



/*
SELECT 	<non-pivoted column>, 
    	[pivoted column 1], 
		[pivoted column 2], ..., 
 
FROM  
    (SELECT <pivoted column>,  
        	<value column 1>  
        	<value column 2>  
    FROM <source table>  

    ) AS <alias for the source subquery>  
PIVOT  
	(  
    	<aggregate function>(<value column>)  

	FOR  
		[<pivoted column>] IN ( [pivoted column1], [pivoted column2], ..., [pivoted columnN] )  

) AS <alias for the pivot table>

--
Columns that will remain unchanged in the result set. 
< non-pivoted column>  product
--
Name of the Columns you want to be pivoted.
[pivoted column1], [pivoted column2], : Fred, Kate
--
The data that will be aggregated.
 <value column>:  product, quantity
--
 <aggregate function>: The name of the function is declared here which will used for aggregation 
 (e.g., SUM, AVG, COUNT
*/



SELECT 	product, 
		Fred, 
		Kate
FROM 
	(
		SELECT 	Customer, 
				product, 
				quantity
		FROM @Orders
	) up
PIVOT 
	(
		SUM(quantity) 
		FOR Customer IN (Fred, Kate)
	) AS pvt

ORDER BY product


/*
	product		Fred	Kate
	--------------------------
	beer		24		12
	milk		3		6
	soda		NULL	6
	veggies		NULL	5
*/