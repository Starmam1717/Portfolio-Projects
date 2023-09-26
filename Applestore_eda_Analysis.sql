create table applestore_description_combined as 
SELECT * from appleStore_description1
UNION all 
select * from appleStore_description2 
union all 
select * from appleStore_description3
union all  
select * from appleStore_description4 
----------------------------------------------------------------
--EDA --------------

--Checking Number of unique apps in both tables 

select count(DISTINCT id) as uniqueappIds 
FROM AppleStore 

select count(DISTINCT id) as uniqueappIds 
FROM applestore_description_combined 

--Checking for missing values 
SELECT count(*) as NullValues 
from Applestore where track_name is null or prime_genre is null  

SELECT count(*) as NullValues 
from applestore_description_combined where app_desc is null  

--Number of apps per genere 

SELECT prime_genre, count(*) as NumApps 
from AppleStore 
Group by prime_genre order by NumApps desc

--Overview of Apps ratings AppleStore 

SELECT min(user_rating) as Minrating,
	   Max(user_rating) as Maxrating, 
       avg(user_rating) as AvgRating
       from applestore 
       
--Prices of Apps 
SELECT min(price) as Minprice,
	   Max(price) as maxprice, 
       avg(price) as AvgPrice 
       from applestore  

SELECT
	count(case when price = 0 then 1 end) as 'Free', 
    count(case when price = 0.99 then 1 end) as '99 cents',
    count(case when price = 1.99 then 1 end) as '$1.99 apps', 
    count(case when price BETWEEN 2 and 5 then 1 end) as '$2 to $5 apps',
    count(case when price >5 then 1 end) as '$5+'
    from AppleStore 
--Overveiw of App sizes 

SELECT min(size_bytes) as Minsize,
	   max(size_bytes) as Maxsize,
       avg(size_bytes) as AvgSize
       from applestore_description_combined 
       
-----------------------------------------------------
--Data Analysis--- 

--Finding out if paid apps have higher rating then free apps 
SELECT case 
	when price >0 Then 'paid'
    Else 'free'
    end as App_type,
    avg(user_rating) as Avg_Rating
    from applestore group by app_type 
--Checking correlation of price range of apps  

SELECT case 
	when price = 0.99 then '99cents' 
    when price = 1.99 then '$1.99' 
   	when price BETWEEN 2 and 5 then '$2 to $5' 
    when price >5 then '$5+' 
    else 'free' 
    end as App_price, 
    avg(user_rating) as avg_rating 
    from AppleStore group by app_price


--Checking if apps with more supported languages have higher ratings 
SELECT case 
	when lang_num BETWEEN 1 and 5 then '1 to 5 languages' 
    when lang_num between 6 and 10 then '6 to 10 languages' 
    when lang_num between 11 and 30 then '11 to 30 languages' 
    else '>30 languages' 
    end as language_bucket, 
    avg(user_rating) as avg_rating
    from AppleStore group by language_bucket 
    order by avg_rating desc 
    
--Genres with low ratings 

SELECT prime_genre, 
	   avg(user_rating) as avg_rating
       from applestore 
       group by prime_genre
       order by avg_rating asc 
       limit 10 
       
--Length of description and rating correlation  
select case 
		when length(b.app_desc) < 500 then 'Short'
        when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
        else 'Long' 
        end as description_length_bucket, 
        avg(A.user_rating) as avg_rating 
from AppleStore as A
join applestore_description_combined as b on A.id = b.id 
group by description_length_bucket 
order by avg_rating 

--Top rated apps for each genere 
SELECT 
	prime_genre,
    track_name,
    user_rating
from ( SELECT 
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank 
      from 
      applestore 
      ) as a 
      where a.rank = 1

