/*  --- generate series -----------*/


/*
The GENERATE_SERIES function takes three arguments:

Start: this is the first numerical value of the interval. It can be any expression that results in a numeric data type.
Stop: this is the last value of the interval.
Step: this optional parameter indicates the number of values to increment (or decrement).
	  The default is 1 is start < stop, and -1 if start > stop.

The output of the function is a result set with one single column named value, which contains all the numeric 
values of the interval defined by the three parameters.
*/
SELECT * FROM GENERATE_SERIES(1,10) as t1
/*
value
1
2
3
4
5
6
7
8
9
10
*/

SELECT DATEADD(MONTH,value,'2025-06-27') AS  MONTHS
FROM GENERATE_SERIES(0,5,1);

/*
MONTHS
2023-09-01 00:00:00.000
2023-10-01 00:00:00.000
2023-11-01 00:00:00.000
2023-12-01 00:00:00.000
2024-01-01 00:00:00.000
2024-02-01 00:00:00.000
*/
SELECT DATEADD(WEEK,value,'2025-06-27') AS  WEEKS
FROM GENERATE_SERIES(0,5,1);

/*
WEEKS
2023-09-01 00:00:00.000
2023-09-08 00:00:00.000
2023-09-15 00:00:00.000
2023-09-22 00:00:00.000
2023-09-29 00:00:00.000
2023-10-06 00:00:00.000
*/

SELECT DATEADD(DAY,value,'2025-06-27') AS  DATES
FROM GENERATE_SERIES(0,5,1);

/*
DATES
2023-09-01 00:00:00.000
2023-09-02 00:00:00.000
2023-09-03 00:00:00.000
2023-09-04 00:00:00.000
2023-09-05 00:00:00.000
*/

SELECT DATEADD(HOUR,value,'2025-06-27 00:00') AS  HOURS
FROM GENERATE_SERIES(0,5,1);

/*
HOURS
2023-09-01 00:00:00.000
2023-09-01 01:00:00.000
2023-09-01 02:00:00.000
2023-09-01 03:00:00.000
2023-09-01 04:00:00.000
2023-09-01 05:00:00.000
*/

SELECT DATEADD(MINUTE,value,'2025-06-27 00:00') AS  MINUTES
FROM GENERATE_SERIES(0,5,1);

/*
MINUTES
2023-09-01 00:00:00.000
2023-09-01 00:01:00.000
2023-09-01 00:02:00.000
2023-09-01 00:03:00.000
2023-09-01 00:04:00.000
2023-09-01 00:05:00.000
*/

SELECT DATEADD(SECOND,value,'2025-06-27 00:00') AS  SECONDS
FROM GENERATE_SERIES(0,5,1);

/*
SECONDS
2023-09-01 00:00:00.000
2023-09-01 00:00:01.000
2023-09-01 00:00:02.000
2023-09-01 00:00:03.000
2023-09-01 00:00:04.000
2023-09-01 00:00:05.000
*/


SELECT DATEADD(MILLISECOND,value,'2025-06-27 00:00:00.000') AS  HUNDREDTH_SEC
FROM GENERATE_SERIES(0,50,10);

/*
HUNDREDTH_SEC
2023-09-01 00:00:00.000
2023-09-01 00:00:00.010
2023-09-01 00:00:00.020
2023-09-01 00:00:00.030
2023-09-01 00:00:00.040
2023-09-01 00:00:00.050
*/



/*-----------  cartesian product ---------------*/

SELECT * FROM   ( SELECT * FROM GENERATE_SERIES(1,3)) as t1,
				( SELECT * FROM GENERATE_SERIES(1,4)) as t2

/*
value	value
	1	1
	1	2
	1	3
	1	4
	2	1
	2	2
	2	3
	2	4
	3	1
	3	2
	3	3
	3	4
*/

SELECT * FROM   ( SELECT * FROM GENERATE_SERIES(1,3)) as t1,
				( SELECT DATEADD(MINUTE,value,'2025-06-27 00:00') AS MINS FROM GENERATE_SERIES(0,4,1) ) AS t2;

/*
value	MINS
	1	2023-09-01 00:00:00.000
	1	2023-09-01 00:01:00.000
	1	2023-09-01 00:02:00.000
	1	2023-09-01 00:03:00.000
	1	2023-09-01 00:04:00.000
	2	2023-09-01 00:00:00.000
	2	2023-09-01 00:01:00.000
	2	2023-09-01 00:02:00.000
	2	2023-09-01 00:03:00.000
	2	2023-09-01 00:04:00.000
	3	2023-09-01 00:00:00.000
	3	2023-09-01 00:01:00.000
	3	2023-09-01 00:02:00.000
	3	2023-09-01 00:03:00.000
	3	2023-09-01 00:04:00.000
*/


/*--------------- generate time series ------------*/
-- CRYPT_GEN_RANDOM(N) generate a random number of N bytes, here is 16 bytes

with sensors_datetimes AS (
		SELECT * 
		FROM	( SELECT * FROM GENERATE_SERIES(1,3)) as t1,
				( SELECT DATEADD(MINUTE,value,'2025-06-27 00:00') AS MINS FROM GENERATE_SERIES(0,4,1) ) AS t2
)
SELECT  sd.value AS IoT_DEVICE, sd.MINS
		--,floor(rand()*30) as temperature
		--,floor(rand()*80) as humidity
		,FLOOR(CONVERT(INT, CRYPT_GEN_RANDOM(2))*30/64535.0) as temperature
		,FLOOR(CONVERT(INT, CRYPT_GEN_RANDOM(2))*80/64535.0) as humidity

		FROM sensors_datetimes AS sd;

/*

IoT_DEVICE	MINS						temperature	humidity
	1		2023-09-01 00:00:00.000		0			5
	1		2023-09-01 00:01:00.000		8			21
	1		2023-09-01 00:02:00.000		18			78
	1		2023-09-01 00:03:00.000		3			24
	1		2023-09-01 00:04:00.000		16			11
	2		2023-09-01 00:00:00.000		28			6
	2		2023-09-01 00:01:00.000		29			56
	2		2023-09-01 00:02:00.000		4			35
	2		2023-09-01 00:03:00.000		14			28
	2		2023-09-01 00:04:00.000		13			23
	3		2023-09-01 00:00:00.000		17			36
	3		2023-09-01 00:01:00.000		2			48
	3		2023-09-01 00:02:00.000		3			74
	3		2023-09-01 00:03:00.000		29			56
	3		2023-09-01 00:04:00.000		24			68

*/


WITH sensor_ids AS (
		SELECT value as i from GENERATE_SERIES(1,5) AS i
		)

SELECT i AS id, CONCAT_WS('_','Sensor',TRIM(STR(i))) AS sensor_name
FROM sensor_ids

/*
id	sensor_name
1	Sensor_1
2	Sensor_2
3	Sensor_3
4	Sensor_4
5	Sensor_5
*/


