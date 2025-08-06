/*
OPENJSON
A table value function will generate a relational table with its contents from the JSON string.
It will iterate through JSON object elements and arrays and generate a row for each element.
We can generate a table without a pre-defined schema or a well-defined schema.

OPENJSON Without a Pre-defined Schema
This functionality will return the value as key-value pairs, including their type. The following
example shows JSON data as key-value pair with its type.

*/



DECLARE @JSONData AS NVARCHAR(4000)
SET @JSONData = N'{
        "FirstName":"John",
        "LastName":"Smith",
        "Code":"EECCDD",
        "Addresses":[
            { "Address":"Main St", "City":"Aurora", "State":"Illinois"},
            { "Address":"First Ave", "City":"Valparaiso", "State":"Indiana"}
        ]
    }'


SELECT * FROM OPENJSON(@JSONData)

/*
	key			value																															type
FirstName	John																																1
LastName	Smith																																1
Code		EECCDD																																1
Addresses	[ { "Address":"Main St", "City":"Aurora", "State":"Illinois"}, { "Address":"First Ave", "City":"Valparaiso", "State":"Indiana"} ]	4
*/


/*
OPENJSON with a Pre-defined Schema

OPENJSON function can also generate a result set with a pre-defined schema. If we generate results
with a pre-defined schema, it generates a table based on provided schema instead of key-value pair.

*/

DECLARE @EmployeeInfoData nvarchar(max)

SET @EmployeeInfoData='[{"Id":12,"Code":"10A", "FirstName":"Sam",  "LastName":"Smith"},
						{"Id":22,"Code":"30V", "FirstName":"George",  "LastName":"Wright"},
						{"Id":32,"Code":"40A", "FirstName":"Josue",  "LastName":"Garcia"},
						{"Id":42,"Code":"20S", "FirstName":"Sandeep",  "LastName":"Gandhi"}]'


select * from openjson(@EmployeeInfoData)
WITH
(
	[Id] [int],
    [Code] [varchar](50),
    [FirstName] [varchar](50),
    [LastName] [varchar](50)
)
/*
Id	Code	FirstName	LastName
12	10A		Sam			Smith
22	30V		George		Wright
32	40A		Josue		Garcia
42	20S		Sandeep		Gandhi
*/

/*
We can also access child JSON objects as well using the OPENJSON function. This can be done by
CROSS APPLYing the JSON child element with the parent element.

In the following example, the EmployeeInfo and Addresses objects are fetched and applied to
Cross join on. We need to use the "AS JSON" option in the column definition to specify which
references the property that contains the child JSON node. 
In the column specified with the "AS JSON" option, the type must be NVARCHAR (MAX).
Without this option, this function returns a NULL value instead of a child JSON object and
returns a run time error in "strict" mode.
*/

DECLARE @JSONData_1 AS NVARCHAR(4000)
SET @JSONData_1 = '[
	{
        "FirstName":"Jose",
        "LastName":"Torres",
        "Code":"ABCDEF",
        "Addresses":[
            { "Address":"Main St", "City":"DeKalb", "State":"Illinois"},
            { "Address":"First St", "City":"Rockford", "State":"Illinois"},
            { "Address":"Lincoln Hwy", "City":"Sandwich", "State":"Illinois"}
        ]
    },
	{
        "FirstName":"Juan",
        "LastName":"Perez",
        "Code":"RSTVXY",
        "Addresses":[
            { "Address":"Maple St", "City":"Naperville", "State":"Illinois"},
            { "Address":"Locus St", "City":"Wheaton", "State":"Illinois"}
        ]
    },
	{
        "FirstName":"Casimiro",
        "LastName":"LaPuerta",
        "Code":"AZBXCY",
		"Addresses":[{"Address":"", "City":"", "State":"Illinois"}]
    },
	{
        "FirstName":"Casimiro",
        "LastName":"LaCasa",
        "Code":"AZBXCY",
		"Addresses":[]
    }
]'


SELECT FirstName, LastName, Code, Address, City, State
FROM OPENJSON(@JSONData_1)
WITH (
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Code VARCHAR(50),
	Addresses NVARCHAR(max) as json
) as B
CROSS APPLY openjson (B.Addresses)
WITH
(
    Address VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50)
)

/*	
FirstName	LastName	Code	Address			City		State
Jose		Torres		ABCDEF	Main St			DeKalb		Illinois
Jose		Torres		ABCDEF	First St		Rockford	Illinois
Jose		Torres		ABCDEF	Lincoln Hwy		Sandwich	Illinois
Juan		Perez		RSTVXY	Maple St		Naperville	Illinois
Juan		Perez		RSTVXY	Locus St		Wheaton	    Illinois
Casimiro	LaPuerta	AZBXCY								Illinois
*/
