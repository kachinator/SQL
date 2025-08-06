/*
	Use the inventory table to write a query that uses a subquery to return ProdCategory, ProdNumber, ProdName,
	and In Stock of Items that have less than the average amount of product left in stock, to help
	the bussines know whichproducts are running low
*/

-- preview
SELECT TOP (5) * FROM [master].[dbo].[Inventory]

/*
	ProdCategory	ProdNumber	ProdName		RetailPrice	Cost	InStock	InventoryOnHand
	---------------------------------------------------------------------------------------
	Blueprints		BP101		All Eyes Drone	9.99		3.7962	243		922.4766
	Blueprints		BP102		Bsquare Robot	8.99		3.4162	351		1199.0862
	Drone Kits		DK203		BYOD-220		200.99		127.34	189		24067.26
	Blueprints		BP104		Cat Robot		4.99		1.8962	2229	4226.6298
	Drone Kits		DK201		BYOD-100		128.45		82.71	16		1323.36
*/

SELECT [ProdCategory], [ProdNumber], [ProdName], [InStock] 
FROM [master].[dbo].[Inventory]
WHERE [InStock] < ( SELECT  AVG([InStock]) FROM [master].[dbo].[Inventory])

/*
	ProdCategory	ProdNumber	ProdName				InStock
	-------------------------------------------------------------
	Blueprints		BP101		All Eyes Drone			243
	Blueprints		BP102		Bsquare Robot			351
	Drone Kits		DK203		BYOD-220				189
	Drone Kits		DK201		BYOD-100				16
	Blueprints		BP106		Hexacopter Drone		334
	Blueprints		BP107		Ladybug Robot Blueprint	283
	Drone Kits		DK204		BYOD-300				127
	Blueprints		BP105		Creature Robot Arms		321
*/


SELECT  AVG([InStock]) FROM [master].[dbo].[Inventory]

/*
	559
*/