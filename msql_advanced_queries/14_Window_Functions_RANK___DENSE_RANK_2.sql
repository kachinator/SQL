/*
Write a Query using RANK() or DENSE_RANK() that returns the registration information for the first 
three conference attendees that register for each state

*/

-- preview

SELECT TOP(6) * FROM [master].[dbo].[ConventionAttendees]

/*
RegistrationDate		FirstName	LastName	Email							Phone Number	Address					City			State					Zip		Package	PackageCost	Discount	DiscountAmount	AmountPaid	PaymentType			Last4CardDigits	AuthorizationN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2024-05-21 00:00:00.000	Andrej		Abbots		aabbotsga@usda.gov				219-567-4074	2 Norway Maple Avenue	Pasadena		California				91125	Mezzo	350			na			0				350			American Express	1884			174182
2024-03-12 00:00:00.000	Ayn			Adamini		aadamini5d@blogspot.com			855-308-5796	7 Forest Terrace		Jamaica			New York				11447	Mezzo	350			Early bird	0.15			297.5		Visa				4013			155112
2024-03-28 00:00:00.000	Averil		Aiskrigg	aaiskriggfg@foxnews.com			789-155-7939	85950 2nd Place			Washington		District of Columbia	20380	Macro	500			na			0				500			Visa				5014			776644
2024-07-15 00:00:00.000	Ariel		Aizlewood	aaizlewood6f@telegraph.co.uk	928-644-9247	2037 Quincy Drive		Redwood City	California				94064	Macro	500			Sponsor		0.2				400			MasterCard			4979			616341
2024-04-10 00:00:00.000	Alfy		Akess		aakessi0@state.tx.us			274-822-2814	7 Granby Drive			Chicago			Illinois				60686	Macro	500			Group		0.1				450			Visa				5019			185714
2024-03-29 00:00:00.000	Anita		Aleksahkin	aaleksahkinh3@uol.com.br		598-789-9940	16748 Pearson Avenue	Tacoma			Washington				98417	Micro	200			Group		0.1				180			Visa				4778			933161
*/

SELECT *,
DENSE_RANK() OVER ( PARTITION BY [State] ORDER BY [RegistrationDate]) AS DENSE_RANK_
FROM [master].[dbo].[ConventionAttendees];

