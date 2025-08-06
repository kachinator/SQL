/* 
	Query using mulitple-row subquery.
	"Working hard or hardly working" company wants to know the session name, start date, end date, and rom that their employees 
	will be delivering their presentation. Extract this information
*/
-- preview of data
SELECT TOP(5) * FROM [master].[dbo].[SessionInfo]

/*
StartDate					EndDate					SessionName									SpeakerName			RoomName
-----------------------------------------------------------------------------------------------------------------------------
2024-07-27 17:00:00.000		2024-07-27 18:00:00.000	AI and Education—Developing a Data Strategy	Anna Rossi			102
2024-07-28 10:30:00.000		2024-07-28 12:30:00.000	Managing Virtual Teams						Ashley Hackett		102
2024-07-27 15:00:00.000		2024-07-27 16:00:00.000	Robots on the Farm							Daron Seeley		102
2024-07-28 12:30:00.000		2024-07-28 14:00:00.000	Managing Virtual Teams	A					shley Hackett		102
2024-07-28 14:00:00.000		2024-07-28 15:30:00.000	Let them Eat Cake—or Do not					Kennedy Beckingham	102
*/

SELECT TOP(5) * FROM [master].[dbo].[SpeakerInfo]

/*
SessionName									StartDate				Name			Organization					EndDate					RoomName
----------------------------------------------------------------------------------------------------------------------------------------------------
AI and Education—Developing a Data Strategy	2024-07-27 17:00:00.000	Anna Rossi		Working hard or hardly working	2024-07-27 18:00:00.000		102
Managing Virtual Teams						2024-07-28 10:30:00.000	Ashley Hackett	Working hard or hardly working	2024-07-28 12:30:00.000		102
Robots on the Farm							2024-07-27 15:00:00.000	Daron Seeley	Working hard or hardly working	2024-07-27 16:00:00.000		102
Managing Virtual Teams						2024-07-28 12:30:00.000	Ashley Hackett	Working hard or hardly working	2024-07-28 14:00:00.000		102
Data and Human Needs						2024-07-28 14:00:00.000	Johnathan Kim	Potato Chip						2024-07-28 15:30:00.000		203
*/

SELECT [Name] FROM [master].[dbo].[SpeakerInfo]
						  WHERE [Organization] = 'Working hard or hardly working'
/*
	Name
	------------
	Anna Rossi
	Ashley Hackett
	Daron Seeley
	Ashley Hackett
	Johnathan Kim
	Lionel Messi
	Lionel Messi
*/

SELECT DISTINCT [SpeakerName], [SessionName], [StartDate], [EndDate], [RoomName]
FROM [master].[dbo].[SessionInfo]
WHERE [SpeakerName] in
						( SELECT [Name] FROM [master].[dbo].[SpeakerInfo]
						  WHERE [Organization] = 'Working hard or hardly working')

/*
SpeakerName					SessionName						StartDate				EndDate					RoomName
---------------------------------------------------------------------------------------------------------------------
Anna Rossi		AI and Education—Developing a Data Strategy	2024-07-27 17:00:00.000	2024-07-27 18:00:00.000		102
Ashley Hackett	Managing Virtual Teams						2024-07-28 10:30:00.000	2024-07-28 12:30:00.000		102
Ashley Hackett	Managing Virtual Teams						2024-07-28 12:30:00.000	2024-07-28 14:00:00.000		102
Daron Seeley	Managing Virtual Teams						2024-07-29 10:30:00.000	2024-07-29 12:00:00.000		104
Daron Seeley	Robots on the Farm							2024-07-27 15:00:00.000	2024-07-27 16:00:00.000		102
Johnathan Kim	Data and Human Needs						2024-07-28 16:00:00.000	2024-07-28 17:00:00.000		102
Lionel Messi	Let them Eat Cake—or Do not					2024-07-28 12:00:00.000	2024-07-28 12:30:00.000		103
Lionel Messi	Robots on the Beach							2024-07-28 12:30:00.000	2024-07-28 14:00:00.000		101
*/

-- Using a JOIN

SELECT DISTINCT [SpeakerName], [SessionName], [StartDate], [EndDate], [RoomName]
FROM [master].[dbo].[SessionInfo] AS ses

JOIN ( SELECT [Name] FROM [master].[dbo].[SpeakerInfo]
			 WHERE [Organization] = 'Working hard or hardly working') AS speak
ON  ses.[SpeakerName] = speak.[Name]

/*
SpeakerName					SessionName						StartDate				EndDate					RoomName
---------------------------------------------------------------------------------------------------------------------
Anna Rossi		AI and Education—Developing a Data Strategy	2024-07-27 17:00:00.000	2024-07-27 18:00:00.000		102
Ashley Hackett	Managing Virtual Teams						2024-07-28 10:30:00.000	2024-07-28 12:30:00.000		102
Ashley Hackett	Managing Virtual Teams						2024-07-28 12:30:00.000	2024-07-28 14:00:00.000		102
Daron Seeley	Managing Virtual Teams						2024-07-29 10:30:00.000	2024-07-29 12:00:00.000		104
Daron Seeley	Robots on the Farm							2024-07-27 15:00:00.000	2024-07-27 16:00:00.000		102
Johnathan Kim	Data and Human Needs						2024-07-28 16:00:00.000	2024-07-28 17:00:00.000		102
Lionel Messi	Let them Eat Cake—or Do not					2024-07-28 12:00:00.000	2024-07-28 12:30:00.000		103
Lionel Messi	Robots on the Beach							2024-07-28 12:30:00.000	2024-07-28 14:00:00.000		101
*/


