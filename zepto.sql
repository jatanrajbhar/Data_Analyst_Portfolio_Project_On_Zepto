drop table if exists zepto;
create table zepto(
    sku_id SERIAL PRIMARY KEY,
    Category VARCHAR(100),
    name VARCHAR(100) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent INT NOT NULL,
    availableQuantity INT NOT NULL,
	discountedSellingPrice NUMERIC(8,2),
    weightInGms INT NOT NULL,
    outOfStock BOOLEAN NOT NULL,
    quantity INT NOT NULL
);

SELECT * FROM zepto

--DATA EXPLORATION

--sample data
SELECT * FROM zepto
LIMIT 10;

-- finding null values
SELECT * FROM zepto
WHERE category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL

--diffrent product category
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--check outofstock product
SELECT outofstock,COUNT (sku_id)
FROM zepto
GROUP BY outofstock;

-- repeated products
SELECT name, COUNT (sku_id) as "Number of sku"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT (sku_id) DESC;

-- DATA CLEANING

-- cleaning data wherempr is 0
SELECT * FROM zepto
WHERE mrp = 0 or discountedSellingPrice =0;

DELETE FROM zepto
WHERE mrp = 0;

-- converting paise into rupees 
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

-- BUsiness insight Question

-- find the top 10 best value products from discountsellingprice
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
-- what are the product of high mrp but outof stock.
SELECT DISTINCT name, mrp, outofstock
FROM zepto
WHERE outofstock = TRUE and mrp > 500;

-- Calcualate the estimate revenue of each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue

-- find the products with price greater than 500 and the discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent <= 10
ORDER BY discountPercent DESC, mrp DESC;
-- identify the top 5 categories offering the highest average discount percent
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
-- find the price per grams of products more than 100gm and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS Price_Pr_Gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY Price_Pr_Gram DESC;

-- group the products into categories like low medium bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'low'
	WHEN weightInGms < 5000 THEN 'medium'
	ELSE 'bulk'
	END AS wieght_category
FROM zepto;
	
-- what is the total weight per category

SELECT category,
SUM(weightInGms * availableQuantity) AS totalweight
FROM zepto
GROUP BY category
ORDER BY totalweight;