CREATE DATABASE IF NOT EXISTS walmartsale;
USE walmartsale;
-- ---------------------------------------------------------------------------------------------------------------
-- -------------------------------------------READ THE DATASET ---------------------------------------------------

SELECT * FROM walmartsaledataset;

-- Write a querry to change the table name
ALTER TABLE walmartsaledataset RENAME TO sales;

-- ---------------------------------------------------------------------------------------------------------------
-- -------------------------------------------FEATURE ENGINEERING-------------------------------------------------

-- time_of_day
SELECT time,
          (CASE
          WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
          WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
          ELSE "Evening"
          END
          ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales SET time_of_day = (
	  CASE
          WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
          WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
          ELSE "Evening"
	  END
);
 
-- day_name
SELECT date, DAYNAME(date) AS day_name FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);

-- month_name
SELECT date, MONTHNAME(date) FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name = MONTHNAME(date);

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------GENERIC QUESTIONS-------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch FROM sales;

-- ---------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------PRODUCT----------------------------------------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales;

-- What is the most selling product line
SELECT SUM(quantity) as qty, product_line FROM sales GROUP BY product_line ORDER BY qty DESC;

-- What is the total revenue by month
SELECT month_name AS month, SUM(total) AS total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT month_name AS month, SUM(cogs) AS cogs FROM sales GROUP BY month_name ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT product_line, SUM(total) as total_revenue FROM sales GROUP BY product_line ORDER BY total_revenue DESC;

-- Which is the city with the largest revenue?
SELECT branch, city, SUM(total) AS total_revenue FROM sales GROUP BY branch, city ORDER BY total_revenue;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT AVG(quantity) AS avg_qnty FROM sales;

SELECT product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qnty FROM sales
GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender
SELECT gender, product_line, COUNT(gender) AS total_cnt FROM sales GROUP BY gender, product_line 
ORDER BY total_cnt DESC;

---- What is the average rating of each product line
SELECT ROUND(AVG(rating), 2) as avg_rating, product_line FROM sales GROUP BY product_line ORDER BY avg_rating DESC;

-- ---------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------CUSTOMERS ------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;

-- What is the most common customer type?
SELECT customer_type, count(*) as count FROM sales GROUP BY customer_type ORDER BY count DESC;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_cnt FROM sales GROUP BY gender ORDER BY gender_cnt DESC;

-- What is the gender distribution C branch?
SELECT gender, COUNT(*) as gender_cnt FROM sales WHERE branch = "C" GROUP BY gender ORDER BY gender_cnt DESC;
-- Gender per branch is more or less or the same hence, 
-- I don't think has an effect on the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales GROUP BY time_of_day ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, 
-- it's more or less the same rating each time of the day.

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales WHERE branch = "A" GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, 
-- branch B needs to do a little more to get better ratings.

-- Which day fo the week has the best avg rating?
SELECT day_name, avg(rating) AS avg_rating FROM sales GROUP BY day_name ORDER BY avg_rating DESC;
-- monday, friday, sunday has the best avg rating.

-- --------------------------------------------------------------------------------------------------------------
-- -------------------------------------------- Sales -----------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT time_of_day, COUNT(*) AS total_sales FROM sales WHERE day_name = "Sunday" GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue FROM sales GROUP BY customer_type ORDER BY total_revenue;

-- Which day fo the week has the largest avg selling?
SELECT day_name, AVG(total) AS avg_total FROM sales GROUP BY day_name ORDER BY avg_total DESC;
-- saturday, sunday, thursday has the largest avg selling.

-- Which product line has the maximum sale?
SELECT product_line, SUM(total), COUNT(product_line) AS count_pl FROM sales GROUP BY product_line ORDER BY count_pl DESC;































