-- SQL Retail Sale Analysis.

CREATE DATABASE Retail_Sale;

-- Create RetailSale Table
DROP TABLE IF EXISTS RetailSale;
CREATE TABLE RetailSale(
	transactions_id INT	PRIMARY KEY ,
	sale_date DATE ,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT ,
	category VARCHAR(25),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM RetailSale
LIMIT 10;

SELECT COUNT(*) FROM RetailSale;

-- DATA Cleaning

SELECT * FROM RetailSale
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL; 


DELETE FROM RetailSale
where 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA Exploratory

-- How many sales we have?

SELECT COUNT(*) AS Total_Sales
FROM RetailSale;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) AS Total_Customer
FROM RetailSale;

-- What is the  uniuque category we have ?

SELECT DISTINCT category AS Category
FROM RetailSale;


-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * 
FROM RetailSale
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM RetailSale
WHERE category = 'Clothing'
	AND quantiy >= 4 
	AND TO_CHAR(sale_date , 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT  category , 
		SUM(total_sale) AS "Total Sales" ,
		COUNT(*) AS "Total Orders"
FROM RetailSale
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) AS "Average Age"
FROM RetailSale
WHERE category = 'Beauty';

---- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * 
FROM RetailSale
WHERE total_sale >=1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender , category , COUNT(*) AS "Total Transactions"
FROM RetailSale
GROUP BY gender , category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	Year , Month , Avg_Sale
FROM(	
SELECT 
	EXTRACT(YEAR FROM sale_date) AS Year,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	AVG(total_sale) AS Avg_Sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS Rank
FROM RetailSale
GROUP BY 1,2
)
WHERE Rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id ,
		SUM(total_sale) AS "Total Sale"
FROM RetailSale
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT COUNT(DISTINCT customer_id) AS "Number Of Customers",
		category
FROM RetailSale
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH Hourly_Shift
AS(
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
		END AS Shift
	FROM RetailSale
)
SELECT Shift , COUNT(*) AS "Number Of Orders"
FROM Hourly_Shift
GROUP BY Shift;

-- End Of Project