/*
Meaning of Ranking

Horse name          Time to Finish			Row Number			RANK			DENSE_RANK

See-quel			132						1					1				1
Top-N				140						2					2				2
QueryOptimizer		140						3					2				2
CamelCase			154						4					4				3
No-Limit			159						5					5				4

*/

/*
	Query using RANK() and DENSE_RANK() that ranks employees in alphabetical order by their last name
*/

--  preview

SELECT TOP(5) * FROM [master].[dbo].[EmployeeDirectory]

/*	
FirstName	LastName	Title								Department			Email				DepartmentID	EmployeeID	Manager
---------------------------------------------------------------------------------------------------------------------------------------
Ainsley		Barnett		Customer Service Representative		Customer Service	abarnett@acme.com	2				1			8
Dominic\t	Buchanan	Product Manager						Travel\tProducts	dbuchanan@acme.com	8				10			2
Hermione	Lane		Product Manager						Travel\tProducts	hlane@acme.com		8				11			2
Quincy		\tLindsay	Designer							Marketing			qlindsay@acme.com	7				12			5
Lewis		Rivas		Senior Writer						Marketing			lrivas@acme.com		7				13			77
*/


SELECT *, 
RANK()  OVER ( ORDER BY [LastName]) AS RANK_,
DENSE_RANK()  OVER ( ORDER BY [LastName]) AS DENSE_RANK_
FROM [master].[dbo].[EmployeeDirectory]


/*

FirstName	LastName	Title							Department			Email				DepartmentID	EmployeeID	Manager	RANK_	DENSE_RANK_
Quincy		\tLindsay	Designer						Marketing			qlindsay@acme.com	7				12			5		1		1
Ronald		Araujo		Customer Service Representative	Customer Service	raraujo@acme.com	7				14			8		2		2
Ainsley		Barnett		Customer Service Representative	Customer Service	abarnett@acme.com	2				1			8		3		3
Dominic\t	Buchanan	Product Manager					Travel\tProducts	dbuchanan@acme.com	8				10			2		4		4
Roanna		Bush		Video Editor					Marketing			rbush@acme.com		7				58			77		5		5
Ella		Callahan	Product Manager					Travel Products		ecallahan@acme.com	8				52			2		6		6
Logan		Davenport	Sales Representative			Travel Products		ldavenport@acme.com	8				48			42		7		7
Julie		Davenport	Customer Service Representative	Customer Service	jdavenport@acme.com	2				15			8		7		7
Devin		David		CFO								Executive Team		ddavid@acme.com		1				49			37		9		8
Yvette		Diaz		Web Designer					Marketing			ydiaz@acme.com		7				45			5		10		9
Hector		Dillon		Accountant						Finance				hdillon@acme.com	4				22			49		11		10
Jeffrey\t	Duhmmer		Designer						Travel\tProducts	jduhmmer@acme.com	76				40			8		12		11
Donovan		England		Product Manager					Travel Products		dengland@acme.com	8				66			2		13		12
Yvonne		Fischer		Product Manager					Travel Products		yfischer@acme.com	8				3			2		14		13
Dacey		Flynn		Server Adminstrator				Information Systems	dflynn@acme.com		6				82			81		15		14
Shay		Gaines		Product Manager					Travel Products		sgaines@acme.com	8				67			2		16		15
Trump		Jeff		Product Manager					Marketing			jtrump@acme.com		77				2			1		17		16
Hermione	Lane		Product Manager					Travel\tProducts	hlane@acme.com		8				11			2		18		17
Lionel		Mess		Designer						Marketing			lmessi@acme.com		7				31			77		19		18
Lewis		Rivas		Senior Writer					Marketing			lrivas@acme.com		7				13			77		20		19
Sean		Smith		Senior Writer					Marketing			ssmith@acme.com		7				32			77		21		20
*/