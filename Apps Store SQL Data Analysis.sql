-- Apps Store SQL Project 

-- Import Data 

CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

-- Exploratory Data Analysis 

-- Check the number of unique apps in both tables 

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined

-- Check for any missing values in key fields 

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null or user_rating IS null OR prime_genre is NULL

SELECT COUNT(*) AS Missingvalues
FROM applestore_description_combined
WHERE app_desc is null

-- Find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- Get an overview of the apps' ratings

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS MaxRating, 
       avg(user_rating) AS AvgRating
FROM AppleStore

-- Get an overview of the apps' Price

SELECT min(price) As MinCost,
       max(price) As MaxCost,
       avg(price) As AvgCost
FROM AppleStore

-- Calculate how much memory the apps will take up on your device

SELECT min(size_bytes) As MinByte,
       max(size_bytes) As MaxByte,
       avg(size_bytes) As AvgByte
FROM AppleStore

-- Find out how many apps are free

SELECT COUNT(1)
FROM AppleStore
WHERE price = 0;

-- Investigate whether paid apps have higher ratings than free apps 

SELECT CASE 
            WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
            END AS App_Type,
            avg(user_rating) AS Avg_Rating
            FROM AppleStore
            GROUP BY App_Type

-- Verify if apps with more supported languages have higher ratings         

SELECT CASE
            WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '> 30 languages'
         END AS language_bracket,
         avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bracket
ORDER BY Avg_Rating DESC 

-- Analyse genres with low ratings

SELECT prime_genre, 
       avg(user_rating) AS Avg_Rating
       FROM AppleStore
       GROUP BY prime_genre
       ORDER BY Avg_Rating ASC
       LIMIT 10
       
-- See if there is correlation between the length of the app description and the user ratingAppleStore

SELECT CASE
           WHEN length(b.app_desc) <500 THEN 'Short'
           WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
           ELSE 'Long'
        END AS description_length_bracket,
        avg(a.user_rating) AS average_rating

FROM 
    AppleStore AS A
JOIN 
    applestore_description_combined AS B
ON 
  a.id = b.id
  
GROUP BY description_length_bracket
ORDER BY average_rating DESC

-- Check the top rated apps for each genre

SELECT prime_genre,
       track_name, 
       user_rating
FROM   (
       SELECT
       prime_genre,
       track_name, 
       user_rating,
       RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
       FROM 
       AppleStore
       ) AS a 
 WHERE 
 a.rank = 1
 
 -- Takeaways/Conclusions
 -- 1. Paid Apps have better ratings
 -- 2. Apps supporting between 10 and 30 languages have better ratings
 -- 3. Finance and Book apps have low ratings
 -- 4. Apps with a longer description have better ratings
 -- 5. A new App should aim for an average rating above 3.5
 -- 6. Games and Entertainment have high competition/high user demand.  