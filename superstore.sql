



/*
1. CREATING A STAGING TABLE: all_sales_staging table, inserting values
2. IDENTIFYING ISSUES IN THE DATA: missing or null values, duplicates, inconsistent date formats
3. CREATING AND JOINING TABLES
4. SUMMARY STATISTICS: average, sum, minimum, maximum, count, frequecny
5. DATA ANALYSIS: correlation
*/

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-- DATA PROCESSING
-- Create a staging table
CREATE TABLE ss_staging	
LIKE ss_cleaned;

# Insert data from the original table to the staging table
INSERT ss_staging
SELECT *
FROM ss_cleaned;
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
/*
SUMMARY STATISTICS
*/

SELECT 
	COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(total_cost), 2) AS total_cost,
    ROUND(SUM(discount_amount), 2) AS total_discount,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(unit_price), 2) AS avg_unit_price,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_percent,
    
-- Calculated KPIs
	ROUND(COUNT(DISTINCT order_id) * 1.0 / COUNT(DISTINCT customer_id), 2) AS orders_per_customer,
	ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS average_order_value,
    ROUND(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id), 2) AS quantity_per_order,
    ROUND(SUM(total_cost) / SUM(quantity), 2) AS average_unit_cost,
	ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent
FROM ss_staging;		

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
/*
PROFITABILITY & LOSS ANALYSIS

1. Which product categories, sub-categories, or specific products are the most and least profitable? 

2. Are the loss-making products concentrated in certain categories that might be used to attract customers?
*/

# PROFITABILITY ANALYSIS
# Profitability by Category (Ranked from Most to Least Profitable)
SELECT 
    category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin_percent,
    
    -- Profitability ranking
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank,
    CASE 
        WHEN SUM(profit) > 0 THEN 'Profitable'
        ELSE 'Loss-Making'
    END AS profitability_status
FROM ss_staging
GROUP BY category
ORDER BY total_profit DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------
# Profitability by Sub-Category
SELECT 
    category,
    sub_category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin_percent,
    
    RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS category_profit_rank,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS overall_profit_rank,
    CASE 
        WHEN SUM(profit) > 0 THEN 'Profitable'
        ELSE 'Loss-Making'
    END AS profitability_status
FROM ss_staging
GROUP BY category, sub_category
ORDER BY total_profit DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------
# Top 10 most profitable specific products
SELECT 
    product_id,
    product_name,
    category,
    sub_category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    ROUND(AVG(unit_price), 2) AS avg_unit_price,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_percent
FROM ss_staging
GROUP BY product_id, product_name, category, sub_category
HAVING total_sales > 0  
ORDER BY total_profit DESC
LIMIT 10;
-------------------------------------------------------------------------------------------------------------------------------------------------
# Top 10 least profitable products
-- Top 10 Least Profitable Products (Biggest Losses)
SELECT 
    product_id,
    product_name,
    category,
    sub_category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_percent,
    ROUND(AVG(unit_price), 2) AS avg_unit_price,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_percent
FROM ss_staging
GROUP BY product_id, product_name, category, sub_category
HAVING total_sales > 0  
ORDER BY total_profit ASC  
LIMIT 10;
-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
-- ANALYSIS OF LOSS-MAKING PRODUCTS CONCENTRATION

SELECT 
    category,
    -- Product counts
    COUNT(DISTINCT product_id) AS total_products,
    SUM(CASE WHEN total_profit < 0 THEN 1 ELSE 0 END) AS loss_making_products,
    ROUND(SUM(CASE WHEN total_profit < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT product_id), 2) AS loss_product_percentage,
    
    -- Sales volume
    SUM(total_quantity) AS total_quantity_sold,
    SUM(CASE WHEN total_profit < 0 THEN total_quantity ELSE 0 END) AS loss_maker_quantity,
    ROUND(SUM(CASE WHEN total_profit < 0 THEN total_quantity ELSE 0 END) * 100.0 / SUM(total_quantity), 2) AS loss_maker_quantity_percentage,
    
    -- Financial metrics
    ROUND(SUM(total_profit), 2) AS net_profit,
    ROUND(SUM(CASE WHEN total_profit < 0 THEN total_profit ELSE 0 END), 2) AS total_loss_amount,
    
    -- Loss leader assessment
    CASE 
        WHEN SUM(CASE WHEN total_profit < 0 THEN total_quantity ELSE 0 END) > AVG(total_quantity) * 2 THEN 'Potential Loss Leader Category'
        ELSE 'Regular Category'
    END AS loss_leader_assessment

