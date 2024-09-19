# RetailSale-Analysis-SQL
## Project Overview
* **Project Title** : Retail Sales Analysis
* **Project DataBase** : Retail_Sale
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objective
* **Set up a retail sales database** : Create and populate a retail sales database with the provided sales data and import (.csv) file into the table.
* **Data Cleaning** : Identify and remove any records with missing or null values.
* **Exploratory Data Analysis (EDA)** : Perform basic exploratory data analysis to understand the dataset.
* **Business Analysis** : Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure
### 1.DataBase Setup
  * **Create DataBase** :The project starts by creating a database named `Retail_Sale`.
  * **Create Table** :  A table named `RetailSale` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount
  
```
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
```
### 2. Data Exploration & Cleaning
**Record Count** : Determine the total number of records in the dataset.
**Customer Count** : Find out how many unique customers are in the dataset.
**Category Count** : Identify all unique product categories in the dataset.
**Null Value Check** : Check for any null values in the dataset and delete records with missing data.
```
SELECT * FROM RetailSale;

SELECT COUNT(DISTINCT customer_id) FROM RetailSale;

SELECT DISTINCT category FROM RetailSale;

SELECT * FROM RetailSale
where transactions_id IS NULL OR sale_date IS NULL
	OR sale_time IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL
	OR quantiy IS NULL OR price_per_unit IS NULL
	OR cogs IS NULL OR total_sale IS NULL; 

DELETE FROM RetailSale
where transactions_id IS NULL OR sale_date IS NULL
	OR sale_time IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL
	OR quantiy IS NULL OR price_per_unit IS NULL
	OR cogs IS NULL OR total_sale IS NULL;

```

### 3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:
  1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**
```
SELECT * 
FROM RetailSale
WHERE sale_date = '2022-11-05';
```
  2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold
     is more than 4 in the month of Nov-2022**
```
SELECT *
 FROM RetailSale
WHERE category = 'Clothing'
      AND quantiy >= 4 
      AND TO_CHAR(sale_date , 'YYYY-MM') = '2022-11';
```
  3. **Write a SQL query to calculate the total sales (total_sale) for each category**
```
SELECT   category , 
         SUM(total_sale) AS "Total Sales" ,
         COUNT(*) AS "Total Orders"
FROM RetailSale
GROUP BY category;
```  
  4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**
```
SELECT ROUND(AVG(age),2) AS "Average Age"
FROM RetailSale
WHERE category = 'Beauty';
```
  5. **Write a SQL query to find all transactions where the total_sale is greater than 1000**
```
SELECT * 
FROM RetailSale
WHERE total_sale >=1000;
```
  6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**
```
SELECT gender , category , COUNT(*) AS "Total Transactions"
FROM RetailSale
GROUP BY gender , category;
```
  7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**
```
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
``` 
  8. **Write a SQL query to find the top 5 customers based on the highest total sales**
```
SELECT customer_id ,
		SUM(total_sale) AS "Total Sale"
FROM RetailSale
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;
``` 
  9. **Write a SQL query to find the number of unique customers who purchased items from each category**
```
SELECT COUNT(DISTINCT customer_id) AS "Number Of Customers",
		category
FROM RetailSale
GROUP BY category;
```
  10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
```
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
```

     

  



























































































































