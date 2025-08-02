--- Preview data
SELECT TOP(5) * from [master].[dbo].[OnlineRetailSales]

/*
OrderNum 	OrderDate				OrderType	CustomerType	CustName			CustState		ProdCategory	ProdNumber	ProdName		Quantity	Price	Discount	OrderTotal
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1100941		2024-09-02 00:00:00.000	Retail		Individual		Antonina Noton		Missouri		Drones			DS306		DX-145 Drone	2			250		0			500
1100963		2024-09-05 00:00:00.000	Wholesale	Business		Stehr Group			North\tCarolina	Drones			DS301		DA-SA702 Drone	3			399		$79.80		1117.2
1100969		2024-09-06 00:00:00.000	Retail		Individual		Raimondo Goretti	Ohio			Drones			DS307		MICR-564K Drone	1			499		0			499
1100971		2024-09-06 00:00:00.000	Wholesale	Business		Hettinger and Sons	West Virginia	Drones			DS306		DX-145 Drone	12			250		$50.00		2950
1100972		2024-09-08 00:00:00.000	Wholesale	Business		Johnson and Sons	West Virginia	Drones			DS306		DX-145 Drone	11			250		$45.00		2356.33
*/

/*
	calculate Total revenue by Product
*/

SELECT [ProdName],  SUM(Quantity * Price) AS Total_revenue
FROM [master].[dbo].[OnlineRetailSales]
GROUP BY [ProdName]


/*

ProdName								Total_revenue
------------------------------------------------------------
Aerial Security							4023.9
Arduino Books							238
BP-287 Blueprint						60
Bsquare Robot Blueprint					89.9
Building Your First Robot				99.8
Building Your Own Drone12				219.89999999999998
BYOD-220								1959.6000000000001
BYOD-300								178
BYOD-400								499
BYOD-500								801.6
BYOR-1000								189
BYOR-1500								3325.25
BYOR-3000								12797
Cartesian Robots						690
Cat Robot Blueprint						427.632
DA-SA702 Drone							1197
DC-304 Drone							31205
Delta Robots							250
DTI-84 Drone							500
DX-145 Drone							12696.25
Mapping with Drones						4008
MICR-564K Drone							499
Panda Robot Blueprint					210
Photograph Drones						521.65
RCB-889 Robot							33380
RLK-9920 Robot							3355.2000000000003
RWW-75 Robot							83707.5
Spherical Robots						90
Understanding Artificial Intelligence	249.6
Understanding Automation				3587.2000000000003
Upside Down Robot						3850
Upside Down Robot Blueprint				420

*/