FROM (
    SELECT 
        category,
        product_id,
        SUM(quantity) AS total_quantity,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM ss_staging
    GROUP BY category, product_id
) product_summary
GROUP BY category
ORDER BY loss_maker_quantity_percentage DESC, total_loss_amount DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
/*
CUSTOMER SEGMENTATION AND SALES ANALYSIS

Who are our most valuable customers? Can we segment them by sales, profit, or region? 
What patterns distinguish high-value customers from others? (e.g., do they buy specific categories, respond to discounts, come from certain regions?) 

*/

-- Most valuable Customers: 
# Top Customers by Total Sales & Profit

SELECT 
    customer_id,
    customer_name,
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(profit_margin), 2) AS avg_profit_margin
FROM ss_staging
GROUP BY customer_id, customer_name, region
ORDER BY total_profit DESC
LIMIT 3;
-------------------------------------------------------------------------------------------------------------------------------------------------
# Customer segmentation by profit and tier
SELECT 
    customer_name,
    region,
    total_sales,
    total_profit,
    CASE 
        WHEN total_profit > 10000 THEN 'Platinum'
        WHEN total_profit BETWEEN 5000 AND 10000 THEN 'Gold'
        WHEN total_profit BETWEEN 1000 AND 5000 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_tier,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM (
    SELECT 
        customer_name,
        region,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM ss_staging
    GROUP BY customer_name, region
) customer_summary
ORDER BY total_profit DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------
# Regional customer value analysis

SELECT 
    region,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales), 2) AS regional_sales,
    ROUND(SUM(profit), 2) AS regional_profit,
    ROUND(AVG(profit), 2) AS avg_profit_per_customer,
    SUM(CASE WHEN profit > 0 THEN 1 ELSE 0 END) AS profitable_customers,
    ROUND(SUM(CASE WHEN profit > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT customer_id), 2) AS profitability_rate
FROM (
    SELECT 
        region,
        customer_id,
        SUM(sales) AS sales,
        SUM(profit) AS profit
    FROM ss_staging
    GROUP BY region, customer_id
) customer_metrics
GROUP BY region
ORDER BY regional_profit DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------
-- Patterns distinguishing high-value customers 

# RFM Analysis (Recency, Frequency, Monetary)

WITH customer_metrics AS (
  SELECT 
    customer_id,
    region,
    COALESCE(DATEDIFF('2020-09-09', MAX(order_date)), 365) as Recency,
    COUNT(DISTINCT order_id) as Frequency,
    ROUND(COALESCE(SUM(sales), 0), 2) as Monetary,
    ROUND(COALESCE(SUM(profit), 0), 2) as Total_Profit,
    AVG(profit) as Avg_Profit_Per_Order
  FROM ss_staging
  GROUP BY customer_id, region
),
rfm_scores AS (
  SELECT *,
    CASE 
      WHEN Recency <= 30 THEN 5    -- Last 30 days
      WHEN Recency <= 90 THEN 4    -- Last 3 months
      WHEN Recency <= 180 THEN 3   -- Last 6 months
      WHEN Recency <= 365 THEN 2   -- Last year
      ELSE 1                       -- Over 1 year
    END as R_Score,
    CASE 
      WHEN Frequency >= 15 THEN 5
      WHEN Frequency >= 10 THEN 4
      WHEN Frequency >= 5 THEN 3
      WHEN Frequency >= 2 THEN 2
      ELSE 1
    END as F_Score,
    CASE 
      WHEN Monetary >= 5000 THEN 5
      WHEN Monetary >= 2500 THEN 4
      WHEN Monetary >= 1000 THEN 3
      WHEN Monetary >= 500 THEN 2
      ELSE 1
    END as M_Score
  FROM customer_metrics
)
SELECT 
  customer_id,
  region,
  Recency,
  Frequency,
  Monetary,
  Total_Profit,
  R_Score,
  F_Score,
  M_Score,
  (R_Score + F_Score + M_Score) as RFM_Score,
  CASE 
    WHEN R_Score = 5 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
    WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 3 THEN 'Loyal Customers'
    WHEN R_Score = 5 AND F_Score <= 2 THEN 'New Customers'
    WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Potential Loyalists'
    WHEN R_Score = 2 AND M_Score >= 3 THEN 'At Risk'
    WHEN R_Score = 1 THEN 'Lost Customers'
    WHEN Total_Profit < 0 THEN 'Unprofitable'
    ELSE 'Need Attention'
  END as Segment
