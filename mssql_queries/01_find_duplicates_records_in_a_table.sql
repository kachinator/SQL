-- Preview data
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
	Find Duplicate records in a table
*/

SELECT [CustName], [ProdCategory], count(*)
FROM [Master].[dbo].[OnlineRetailSales]
GROUP BY [CustName], [ProdCategory]
HAVING COUNT(*) > 1;

/*
CustName		ProdCategory	NO name	
---------------------------------------
Abbott Group	Blueprint			2
Boehm Inc.		Blueprints			2
Boehm Inc.		Drone Kits			3
Boehm Inc.		eBooks				3
Boehm Inc.		Robot Kits			3
Abbott Group	Robots				3
Boehm Inc.		Robots				3
Boehm Inc.		Training Videos		3

*/
