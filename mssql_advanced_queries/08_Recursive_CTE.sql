/*
	Recursive CTE
	Often used to model data composed of relationship structures:
		Network Graphs
		Hierarchical data

	1st Anchor member: the base result set for the query
	2nd Recusrsive member: references the CTE itself, building on the base result set returned by the anchor member
	3rd Anchor and recursive mmbers separated by operators like UNION ALL or EXCEPT


	write a query that uses a Recursive CTE to return the count of direct reports that one person has, Grant Nguyen, EmployeeID = 2
*/

-- preview
SELECT TOP (5) * FROM [master].[dbo].[EmployeeDirectory]

/*
	
	FirstName	LastName	Title							Department			Email				DepartmentID	EmployeeID	Manager
	-------------------------------------------------------------------------------------------------------------------------------------
	Ainsley		Barnett		Customer Service Representative	Customer Service	abarnett@acme.com	2				1			8
	Dominic\t	Buchanan	Product Manager					Travel\tProducts	dbuchanan@acme.com	8				10			2
	Hermione	Lane		Product Manager					Travel\tProducts	hlane@acme.com		8				11			2
	Quincy		\tLindsay	Designer						Marketing			qlindsay@acme.com	7				12			5
	Lewis		Rivas		Senior Writer					Marketing			lrivas@acme.com		7				13			77
*/

------ These two notations work
--================================
-- SELECT [EmployeeID], [FirstName], [LastName],  [Manager]
-- FROM  [master].[dbo].[EmployeeDirectory]
-- WHERE [EmployeeID] = 2;


SELECT EmployeeID, FirstName, LastName,  Manager
FROM  master.dbo.EmployeeDirectory
WHERE EmployeeID = 2;


/*
	EmployeeID	FirstName	LastName	Manager
	-----------------------------------------------
	2			Trump		Jeff		1
*/


WITH DirectReports AS (
			-- Anchor member, returns the base result set
			SELECT [EmployeeID], [FirstName], [LastName],  [Manager]
			FROM  [master].[dbo].[EmployeeDirectory]
			WHERE [EmployeeID] = 2
			-- Anchor and recursive are separated by UNION, UNION ALL, intersect or accept
			UNION ALL
			-- second member, recursive member, it reference the CTE itself
			-- building on the base result
			SELECT e.[EmployeeID], e.[FirstName], e.[LastName],  e.[Manager]
			FROM  [master].[dbo].[EmployeeDirectory] AS e
			-- 
			INNER JOIN DirectReports as d  ON e.[Manager] = d.[EmployeeID]
			)

SELECT * FROM DirectReports;

/*
Recursively add as a UNION of ALL the combinations (one-row) where the Manager is 2 ( Trump	Jeff)

	EmployeeID	FirstName	LastName	Manager
	-------------------------------------------
	2			Trump		Jeff		1
	10			Dominic\t	Buchanan	2
	11			Hermione	Lane		2
	52			Ella		Callahan	2
	66			Donovan		England		2
	3			Yvonne		Fischer		2
	67			Shay		Gaines		2

*/



WITH DirectReports AS (
			SELECT [EmployeeID], [FirstName], [LastName],  [Manager]
			FROM  [master].[dbo].[EmployeeDirectory]
			WHERE [EmployeeID] = 2
			UNION ALL
			SELECT e.[EmployeeID], e.[FirstName], e.[LastName],  e.[Manager]
			FROM  [master].[dbo].[EmployeeDirectory] AS e
			INNER JOIN DirectReports as d  ON e.[Manager] = d.[EmployeeID]
			)

SELECT COUNT(*) as Direct_Reports
FROM DirectReports as d
WHERE d.[EmployeeID] != 2		-- do not include 2 itslef

/*
Direct_Reports
6
*/


/*
Subquery
	Tends to be concise
	Better supported across most database engines  (as has been part of SQL since the beginning)
	Takes up less memory     ( not kept on memory for later use)


CTE
	Tends to be more readable   ( split in CTE's)
	Ability to be referenced multiple times
	Easy to reuse  (as they are kept in memory)

*/