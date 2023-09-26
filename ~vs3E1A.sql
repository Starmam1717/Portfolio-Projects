SELECT TOP (1000) [year]
      ,[month]
      ,[carrier]
      ,[carrier_name]
      ,[airport]
      ,[airport_name]
      ,[arr_flights]
      ,[arr_del15]
      ,[carrier_ct]
      ,[weather_ct]
      ,[nas_ct]
      ,[security_ct]
      ,[late_aircraft_ct]
      ,[arr_cancelled]
      ,[arr_diverted]
      ,[arr_delay]
      ,[carrier_delay]
      ,[weather_delay]
      ,[nas_delay]
      ,[security_delay]
      ,[late_aircraft_delay]
  FROM [Airport].[dbo].[Airline_Delay_Cause]

select * from airport_sums order by percent_delayed_flights
select * from carrier_sums order by arr_flights desc
select * from Month_sums order by month 
select * from carrier_sums_month order by month  

select * from airport_sums_month order by arr_flights desc






--Setting up Tables and cleaning data for easier EDA and Insights

--------------------------------------------------------------------------
--Creating a table with totals based on airports
select airport, sum(arr_flights) as arr_flights, sum(arr_del15)as arr_del15,sum(carrier_ct) as carrier_ct,sum(weather_ct) as weather_ct,sum(nas_ct) as nas_ct,sum(security_ct) as security_ct ,sum(late_aircraft_ct) as late_aricraft_ct,sum(arr_cancelled) as arr_cancelled, sum(arr_diverted) as arr_diverted,sum(arr_delay) as arr_delay, sum(carrier_delay) as carrier_delay, sum(nas_delay) as nas_delay, sum(security_delay) as security_delay, sum(late_aircraft_delay) as late_aircraft_delay,sum(weather_delay) as weather_delay into Airport_sums from airline_delay_cause 
  group by airport  

--Column for delay total
alter table airport_sums 
add delay_totals float 
update  airport_sums set delay_totals = arr_delay + carrier_delay + nas_delay + security_delay + late_aircraft_delay +weather_delay 

--Column for delay_total over flights
alter table airport_sums add delay_over_flight float
update airport_sums set delay_over_flight = round(delay_totals/arr_flights,2)  

select * from airport_sums order by delay_over_flight desc


 alter table airport_sums add percent_delayed_flights float

update airport_sums set percent_delayed_flights = round(arr_del15/arr_flights*100,2);





alter table airport_sums add total_ct_delay int 
update  airport_sums set total_ct_delay = nas_ct + late_aircraft_delay + carrier_ct + security_ct + weather_ct 

alter table airport_sums add delay_over_ct float 
update Airport_sums set delay_over_ct = round(delay_totals/total_ct_delay,2) where total_ct_delay != 0

alter table airport_sums add weather_delay_over_ct float
update airport_sums set weather_delay_over_ct = round(weather_delay/weather_ct,2) where weather_ct != 0

--updating certian values to round number
update airport_sums set nas_ct = round(nas_ct,0) 
update airport_sums set late_aricraft_ct = round(late_aricraft_ct ,0) 
update airport_sums set carrier_ct = round(carrier_ct,0) 
update airport_sums set security_ct = round(security_ct,0)
update airport_sums set weather_ct = round(weather_ct,0) 

----------------------------------------------------------------------------------------------


--table for carriers and delays 
select carrier_name, sum(arr_flights) as arr_flights, sum(arr_del15)as arr_del15,sum(carrier_ct) as carrier_ct,sum(weather_ct) as weather_ct,sum(nas_ct) as nas_ct,sum(security_ct) as security_ct ,sum(late_aircraft_ct) as late_aricraft_ct,sum(arr_cancelled) as arr_cancelled, sum(arr_diverted) as arr_diverted,sum(arr_delay) as arr_delay, sum(carrier_delay) as carrier_delay, sum(nas_delay) as nas_delay, sum(security_delay) as security_delay, sum(late_aircraft_delay) as late_aircraft_delay, sum(weather_delay) as weather_delay into carrier_sums from airline_delay_cause 
  group by carrier_name   

select * from carrier_sums 

--Column for delay total
alter table carrier_sums 
add delay_totals float 
update  carrier_sums  set delay_totals = arr_delay + carrier_delay + nas_delay + security_delay + late_aircraft_delay +weather_delay 

--Column for delay_total over flights
alter table carrier_sums add delay_over_flight float
update carrier_sums set delay_over_flight = round(delay_totals/arr_flights,2)  

select * from carrier_sums order by arr_flights desc  
 
 
 alter table carrier_sums add percent_delayed_flights float
