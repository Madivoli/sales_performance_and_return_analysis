//

-- Management Task 1: Return Impact

-- Objective: To identify sub-categories with a return rate exceeding 10% and quantify the total profit lost due to those returns.

//


SELECT 
    o.sub_category,
    COUNT(o.order_id ) AS Total_Orders,
    -- Calculate Return Rate: (Total Returns / Total Orders) * 100
    ROUND(
        COUNT(r.order_id) / COUNT(o.order_id) * 100, 
        2
    ) AS Return_Rate_Pct,
    -- Quantify the Profit Erosion: Sum of profit from returned orders
    ROUND(SUM(CASE WHEN r.order_id IS NOT NULL THEN o.profit ELSE 0 END), 2) AS Returned_Profit_Impact
FROM 
    orders AS o
LEFT JOIN 
    returns AS r ON o.order_id = r.order_id
GROUP BY 
    o.sub_category
HAVING 
    Return_Rate_Pct > 10
ORDER BY 
    Return_Rate_Pct DESC;


//

-- Management Task 2: Discount Optimization and Margin Health

-- Objective: To determine if aggressive discounting is driving volume or if it's just attracting "big loss" transactions.

//

SELECT 
    discount,
    ROUND(SUM(sales),2) AS Total_Sales,
    ROUND(SUM(profit), 2) AS Total_Profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS Profit_Margin_Pct
FROM 
    Orders
GROUP BY 
    discount
ORDER BY 
    discount ASC;



//

-- Management Task 3: Operational Bottleneck Identification

-- Objective: To determine which regional manager has the highest average shipping duration and the correlation between shipping times and return rates.

//

SELECT 
    p.person AS Manager,
    p.region,
    -- In MySQL, DATEDIFF is simply (end_date, start_date)
    ROUND(AVG(DATEDIFF(o.ship_date, o.order_date)), 2) AS Avg_Shipping_Duration,
    ROUND(SUM(CASE WHEN r.order_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(o.order_id) * 100, 2) AS Return_Rate_Pct
FROM 
    orders AS o
JOIN 
    sales_rep AS p ON o.region = p.region
LEFT JOIN 
    returns AS r ON o.order_id = r.order_id
GROUP BY 
    p.person, 
    p.region
ORDER BY 
    Avg_Shipping_Duration DESC;


//

-- Management Task 4: Customer Profiling

-- Objective: To identify the top 5% of customers in terms of Lifetime Value (LTV) who have a Return Rate of 0%.

//

WITH CustomerSummary AS (
    -- Step 1: Calculate total profit and return count for every customer
    SELECT 
        o.customer_name,
        o.segment,
        SUM(o.profit) AS Total_LTV,
        COUNT(r.order_id) AS Total_Returns
    FROM 
        orders AS o
    LEFT JOIN 
        returns r ON o.order_id = r.order_id
    GROUP BY 
        o.customer_name, o.segment
),
FilteredLoyalists AS (
    -- Step 2: Filter for 0% Return Rate and calculate percentiles
    SELECT 
        customer_name,
        segment,
        Total_LTV,
        PERCENT_RANK() OVER (ORDER BY Total_LTV DESC) as LTV_Rank
    FROM 
        CustomerSummary
    WHERE 
        Total_Returns = 0
)
-- Step 3: Select the Top 5% (where rank is 0.05 or lower)
SELECT 
    customer_name,
    segment,
    ROUND(Total_LTV, 2) AS Lifetime_Value
FROM 
    FilteredLoyalists
WHERE 
    LTV_Rank <= 0.05
ORDER BY 
    Total_LTV DESC;



//

-- Management Task 5: Inventory Risk and Overstock Mitigation

-- Objective: To identify products that have high quantity sold but fall into the bottom 10% of total profit. This identifies high-effort, low-reward inventory.
-- This query uses a CTE to aggregate product performance and then identifies the bottom 10% of profit earners that exceed the average quantity sold.

//

WITH ProductPerformance AS (
    -- Step 1: Aggregating quantity and profit by product
    SELECT 
        product_name, 
        sub_category,
        SUM(quantity) AS total_quantity, 
        ROUND(SUM(profit), 2) AS total_profit
    FROM orders
    GROUP BY product_name, sub_category
),
RankedProducts AS (
    
	-- Step 2: Calculating profit percentiles and the quantity benchmark
    SELECT 
        *,
        PERCENT_RANK() OVER (ORDER BY total_profit ASC) AS profit_percentile,
        AVG(total_quantity) OVER () AS global_avg_quantity
    FROM ProductPerformance
)
-- Step 3: Filtering for the "high-effort, low-reward" quadrant
SELECT 
    product_name, 
    sub_category,
    total_quantity, 
    total_profit
FROM RankedProducts
WHERE profit_percentile <= 0.10  -- Bottom 10% of profit
  AND total_quantity > global_avg_quantity -- High effort (above average volume)
ORDER BY total_quantity DESC;