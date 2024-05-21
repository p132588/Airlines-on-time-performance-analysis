flights = LOAD '/home/maria_dev/assignment2/2006.csv' USING PigStorage(',') AS (Year:int,Month:int,DayOfmonth:int,DayOfweek:int,DepTime:int,
    CrsDepTime:int,ArrTime:int,CrsArrtime:int,UniqueCarrier:chararray,FlightNum:int,TailNum:chararray,ActualElapsedTime:int,
    CrsElapsedTime:int,AirTime:int,ArrDelay:int,DepDelay:int,Origin:chararray,Dest:chararray,Distance:int,Taxiln:int,TaxiOut:int,
    Cancelled:int,CancellationCode:int,Diverted:int,CarrierDelay:int,WeatherDelay:int,NasDelay:int,SecurityDelay:int,LateAircraftDelay:int);

-- Analyze delays caused by weather
Weather_reason = FOREACH flights GENERATE WeatherDelay, (CASE WHEN ArrDelay IS NULL THEN 0 ELSE ArrDelay END) AS arrdelay;

-- Filter out data whose arrival delay time is less than or equal to 0
Weather_reason_data = FILTER Weather_reason BY arrdelay>0;

-- Group
Weather_data = GROUP Weather_reason_data ALL;

-- Calculate average weather delays
delay_Weather_data = FOREACH Weather_data GENERATE AVG(Weather_reason_data.WeatherDelay) AS total;

DUMP delay_Weather_data;


-- Carrier delay
delay_Carrier_reason = FOREACH flights GENERATE CarrierDelay, (CASE WHEN ArrDelay IS NULL THEN 0 ELSE ArrDelay END) AS arrdelay;
delay_Carrier_data = FILTER delay_Carrier_reason BY arrdelay>0;
Carrier_data = GROUP delay_Carrier_data ALL;
-- Calculate average carrier delay time
delay_CarrierDelay = FOREACH Carrier_data GENERATE AVG(delay_Carrier_data.CarrierDelay) AS total;
DUMP delay_CarrierDelay;

-- NasDelay
delay_NasDelay_reason = FOREACH flights GENERATE NasDelay, (CASE WHEN ArrDelay IS NULL THEN 0 ELSE ArrDelay END) AS arrdelay;
delay_NasDelay_data = FILTER delay_NasDelay_reason BY arrdelay>0;
NasDelay_data = GROUP delay_NasDelay_data ALL;

-- Calculate average NasDelay delay time
delay_NasDelay = FOREACH NasDelay_data GENERATE AVG(delay_NasDelay_data.NasDelay) AS total;
DUMP delay_NasDelay;

-- SecurityDelay
delay_SecurityDelay_reason = FOREACH flights GENERATE SecurityDelay, (CASE WHEN ArrDelay IS NULL THEN 0 ELSE ArrDelay END) AS arrdelay;
delay_SecurityDelay_data = FILTER delay_SecurityDelay_reason BY arrdelay>0;
SecurityDelay_data = GROUP delay_SecurityDelay_data ALL;

-- SecurityDelay delay time
delay_SecurityDelay = FOREACH SecurityDelay_data GENERATE AVG(delay_SecurityDelay_data.SecurityDelay) AS total;
DUMP delay_SecurityDelay;

-- LateAircraftDelay
delay_LateAircraftDelay_reason = FOREACH flights GENERATE LateAircraftDelay, (CASE WHEN ArrDelay IS NULL THEN 0 ELSE ArrDelay END) AS arrdelay;
delay_LateAircraftDelay_data = FILTER delay_LateAircraftDelay_reason BY arrdelay>0;
LateAircraftDelay_data = GROUP delay_LateAircraftDelay_data ALL;

-- Calculate the average LateAircraftDelay time
delay_LateAircraftDelay = FOREACH LateAircraftDelay_data GENERATE AVG(delay_LateAircraftDelay_data.LateAircraftDelay) AS total;
DUMP delay_LateAircraftDelay;