/*

RegistrationDate		FirstName	LastName	Email							Phone Number	Address					City			State					Zip		Package	PackageCost	Discount	DiscountAmount	AmountPaid	PaymentType			Last4CardDigits	AuthorizationN  DENSE_RANK_
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2024-03-02 00:00:00.000	Luelle		Beales		lbealesql@nsw.gov.au			286-713-0147	1288 Corscot Street		Birmingham		Alabama					35205	Mezzo	350			Group		0.1				315			MasterCard			6999			708552			1
2024-03-04 00:00:00.000	Reynolds	Youthead	ryoutheadgw@google.fr			194-596-8326	36392 Vahlen Drive		Tuscaloosa		Alabama					35487	Mezzo	350			na			0				350			Visa				4887			188357			2
2024-03-04 00:00:00.000	Vite		Kilius		vkilius69@vk.com				491-191-1714	6376 Hovde Terrace		Mobile			Alabama					36610	Mezzo	350			na			0				350			American Express	5582			72661			2
2024-03-05 00:00:00.000	Heida		Derl		hderlef@sogou.com				238-319-1720	424 4th Terrace			Montgomery		Alabama					36114	Macro	500			Group		0.1				450			Visa				1246			209293			3
2024-03-06 00:00:00.000	Jared		Mulford		jmulford5i@angelfire.com		569-965-2830	815 Mandrake Way		Mobile			Alabama					36689	Micro	200			Early bird	0.15			170			MasterCard			5114			659605			4
2024-03-06 00:00:00.000	Abbot		Wayman		awaymanmg@cam.ac.uk				771-806-0020	377 Sunbrook Junction	Birmingham		Alabama					35231	Macro	500			Sponsor		0.2				400			Discover			9161			686837			4
2024-03-06 00:00:00.000	Crissy		Slinn		cslinnmp@epa.gov				215-279-3654	45231 Clove Center		Mobile			Alabama					36605	Mezzo	350			Group		0.1				315			Visa				9295			281365			4
2024-05-21 00:00:00.000	Andrej		Abbots		aabbotsga@usda.gov				219-567-4074	2 Norway Maple Avenue	Pasadena		California				91125	Mezzo	350			na			0				350			American Express	1884			174182			1
2024-07-15 00:00:00.000	Ariel		Aizlewood	aaizlewood6f@telegraph.co.uk	928-644-9247	2037 Quincy Drive		Redwood City	California				94064	Macro	500			Sponsor		0.2				400			MasterCard			4979			616341			2
2024-03-28 00:00:00.000	Averil		Aiskrigg	aaiskriggfg@foxnews.com			789-155-7939	85950 2nd Place			Washington		District of Columbia	20380	Macro	500			na			0				500			Visa				5014			776644			1
2024-04-10 00:00:00.000	Alfy		Akess		aakessi0@state.tx.us			274-822-2814	7 Granby Drive			Chicago			Illinois				60686	Macro	500			Group		0.1				450			Visa				5019			185714			1
2024-03-12 00:00:00.000	Ayn			Adamini		aadamini5d@blogspot.com			855-308-5796	7 Forest Terrace		Jamaica			New York				11447	Mezzo	350			Early bird	0.15			297.5		Visa				4013			155112			1
2024-03-29 00:00:00.000	Anita		Aleksahkin	aaleksahkinh3@uol.com.br		598-789-9940	16748 Pearson Avenue	Tacoma			Washington				98417	Micro	200			Group		0.1				180			Visa				4778			933161			1

*/

-- As we can't use WHERE in a WINDOWS function, lets use CTE

WITH RANKS AS (
		SELECT *,
		DENSE_RANK() OVER ( PARTITION BY [State] ORDER BY [RegistrationDate]) AS DENSE_RANK_
		FROM [master].[dbo].[ConventionAttendees]
)

SELECT * FROM RANKS 
WHERE DENSE_RANK_ <= 3;


/*
RegistrationDate		FirstName	LastName	Email							Phone Number	Address					City			State					Zip		Package	PackageCost	Discount	DiscountAmount	AmountPaid	PaymentType			Last4CardDigits	AuthorizationN  DENSE_RANK_
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2024-03-02 00:00:00.000	Luelle		Beales		lbealesql@nsw.gov.au			286-713-0147	1288 Corscot Street		Birmingham		Alabama					35205	Mezzo	350			Group		0.1				315			MasterCard			6999			708552			1
2024-03-04 00:00:00.000	Reynolds	Youthead	ryoutheadgw@google.fr			194-596-8326	36392 Vahlen Drive		Tuscaloosa		Alabama					35487	Mezzo	350			na			0				350			Visa				4887			188357			2
2024-03-04 00:00:00.000	Vite		Kilius		vkilius69@vk.com				491-191-1714	6376 Hovde Terrace		Mobile			Alabama					36610	Mezzo	350			na			0				350			American Express	5582			72661			2
2024-03-05 00:00:00.000	Heida		Derl		hderlef@sogou.com				238-319-1720	424 4th Terrace			Montgomery		Alabama					36114	Macro	500			Group		0.1				450			Visa				1246			209293			3
2024-05-21 00:00:00.000	Andrej		Abbots		aabbotsga@usda.gov				219-567-4074	2 Norway Maple Avenue	Pasadena		California				91125	Mezzo	350			na			0				350			American Express	1884			174182			1
2024-07-15 00:00:00.000	Ariel		Aizlewood	aaizlewood6f@telegraph.co.uk	928-644-9247	2037 Quincy Drive		Redwood City	California				94064	Macro	500			Sponsor		0.2				400			MasterCard			4979			616341			2
2024-03-28 00:00:00.000	Averil		Aiskrigg	aaiskriggfg@foxnews.com			789-155-7939	85950 2nd Place			Washington		District of Columbia	20380	Macro	500			na			0				500			Visa				5014			776644			1
2024-04-10 00:00:00.000	Alfy		Akess		aakessi0@state.tx.us			274-822-2814	7 Granby Drive			Chicago			Illinois				60686	Macro	500			Group		0.1				450			Visa				5019			185714			1
2024-03-12 00:00:00.000	Ayn			Adamini		aadamini5d@blogspot.com			855-308-5796	7 Forest Terrace		Jamaica			New York				11447	Mezzo	350			Early bird	0.15			297.5		Visa				4013			155112			1
2024-03-29 00:00:00.000	Anita		Aleksahkin	aaleksahkinh3@uol.com.br		598-789-9940	16748 Pearson Avenue	Tacoma			Washington				98417	Micro	200			Group		0.1				180			Visa				4778			933161			1
*/



