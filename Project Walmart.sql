CREATE DATABASE IF NOT EXISTS walmart;


CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(10) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(20) NOT NULL,
	product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1) 
);


select * from sales;


-- Feature Engineering

-- time_of_day

SELECT time,
       (CASE
           WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
           WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
           ELSE 'Evening'
       END
       ) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

SELECT * FROM sales;

UPDATE sales
SET time_of_day = ( CASE
			WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
		END
);

SELECT * FROM sales;

-- day_name

SELECT date, dayname(date) FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(30);

UPDATE sales
SET day_name = ( dayname(date) );

-- month_name

SELECT date, monthname(date) FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(30);

UPDATE sales
SET month_name = (monthname(date));

-- How many unique cities does the data hav

SELECT DISTINCT city FROM sales;

-- how many branches in each city

SELECT DISTINCT branch FROM sales;

SELECT city, count(branch) as total_bracnhes_per_city, branch FROM sales
GROUP BY city, branch
ORDER BY total_bracnhes_per_city DESC;

-- How many unique product line do we have?

SELECT distinct product_line FROM sales;

-- most common payment method

SELECT * FROM sales;

SELECT payment_method, COUNT(payment_method) as cnt FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;


-- most selling product line

SELECT * FROM sales;


SELECT product_line, COUNT(product_line) as cnt_of_Prod_line FROM sales
GROUP BY product_line
ORDER BY cnt_of_Prod_line DESC;

-- total revenue by month

SELECT month_name AS month , SUM(total) AS total_revenue  FROM sales
GROUP BY month
ORDER BY total_revenue DESC; 

-- what month have highest COGS

SELECT month_name AS month, SUM(COGS) as Cost_of_Good FROM sales
GROUP BY month
ORDER BY Cost_of_Good DESC;

-- what product line have highest revenue

SELECT product_line, SUM(total) as revenue FROM sales
group by product_line
ORDER BY revenue DESC;

-- what is the city with largest revenue

SELECT city, branch, SUM(cogs) as revenue FROM sales
group by city, branch
ORDER BY revenue DESC;

-- city with largest VAT

SELECT city, AVG(VAT) as total_tax FROM sales
group by city
order by total_tax DESC;

-- product line with largest VAT

SELECT product_line, AVG(VAT) as total_tax FROM sales
group by product_line
order by total_tax DESC;

-- which branch sold more products than average product sold?

SELECT branch, SUM(quantity) AS qty FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Sales);

-- most common product line by gender

SELECT product_line, gender, COUNT(gender) as total_cnt FROM sales
group by product_line, gender
order by total_cnt DESC;

-- avg rating for each product line

SELECT ROUND(AVG(rating), 2) as avg_rating, product_line FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- sales made in each time of the day per week

SELECT time_of_day FROM sales;

SELECT time_of_day, COUNT(*) as total_sales
FROM sales
GROUP BY time_of_day;


SELECT time,
       (CASE
           WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
           WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
           ELSE 'Evening'
       END
       ) AS time_of_day
FROM sales;



SELECT time_of_day, COUNT(*) as total_sales
FROM sales
GROUP BY time_of_day;

-- which customer brings more reveneue

select * FROM sales;

SELECT customer_type, SUM(total) as total_revenue
FROM sales
group by customer_type 
ORDER BY total_revenue DESC;

-- which city have largest tax percent

SELECT city, ROUND(AVG(vat), 2) as Tax_percent
FROM sales
group by city
Order by Tax_percent DESC;

-- which customer paid more in VAT

SELECT customer_type, ROUND( AVG(VAT), 2) as tax_pct
FROM sales
GROUP BY customer_type
ORDER BY tax_pct DESC;

-- unique cutomer and payment type

SELECT DISTINCT customer_type FROM sales;

SELECT DISTINCT payment_method FROM sales;

-- which customer buy most

SELECT customer_type, COUNT(*) as Cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt;

-- what gender of most cutomer

SELECT gender, COUNT(*) as Gender_cnt
FROM sales
group by gender
order by Gender_cnt DESC;

-- which day of the week have the best rating 

select day_name, ROUND( AVG(rating), 2) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- which day have best rating per bracnh

SELECT day_name,  ROUND( avg(rating), 2) as avg_rating
FROM sales
WHERE branch = 'A'
group by day_name
ORDER by avg_rating DESC;






