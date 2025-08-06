/*
FOR JSON
Function FOR JSON is very useful when exporting SQL table data in JSON format. 
It is very similar to FOR XML function. Here, column names or aliases are key names 
for JSON objects. There are two options FOR JSON.

AUTO - It will create nested JSON sub-array based on the table hierarchy used in the query.
PATH - It enables us to define the required JSON structure using the column name or aliases.
	If we put dot (.) separated names in the column aliases, JSON properties follow the same
	naming convention.

The FOR JSON AUTO is suitable for most scenarios, but FOR JSON PATH is very useful in specific
scenarios where we must control how JSON data is generated or nested. The FOR JSON PATH gives
us full control to specify the output format for JSON data.

*/




DECLARE @AddressData nvarchar(max)

DECLARE @AddressesTable TABLE(
	[Id] [int] NOT NULL,
    [EmployeeId] [int] NULL,
    [Address] [varchar](250) NULL,
    [City] [varchar](50) NULL,
    [State] [varchar](50) NULL
	)


SET @AddressData='[ {"Id":1,"EmployeeId":1, "Address":"Fisrt Ave", "City":"Glen Ellyn", "State":"Illinois"},
					{"Id":2,"EmployeeId":1, "Address":"Second Ave", "City":"Wheaton", "State":"Illinois"},
					{"Id":3,"EmployeeId":2, "Address":"Fifth Ave", "City":"Naperville", "State":"Illinois"},
					{"Id":4,"EmployeeId":2, "Address":"Main St", "City":"Lisle", "State":"Illinois"}]'



INSERT INTO @AddressesTable  (
			    [Id],
				[EmployeeId], 
				[Address], 
				[City], 
				[State]
				)

select * from openjson(@AddressData)
WITH
(
	Id int '$.Id',
	EmployeeId int '$.EmployeeId',
	Address nvarchar(250) '$.Address',
	City nvarchar(50) '$.City',
	State nvarchar(50) '$.State'
)
select * from @AddressesTable

/*
Id	EmployeeId	Address			City		State
1	1			Fisrt Ave		Glen Ellyn	Illinois
2	1			Second Ave		Wheaton		Illinois
3	2			Fifth Ave		Naperville	Illinois
4	2			Main St			Lisle		Illinois

*/

DECLARE @EmployeeInfoData nvarchar(max)

DECLARE @EmployeeInfoTable TABLE(
	[Id] [int] NOT NULL,
    [Code] [int] NULL,
    [FirstName] [varchar](50) NULL,
    [LastName] [varchar](50) NULL
	)


SET @EmployeeInfoData='[{"Id":1,"Code":1, "FirstName":"Sam",  "LastName":"Smith"},
						{"Id":2,"Code":3, "FirstName":"Olsen",  "LastName":"Wright"},
						{"Id":3,"Code":4, "FirstName":"Jose",  "LastName":"Garcia"},
						{"Id":4,"Code":2, "FirstName":"Sandeep",  "LastName":"Gandhi"}]'



INSERT INTO @EmployeeInfoTable  (
			    [Id],
				[Code], 
				[FirstName], 
				[LastName]
				)

select * from openjson(@EmployeeInfoData)
WITH
(
	Id int '$.Id',
	Code int '$.Code',
	FirstName nvarchar(50) '$.FirstName',
	LastName nvarchar(50) '$.LastName'
)
select * from @EmployeeInfoTable

/*
Id	Code	FirstName	LastName
1	1		Sam			Smith
2	3		Olsen		Wright
3	4		Jose		Garcia
4	2		Sandeep		Gandhi
*/

-----------------------------------------------------
--      FOR JSON AUTO

SELECT * FROM @EmployeeInfoTable e
INNER JOIN @AddressesTable Addresses ON e.Id = Addresses.EmployeeId
WHERE e.Id = 1
FOR JSON AUTO

/*
[	{
		"Id":1,
		"Code":1,
		"FirstName":"Sam",
		"LastName":"Smith",
		"Addresses":[
			{
				"Id":1,
				"EmployeeId":1,
				"Address":"Fisrt Ave",
				"City":"Glen Ellyn",
				"State":"Illinois"
			},
			{
				"Id":2,
				"EmployeeId":1,
				"Address":"Second Ave",
				"City":"Wheaton",
				"State":"Illinois"
			}
		]
	}
]

*/


-----------------------------------------------------
--      FOR JSON PATH

SELECT Id, Code, FirstName, LastName,
    (SELECT Id, Address, City, State
    FROM @AddressesTable a
    WHERE a.EmployeeId = e.Id
    FOR JSON AUTO
    ) as Addresses
FROM @EmployeeInfoTable e
WHERE e.Id =1
FOR JSON PATH, ROOT ('EmployeeInfo')

/*
{
	"EmployeeInfo":[
	{
		"Id":1,
		"Code":1,
		"FirstName":"Sam",
		"LastName":"Smith",
		"Addresses":[
			{	"Id":1,
				"Address":"Fisrt Ave",
				"City":"Glen Ellyn",
				"State":"Illinois"
			},
			{	"Id":2,
				"Address":"Second Ave",
				"City":"Wheaton",
				"State":"Illinois"
			}
		]
	}
	]
}

*/