FROM rfm_scores
ORDER BY Monetary DESC, Recency ASC;
-------------------------------------------------------------------------------------------------------------------------------------------------
-- What patterns distinguish high-value customers?
-- Comparing high-value customers segments vs other customers using RFM segments

WITH customer_analysis AS (
  SELECT 
    customer_id,
    -- RFM Metrics
    COALESCE(DATEDIFF('2020-09-09', MAX(order_date)), 365) as recency,
    COUNT(DISTINCT order_id) as frequency,
    COALESCE(SUM(sales), 0) as monetary,
    COALESCE(SUM(profit), 0) as total_profit,
    
    -- Value Segment
    CASE 
      WHEN COALESCE(SUM(sales), 0) >= 10000 THEN 'Platinum'
      WHEN COALESCE(SUM(sales), 0) >= 5000 THEN 'Gold'
      WHEN COALESCE(SUM(sales), 0) >= 1000 THEN 'Silver'
      ELSE 'Bronze'
    END as value_segment,
    
    -- Additional metrics
    AVG(sales) as avg_order_value,
    AVG(discount) * 100 as discount_rate_pct,
    SUM(CASE WHEN category = 'Furniture' THEN sales ELSE 0 END) as furniture_sales,
    SUM(CASE WHEN category = 'Office Supplies' THEN sales ELSE 0 END) as office_supplies_sales,
    SUM(CASE WHEN category = 'Technology' THEN sales ELSE 0 END) as technology_sales,
    SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) as return_count
  FROM ss_staging
  GROUP BY customer_id
)

SELECT
    value_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary), 2) AS avg_sales,
    ROUND(AVG(total_profit), 2) AS avg_profit,
    ROUND(AVG(frequency), 2) AS avg_orders,
    ROUND(AVG(monetary / NULLIF(frequency, 0)), 2) AS avg_order_value,
    ROUND(AVG(discount_rate_pct), 2) AS avg_discount_rate,
    ROUND(AVG(furniture_sales) / AVG(monetary) * 100, 2) AS furniture_pct,
    ROUND(AVG(office_supplies_sales) / AVG(monetary) * 100, 2) AS office_supplies_pct,
    ROUND(AVG(technology_sales) / AVG(monetary) * 100, 2) AS technology_pct,
    ROUND(AVG(return_count), 2) AS avg_returns
FROM
    customer_analysis
GROUP BY
    value_segment
ORDER BY
    CASE value_segment
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
        ELSE 4
    END;

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
/*
CUSTOMER SEGMENTATION AND SALES ANALYSIS 

# Who are our most valuable customers? Can we segment them by sales, profit, or region?
# What patterns distinguish high-value customers from others? (e.g., do they buy specific categories, respond to discounts, come from certain regions?)

*/
	-- determining the most valuable customers
    -- segmenting customers by sales, profits, and region
    -- patterns distinguishing high-value customers from the rest
    
