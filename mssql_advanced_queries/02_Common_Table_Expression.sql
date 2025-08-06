/*
	Query using Common Table Expression (CTE), 
	Query identifies orders whose Order Total is higher than the average total price of all orders
*/

WITH AVGTOTAL ( AVG_TOTAL) AS 
		( SELECT AVG([OrderTotal]) AS AVG_TOTAL
		 FROM [Master].[dbo].[OnlineRetailSales])

SELECT * 
FROM [Master].[dbo].[OnlineRetailSales], AVGTOTAL
WHERE [OrderTotal] >= AVG_TOTAL

/*
OrderNum	OrderDate				OrderType	CustomerType	CustName		CustState	ProdCategory	ProdNumber	ProdName		Quantity	Price	Discount	OrderTotal	AVG_TOTAL
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1100939		2024-09-02 00:00:00.000	Wholesale	Business		Turcotte Corp	New York	Drones			DS302		DC-304 Drone	79			395		$79.00		31126		4846.798857142857
1101622		2022-12-08 00:00:00.000	Wholesale	Business		Boehm Inc.		Texas		Robot Kits		BYOR-3000	BYOR-3000		100			127.97	0			12797		4846.798857142857
1104506		2024-02-04 00:00:00.000	Wholesale	Business		Boehm Inc.		Texas		Robots			RWW-75		RWW-75 Robot	250			334.83	0			83708.4		4846.798857142857
1104835		2024-03-22 00:00:00.000	Wholesale	Business		Boehm Inc.	T	exas		Robots			RCB-889		RCB-889 Robot	200			166.9	0			33379.2		4846.798857142857

*/
