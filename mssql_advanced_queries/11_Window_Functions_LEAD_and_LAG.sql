/*
	Window Functions  LAG() and LEAD()

		LEAD() function is used to retrieve data from the  NEXT ROW

		LAG()  is used to retrieve data from the  PREVIOUS ROW

		Often used to answer  " What's next ?"  or "Waht happened last time ?"

*/

/*
	Example of a query using LAG() and LEAD() 

	Write a query using LAG() and LEAD() to show the Session ANme and Start Time ofthe previousSession conducted in Room 102
	as well as what the next session will be
*/


-- preview

SELECT TOP (6) * FROM [master].[dbo].[SessionInfo]
WHERE [RoomName] = 102
ORDER BY [StartDate] ASC

/*

Start Date					End Date					SessionName									SpeakerName			RoomName	
--------------------------------------------------------------------------------------------------------------------------------																																																																																		Session Track			Industry	Speaker Name									Room Name
2024-07-27 15:00:00.000		2024-07-27 16:00:00.000		Robots on the Farm							Daron Seeley		102
2024-07-27 17:00:00.000		2024-07-27 18:00:00.000		AI and Education—Developing a Data Strategy	Anna Rossi			102
2024-07-28 10:30:00.000		2024-07-28 12:30:00.000		Managing Virtual Teams						Ashley Hackett		102
2024-07-28 12:30:00.000		2024-07-28 14:00:00.000		Managing Virtual Teams						Ashley Hackett		102
2024-07-28 14:00:00.000		2024-07-28 15:30:00.000		Let them Eat Cake—or Do not					Kennedy Beckingham	102
2024-07-28 16:00:00.000		2024-07-28 17:00:00.000		Data and Human Needs						Johnathan Kim		102
*/

-- Use LAG() and LEAD to get the Session Name and Start Time of the previous and next session


SELECT [StartDate],[EndDate],[SessionName],
-- default for LAG and LEAD is 1
-- Because we want to choose the next or last session with respect to the start date, we want to order by start date in ascending order
LAG([SessionName], 1) OVER (ORDER BY [StartDate] ASC) AS PreviousSession,
-- use LAG to get the session immediately preceeding this one
LAG([StartDate], 1) OVER (ORDER BY [StartDate] ASC) AS PreviousSessionStartTime,

LEAD([SessionName], 1) OVER (ORDER BY [StartDate] ASC) AS NextSession,
LEAD([StartDate], 1) OVER (ORDER BY [StartDate] ASC) AS NextSessionStartTime

FROM [master].[dbo].[SessionInfo]
WHERE [RoomName] = 102


/*

Start Date					End Date					Session Name									PreviousSession								PreviousSessionStartTime	NextSession									NextSessionStartTime
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2024-07-27 15:00:00.000		2024-07-27 16:00:00.000		Robots on the Farm								NULL										NULL						AI and Education—Developing a Data Strategy	2024-07-27 17:00:00.000
2024-07-27 17:00:00.000		2024-07-27 18:00:00.000		AI and Education—Developing a Data Strategy		Robots on the Farm							2024-07-27 15:00:00.000		Managing Virtual Teams						2024-07-28 10:30:00.000
2024-07-28 10:30:00.000		2024-07-28 12:30:00.000		Managing Virtual Teams							AI and Education—Developing a Data Strategy	2024-07-27 17:00:00.000		Managing Virtual Teams						2024-07-28 12:30:00.000
2024-07-28 12:30:00.000		2024-07-28 14:00:00.000		Managing Virtual Teams							Managing Virtual Teams						2024-07-28 10:30:00.000		Let them Eat Cake—or Do not					2024-07-28 14:00:00.000
2024-07-28 14:00:00.000		2024-07-28 15:30:00.000		Let them Eat Cake—or Do not						Managing Virtual Teams						2024-07-28 12:30:00.000		Data and Human Needs						2024-07-28 16:00:00.000
2024-07-28 16:00:00.000		2024-07-28 17:00:00.000		Data and Human Needs							Let them Eat Cake—or Do not					2024-07-28 14:00:00.000		NULL										NULL
*/