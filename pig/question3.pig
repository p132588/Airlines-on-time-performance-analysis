flights = LOAD '/home/maria_dev/assignment2/2006.csv' USING PigStorage(',') AS (Year:int,Month:int,DayOfmonth:int,DayOfweek:int,DepTime:int,
    CrsDepTime:int,ArrTime:int,CrsArrtime:int,UniqueCarrier:chararray,FlightNum:int,TailNum:chararray,ActualElapsedTime:int,
    CrsElapsedTime:int,AirTime:int,ArrDelay:int,DepDelay:int,Origin:chararray,Dest:chararray,Distance:int,Taxiln:int,TaxiOut:int,
    Cancelled:int,CancellationCode:chararray,Diverted:int,CarrierDelay:int,WeatherDelay:int,NasDelay:int,SecurityDelay:int,LateAircraftDelay:int);

cancell_reson = FOREACH flights GENERATE Cancelled, CancellationCode;

cancell_reson_data = FILTER cancell_reson BY Cancelled == 1;
cancell_reason_group = GROUP cancell_reson_data by CancellationCode;
cancell_reason_num = FOREACH cancell_reason_group GENERATE group AS CancellationCode, COUNT(cancell_reson_data.Cancelled) AS total;
DUMP cancell_reason_num;