-- Step 1: Creating a temporary table for customer metrics
CREATE TEMPORARY TABLE customer_metrics AS
SELECT
    customer_id,
    customer_name,
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    ROUND(SUM(discount_amount), 2) AS total_discount_amount,
    ROUND(SUM(discount_amount) / SUM(sales) * 100, 2) AS discount_rate_pct,
    
    -- Category preferences
    ROUND(SUM(CASE WHEN category = 'Furniture' THEN sales ELSE 0 END), 2) AS furniture_sales,
    ROUND(SUM(CASE WHEN category = 'Office Supplies' THEN sales ELSE 0 END), 2) AS office_supplies_sales,
    ROUND(SUM(CASE WHEN category = 'Technology' THEN sales ELSE 0 END), 2) AS technology_sales,
    
    -- Return behavior
    SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) AS return_count
FROM
    ss_staging
GROUP BY
    customer_id, customer_name, region;

-- Step 2: Calculating percentile values for segmentation
SET @profit_80 = (SELECT MAX(total_profit) FROM (
    SELECT total_profit FROM customer_metrics ORDER BY total_profit DESC LIMIT 80
) t);
SET @profit_60 = (SELECT MAX(total_profit) FROM (
    SELECT total_profit FROM customer_metrics ORDER BY total_profit DESC LIMIT 60
) t);
SET @profit_40 = (SELECT MAX(total_profit) FROM (
    SELECT total_profit FROM customer_metrics ORDER BY total_profit DESC LIMIT 40
) t);

SET @sales_80 = (SELECT MAX(total_sales) FROM (
    SELECT total_sales FROM customer_metrics ORDER BY total_sales DESC LIMIT 80
) t);
SET @sales_60 = (SELECT MAX(total_sales) FROM (
    SELECT total_sales FROM customer_metrics ORDER BY total_sales DESC LIMIT 60
) t);

-- Step 3: Creating a temporary table with segmentation
CREATE TEMPORARY TABLE customer_segmented AS
SELECT
    customer_id,
    customer_name,
    region,
    total_sales,
    total_profit,
    order_count,
    avg_order_value,
    discount_rate_pct,
    
    -- Value segmentation
    CASE
        WHEN total_profit > @profit_80 AND total_sales > @sales_80 THEN 'Platinum'
        WHEN total_profit > @profit_60 AND total_sales > @sales_60 THEN 'Gold'
        WHEN total_profit > @profit_40 THEN 'Silver'
        ELSE 'Bronze'
    END AS value_segment,

    -- Discount responsiveness
    CASE
        WHEN discount_rate_pct > 15 THEN 'Discount-Driven'
        WHEN discount_rate_pct BETWEEN 5 AND 15 THEN 'Moderate-Discount'
        ELSE 'Full-Price'
    END AS discount_segment,
    
    -- Category preferences
    furniture_sales,
    office_supplies_sales,
    technology_sales,
    return_count
FROM
    customer_metrics;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- segmented data
SELECT * FROM customer_segmented ORDER BY total_profit DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- using the segmented data i want to answer the following three questions:
-- 1. Who are our most valuable 20 customers?
SELECT
    customer_id,
    customer_name,
    region,
    total_sales,
    total_profit,
    order_count,
    avg_order_value,
    value_segment
FROM
    customer_segmented
ORDER BY
    total_profit DESC
LIMIT 20;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 2. What patterns distinguish high-value customers?
SELECT
    value_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_sales), 2) AS avg_sales,
    ROUND(AVG(total_profit), 2) AS avg_profit,
    ROUND(AVG(order_count), 2) AS avg_orders,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(AVG(discount_rate_pct), 2) AS avg_discount_rate,
    ROUND(AVG(furniture_sales), 2) AS avg_furniture_sales,
    ROUND(AVG(office_supplies_sales), 2) AS avg_office_supplies_sales,
    ROUND(AVG(technology_sales), 2) AS avg_technology_sales,
    ROUND(AVG(return_count), 2) AS avg_returns
FROM
    customer_segmented
GROUP BY
    value_segment
ORDER BY
    CASE value_segment
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
        ELSE 4
    END;

