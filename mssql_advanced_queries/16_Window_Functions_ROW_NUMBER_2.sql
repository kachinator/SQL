/*

Write a Query using ROW_NUMBER() that returns
	OrderNum
	OrderDate				
	CustName
	ProdCategory
	ProdName
	Order Total

For the three orders with the highest Order Totals from each ProdCategory purchased by Boehm Inc.
*/

-- preview
SELECT TOP (5) [OrderNum],[OrderDate],[CustName],[ProdCategory],[ProdName],[OrderTotal] FROM [master].[dbo].[OnlineRetailSales];

/*

OrderNum	OrderDate				CustName				ProdCategory	ProdName			OrderTotal
-----------------------------------------------------------------------------------------------------------
1100941		2024-09-02 00:00:00.000	Antonina Noton			Drones			DX-145 Drone		500
1100963		2024-09-05 00:00:00.000	Stehr Group				Drones			DA-SA702 Drone		1117.2
1100969		2024-09-06 00:00:00.000	Raimondo Goretti		Drones			MICR-564K Drone		499
1100971		2024-09-06 00:00:00.000	Hettinger and Sons		Drones			DX-145 Drone		2950
1100972		2024-09-08 00:00:00.000	Johnson and Sons		Drones			DX-145 Drone		2356.33

*/

WITH ROW_NUMBERS AS (
	SELECT [OrderNum],[OrderDate],[CustName],[ProdCategory],[ProdName],[OrderTotal],
	ROW_NUMBER() OVER ( PARTITION BY [ProdCategory] ORDER BY [OrderTotal] DESC) as ROW_NUM
	FROM [master].[dbo].[OnlineRetailSales] 
	WHERE [CustName] = 'Boehm Inc.')

SELECT [OrderNum],[OrderDate],[CustName],[ProdCategory],[ProdName],[OrderTotal], ROW_NUM FROM ROW_NUMBERS
--WHERE ROW_NUM in (1,2,3)
WHERE ROW_NUM <= 3
ORDER BY [ProdCategory],[OrderTotal] DESC


/*

OrderNum	OrderDate					CustName	ProdCategory	ProdName								Order Total	ROW_NUM
--------------------------------------------------------------------------------------------------------------------------------
1104681		2024-02-28 00:00:00.000		Boehm Inc.	Blueprints		Cat Robot Blueprint						113.772		1
1100997		2022-09-11 00:00:00.000		Boehm Inc.	Blueprints		Cat Robot Blueprint						63.872		2
1102988		2023-06-29 00:00:00.000		Boehm Inc.	Drone Kits		BYOD-220								883.2		1
1105161		2024-05-09 00:00:00.000		Boehm Inc.	Drone Kits		BYOD-500								801.6		2
1101378		2022-11-03 00:00:00.000		Boehm Inc.	Drone Kits		BYOD-220								193.2		3
1101315		2022-10-25 00:00:00.000		Boehm Inc.	eBooks			Photograph Drones						521.65		1
1105539		2024-07-03 00:00:00.000		Boehm Inc.	eBooks			Understanding Artificial Intelligence	249.6		2
1105116		2024-05-03 00:00:00.000		Boehm Inc.	eBooks			Building Your Own Drone12				219.912		3
1101622		2022-12-08 00:00:00.000		Boehm Inc.	Robot Kits		BYOR-3000								12797		1
1104322		2024-01-02 00:00:00.000		Boehm Inc.	Robot Kits		BYOR-1500								1852.2		2
1104516		2024-02-06 00:00:00.000		Boehm Inc.	Robot Kits		BYOR-1500								1474.2		3
1104506		2024-02-04 00:00:00.000		Boehm Inc.	Robots			RWW-75 Robot							83708.4		1
1104835		2024-03-22 00:00:00.000		Boehm Inc.	Robots			RCB-889 Robot							33379.2		2
1102250		2023-03-12 00:00:00.000		Boehm Inc.	Robots			RLK-9920 Robot							3355.2		3
1103310		2023-08-08 00:00:00.000		Boehm Inc.	Training Videos	Mapping with Drones						4008.2		1
1105471		2024-06-23 00:00:00.000		Boehm Inc.	Training Videos	Aerial Security							3654.612	2
1105833		2024-08-18 00:00:00.000		Boehm Inc.	Training Videos	Understanding Automation				3587.01		3
*/