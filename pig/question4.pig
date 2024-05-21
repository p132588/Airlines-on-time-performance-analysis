flights = LOAD '/home/maria_dev/assignment2/2006.csv' USING PigStorage(',') AS (Year:int,Month:int,DayOfmonth:int,DayOfweek:int,DepTime:int,
    CrsDepTime:int,ArrTime:int,CrsArrtime:int,UniqueCarrier:chararray,FlightNum:chararray,TailNum:chararray,ActualElapsedTime:int,
    CrsElapsedTime:int,AirTime:int,ArrDelay:int,DepDelay:int,Origin:chararray,Dest:chararray,Distance:int,Taxiln:int,TaxiOut:int,
    Cancelled:int,CancellationCode:chararray,Diverted:int,CarrierDelay:int,WeatherDelay:int,NasDelay:int,SecurityDelay:int,LateAircraftDelay:int);

flight_num = FOREACH flights GENERATE FlightNum, ArrDelay, Cancelled;


--Filter out canceled flights

cancelled_flights = FILTER flight_num BY Cancelled != 0;

--Filter out flights with arrival delays
delayed_flights = FILTER flight_num BY ArrDelay > 0;

grouped_cancelled = GROUP cancelled_flights BY FlightNum;
count_cancelled = FOREACH grouped_cancelled GENERATE group AS FlightNum, COUNT(cancelled_flights) AS CancelledCount;

--Sort by number of cancellations
most_count_cancelled = ORDER count_cancelled BY CancelledCount DESC;

--DUMP most_count_cancelled;

--Group and count delayed flights
grouped_delayed = GROUP delayed_flights BY FlightNum;
count_delayed = FOREACH grouped_delayed GENERATE group AS FlightNum, COUNT(delayed_flights) AS delayedCount;
most_count_delayed = ORDER count_delayed BY delayedCount DESC;

DUMP most_count_delayed;
