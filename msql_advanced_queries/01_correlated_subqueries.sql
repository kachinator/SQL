/*
Correlated sub-query 
Query that outputs first and last name, state, email address, and phone number of conference attendees
who come from states that have no Online Retail Sales
*/

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

SELECT TOP(5) * from [master].[dbo].[ConventionAttendees]

/*
RegistrationDate				FirstName	lastName	Email							PhoneNumber		Address					City			State					Zip		Package	PackageCost	Discount	DiscountAmount	AmountPaid	PaymentType			Last4cardDigits	AuthorizationN
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2024-05-21 00:00:00.000			Andrej		Abbots		aabbotsga@usda.gov				219-567-4074	2 Norway Maple Avenue	Pasadena		California				91125	Mezzo	350			na			0				350			American Express	1884			174182
2024-03-12 00:00:00.000			Ayn			Adamini		aadamini5d@blogspot.com			855-308-5796	7 Forest Terrace		Jamaica			New York				11447	Mezzo	350			Early bird	0.15			297.5		Visa				4013			155112
2024-03-28 00:00:00.000			Averil		Aiskrigg	aaiskriggfg@foxnews.com			789-155-7939	85950 2nd Place			Washington		District of Columbia	20380	Macro	500			na			0				500			Visa				5014			776644
2024-07-15 00:00:00.000			Ariel		Aizlewood	aaizlewood6f@telegraph.co.uk	928-644-9247	2037 Quincy Drive		Redwood City	California				94064	Macro	500			Sponsor		0.2				400			MasterCard			4979			616341
2024-04-10 00:00:00.000			Alfy		Akess		aakessi0@state.tx.us			274-822-2814	7 Granby Drive			Chicago			Illinois				60686	Macro	500			Group		0.1				450			Visa				5019			185714

*/

SELECT [FirstName], [lastName], [State], [Email], [PhoneNumber]
FROM [master].[dbo].[ConventionAttendees]  as  c
WHERE NOT EXISTS 
				 ( SELECT [CustState] FROM [master].[dbo].[OnlineRetailSales] as o
				   WHERE c.[State] = o.[CustState]);

/*

	FirstName	lastName	State					Email							PhoneNumber
	---------------------------------------------------------------------------------------------
	Andrej		Abbots		California				aabbotsga@usda.gov				219-567-4074
	Averil		Aiskrigg	District of Columbia	aaiskriggfg@foxnews.com			789-155-7939
	Ariel		Aizlewood	California				aaizlewood6f@telegraph.co.uk	928-644-9247
	Anita	A	leksahkin	Washington				aaleksahkinh3@uol.com.br		598-789-9940

*/