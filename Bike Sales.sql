
-- Select the dataset we will be using

SELECT *
FROM dbo.Sales;

-- Sum total revenue per Country

SELECT country, SUM(revenue) AS total_revenue
FROM dbo.Sales
GROUP BY country
ORDER BY total_revenue desc;

-- Revenue per state for US (Country with largest revenue)

SELECT state, country, SUM(revenue) AS total_revenue
FROM dbo.Sales
WHERE country = 'United States'
GROUP BY state, country
ORDER BY total_revenue desc;

-- Amount and percentage of US sales to overall sales

SELECT
(SELECT SUM(revenue) FROM dbo.Sales WHERE country= 'United States') AS total_US_sales, 
	SUM(revenue) as total_revenue, 
	ROUND((SELECT SUM(revenue) FROM dbo.Sales WHERE country= 'United States') / SUM(revenue), 2) AS percent_US_revenue
FROM dbo.Sales;

-- Order quantity per age group in US

SELECT age_group, SUM(order_quantity) AS total_quantity
FROM dbo.Sales
WHERE country = 'United States'
GROUP BY age_group
ORDER BY total_quantity desc;

-- Amount and percentage of adult bike quantity to total quantity in US

SELECT
(SELECT SUM(order_quantity) FROM dbo.Sales WHERE age_group= 'Adults (35-64)' AND country = 'United States') AS adult_order_quantity,
	SUM(order_quantity) as total_quantity,
	ROUND((SELECT SUM(order_quantity) FROM dbo.Sales WHERE age_group= 'Adults (35-64)' AND country = 'United States') / SUM(order_quantity), 2) percent_adult_quantity
FROM dbo.Sales
WHERE country = 'United States';

-- Total revenue, cost, revenue for 2015 in US

SELECT sum(revenue) AS total_revenue_2015, sum(cost) AS total_cost_2015, sum(profit) AS total_profit_2015
FROM dbo.Sales
WHERE year = '2015' AND country = 'United States';

-- Gross margin calculation for 2015 in US

SELECT sum(profit) AS total_profit_2015, sum(revenue) AS total_revenue_2015, ROUND(sum(profit) / sum(revenue), 2) AS gross_margin_2015
FROM dbo.Sales
WHERE year = '2015' AND country = 'United States';

-- Revenue per quarter for 2015 

SELECT sum(revenue) AS total_revenue_2015,
(SELECT sum(revenue) FROM dbo.Sales WHERE month IN ('January', 'February', 'March') AND year = 2015 AND country = 'United States') AS q1_2015,
(SELECT sum(revenue) FROM dbo.Sales WHERE month IN ('April', 'May', 'June') AND year = 2015 AND country = 'United States') AS q2_2015,
(SELECT sum(revenue) FROM dbo.Sales WHERE month IN ('July', 'August', 'September') AND year = 2015 AND country = 'United States') AS q3_2015,
(SELECT sum(revenue) FROM dbo.Sales WHERE month IN ('October', 'November', 'December') AND year = 2015 AND country = 'United States') AS q4_2015
FROM dbo.Sales
WHERE year = 2015 AND country ='United States';

-- Revenue per month in 2015

SELECT month, sum(revenue) AS total_revenue_2015
FROM dbo.Sales
WHERE year = 2015 AND country = 'United States'
GROUP BY month
ORDER BY total_revenue_2015 desc;

-- Count of product per category in US

SELECT product_category, COUNT(product) AS total_product
FROM dbo.Sales
WHERE country = 'United States'
GROUP BY product_category
ORDER BY total_product desc;

-- Total orders of each product in US

SELECT product, COUNT(order_quantity) AS total_orders
FROM dbo.Sales
WHERE country = 'United States' and product_category = 'Accessories'
GROUP BY product
ORDER BY total_orders desc;

-- Total revenue per order in US

SELECT DISTINCT product, unit_price, SUM(order_quantity) AS total_orders, unit_price * SUM(order_quantity) AS total_revenue_per_product
FROM dbo.Sales
WHERE country = 'United States'
GROUP BY product, unit_price
ORDER BY total_revenue_per_product desc;

-- Total orders per gender in US

SELECT customer_gender, COUNT(*) as total_orders
FROM dbo.Sales
WHERE country = 'United States'
GROUP BY customer_gender
ORDER BY total_orders desc;















