 -- COMMAND -----

SELECT 
COUNT(*)
FROM
westminster_council_food_safety_report

 -- COMMAND -----
 
SELECT 
COUNT(DISTINCT FHRSID)
FROM
westminster_council_food_safety_report
    
 -- COMMAND -----
 
SELECT 
ROUND(AVG(RatingValue), 2) AS Average_Rating
FROM
westminster_council_food_safety_report
WHERE
RatingValue NOT IN ('AwaitingInspection' , 'Exempt', 'AwaitingPublication')
    
    
 -- COMMAND -----
 
SELECT 
RatingValue,COUNT(FHRSID) AS count, COUNT(FHRSID)*100.00 / SUM(COUNT(FHRSID)) over() as pct
FROM
westminster_council_food_safety_report
WHERE
RatingValue NOT IN ('AwaitingInspection' , 'Exempt', 'AwaitingPublication')
GROUP BY RatingValue
ORDER BY RatingValue

  -- COMMAND -----
 
DELETE FROM westminster_council_food_safety_report 
WHERE RatingValue IN ('AwaitingInspection' , 'Exempt', 'AwaitingPublication')

 -- COMMAND -----

SELECT 
    BusinessType,
    COUNT(FHRSID) AS 'count',
    ROUND(AVG(RatingValue), 2) AS Average_Rating
FROM
    westminster_council_food_safety_report
GROUP BY BusinessType
ORDER BY Average_Rating DESC

 -- COMMAND -----

SELECT 
    COUNT(*), YEAR(RatingDate) AS Year
FROM
    westminster_council_food_safety_report
GROUP BY YEAR(RatingDate)
ORDER BY Year

 -- COMMAND -----
 
SELECT
BusinessType,
COUNT(FHRSID) as count,
COUNT(FHRSID)*100.00 / SUM(COUNT(FHRSID)) OVER() AS pct,
DENSE_RANK()OVER(ORDER BY COUNT(FHRSID) DESC) AS rnk
FROM 
westminster_council_food_safety_report
WHERE
RatingValue <3
GROUP BY
BusinessType

 -- COMMAND -----
 
WITH total as (SELECT
LEFT(Postcode, LOCATE(" ",Postcode)-1) AS Area,COUNT(FHRSID) AS total_rating
FROM
westminster_council_food_safety_report 
WHERE
Postcode IS NOT NULL AND Postcode != ""
GROUP BY
Area),

highest AS (SELECT
LEFT(Postcode, LOCATE(" ",Postcode)-1) AS Area,count(FHRSID) AS highest_rating
FROM
westminster_council_food_safety_report 
WHERE
Postcode IS NOT NULL AND Postcode != "" and RatingValue = 5
GROUP BY
Area)

SELECT
*, 100.00 * highest_rating / total_rating AS pct
FROM
highest
JOIN
total USING(Area)
ORDER BY
pct DESC

 -- COMMAND -----
 
SELECT
BusinessName, COUNT(FHRSID) as cnt
FROM
westminster_council_food_safety_report
GROUP BY
BusinessName
ORDER BY
cnt DESC,
BusinessName

 
 -- COMMAND -----
 
UPDATE westminster_council_food_safety_report
SET BusinessName = CASE 
		WHEN BusinessName LIKE "Pret%A%Manger" THEN "Pret A Manger"
		WHEN BusinessName LIKE "%Starbucks%" THEN "Starbucks"
		WHEN BusinessName LIKE "Caffe%Nero" THEN "Caffe Nero"
		WHEN BusinessName LIKE "Mcdonalds%" THEN "Mcdonalds"
		WHEN BusinessName LIKE "Greggs" THEN "Greggs"
		WHEN BusinessName LIKE "Costa%" THEN "Costa" 
		ELSE BusinessName END
       
-- COMMAND ----- 

SELECT
BusinessName, RatingValue, COUNT(*) AS cnt, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (partition by BusinessName),2) AS pct
FROM 
westminster_council_food_safety_report
WHERE BusinessName in ("Pret A Manger","Starbucks","Caffe Nero","Mcdonalds","Greggs","Costa","Subway","Pizza Express", "Joe & The Juice Uk Ltd","Itsu")
GROUP BY
BusinessName,RatingValue
ORDER BY
BusinessName, RatingValue DESC


-- COMMAND -----

SELECT
BusinessName, 
COUNT(CASE WHEN RatingValue=0 THEN FHRSID END) AS  "0", 
COUNT(CASE WHEN RatingValue=1 THEN FHRSID END) AS "1",
COUNT(CASE WHEN RatingValue=2 THEN FHRSID END) AS "2",
COUNT(CASE WHEN RatingValue=3 THEN FHRSID END) AS  "3",
COUNT(CASE WHEN RatingValue=4 THEN FHRSID END) AS  "4",
COUNT(CASE WHEN RatingValue=5 THEN FHRSID END) AS  "5"
FROM 
westminster_council_food_safety_report
WHERE BusinessName in ("Pret A Manger","Starbucks","Caffe Nero","Mcdonalds","Greggs","Costa","Subway","Pizza Express", "Joe & The Juice Uk Ltd","Itsu")
GROUP BY
BusinessName

-- COMMAND -----

SELECT 
YEAR(RatingDate) AS Year, RatingValue, COUNT(*) as cnt, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) over (partition by YEAR(RatingDate)),2) AS pct
FROM 
westminster_council_food_safety_report
WHERE
YEAR(RatingDate) BETWEEN 2019 AND 2023
group by
YEAR(RatingDate), RatingValue
ORDER BY 
Year,RatingValue

-- COMMAND -----

SELECT 
DATE_FORMAT(CAST(RatingDate AS DATE),'%Y-%m') AS year_and_month, RatingValue, COUNT(*) as cnt, ROUND(count(*) * 100.0 / SUM(COUNT(*)) OVER (partition by DATE_FORMAT(CAST(RatingDate AS DATE),'%Y-%m')),2) AS pct
FROM 
westminster_council_food_safety_report
WHERE
YEAR(RatingDate) BETWEEN 2019 AND 2023
GROUP BY
DATE_FORMAT(CAST(RatingDate AS DATE),'%Y-%m'), RatingValue
ORDER BY
year_and_month,RatingValue

-- COMMAND -----

SELECT 
CONCAT(YEAR(RatingDate),"-Q",QUARTER(RatingDate)) AS year_quarter, RatingValue, COUNT(*) as cnt, ROUND(count(*) * 100.0 / SUM(COUNT(*)) OVER (partition by CONCAT(YEAR(RatingDate),"-Q",QUARTER(RatingDate))),2) AS pct
FROM 
westminster_council_food_safety_report
WHERE
YEAR(RatingDate) BETWEEN 2019 AND 2023
GROUP BY
CONCAT(YEAR(RatingDate),"-Q",QUARTER(RatingDate)), RatingValue
ORDER BY
year_quarter,RatingValue

