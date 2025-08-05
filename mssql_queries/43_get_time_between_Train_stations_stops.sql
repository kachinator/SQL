-- ########  
DECLARE @jsonSchedule nvarchar(max)


SET @jsonSchedule ='[
		{   "train_id":110,"station":"Lombard","time":"10:00:00"},
		{   "train_id":110,"station":"Elmhust","time":"10:12:00"},
		{   "train_id":110,"station":"Cicero","time":"10:42:00"},
		{   "train_id":110,"station":"Chicago","time":"11:05:00"},
		{   "train_id":120,"station":"Chicago","time":"11:30:00"},
		{   "train_id":120,"station":"Oak Park","time":""},
		{   "train_id":120,"station":"Villa Park","time":"11:59:00"},
		{   "train_id":120,"station":"Wheaton","time":"12:20:00"},
		{   "train_id":120,"station":"Geneva","time":"13:00:00"}]'

--   replace empty entries by NULL
SET @jsonSchedule = REPLACE(@jsonSchedule, '""','null')

DECLARE @Schedule TABLE(
		[train_id] [nvarchar](50) NULL,
		[station] [nvarchar](50) NULL,
		[time] TIME NULL

		)

INSERT INTO @Schedule (
		[train_id],
		[station],
		[time]
		)

SELECT * from openjson(@jsonSchedule)
WITH
(
		[train_id] nvarchar(50) '$.train_id',
		[station] nvarchar(50) '$.station',
		[time] TIME '$.time'		
);

select * from @Schedule;

/*
	train_id	station		time
	----------------------------------------------------------
	110			Lombard		10:00:00.000
	110			Elmhust		10:12:00.000
	110			Cicero		10:42:00.000
	110			Chicago		11:05:00.000
	120			Chicago		11:30:00.000
	120			Oak Park	NULL
	120			Villa Park	11:59:00.000
	120			Wheaton		12:20:00.000
	120			Geneva		13:00:00.000
*/

/*
Subtract the station times for pairs of contiguous stations. 
We can calculate this value without using a SQL window function, but that
can be very complicated. It’s simpler to do it using the `LEAD` window function. 

This function compares values from one row with the next row to come up with
a result.  
In this case, it compares the values in the “time” column for a station with
the station immediately after it.

*/
SELECT 
	train_id, 
	station,
	time as "station_time",
	lead(time) OVER (PARTITION BY train_id ORDER BY time) as lead,
	lag(time) OVER (PARTITION BY train_id ORDER BY time) as lag
FROM @Schedule;	

/*
	train_id	station		station_time	lead		lag
	------------------------------------------------------------
	110			Lombard		10:00:00		10:12:00	NULL
	110			Elmhust		10:12:00		10:42:00	10:00:00
	110			Cicero		10:42:00		11:05:00	10:12:00
	110			Chicago		11:05:00		11:30:00	10:42:00
	120			Chicago		11:30:00		NULL		11:05:00
	120			Oak Park	NULL			11:59:00	NULL
	120			Villa Park	11:59:00		12:20:00	NULL
	120			Wheaton		12:20:00		13:00:00	11:59:00
	120			Geneva		13:00:00		NULL		12:20:00

*/




SELECT 
	train_id, 
	station,
	time as "station_time",
	CONCAT(
		(DATEDIFF(MINUTE, time, lead(time) OVER (PARTITION BY train_id ORDER BY time))/60),':',
		(DATEDIFF(MINUTE, time, lead(time) OVER (PARTITION BY train_id ORDER BY time))%60))
		AS time_to_next_station
FROM @Schedule;


/*

	train_id	station		station_time	time_to_next_station
	------------------------------------------------------------
	110			Lombard		10:00:00		0:12
	110			Elmhust		10:12:00		0:30
	110			Cicero		10:42:00		0:23
	110			Chicago		11:05:00		0:25
	110			Chicago		11:30:00		:
	120			Oak Park	NULL			:
	120			Villa Park	11:59:00		0:21
	120			Wheaton		12:20:00		0:40
	120			Geneva		13:00:00		:

*/