update carrier_sums set percent_delayed_flights = round(arr_del15/arr_flights*100,2);

alter table carrier_sums add total_delay_ct int 
update carrier_sums set total_delay_ct  = carrier_ct + weather_ct + nas_ct + security_ct + late_aricraft_ct


update carrier_sums set nas_ct = round(nas_ct,0) 
update carrier_sums set late_aricraft_ct = round(late_aricraft_ct ,0) 
update carrier_sums set carrier_ct = round(carrier_ct,0) 
update carrier_sums set security_ct = round(security_ct,0)
update carrier_sums set weather_ct = round(weather_ct,0) 



------------------------------------------------------------------------------------------------------------------- 
----By month
select month, sum(arr_flights) as arr_flights, sum(arr_del15)as arr_del15,sum(carrier_ct) as carrier_ct,sum(weather_ct) as weather_ct,sum(nas_ct) as nas_ct,sum(security_ct) as security_ct ,sum(late_aircraft_ct) as late_aricraft_ct,sum(arr_cancelled) as arr_cancelled, sum(arr_diverted) as arr_diverted,sum(arr_delay) as arr_delay, sum(carrier_delay) as carrier_delay, sum(nas_delay) as nas_delay, sum(security_delay) as security_delay, sum(late_aircraft_delay) as late_aircraft_delay,sum(weather_delay) as weather_delay into Month_sums from airline_delay_cause 
  group by month 
 
 select * from Month_sums order by month 

 alter table month_sums add delay_totals float
update month_sums set delay_totals = arr_delay + carrier_delay + nas_delay + security_delay + late_aircraft_delay  +weather_delay 

 alter table month_sums add delay_over_flight float 
update month_sums set delay_over_flight = round(delay_totals/arr_flights,2) 

 
 
 alter table month_sums add percent_delayed_flights float
 update month_sums set percent_delayed_flights = round(arr_del15/arr_flights*100,2);

update Month_sums set late_aricraft_ct = round(late_aricraft_ct ,0) 
update Month_sums set carrier_ct = round(carrier_ct,0) 
update Month_sums set security_ct = round(security_ct,0)
update Month_sums set weather_ct = round(weather_ct,0) 
 
 





 ---------------------------------------------------------------------------------------------------------------------

 select carrier_name,month, sum(arr_flights) as arr_flights, sum(arr_del15)as arr_del15,sum(carrier_ct) as carrier_ct,sum(weather_ct) as weather_ct,sum(nas_ct) as nas_ct,sum(security_ct) as security_ct ,sum(late_aircraft_ct) as late_aricraft_ct,sum(arr_cancelled) as arr_cancelled, sum(arr_diverted) as arr_diverted,sum(arr_delay) as arr_delay, sum(carrier_delay) as carrier_delay, sum(nas_delay) as nas_delay, sum(security_delay) as security_delay, sum(late_aircraft_delay) as late_aircraft_delay,sum(weather_delay) as weather_delay into carrier_sums_month from airline_delay_cause 
  group by carrier_name, month  


  select * from carrier_sums_month order by month   


   alter table carrier_sums_month  add delay_totals float
 update carrier_sums_month  set delay_totals = arr_delay + carrier_delay + nas_delay + security_delay + late_aircraft_delay  

 
 alter table carrier_sums_month  add delay_over_flight float 
 update carrier_sums_month  set delay_over_flight = round(delay_totals/arr_flights,2) 

 
 
 alter table carrier_sums_month  add percent_delayed_flights float; 
 update carrier_sums_month set percent_delayed_flights = round(arr_del15/arr_flights*100,2);


  
  
   
update carrier_sums_month set nas_ct = round(nas_ct,0) 
update carrier_sums_month set late_aricraft_ct = round(late_aricraft_ct ,0) 
update carrier_sums_month set carrier_ct = round(carrier_ct,0) 
update carrier_sums_month set security_ct = round(security_ct,0)
update carrier_sums_month set weather_ct = round(weather_ct,0)
  
  
  
  

  
  
  
  
  
  
  ---------------------------------------------------------------------------------------------------------------------  

select airport,month, sum(arr_flights) as arr_flights, sum(arr_del15)as arr_del15,sum(carrier_ct) as carrier_ct,sum(weather_ct) as weather_ct,sum(nas_ct) as nas_ct,sum(security_ct) as security_ct ,sum(late_aircraft_ct) as late_aricraft_ct,sum(arr_cancelled) as arr_cancelled, sum(arr_diverted) as arr_diverted,sum(arr_delay) as arr_delay, sum(carrier_delay) as carrier_delay, sum(nas_delay) as nas_delay, sum(security_delay) as security_delay, sum(late_aircraft_delay) as late_aircraft_delay,sum(weather_delay) as weather_delay into airport_sums_month from airline_delay_cause 
group by airport, month

