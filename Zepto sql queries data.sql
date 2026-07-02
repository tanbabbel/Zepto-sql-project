DROP TABLE IF EXISTS Zepto;

CREATE TABLE Zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(10,2),
    discountPercent NUMERIC(10,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(30,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);

-- COUNT OF ROWS
SELECT COUNT(*) FROM Zepto;

--sample data
SELECT * FROM Zepto;

--diff product categories
SELECT DISTINCT category
FROM Zepto
GROUP BY category;

--How many products are out of stock and are in stock
SELECT outOfStock , COUNT(sku_id)
FROM Zepto
GROUP BY outOfStock;

--product names who came more than 1 time
SELECT name , COUNT(sku_id) AS number_of_skus
FROM Zepto
GROUP BY name
HAVING COUNT (sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING--

--checking any products who has the price 0
SELECT * FROM Zepto
WHERE mrp = '0' OR discountedsellingprice = '0';  -- one column showing a product which has 0 price which is not possible so we have to del it

DELETE FROM Zepto
WHERE mrp = '0';

--converting paise to rupees in mrp
UPDATE Zepto
SET mrp = mrp/100.00,
discountedsellingprice = discountedsellingprice/100.00;

SELECT mrp , discountedsellingprice FROM Zepto;

--BUISNESS INSIGHTS--

--Q 1. Find the top 10 best value products based on their discount percentage.
SELECT DISTINCT name , mrp , discountpercent
FROM Zepto
ORDER BY discountpercent DESC LIMIT 10;

--Q 2. What are the products with high mrp that is out of stock
SELECT DISTINCT(name) , mrp
FROM Zepto
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;

--Q 3. Calulate estimated revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM Zepto
GROUP BY category
ORDER BY total_revenue;

--Q 4. Find all the products where mrp is greater than 500rs and discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM Zepto 
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC LIMIT 10;

--Q 5. Identify the top 5 categories offering the highest avg discount percentage.
SELECT category,
ROUND (AVG(discountpercent),2) AS avg_discount
FROM Zepto
GROUP BY CATEGORY
ORDER BY avg_discount DESC LIMIT 5;

--Q 6. find the price per gram for products above 100gm and sort by the best value
SELECT DISTINCT name , weightingms , discountedsellingprice,
ROUND (discountedsellingprice/weightingms , 2) AS price_per_gram
FROM Zepto
WHERE weightingms >= 100
ORDER BY price_per_gram;

--Q 7. Group the products into categories like low,medium and bulk.
SELECT DISTINCT name , weightingms,
CASE WHEN weightingms < 1000 THEN 'low'
     WHEN weightingms < 5000 THEN 'medium'
	 ELSE 'bulk'
	 END AS weight_category
FROM Zepto;

--Q 8. What is the total inventory weight per category
SELECT category,
SUM(weightingms * availableQuantity) AS total_weight
FROM Zepto
GROUP BY category
ORDER BY total_weight;

