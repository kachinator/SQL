/*------------------   SUBQUERIES   ------------*/
-- Preview the query

SELECT TOP(5) * FROM [master].[dbo].[OnlineRetailSales]

/*
    OrderNum    OrerDate                OrderType   CustomerType    CustName            CustState       ProdCategory    ProdNumber  ProdName        Quantity    Price   Discount    OrderTotal
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    1100941	    2024-09-02 00:00:00.000	Retail	    Individual	    Antonina Noton	    Missouri	    Drones	        DS306	    DX-145 Drone	2	        250	    0	        500
    1100963	    2024-09-05 00:00:00.000	Wholesale	Business	    Stehr Group	        North\tCarolina	Drones	        DS301	    DA-SA702 Drone	3	        399	    $79.80	    1117.2
    1100969	    2024-09-06 00:00:00.000	Retail	    Individual	    Raimondo Goretti	Ohio	Drones	DS307	        MICR-564K   Drone	        1	        499	    0	        499
    1100971	    2024-09-06 00:00:00.000	Wholesale	Business	    Hettinger and Sons	West Virginia	Drones	        DS306	    DX-145 Drone	12	        250	    $50.00	    2950
    1100972	    2024-09-08 00:00:00.000	Wholesale	Business	    Johnson and Sons	West Virginia	Drones	        DS306	    DX-145 Drone	11	        250	    $45.00	    2356.33

*/

/* Oder higher than the average value */
SELECT * FROM [master].[dbo].[OnlineRetailSales]

WHERE [OrderTotal] >= ( SELECT AVG([OrderTotal]) FROM [master].[dbo].[OnlineRetailSales])

/*
    OrderNum    OrerDate                OrderType   CustomerType    CustName        CustState   ProdCategory    ProdNumber  ProdName        Quantity    Price   Discount    OrderTotal
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    1100939	    2024-09-02 00:00:00.000	Wholesale	Business	    Turcotte Corp	New York	Drones	        DS302	    DC-304 Drone	79	        395	    $79.00	    31126
    1101622	    2022-12-08 00:00:00.000	Wholesale	Business	    Boehm Inc.	    Texas	    Robot Kits	    BYOR-3000	BYOR-3000	    100	        127.97	0	        12797
    1104506	    2024-02-04 00:00:00.000	Wholesale	Business	    Boehm Inc.	    Texas	    Robots	        RWW-75	    RWW-75 Robot	250	        334.83	0	        83708.4
    1104835	    2024-03-22 00:00:00.000	Wholesale	Business	    Boehm Inc.	    Texas	    Robots	        RCB-889	    RCB-889 Robot	200	        166.9	0	        33379.2

*/

-- SUBQUERY

SELECT AVG([OrderTotal]) FROM [master].[dbo].[OnlineRetailSales]
/*
    4846.798857142857
*/