-- With RANK

WITH RANKS AS (
		SELECT *,
		RANK() OVER ( PARTITION BY [State] ORDER BY [RegistrationDate]) AS RANK_
		FROM [master].[dbo].[ConventionAttendees]
)

SELECT * FROM RANKS 
WHERE RANK_ <= 3

-- this solution has 

/*

RegistrationDate		FirstName	LastName	Email							Phone Number	Address					City			State					Zip		Package	PackageCost	Discount	DiscountAmount	AmountPaid	PaymentType			Last4CardDigits	AuthorizationN  RANK_
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2024-03-02 00:00:00.000	Luelle		Beales		lbealesql@nsw.gov.au			286-713-0147	1288 Corscot Street		Birmingham		Alabama					35205	Mezzo	350			Group		0.1				315			MasterCard			6999			708552			1
2024-03-04 00:00:00.000	Reynolds	Youthead	ryoutheadgw@google.fr			194-596-8326	36392 Vahlen Drive		Tuscaloosa		Alabama					35487	Mezzo	350			na			0				350			Visa				4887			188357			2
2024-03-04 00:00:00.000	Vite		Kilius		vkilius69@vk.com				491-191-1714	6376 Hovde Terrace		Mobile			Alabama					36610	Mezzo	350			na			0				350			American Express	5582			72661			2
2024-05-21 00:00:00.000	Andrej		Abbots		aabbotsga@usda.gov				219-567-4074	2 Norway Maple Avenue	Pasadena		California				91125	Mezzo	350			na			0				350			American Express	1884			174182			1
2024-07-15 00:00:00.000	Ariel		Aizlewood	aaizlewood6f@telegraph.co.uk	928-644-9247	2037 Quincy Drive		Redwood City	California				94064	Macro	500			Sponsor		0.2				400			MasterCard			4979			616341			2
2024-03-28 00:00:00.000	Averil		Aiskrigg	aaiskriggfg@foxnews.com			789-155-7939	85950 2nd Place			Washington		District of Columbia	20380	Macro	500			na			0				500			Visa				5014			776644			1
2024-04-10 00:00:00.000	Alfy		Akess		aakessi0@state.tx.us			274-822-2814	7 Granby Drive			Chicago			Illinois				60686	Macro	500			Group		0.1				450			Visa				5019			185714			1
2024-03-12 00:00:00.000	Ayn			Adamini		aadamini5d@blogspot.com			855-308-5796	7 Forest Terrace		Jamaica			New York				11447	Mezzo	350			Early bird	0.15			297.5		Visa				4013			155112			1
2024-03-29 00:00:00.000	Anita		Aleksahkin	aaleksahkinh3@uol.com.br		598-789-9940	16748 Pearson Avenue	Tacoma			Washington				98417	Micro	200			Group		0.1				180			Visa				4778			933161			1

*/