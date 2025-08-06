/*
Window Function
	* A function that performs operations on a subset of the result set defined by a window or frame
	* can be used to solve problems like
		- The most recent or oldest value
		- Rolling averages
		- Calculating running totals

	* Types include aggregate, ranking, and value functions


Components of a Windows function

FUNCTION NAME()              OVER( PARTITION BY [...]			ORDER BY [.....]				FRAME [.....] )

Identifies						Creates the						Orders the						Limits the
the specific					window or						results of						function by
window							frame							each							set of rows
function														window							or range


*/


/*

Query using ROW_NUMBER, and return each costumer's most recent order

*/

--preview
SELECT TOP (5) * FROM [master].[dbo].[OnlineRetailSales]

/*
OrderNum	OrderDate				OrderType	CustomerType	CustName			CustState		ProdCategory	ProdNumber	ProdName		Quantity	Price	Discount	OrderTotal
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1100941		2024-09-02 00:00:00.000	Retail		Individual		Antonina Noton		Missouri		Drones			DS306		DX-145 Drone	2			250		0			500
1100963		2024-09-05 00:00:00.000	Wholesale	Business		Stehr Group			North\tCarolina	Drones			DS301		DA-SA702 Drone	3			399		$79.80		1117.2
1100969		2024-09-06 00:00:00.000	Retail		Individual		Raimondo Goretti	Ohio			Drones			DS307		MICR-564K Drone	1			499		0			499
1100971		2024-09-06 00:00:00.000	Wholesale	Business		Hettinger and Sons	West Virginia	Drones			DS306		DX-145 Drone	12			250		$50.00		2950
1100972		2024-09-08 00:00:00.000	Wholesale	Business		Johnson and Sons	West Virginia	Drones			DS306		DX-145 Drone	11			250		$45.00		2356.33
*/

SELECT CUSTNAME, COUNT(DISTINCT OrderNum) AS OrderQuantity
FROM [master].[dbo].[OnlineRetailSales]
GROUP BY CUSTNAME

/*--- sample 

CUSTNAME				OrderQuantity
--------------------------------------
Aarika Adlington		1
Aaron Homenick			1
Abba Handman			1
Abbie Leroux			1
Abbott Group			6
Antonina Noton			1
Boehm Inc.				17
Donald Bump				1
Gusikowski Group		1
Hettinger and Sons		1
Home Depot Inc.			1
Johnson and Sons		1
Raimondo Goretti		1
Saxon Laviss			1
Schinner Inc.			1
Spencer Educators		1
Stehr Group				1
Target Corp				1
Turcotte Corp			1
Walmart Corp			1
Wilderman Technologies	1
*/


SELECT TOP(10) [OrderNum],[OrderDate],[CustName],[ProdName],[Quantity],
ROW_NUMBER() OVER ( PARTITION BY [CustName] ORDER BY [OrderDate] DESC) as ROW_NUM
FROM [master].[dbo].[OnlineRetailSales];

/*

OrderNum	OrderDate					CustName			ProdName					Quantity	ROW_NUM
1101870		2023-01-14 00:00:00.000		Aarika Adlington	Delta Robots				1			1
1101685		2022-12-18 00:00:00.000		Aaron Homenick		BYOD-400					1			1
1101370		2022-11-03 00:00:00.000		Abba Handman		Panda Robot Blueprint		1			1
1102807		2023-06-05 00:00:00.000		Abbie Leroux		DTI-84 Drone				2			1
1104858		2024-03-26 00:00:00.000		Abbott Group		Cat Robot Blueprint			5			1
1104758		2024-03-12 00:00:00.000		Abbott Group		Spherical Robots			9			2
1104687		2024-03-01 00:00:00.000		Abbott Group		Cartesian Robots			3			3
1103101		2023-07-13 00:00:00.000		Abbott Group		Arduino Books				7			4
1102408		2023-04-06 00:00:00.000		Abbott Group		Upside Down Robot Blueprint	21			5
1102312		2023-03-22 00:00:00.000		Abbott Group		Upside Down Robot			11			6
*/

/*
-- This fails as WHERE is executed before the WINDOWS function, and this do not exist yet

SELECT TOP(10) [OrderNum],[OrderDate],[CustName],[ProdName],[Quantity],
ROW_NUMBER() OVER ( PARTITION BY [CustName] ORDER BY [OrderDate] DESC) as ROW_NUM
FROM [master].[dbo].[OnlineRetailSales]
WHERE ROW_NUM=1
*/

-- Using a CTE

WITH ROW_NUMBERS AS (
	SELECT [OrderNum],[OrderDate],[CustName],[ProdName],[Quantity],
	ROW_NUMBER() OVER ( PARTITION BY [CustName] ORDER BY [OrderDate] DESC) as ROW_NUM
	FROM [master].[dbo].[OnlineRetailSales] )

SELECT * FROM ROW_NUMBERS WHERE ROW_NUM=1

/*
OrderNum	OrderDate				CustName				ProdName				Quantity	ROW_NUM
1101870		2023-01-14 00:00:00.000	Aarika Adlington		Delta Robots				1		1
1101685		2022-12-18 00:00:00.000	Aaron Homenick			BYOD-400					1		1
1101370		2022-11-03 00:00:00.000	Abba Handman			Panda Robot Blueprint		1		1
1102807		2023-06-05 00:00:00.000	Abbie Leroux			DTI-84 Drone				2		1
1104858		2024-03-26 00:00:00.000	Abbott Group			Cat Robot Blueprint			5		1
1100941		2024-09-02 00:00:00.000	Antonina Noton			DX-145 Drone				2		1
1105833		2024-08-18 00:00:00.000	Boehm Inc.				Understanding Automation	160		1
1100989		2024-09-20 00:00:00.000	Donald Bump				DX-145 Drone				14		1
1100934		2024-09-01 00:00:00.000	Gusikowski Group		Bsquare Robot Blueprint		10		1
1100971		2024-09-06 00:00:00.000	Hettinger and Sons		DX-145 Drone				12		1
1100981		2024-09-14 00:00:00.000	Home Depot Inc.			DX-145 Drone				21		1
1100972		2024-09-08 00:00:00.000	Johnson and Sons		DX-145 Drone				11		1
1100969		2024-09-06 00:00:00.000	Raimondo Goretti		MICR-564K Drone				1		1
1100937		2024-09-04 00:00:00.000	Saxon Laviss			BYOR-1000					1		1
1100936		2024-09-01 00:00:00.000	Schinner Inc.			Aerial Security				10		1
1100935		2022-09-02 00:00:00.000	Spencer Educators		BYOD-300					2		1
1100963		2024-09-05 00:00:00.000	Stehr Group				DA-SA702 Drone				3		1
1100973		2024-09-12 00:00:00.000	Target Corp				BP-287 Blueprint			24		1
1100939		2024-09-02 00:00:00.000	Turcotte Corp			DC-304 Drone				79		1
1100974		2024-09-12 00:00:00.000	Walmart Corp			DX-145 Drone				12		1
1100938		2024-09-10 00:00:00.000	Wilderman Technologies	Building Your First Robot	4		1

*/


