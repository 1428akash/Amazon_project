create database sql_capstone; -- creating database with the name of sql_capstone
use sql_capstone;
desc amazon;  
select * from amazon;
select `invoice ID` from amazon LIMIT 5;

-- checking the presence of NULL values
SELECT 
     * 
     FROM
		 amazon 
             WHERE invoice_id IS NULL OR
                    branch IS NULL OR
                     city IS NULL OR
                     customer_type IS NULL OR
                     gender IS NULL OR
                     product_line IS NULL OR
                     unit_price IS NULL OR
                     quantity IS NULL OR
                     VAT IS NULL OR
                     total IS NULL OR
                     date IS NULL OR
                     time IS NULL OR
                     payment_method IS NULL OR
                     cogs IS NULL OR
                     gross_margin_percentage IS NULL OR
                     gross_income IS NULL OR
                     rating IS NULL;
                     
-- Altering the names and data types of the data
Alter table amazon 
rename column `Product line` to product_line;

ALTER TABLE amazon
MODIFY COLUMN product_line Varchar(100);

Alter table amazon 
rename column `Invoice ID` to invoice_id;

ALTER TABLE amazon
MODIFY COLUMN invoice_id Varchar(30);

ALTER TABLE amazon
MODIFY COLUMN branch Varchar(5);

ALTER TABLE amazon
MODIFY COLUMN city Varchar(30);

Alter table amazon 
rename column `Customer type` to customer_type;

ALTER TABLE amazon
MODIFY COLUMN customer_type Varchar(30);

ALTER TABLE amazon
MODIFY COLUMN gender Varchar(10);

Alter table amazon 
rename column `Unit price` to unit_price;

ALTER TABLE amazon
MODIFY COLUMN unit_price decimal(10,2);

ALTER TABLE amazon
MODIFY COLUMN quantity INT;

Alter table amazon 
rename column `Tax 5%` to VAT;

ALTER TABLE amazon
MODIFY COLUMN VAT float(6,4);

ALTER TABLE amazon
MODIFY COLUMN total decimal(10,2);

ALTER TABLE amazon
MODIFY COLUMN date DATE;

ALTER TABLE amazon
MODIFY COLUMN Time TIME;

Alter table amazon
rename column `Payment` to payment_method;

ALTER TABLE amazon
MODIFY COLUMN payment_method Varchar(30);

ALTER TABLE amazon
MODIFY COLUMN cogs decimal(10,2);

Alter table amazon
rename column `gross margin percentage` to gross_margin_percentage;

ALTER TABLE amazon
MODIFY COLUMN gross_margin_percentage float(11,9);

Alter table amazon
rename column `gross income` to gross_income;

ALTER TABLE amazon
MODIFY COLUMN gross_income decimal(10,2);

Alter table amazon
rename column `rating` to rating;

ALTER TABLE amazon
MODIFY COLUMN rating float(3,1);

-- Feature Engineering

-- creating a new column with the name of time_of_day

SELECT 
    *,
    CASE 
        WHEN HOUR(time) >= 0 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM 
    amazon;

-- creating a new column with the name of day_of_week
SELECT 
    *,
    DAYNAME(date) AS day_of_week
FROM 
    amazon;

-- creating a new column with the name of monthname
SELECT 
    *,
    MONTHNAME(date) AS monthname
FROM 
    amazon;

-- count of distinct cities
SELECT city, COUNT(*) AS Total_cities
FROM amazon
GROUP BY city
ORDER BY Total_cities DESC; 

select distinct city from amazon;  -- name of distinct cities

-- distinct branch with city name in order
select distinct branch,city from amazon
order by branch;

select count(distinct product_line) from amazon; -- count of distinct product_line

-- payment_method which occurs most
SELECT payment_method, COUNT(*) AS occurrences
FROM amazon
GROUP BY payment_method
ORDER BY occurrences DESC
LIMIT 1;

Select distinct(product_line) from amazon; -- types of product_lines

-- the below code represents that Fashion accessories product_line had highest sales --
SELECT product_line, COUNT(*) AS Total_sales
FROM amazon
GROUP BY product_line
ORDER BY Total_sales DESC
;

-- product_line that generated highest revenue --
SELECT product_line, SUM(total) AS revenue
FROM amazon
GROUP BY product_line
ORDER BY revenue DESC
;

-- highest VAT that came in Fashion accessories Product_line
SELECT 
     Product_line, VAT 
FROM 
     amazon
ORDER BY 
     cogs DESC