select * from airport_sums_month order by delay_over_flight desc

 
 alter table airport_sums_month  add delay_totals float
 update airport_sums_month  set delay_totals = arr_delay + carrier_delay + nas_delay + security_delay + late_aircraft_delay  

 
 alter table airport_sums_month  add delay_over_flight float 
 update airport_sums_month  set delay_over_flight = round(delay_totals/arr_flights,2) 

 
 
 alter table airport_sums_month add percent_delayed_flights float; 
 update airport_sums_month set percent_delayed_flights = round(arr_del15/arr_flights*100,2); 



    
update airport_sums_month set nas_ct = round(nas_ct,0) 
update airport_sums_month set late_aricraft_ct = round(late_aricraft_ct ,0) 
update airport_sums_month set carrier_ct = round(carrier_ct,0) 
update airport_sums_month set security_ct = round(security_ct,0)
update airport_sums_month set weather_ct = round(weather_ct,0) 

alter table airport_sums_month add total_ct_delay int 
update  airport_sums_month set total_ct_delay = nas_ct + late_aircraft_delay + carrier_ct + security_ct + weather_ct


----------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------- 
--Analysis of Data 
-----------------------------------------------------------------------------------------------------------------------------

select * from airport_sums
--Busiest airports in descending order

select airport, arr_flights from airport_sums order by arr_flights desc
--Flight amounts
select	
	count( case when arr_flights > 50000 then 1 end) as 'Airports with flights >50k',
	count(case when arr_flights between 30000 and 50000 then 1 end) as 'Airports with flights  30k to 50k' ,
	count( case when arr_flights between 15000 and 30000 then 1 end) as 'Airports with flights 15k to 30k',
	count( case when arr_flights < 15000 then 1 end) as 'Airports with flights < 15k'  
	
	from airport_sums


--Airports with the most delays in descending order
select airport, total_ct_delay from Airport_sums order by total_ct_delay desc 

--Airports with most delay time in descending order
select airport, delay_totals from Airport_sums order by delay_totals desc 

--(Delay time)/(arrival flights) for airports over 20k flights
select airport, delay_over_flight from airport_sums where arr_flights >= 20000 order by delay_over_flight desc 

--(delay time)/(delays) for airports with over 20k flights
select airport, delay_over_ct from airport_sums where arr_flights >= 20000 order by delay_over_ct desc

--Percentage of delayed flights with airports over 20k flights
select airport, percent_delayed_flights from airport_sums where arr_flights >= 20000 order by percent_delayed_flights desc 

--airports with most weather delays 
select airport, weather_ct, weather_delay, weather_delay_over_ct from airport_sums order by weather_ct desc 

--airports with over 20k flights in order (weather delay time)/(weather delay) desc
select airport, weather_ct, weather_delay, weather_delay_over_ct from airport_sums where arr_flights >= 20000 order by weather_delay_over_ct desc 

--Airports with most late aircraft delays 
select airport, late_aricraft_ct, late_aircraft_delay from airport_sums order by late_aricraft_ct desc 

--Airports with over 20k flights in order of (late aircraft delay time)/(late aircraft delay) 

select airport, late_aricraft_ct, late_aircraft_delay, round(late_aircraft_delay/late_aricraft_ct,2) as late_delay_over_ct  from airport_sums where arr_flights >= 20000 order by late_delay_over_ct desc 

-------------------------------------------------------------------------------------------------------------------------------------------------------------- 
select * from carrier_sums 

--Carriers with most delays 
select carrier_name, total_delay_ct from carrier_sums order by total_delay_ct desc 
--Carriers with most delay times  
select carrier_name, delay_totals from carrier_sums order by delay_totals desc  
--Carriers by percentage of delayed flights 
select carrier_name, percent_delayed_flights from carrier_sums order by percent_delayed_flights desc
--Carriers by (delay time)/(delays) 
select carrier_name, delay_over_flight from carrier_sums order by delay_over_flight desc

--Carriers with most delays in their control
select carrier_name, carrier_ct, carrier_delay, round(carrier_delay/carrier_ct,2) as delay_over_ct from carrier_sums order by delay_over_ct desc


--Carriers with most late aircraft delays in desc order of (late aircraft delay time)/(late aircrafts)

select carrier_name, late_aricraft_ct, late_aircraft_delay, round(late_aircraft_delay/late_aricraft_ct,2) as delay_over_ct from carrier_sums order by delay_over_ct desc 

