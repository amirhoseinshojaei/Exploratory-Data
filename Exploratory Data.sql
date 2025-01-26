-- Exploratory Data

USE world_layoffs;

SELECT *
FROM
	world_layoffs.layoffs3
;


SELECT 
	MAX(total_laid_off),
    MIN(total_laid_off),
    MAX(percentage_laid_off),
    MIN(percentage_laid_off),
    SUM(total_laid_off)
FROM
	world_layoffs.layoffs3
;

SELECT *
FROM
	world_layoffs.layoffs3
WHERE
	percentage_laid_off = 1
;

SELECT 
	COUNT(*)
FROM
	world_layoffs.layoffs3
WHERE
	percentage_laid_off = 1
;

SELECT 
	COUNT(*)
FROM
	world_layoffs.layoffs3
WHERE
	percentage_laid_off = 0
;

SELECT *
FROM
	world_layoffs.layoffs3
WHERE
	percentage_laid_off = 0
;

SELECT 
	DISTINCT(location)
FROM
	world_layoffs.layoffs3
ORDER BY 1
;


SELECT 
	MAX(percentage_laid_off)
FROM
	world_layoffs.layoffs3
;

SELECT *
FROM
	world_layoffs.layoffs3
WHERE
	percentage_laid_off = 1
AND 
	location = 'Los angeles'
;

SELECT 
	count(*)
FROM
	world_layoffs.layoffs3
WHERE
	location = 'Los angeles'
;

SELECT 
	company,
    SUM(total_laid_off) AS total_laid_of_per_company
FROM
	world_layoffs.layoffs3
GROUP BY
	company
ORDER BY 2 DESC
;


SELECT 
	MAX(`date`),
    MIN(`date`)
FROM
	world_layoffs.layoffs3
;

SELECT 
	company,
    MAX(total_laid_off),
    MIN(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY
	company
ORDER BY 2 DESC
;

SELECT *
FROM
	world_layoffs.layoffs3
WHERE
	company = 'Google'
;

SELECT 
	location,
    MAX(total_laid_off),
    MIN(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY 
	location
ORDER BY 2 DESC
;

SELECT 
	location,
    company,
    MAX(total_laid_off)
FROM
	world_layoffs.layoffs3
WHERE
	location = 'chicago'
GROUP BY
	location, company
;

SELECT 
	location,
    SUM(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY
	location
ORDER BY 2 DESC
;


SELECT 
	industry,
    SUM(total_laid_off),
    MAX(total_laid_off),
    MIN(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY industry
ORDER BY 2 DESC
;

SELECT 
	location,
    COUNT(company)
FROM
	world_layoffs.layoffs3
GROUP BY 
	location
ORDER BY 2 DESC
;

SELECT 
	country,
    SUM(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY
	country
ORDER BY 2 DESC
;

SELECT 
	YEAR(`date`) AS `year`,
    SUM(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY `year`
ORDER BY 2 DESC
;


SELECT 
	SUBSTRING(`date`, 1,7) AS `date`,
    SUM(total_laid_off) total_laid_off
FROM
	world_layoffs.layoffs3
GROUP BY `date`
ORDER BY 1 DESC
;

WITH Rolling_Total AS
(
SELECT 
	SUBSTRING(`date`, 1,7) AS `date`,
    SUM(total_laid_off) total_laid_off
FROM
	world_layoffs.layoffs3
GROUP BY `date`
ORDER BY 1 DESC
)
SELECT 
	`date`,
    SUM(total_laid_off)
FROM
	Rolling_Total
GROUP BY `date`
;

SELECT 
	company,
    YEAR(`date`) `year`,
    SUM(total_laid_off)
FROM
	world_layoffs.layoffs3
GROUP BY
	company,
    `year`
HAVING
	SUM(total_laid_off) IS NOT NULL
order by `year`, 3 DESC
;


WITH Company_year(company, years, total_laid_off) AS
(
SELECT 
	company,
    YEAR(`date`),
    SUM(total_laid_off)
FROM
	layoffs3
WHERE
	YEAR(`date`) IS NOT NULL
GROUP BY
	company,
     YEAR(`date`)
), Company_year_rank AS(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM
	Company_year 
ORDER BY 
	Ranking ASC
)
SELECT *
FROM
	Company_year_rank
WHERE 
	Ranking <= 5
;

WITH Ranking(company, `year`, total_laid_off) AS 
(
SELECT 
	company,
    YEAR(`date`) `year`,
    SUM(total_laid_off)
FROM
	world_layoffs.layoffs3
WHERE
	YEAR(`date`) IS NOT NULL
GROUP BY
	company,
    `year`
HAVING
	SUM(total_laid_off) IS NOT NULL
order by `year`, 3 DESC
)
SELECT *,
		DENSE_RANK() over(PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
FROM
	Ranking
;
