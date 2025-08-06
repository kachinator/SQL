/*
	Inventory Planning
		- customers expect bussinesses to have products stocked

		- Methods like time series analysis are used to forecast demand

		- These methods use past events to predict future sales
*/

/*
Write a Query using LAG or LEAD that returns:
	- OrderDate
	- Quantity
	- QUantities from the las five OrderDates

	For each drone order from the OnlineRetailSales table

*/

-- preview 
SELECT TOP (5) * FROM [master].[dbo].[OnlineRetailSales]
WHERE [ProdCategory] = 'Drones';

/*

OrderNum	OrderDate				OrderType	CustomerType	CustName			CustState		ProdCategory	ProdNumber	ProdName		Quantity	Price	Discount	OrderTotal
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1100941		2024-09-02 00:00:00.000	Retail		Individual		Antonina Noton		Missouri		Drones			DS306		DX-145 Drone	2			250		0			500
1100963		2024-09-05 00:00:00.000	Wholesale	Business		Stehr Group			North\tCarolina	Drones			DS301		DA-SA702 Drone	3			399		$79.80		1117.2
1100969		2024-09-06 00:00:00.000	Retail		Individual		Raimondo Goretti	Ohio			Drones			DS307		MICR-564K Drone	1			499		0			499
1100971		2024-09-06 00:00:00.000	Wholesale	Business		Hettinger and Sons	West Virginia	Drones			DS306		DX-145 Drone	12			250		$50.00		2950
1100972		2024-09-08 00:00:00.000	Wholesale	Business		Johnson and Sons	West Virginia	Drones			DS306		DX-145 Drone	11			250		$45.00		2356.33
*/

-- ORDERS needed in a single day, use CTE

WITH ORDER_BY_DAYS AS (
			SELECT [OrderDate], SUM([Quantity]) AS Quantity_by_day
			FROM [master].[dbo].[OnlineRetailSales]
			WHERE [ProdCategory] = 'Drones'
			GROUP BY [OrderDate] 
			)

SELECT TOP(5) * FROM ORDER_BY_DAYS ORDER BY [OrderDate];

/*
	OrderDate					Quantity_by_day
	-------------------------------------------
	2024-09-02 00:00:00.000		81
	2024-09-05 00:00:00.000		3
	2024-09-06 00:00:00.000		13
	2024-09-08 00:00:00.000		11
	2024-09-12 00:00:00.000		12
*/


WITH ORDER_BY_DAYS AS (
			SELECT [OrderDate], SUM([Quantity]) AS Quantity_by_day
			FROM [master].[dbo].[OnlineRetailSales]
			WHERE [ProdCategory] = 'Drones'
			GROUP BY [OrderDate]
			)

SELECT [OrderDate], Quantity_by_day,
LAG([Quantity_by_day], 1) OVER (ORDER BY [OrderDate] ASC)  AS LastDateQuantity_1,
LAG([Quantity_by_day], 2) OVER (ORDER BY [OrderDate] ASC)  AS LastDateQuantity_2,
LAG([Quantity_by_day], 3) OVER (ORDER BY [OrderDate] ASC)  AS LastDateQuantity_3,
LAG([Quantity_by_day], 4) OVER (ORDER BY [OrderDate] ASC)  AS LastDateQuantity_4,
LAG([Quantity_by_day], 5) OVER (ORDER BY [OrderDate] ASC)  AS LastDateQuantity_5

FROM ORDER_BY_DAYS;

/*
OrderDate					Quantity_by_day	LastDateQuantity_1	LastDateQuantity_2	LastDateQuantity_3	LastDateQuantity_4	LastDateQuantity_5
----------------------------------------------------------------------------------------------------------------------------------------------
2024-09-02 00:00:00.000		81				NULL				NULL				NULL				NULL				NULL
2024-09-05 00:00:00.000		3				81					NULL				NULL				NULL				NULL
2024-09-06 00:00:00.000		13				3					81					NULL				NULL				NULL
2024-09-08 00:00:00.000		11				13					3					81					NULL				NULL
2024-09-12 00:00:00.000		12				11					13					3					81					NULL
2024-09-14 00:00:00.000		21				12					11					13					3					81
2024-09-20 00:00:00.000		14				21					12					11					13					3
*/



WITH ORDER_BY_DAYS AS (
			SELECT [OrderDate], SUM([Quantity]) AS Quantity_by_day
			FROM [master].[dbo].[OnlineRetailSales]
			WHERE [ProdCategory] = 'Drones'
			GROUP BY [OrderDate]
			)

SELECT [OrderDate], Quantity_by_day,
LEAD([Quantity_by_day], 1) OVER (ORDER BY [OrderDate] DESC)  AS LastDateQuantity_1,
LEAD([Quantity_by_day], 2) OVER (ORDER BY [OrderDate] DESC)  AS LastDateQuantity_2,
LEAD([Quantity_by_day], 3) OVER (ORDER BY [OrderDate] DESC)  AS LastDateQuantity_3,
LEAD([Quantity_by_day], 4) OVER (ORDER BY [OrderDate] DESC)  AS LastDateQuantity_4,
LEAD([Quantity_by_day], 5) OVER (ORDER BY [OrderDate] DESC)  AS LastDateQuantity_5

FROM ORDER_BY_DAYS

/*

OrderDate					Quantity_by_day	LastDateQuantity_1	LastDateQuantity_2	LastDateQuantity_3	LastDateQuantity_4	LastDateQuantity_5
----------------------------------------------------------------------------------------------------------------------------------------------
2024-09-20 00:00:00.000		14				21					12					11					13					3
2024-09-14 00:00:00.000		21				12					11					13					3					81
2024-09-12 00:00:00.000		12				11					13					3					81					NULL
2024-09-08 00:00:00.000		11				13					3					81					NULL				NULL
2024-09-06 00:00:00.000		13				3					81					NULL				NULL				NULL
2024-09-05 00:00:00.000		3				81					NULL				NULL				NULL				NULLL
2024-09-02 00:00:00.000		81				NULL				NULL				NULL				NULL				NULL

*/