--1)

CREATE TABLE Types(
Tid int Primary key,
Tname varchar(50),
Tdescription varchar(200)
)


CREATE TABLE Trains(
Trid int Primary key,
TName varchar(50),
Tid int References Types(Tid),
)


Create Table Stations(
Sid int Primary key,
Sname varchar(50) Unique
)

DROP TABLE Route

Create Table Route(
Rid int Primary key,
Rname varchar(50) Unique,
Trid int  References Trains(Trid),
)

DROP TABLE RouteStation

Create Table RouteStation
(
Rid int References Route(Rid),
Sid int References Stations(Sid),
PRimary key(Rid,Sid),
ArrivalTime Time,
DepartureTime Time

)



INSERT INTO Types(Tid,Tname,Tdescription)
Values(1,'A','A')

INSERT INTO Trains(Trid,TName,Tid)
Values(2,'Ceaw',1)

INSERT INTO Route(Rid,Rname,Trid)
Values (2,'Name2',1)

--2)

ALTER PROCEDURE addRouteStation(@rid INT, @sid Int,@Arrival Time,@Departure Time)
AS

IF @rid not in(SELECT R.Rid FROM Route R)
BEGIN
	RAISERROR ('Rid is not in the Route Table',11,1)

END
ELSE
	BEGIN

	IF @sid not in(SELECT S.Sid FROM Stations S)
	BEGIN
		RAISERROR ('Sid is not in the Stations Table',11,1)

	END
	ELSE
		BEGIN
		IF EXISTS(SELECT * FROM RouteStation WHERE Rid=@rid and Sid=@sid)
			BEGIN
			UPDATE RouteStation
			SET ArrivalTime=@Arrival, DepartureTime=@Departure
			WHERE Rid=@rid and Sid=@sid
			END
		ELSE
			BEGIN
			
		

			INSERT INTO  RouteStation(Rid,Sid,ArrivalTime,DepartureTime)
			Values(@rid,@sid,@Arrival,@Departure)

						
		
			END
	
		END
END
GO


EXEC addRouteStation 3,3,'17:35','19:20'

--3)

ALTER VIEW AllStations AS
SELECT Rname
FROM Route
WHERE Rid IN
(	
SELECT R.Rid
FROM Route R LEFT JOIN RouteStation RS ON R.Rid=Rs.Rid
GROUP BY R.Rid
HAVING COUNT(Sid)=(SELECT COUNT(Sid) FRom Stations)
)


SELECT * FROM AllStations

--4)

Alter FUNCTION AllROutes(@R INT)
RETURNS TABLE
AS
 RETURN
 SELECT Sname
FROM Stations
WHERE Sid IN
(	
SELECT S.Sid
FROM Stations S LEFT JOIN RouteStation RS ON S.Sid=Rs.Sid
GROUP BY S.Sid
HAVING COUNT(Rid)>@R
)
GO


SELECT *
FROM AllROutes(3)


--ext)
INSERT INTO Route(Rid,Rname,Trid)
VALUES(3,'Vosi',1)

INSERT INTO Stations(Sid,Sname)
VALUES (3,'Station 3')

SELECT * FROM Trains
SELECT * FROM Route
SELECT * FROM Stations
SELECT * FROM RouteStation