------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Regional analysis of high-value customers:
SELECT
    region,
    value_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_sales), 2) AS region_sales,
    ROUND(SUM(total_profit), 2) AS region_profit
FROM
    customer_segmented
GROUP BY
    region, value_segment
ORDER BY
    region,
    CASE value_segment
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
        ELSE 4
    END;

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
/*
PRODUCT AND INVENTORY MANAGEMENT ANALYSIS

Can we segment products into groups (e.g., "High-Profit Stars," "Low-Sale Negligibles," "High-Risk Return Items")?
*/		
        
-- segmenting products into groups
SELECT 
    ps.product_id,
    ps.product_name,
    ps.category,
    ps.sub_category,
    ps.total_sales,
    ps.total_profit,
    ps.avg_profit_margin,
    ps.return_rate,
    CASE 
        WHEN ps.total_profit > (SELECT AVG(total_profit) * 2 FROM (
            SELECT SUM(profit) AS total_profit
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
            AND ps.total_sales > (SELECT AVG(total_sales) * 1.5 FROM (
            SELECT SUM(sales) AS total_sales
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
            AND ps.return_rate < 0.1
        THEN 'High-Profit Stars'
        
        WHEN ps.total_sales < (SELECT AVG(total_sales) * 0.3 FROM (
            SELECT SUM(sales) AS total_sales
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
            AND ps.total_profit < (SELECT AVG(total_profit) * 0.3 FROM (
            SELECT SUM(profit) AS total_profit
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
        THEN 'Low-Sale Negligibles'
        
        WHEN ps.return_rate > 0.2 
            OR ps.return_count > (SELECT AVG(return_count) * 2 FROM (
            SELECT SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) AS return_count
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
        THEN 'High-Risk Return Items'
        
        WHEN ps.avg_profit_margin > (SELECT AVG(avg_profit_margin) * 1.5 FROM (
            SELECT AVG(profit_margin) AS avg_profit_margin
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
            AND ps.total_sales > (SELECT AVG(total_sales) FROM (
            SELECT SUM(sales) AS total_sales
            FROM ss_staging
            GROUP BY product_id
        ) AS t)
        THEN 'High-Margin Performers'
        
        WHEN ps.avg_profit_margin < 0
        THEN 'Loss-Makers'
        
        ELSE 'Standard Products'
    END AS product_segment
FROM (
    SELECT 
        product_id,
        product_name,
        category,
        sub_category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        SUM(quantity) AS total_quantity,
        AVG(profit_margin) AS avg_profit_margin,
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) AS return_count,
        SUM(CASE WHEN returned = 'Yes' THEN quantity ELSE 0 END) AS return_quantity,
        CASE 
            WHEN SUM(quantity) = 0 THEN 0 
            ELSE SUM(CASE WHEN returned = 'Yes' THEN quantity ELSE 0 END) / SUM(quantity)
        END AS return_rate
    FROM ss_staging
    GROUP BY product_id, product_name, category, sub_category
) AS ps
ORDER BY ps.total_profit DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------
/*

RETURN ANALYSIS

*/

-- Data processing
ALTER TABLE returns
RENAME COLUMN `Order ID` TO order_id;

ALTER TABLE returns
RENAME COLUMN Returned TO returned;


-- Creating a staging table
CREATE TABLE returns_staging AS
SELECT
    ss.order_id,
    ss.order_date,
    ss.ship_mode,
    ss.segment,
    ss.customer_name,
    ss.region,
    ss.product_id,
    ss.category,
    ss.sub_category,
    ss.product_name,
    ss.sales,
    ss.quantity,
    ss.profit,
    ss.total_cost,
    ss.unit_price,
    ss.discount_amount,
    r.returned
FROM
    ss_cleaned AS ss
JOIN
    returns AS r ON ss.order_id = r.order_id;

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
--  Returned Products
SELECT 
	region,
    segment,
    category,
    product_id,
    product_name,
	COUNT(*) as return_count
FROM returns_staging 
WHERE returned = 'Yes'  
GROUP BY product_id, product_name, region, category, segment
ORDER BY return_count DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------------------------------------------------------