LIMIT 1;
     
-- renvenue generated on each month
SELECT MONTH(date) AS MONTH, SUM(total) AS revenue
FROM amazon
GROUP BY MONTH
ORDER BY revenue DESC;

-- city that recorded highest revenue
SELECT city, SUM(total) AS revenue
FROM amazon
GROUP BY (city)
ORDER BY revenue DESC
LIMIT 1;

-- cogs highest peak was in FEBRUARY 
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    cogs
FROM 
    amazon
GROUP BY 
    YEAR(date), MONTH(date), cogs
ORDER BY 
    cogs DESC
LIMIT 1;

-- city with the highest VAT percentage
SELECT city, VAT 
FROM amazon
ORDER BY VAT DESC
LIMIT 1;

-- count of distinct payment_method in the dataset
SELECT DISTINCT(payment_method), COUNT(*) AS occurrences
FROM amazon
GROUP BY payment_method
ORDER BY occurrences DESC;

-- product_line line which is most frequently associated with each gender
SELECT gender, product_line, COUNT(*) AS frequency
FROM amazon
GROUP BY gender, product_line
ORDER BY gender, frequency DESC;

-- avg_rating for each product_line
SELECT product_line, AVG(rating) AS avg_rating
FROM amazon
GROUP BY product_line;


-- showing the sale status of product_line 
SELECT 
    product_line,
    CASE 
        WHEN total_sales > average_sales THEN 'Good'
        ELSE 'Bad'
    END AS sales_status
FROM (
    SELECT 
        product_line,
        SUM(quantity) AS total_sales,
        AVG(SUM(quantity)) OVER() AS average_sales
    FROM 
        amazon
    GROUP BY 
        product_line
) AS sales_summary;

-- shows the time of day when customers provide the most ratings
SELECT 
    HOUR(time) AS hour_of_day,
    COUNT(*) AS rating_count
FROM 
    amazon
GROUP BY 
    hour_of_day
ORDER BY 
    rating_count DESC;
    
-- day of the week with the highest average rating
SELECT 
    DAYNAME(date) AS day_of_week,
    AVG(rating) AS avg_rating
FROM 
    amazon
GROUP BY 
    day_of_week
ORDER BY 
    avg_rating DESC
LIMIT 1;

-- day of the week with the highest average ratings for each branch
SELECT 
    branch,
    DAYNAME(date) AS day_of_week,
    AVG(rating) AS avg_rating
FROM 
    amazon
GROUP BY 
    branch, day_of_week
ORDER BY 
    branch, avg_rating DESC;

-- time of day with the highest customer ratings for each branch.
SELECT 
    HOUR(time) AS hour_of_day,
    COUNT(*) AS rating_count
FROM 
    amazon
GROUP BY 
    hour_of_day
ORDER BY 
    rating_count DESC
LIMIT 1;
        
-- distribution of genders within each branch    
SELECT 
    branch,
    gender,
    COUNT(*) AS gender_count
FROM 
    amazon
GROUP BY 
    branch, gender
ORDER BY 
    branch, gender;
    
-- branch that exceeded the average number of products sold
SELECT 
    branch,
    SUM(quantity) AS total_products_sold,
    (SELECT AVG(total_quantity) FROM (SELECT branch, SUM(quantity) AS total_quantity FROM amazon GROUP BY branch) AS avg_sales) AS average_products_sold
FROM 
    amazon
GROUP BY 
    branch
HAVING 
    total_products_sold > average_products_sold;


-- customer_type with the highest purchase frequency.
SELECT 
    customer_type,
    COUNT(*) AS purchase_frequency
FROM 
    amazon
GROUP BY 
    customer_type
ORDER BY 
    purchase_frequency DESC
LIMIT 1;

-- customer_type with the highest VAT payment
SELECT customer_type, VAT 
FROM amazon
ORDER BY VAT DESC
LIMIT 1;

-- customer_type that contributes highest revenue
SELECT customer_type, SUM(total) AS revenue
FROM amazon
GROUP BY customer_type
ORDER BY revenue DESC
LIMIT 1;

-- customer_type which occurs most
SELECT customer_type, COUNT(*) AS Total_customer_type
FROM amazon
GROUP BY customer_type
ORDER BY Total_customer_type DESC
Limit 1;

-- predominant gender among customers
SELECT 
    gender,
    COUNT(*) AS gender_count
FROM 
    amazon
GROUP BY 
    gender
ORDER BY 
    gender_count DESC
LIMIT 1;






