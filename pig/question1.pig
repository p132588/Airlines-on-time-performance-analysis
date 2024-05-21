flights = LOAD '/home/maria_dev/assignment2/2006.csv' USING PigStorage(',') AS (Year:int,Month:int,DayOfmonth:int,DayOfweek:int,DepTime:int,
    CrsDepTime:int,ArrTime:int,CrsArrtime:int,UniqueCarrier:chararray,FlightNum:int,TailNum:chararray,ActualElapsedTime:int,
    CrsElapsedTime:int,AirTime:int,ArrDelay:int,DepDelay:int,Origin:chararray,Dest:chararray,Distance:int,Taxiln:int,TaxiOut:int,
    Cancelled:int,CancellationCode:chararray,Diverted:int,CarrierDelay:int,WeatherDelay:int,NasDelay:int,SecurityDelay:int,LateAircraftDelay:int);
--Extract the information required for the first question
flights_delay = FOREACH flights GENERATE Month, DayOfmonth, DayOfweek, 
    (CASE
        WHEN Month IN (12,1,2) THEN 'Winter'
        WHEN Month IN (3,4,5) THEN 'Spring'
        WHEN Month IN (6,7,8) THEN 'Summer'
        WHEN Month IN (9,10,11) THEN 'Autumn'
    END) AS season,
    (CASE
        WHEN ArrDelay IS NULL THEN 0 ELSE ArrDelay
    END) AS arrdelay;
--Calculate average flight delays for each season
season_group = GROUP flights_delay BY season;
average_delays = FOREACH season_group GENERATE group AS season,
    AVG(flights_delay.arrdelay) AS average_delay;

--Calculate the total number of flights per season
season_all = FOREACH season_group GENERATE group AS season, COUNT(flights_delay.arrdelay) AS total;

-- Calculate the number of delayed flights
season_delayed_flights = FILTER flights_delay BY arrdelay > 0;
season_group_delayed = GROUP season_delayed_flights BY season;
delayed_flights_count = FOREACH season_group_delayed GENERATE group AS season, COUNT(season_delayed_flights) AS delayed_flights_number;

--Combine two tables
delayed_flights_ratio = JOIN season_all BY season, delayed_flights_count BY season;
delayed_flights_percentage = FOREACH delayed_flights_ratio GENERATE season_all::season AS season, 
    ((float)delayed_flights_count::delayed_flights_number / (float)season_all::total) * 100 AS delay_percentage;
DUMP average_delays_hour_sorted;

--Calculate average flight delays per month
month_group = GROUP flights_delay BY Month;
average_delays_month = FOREACH month_group GENERATE group AS Month,
    AVG(flights_delay.arrdelay) AS average_delay;

--Calculate the total number of flights per month
month_all = FOREACH month_group GENERATE group AS month, COUNT(flights_delay.arrdelay) AS total;
-- Calculate the number of delayed flights
month_delayed_flights = FILTER flights_delay BY arrdelay > 0;
month_group_delayed = GROUP month_delayed_flights BY Month;
delayed_month_count = FOREACH month_group_delayed GENERATE group AS month, COUNT(month_delayed_flights) AS delayed_flights_number;

delayed_month_ratio = JOIN month_all BY month, delayed_month_count BY month;
delayed_month_percentage = FOREACH delayed_month_ratio GENERATE month_all::month AS month, 
    ((float)delayed_month_count::delayed_flights_number / (float)month_all::total) * 100 AS delay_percentage;


--day of the week
day_group = GROUP flights_delay BY DayOfweek;
average_delays_day = FOREACH day_group GENERATE group AS DayOfweek,
    AVG(flights_delay.arrdelay) AS average_delay;

day_all = FOREACH day_group GENERATE group AS DayOfweek, COUNT(flights_delay.arrdelay) AS total;

day_delayed_flights = FILTER flights_delay BY arrdelay > 0;
day_group_delayed = GROUP day_delayed_flights BY DayOfweek;
delayed_day_count = FOREACH day_group_delayed GENERATE group AS DayOfweek, COUNT(day_delayed_flights) AS delayed_flights_number;

delayed_day_ratio = JOIN day_all BY DayOfweek, delayed_day_count BY DayOfweek;
delayed_day_percentage = FOREACH delayed_day_ratio GENERATE day_all::DayOfweek AS day, 
    ((float)delayed_day_count::delayed_flights_number / (float)day_all::total) * 100 AS delay_percentage;
    
--Calculate the time of day
--Extract hour part
flights_hour = FOREACH flights GENERATE (CrsDepTime / 100) AS hour, ArrDelay;
flights_hour_delay = FILTER flights_hour BY ArrDelay > 0;
hour_group = GROUP flights_hour_delay BY hour;

-- Calculate average delay time per hour
average_delays_hour = FOREACH hour_group GENERATE group AS hour, AVG(flights_hour_delay.ArrDelay) AS average_delay;

-- Sort by average delay time
average_delays_hour_sorted = ORDER average_delays_hour BY average_delay;

DUMP average_delays_hour_sorted;






