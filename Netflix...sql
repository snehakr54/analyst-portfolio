--Netflix project
CREATE table netflix
(
show_id VARCHAR (6),
type	VARCHAR (10),
title   VARCHAR (150),
director VARCHAR (208),
casts VARCHAR (1000),
country	VARCHAR (150),
date_added VARCHAR (50),
release_year INT,
rating	 VARCHAR (10),
duration VARCHAR (15),
listed_in	VARCHAR (150),
description VARCHAR (250)
);
SELECT * from netflix;

SELECT 
COUNT(*) AS total_content
from netflix;

SELECT 
  DISTINCT type
from netflix;

SELECT* from netflix;

--15 Business problems
-- 1.Count the number of Movies vs TV shows
SELECT
  Count (*) as total_content
  from Netflix
  group by type

  -- 2. Find the most common rating for movies and TV show
  SELECT 
      type,
	  rating
  FROM
  (
      SELECT 
      type,
	  rating,
	  Count (*),
	  Rank() OVER(PARTITION BY type ORDER BY count(*) DESC) as ranking
   from netflix
   group by 1,2
) as t1
WHERE 
 ranking = 1
 -- 3.List all movies released in a specific year e.g (2020)

--filter 2020
--movies

SELECT * FROM Netflix
WHERE 
    type = 'Movies'
    AND
    release_year = 2020
-- 4.Find the top 5 countries with the most content on Nertflix

SELECT
     UNNEST(String_to_Array(Country, ',')) as new_country,
	 Count(show_id ) as Total_content
	 FROM Netflix
     Group by 1
	 ORDER BY 2 DESC
	 Limit  5
SELECT
     UNNEST(String_to_Array(Country, ',')) as new_country
	 FROM Netflix
-- 5.Identify the longest movie

SELECT * FROM Netflix
WHERE
    type = 'Movie'
	AND
	duration = (SELECT MAX(duration)from netflix)
-- 6.Find content added in the last 5 years

SELECT 
    *
FROM Netflix
WHERE 
    TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - Interval '5 years'

SELECT CURRENT_DATE - Interval '5 years'
-- 7.Find all the Movies/TV shows by director 'Rajiv chilaka'

SELECT* FROM Netflix
WHERE director ILIKE  '%Rajiv Chilaka%'

-- 8.List all the TV Shows with more than 5 seasons

SELECT 
     *
FROM netflix
WHERE 
     type ='TV Shows'
	 AND
	 SPLIT_PART(duration,' ', 1)::numeric > 5
-- 9.Count the number of content items in each genre

SELECT
     UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	 COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

-- 10.Find each year and the average number of content release by India on netflix.
      return top 5 years with the highest avg content release


--Total content 333/972

SELECT 
     EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as Year
     COUNT(*) as yearly_content,
	 ROUND(
	 COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE Country= 'India')::numeric * 100
	 ,2)as avg_content_per_year
FROM netflix

--11. List all the movies that are documentries

SELECT* FROM netflix
WHERE
    listed_in ILIKE '%documentries%'

--12. Find all content without a director

SELECT* FROM netflix
WHERE
    director IS NULL

--13. Find how many movies actor 'Salman Khan' appeared in last 10years

SELECT * FROM netflix
WHERE
    casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--14. Find the top actors who have appeared in the highest number of movies produced in India

SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing
      these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

WITH new_table
AS
(
SELECT
*,
   CASE
   WHEN
      description ILIKE '%kill%' OR
	  description ILIKE '%violence%' THEN 'Bad_Content'
	  ELSE 'Good content'
	END category
FROM netflix
)
SELECT
     category,
	 COUNT(*)as total_content
FROM new_table
GROUP BY 1

  

	




 
   
