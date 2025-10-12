## Superstore's Performance, Customer, and Product Analysis

![hanson-lu-sq5P00L7lXc-unsplash](https://github.com/user-attachments/assets/74fc54bb-9619-4bf2-98d0-559ff9517e1b)


## Project Overview

This dataset contains 11,978 transactional records for a superstore, including sales, profits, customer information, and product categories. The primary goal is to leverage this data to identify key drivers of profitability, understand customer purchasing behaviour, optimise product inventory and pricing, and ultimately provide actionable insights to increase overall store performance and reduce losses from returned items.

---
## Objectives and Business Questions

To analyse 4 key areas and answer the following business questions:

**1. Profitability & Loss Analysis:**

    • Which product categories, sub-categories, or specific products are the most and least profitable? 
	• What are the key factors that correlate with a product or order generating a loss (negative profit)? 
    • Are the loss-making products concentrated in certain categories that might be used to attract customers? 
	• Is there a relationship between discount levels and profitability? At what discount level do products typically become unprofitable? 
    
**2. Customer Segmentation and Sales Analysis:**

    • Who are our most valuable customers? Can we segment them by sales, profit, or region?
    • What patterns distinguish high-value customers from others? 
	• How do sales fluctuate over time, and are there seasonal peaks?
    • Is there a relationship between the quantity of items purchased, the discount offered, and the total sales value? 
    
**3. Product and Inventory Management:**

    • Can we segment products into groups to tailor marketing and inventory strategies? 
    • How do sales and profit performance vary by category and sub-category?
    • What is the typical sales amount and profit margin based on category and region? 
    
**4. Returns Analysis:**

    • Why are products being returned? What patterns distinguish returned orders from kept orders? 
    • Can we predict the probability of an order being returned based on factors like discount, product category, and profit? 

---

## Methods

    1. Descriptive Analytics: Summarising key metrics (total sales, average profit, overall profit margin, return rate, quantity sold by category). 
    2. Correlation Analysis: Identifying relationships between variables (e.g., discount vs. profit, sales vs. quantity, profit vs. probability of return).
    3. Predictive Modelling: Using historical data to predict future outcomes (e.g., Logistic Regression to predict if an order will be returned based on discount, category, or profit).
    4. Clustering: Using algorithms like K-Means to segment customers into distinct groups based on their total sales, profit generated, and frequency of orders.

---

## Tools 

	• Excel: Initial data exploration and visualisation.
	• MySQL: To query the database and prepare specific datasets for deeper analysis.
	• Python (Pandas, Scikit-learn, Seaborn, Matplotlib): The primary tool for data cleaning, processing, manipulation and deep analysis.
	• Tableau: To build an interactive Superstore Performance Dashboard for management.
       
---

## Procedures

**Data Processing, Cleaning and Manipulation**

1. **Join and save file**: Joined and saved multiple Excel files (2016 - 2020 Orders) into a combined CSV file.
2. **Rename columns**: Renamed columns in the CSV file.
3.  **Fix data types**: Converted order_date and ship_date to datetime objects for accurate analysis.
4. **Handle missing data**: Checked and removed null values in the returned column.
5. **Remove duplicates**: Checked and removed duplicate rows.
6. **Reset the table's index column**:To ensure that the index is sequential without any gaps from the removed row.
7. **Add new calculated columns:** Calculated profit margin, unit price, total cost, discount amount, net sales, net profit margin, and order processing time, in days columns for better comparisons.    

   
 ---  

 **Exploratory Data Analysis**
 
Calculated KPIs:
	<img width="1350" height="489" alt="image" src="https://github.com/user-attachments/assets/e4bd2da2-7455-4b59-b8c3-1f71de242828" />

**Key Insights:**
- There are a total of **793 customers**, with an average of **7.42 orders per customer (OPC)**.
- The **Average Order Value (AOV) is $1,865**, driven by a significant number of units sold per transaction, averaging 30 units.
- The average **discount percentage is 15.58%**, indicating that the business relies heavily on discounts to stimulate sales.
- The business maintains a **profit margin of 12%**, which is commendable given the high discount rate.
- The difference between the **average selling price** and **average cost per unit is $7.85**. With a discount of 15.58% on the average price, this amounts to $9.75.
- The business is effectively "giving away" more in discounts ($9.75) than it retains as gross profit per unit ($7.85). 

**Recommendations:**

Based on the KPI analysis, the business should consider the following:

1. **Protecting and Nurturing the Customer Base**: The business should initiate initiatives to improve customer retention, such as loyalty programs, exclusive offers, and exceptional service. These strategies will yield a much higher return than focusing solely on acquiring new customers with similar lifetime values.

2. **Analyse the Discount Strategy**: The business should use discounts strategically to attract new customers or clear out slow-selling inventory, rather than applying them as a blanket policy or for merely retaining loyal customers. Additionally, it may be beneficial to reduce the discount percentage, for example to 14%, to evaluate its impact on profits or sales volume.

3. **Increase Customer Lifetime Value (LTV)**: Since customers tend to make frequent purchases, the business can encourage them to add one more item to each order through upselling or cross-selling strategies. It might also consider introducing a new, higher-margin product to the lineup.

---

## Profitability & Loss Analysis

**Which product categories, sub-categories, or specific products are the most and least profitable?**

-- Profitability by category (ranked from the most to the least profitable):

<img width="1202" height="452" alt="image" src="https://github.com/user-attachments/assets/44ad94de-2029-4622-87c2-5f0cdba69044" />

  

-- Profitability by sub-categories

<img width="1202" height="622" alt="image" src="https://github.com/user-attachments/assets/29b2bde1-ea22-4e20-86b7-2795aecb6ba4" />



-- Top 10 most profitable specific products

<img width="1202" height="632" alt="image" src="https://github.com/user-attachments/assets/eb83ca8b-46e9-411f-901e-ac8b7a93a2f9" />


-- Top 10 least profitable products 

<img width="1202" height="555" alt="image" src="https://github.com/user-attachments/assets/676a6e6f-d7a3-436f-ac37-11101e17134a" />


---

**What factors correlate with a product or an order generating a loss (negative profit)?**
        
<img width="975" height="695" alt="image" src="https://github.com/user-attachments/assets/d4d42373-3e5a-419f-ab2f-151ba2aa95fa" />


**Key Insight:** 

- There is **a strong positive correlation between discount and is_loss** (r = 0.753921). This suggests that a higher discount is significantly associated with a higher likelihood of a transaction resulting in a loss. In other words, larger discounts directly reduce profit margins.
- There is **a weak positive correlation between the dollar amount of the discount and is_loss** (r = 0.169223). This suggests that a higher absolute dollar discount also correlates with losses. Larger discount amounts (in dollars) increase the risk of incurring losses.
- The **correlation between total cost and is_loss is very weak** (r = 0.118892). The cost of an item has little to no direct linear relationship with whether a transaction results in a loss. Other factors, such as sales price and discount, play a more significant role.
- Unit price, sales, processing days, and quantity show **no significant linear relationship with the occurrence of a loss**. All of these variables have correlations very close to zero, ranging from -0.002504 to 0.025537.
- Profit margin (r = -0.765811) has **a strong negative correlation**. As the profit margin decreases, the likelihood of a loss increases. A low profit margin directly leads to a loss, while higher profit margins strongly protect against losses.
- Net profit margin (r = -0.591829) exhibits **a moderately strong negative correlation**. Similar to profit margin, a lower net profit margin is associated with a greater chance of incurring a loss.
- There is **a weak negative relationship between profit and is_loss** (r = -0.234539). As profit decreases, the likelihood of a loss tends to increase.

---

**Is there a relationship between discount levels and profit margin? At what discount level do products typically become unprofitable?**

<img width="975" height="156" alt="image" src="https://github.com/user-attachments/assets/ee1cb8c9-f70a-4bb5-8c57-ee2739e70126" />


**Key Insight:** 

- There exists a **strong negative linear relationship between discount and profit margin**. This finding corroborates the previous correlation results (r = -0.76).
- The intercept of 42.63% indicates that **when the discount is 0%**, the **predicted profit margin is 42.63%**.
- The slope of -195.73 suggests that **for each 1 unit increase in discount, the profit margin is expected to decrease by 195.73 units**.
- The R-squared value of 0.7475 (or 74.8%) signifies that **74.8% of the variability in profit margin can be attributed to the discount variable alone**.
- Therefore, **discount serves as a very strong predictor of profit margin** within this model.


<img width="975" height="103" alt="image" src="https://github.com/user-attachments/assets/c90d5229-e6f4-4d1d-95e6-549793b04cfd" />


**Key Insight:** 

- The **products will become unprofitable when the discount exceeds 21.8%**.

---

**Are the loss-making products concentrated in certain categories that might be used to attract customers?**

-- Analysis of loss-making products concentration

<img width="1350" height="117" alt="image" src="https://github.com/user-attachments/assets/d830cd07-e535-4d61-a3be-6dc94a351923" />


**Key Insight:** 

- A significant 32.51% of all loss-making products are concentrated in a single category: Furniture.
- This suggests a highly uneven distribution of loss-making products across different categories.

----

## Customer Segmentation and Sales Analysis

**Who are our most valuable customers? Can we segment them by sales, profit, or region?**

-- Most valuable customers by sales and profits


<img width="1517" height="529" alt="image" src="https://github.com/user-attachments/assets/2370b654-0425-4bac-9c0c-9513c958b4e7" />


**Key Insight:** 

- Customer ID SC-20095 is **the most valuable customer**, as they generate the highest sales and profit.


-- Customer segmentation by profit and tier

  <img width="1022" height="677" alt="image" src="https://github.com/user-attachments/assets/293bde8a-a99d-496f-80da-63224b1c10e2" />


**Key Insight:** 

- The Gold Tier is the most profitable customer segment.
- Customers such as Sanjit Chand and Tamara Chand generate significantly more profit than customers in other tiers.
- Sanjit Chand, in particular, is a highly valuable customer, contributing over $9,000 in profit.

-- Regional customer value analysis

<img width="947" height="677" alt="image" src="https://github.com/user-attachments/assets/a5a4fd3e-9bf1-4dab-aeed-398c88b8861c" />


**Key Insight:** 

- The West region has the highest number of profitable customers, totalling 615, and boasts an impressive profitability rate of 90.31%.
- This indicates that more than 90% of customers in the West are profitable, making it the most valuable region for the business.


-- Customer segmentation 

 -- Segmenting customers into 4 value segments/tiers: Platinum, Gold, Silver and Bronze
 
<img width="1500" height="764" alt="image" src="https://github.com/user-attachments/assets/02806d85-c029-4d74-956d-574ab350582e" />


-- Using the segmented data to answer the following question:

-- Who are our most valuable 20 customers?


<img width="1502" height="677" alt="image" src="https://github.com/user-attachments/assets/41d703f3-d668-4f3b-b67d-ee7c1c104e85" />


**Key Insight:** 

- Greg Tran is **the most frequent purchaser**, with a total of **7 orders**.
- He is followed by Adrian Barton, who has placed 6 orders, and Maria Etezadi, who has made 5 orders.
- A small group of customers — Tran, Barton, Etezadi, and Gary Hwang — accounts for a significant portion of the total orders.
- In contrast, many customers have only placed 1 or 2 orders.
- This pattern indicates that a few customers are driving the majority of the transaction volume. This creates a significant business risk if any customer churns.

---

**What patterns distinguish high-value customers from others? (e.g., do they buy specific categories, respond to discounts, come from certain regions?)**

-- RFM Analysis (Recency, Frequency, Monetary) to distinguish customers' purchasing patterns

      
<img width="1500" height="1309" alt="image" src="https://github.com/user-attachments/assets/78180b42-1711-4bc9-a0ce-923a0506994a" />


**Key Insight:** 

- All customers have **a recency score of 2**, indicating that no one has made a purchase recently, which is a significant concern. The last order was placed 365 days ago.
- The **frequency score ranges from 1 to 4**, with a higher score indicating more recent orders.
- The **monetary score ranges from 1 to 5**, with a higher score indicating greater spending.
- All customers are categorised as "At Risk" due to their low R Score.


-- Comparing high-value customer segments vs other customers using RFM segments

<img width="977" height="644" alt="image" src="https://github.com/user-attachments/assets/2d1f1c8a-43b5-4c2c-9f7c-1962f24e4b64" />

**Key Insight:** 

- Customers in the **Platinum segment are the most valuable**, generating more than half of the total revenue.
- However, this creates significant business risk if any Platinum customers churn.
- The analysis **reveals a classic "whale curve",** where a small percentage of customers (in this case, the Platinum segment) drives the majority of business revenue.

-- Regional analysis of high-value customers

    
<img width="1502" height="581" alt="image" src="https://github.com/user-attachments/assets/9f18770a-2790-4463-95fc-873f141f037b" />

---

**How do sales fluctuate over time, and are there seasonal peaks?**

<img width="1502" height="592" alt="image" src="https://github.com/user-attachments/assets/d2128a85-ef4f-4f8c-9188-af4e15d7636b" />

**Key Observations:**

- **Q4 Performance:** In every year, the fourth quarter (Q4) has been the strongest for sales; that is, there have been huge spikes in Q4 sales. This consistent pattern indicates seasonality in the business, likely due to holiday shopping, year-end budget spending by clients, or the renewal of annual contracts.
-  **Q1 Volatility:** The first quarter has been the weakest for sales every year. It recorded its lowest sales in 2018 ($68,852), but showed significant growth in 2019 ($93,192) and 2020 ($123,145). Understanding the reasons behind this volatility—such as summer slowdowns or specific campaign timings—will be crucial for future forecasting.
-   **Accelerating Growth:** The growth from 2019 to 2020 is particularly remarkable, breaking the company out of its plateau and achieving its highest-ever quarterly sales.


---

**Is there a relationship between the quantity of items purchased, the discount offered, and the total sales value?**

<img width="1500" height="336" alt="image" src="https://github.com/user-attachments/assets/1efe945d-b49b-449f-b21e-6ad0e7a2ab26" />

**Key Insight:** 
- There is **a very weak positive relationship between the quantity purchased and total sales value**, indicating that selling more units does lead to higher sales.
- This suggests that the business does not heavily rely on volume-driven sales, as customers are not buying large quantities to secure better value.
- There is **no relationship between discount levels and sales value**, meaning that discounts are not driving additional sales revenue. **This is a critical finding!**
- The business's **discount strategy is ineffective at stimulating demand**, as customers are not buying more in dollar terms when discounts are offered. 

**Recommendations:**
1. Reevaluate the entire discount strategy. Discounts are negatively impacting profits (-0.224) without boosting sales (-0.022).
2. Consider eliminating or reducing discounts on low-responding products.
3. Test alternative promotions, such as bundling, loyalty programs, or free shipping.

**Recommended Actions:**
- **Immediate:** Audit current discount practices.  
- **Short-term:** Test removing discounts on select products to measure the impact.  
- **Medium-term:** Develop strategies for customer acquisition that do not rely on price reductions.  
- **Strategic:** Focus on increasing the average order value rather than just transaction volume.


-- Correlation heatmap

<img width="1341" height="1184" alt="image" src="https://github.com/user-attachments/assets/985bdfa9-5ebb-4ca6-8426-b222e3baf592" />

---

## Product and Inventory Management

**Can we segment products into groups to tailor marketing and inventory strategies?**

-- Segmenting products into groups 

The analysis categorized products into six segments:

1. **High-Profit Stars**: These products have both high sales volume and high profit margins, making them highly valuable to the business.
2. **Low-Sale Negligibles**: This group consists of products with very low sales volume and a reasonable profit margin.
3. **High-Risk Return Items**: These products sell well but come with a significant issue: a high return rate. 
4. **High-Margin Performers**: These products are highly profitable on a per-unit basis but do not sell in large volumes.
5. **Loss-Makers**: This category includes products that result in a loss for every sale. 
6. **Standard Products**: These are reliable, steady-selling products that generate decent profit margins, though not exceptionally high.

<img width="1515" height="302" alt="image" src="https://github.com/user-attachments/assets/b5f93714-69c1-40cc-8d9d-da5735d9547d" />

**Interpretation and Implications**

- The "Loss-Makers" group, which has recorded a loss of $266,018.97, represents **a segment of products actively diminishing the company's value** by over a quarter of a million dollars. Although this segment accounts for 24.14% (i.e., $2,648,667.13) of total sales ($10,973,246.50), it is **the largest contributor to losses**.
- High-Profit Stars and Standard Products are **the main generators of the net profit** of $1.317 million, contributing 56.62% and 27.54% of the profits, respectively. These products are effectively carrying the business and covering the losses incurred by the Loss-Makers.
- With a total of 702 products (38% of the total products), **Low-Sale Negligibles contributes only 2.95% to total sales and 2.97% to total profits**.
- **High-Profit Stars and Loss-Makers account for significant portions of gross sales**. High-Profit Stars represent 31.30% of total sales, while Loss-Makers account for 24.14%.
- High-Risk Return Items: The **presence of 238 returned products may be a hidden factor contributing to margin erosion.**


**Recommendations**

- **Eliminate the Loss-Makers**: The first step is to identify all products in this segment that produce negative value. After determining which products are causing losses,  discontinue, reprice, or reconfigure them. 
- **Analyze Low-Sale Negligibles**: After addressing the Loss-Makers, review the Low-Sale Negligibles. Reducing this group can lower inventory costs, simplify marketing efforts, and allow the business to concentrate resources on high-performing products.
- **Focus on High-Profit Products**: Once the Loss-Makers have been discontinued, identify the products that are driving profits (the High-Profit Stars and High-Margin Performers). Develop strategies to enhance their sales and defend their market position.

---

**How do products segments sales and profit performance vary by category (Furniture, Office Supplies, Technology) and sub-category?**

-- Sales performance by category 


<img width="1202" height="672" alt="image" src="https://github.com/user-attachments/assets/dd0f2f37-625f-4f61-9b4a-0ba43f399721" />


-- Profit performance by category 
<img width="1202" height="699" alt="image" src="https://github.com/user-attachments/assets/8e7dac39-8caa-4390-9c7d-f2b3426ac090" />


-- Sales performance by sub-category 
<img width="1202" height="677" alt="image" src="https://github.com/user-attachments/assets/be6bc60c-2329-4d7b-a002-8d130e6f14df" />


-- Profit performance by sub-category 

<img width="1202" height="1172" alt="image" src="https://github.com/user-attachments/assets/f3a9ff20-b5d6-4b8b-b7b2-357622e015df" />

---

**What is the typical sales amount and profit margin based on category and region?**

<img width="1502" height="586" alt="image" src="https://github.com/user-attachments/assets/6450218d-cd66-41e1-9c07-4b9a4041e392" />


---

## Returns Analysis

**Why are products being returned? What patterns distinguish returned orders from kept orders?**

-- Count of returned orders and return rate

<img width="1200" height="84" alt="image" src="https://github.com/user-attachments/assets/3227db7f-92c6-444a-894c-6b35fc60e448" />


**Key Insights:**

- From the analysis, the total number of orders were 11,978, from which **950 products were returned by customers**, representing a **7.93% return rate**.


-- By region

<img width="1200" height="336" alt="image" src="https://github.com/user-attachments/assets/f01f8291-f348-42f0-a1f9-fe3f648e9dcc" />
<img width="1200" height="595" alt="image" src="https://github.com/user-attachments/assets/f28a213e-3cef-48d6-ae8c-2b7ae444803c" />

**Key Insights:**

- The region with the highest and lowest return rates were the West (571 items) and the South (83 items), representing 15% and 4% of the total returns.
- The results show significant regional disparity in terms of product returns.


-- Return Distribution by Region

<img width="1200" height="197" alt="image" src="https://github.com/user-attachments/assets/a221a2d9-5eea-4a4f-b6c3-8060a099cda8" />

<img width="513" height="481" alt="image" src="https://github.com/user-attachments/assets/4b98eb8a-b5a7-441a-b1c1-31aea7ab21c7" />


**Key Insights:**

- The objective is to identify **where returns are concentrated**.
- The analysis shows that the West accounts for the majority of returns at 60%.
- In comparison, returns in the East, Central, and South regions are concentrated at 18.7%, 12.4%, and 8.7%, respectively.

  
--By Product

<img width="1200" height="420" alt="image" src="https://github.com/user-attachments/assets/f0c4ebe5-0ca3-4ba5-83ae-5e340c59e202" />

**Key Insights:**

- The **top 10 returned products** are adjustable height table (7 returns), staple envelope (6 returns), low pile carpets, binders, polypropylene holder, wall hangings, transparent covers, hanging binders, service call books, xerox, line scissors, and encore headset, each 4 returns.

-- Pattern Analysis 

<img width="975" height="392" alt="image" src="https://github.com/user-attachments/assets/63d46dd3-23df-4145-b060-fcaaa9fe5909" />

**Interpretation**

- All correlations are between -0.03 and +0.03, indicating very weak linear relationships with returns. 
- The most significant, albeit weak, factors are processing days and discounts. 
- There is a weak negative correlation between processing days and returns (r = -0.028), suggesting that slightly longer processing times are associated with a slight decrease in returns. 
- There is also a weak negative correlation between discounts and returns, implying that higher discounts are slightly associated with fewer returns. 
- Conversely, there is a positive weak correlation between profit margin and returns (r = 0.0113), indicating that products with higher profit margins have a slight tendency to have more returns.

**Conclusion**

- No single factor strongly predicts returns; returns are not concentrated in specific product types or customer behaviors.
- Discounts do not contribute to an increase in returns; in fact, they are slightly linked to a reduced likelihood of returns.
- Processing time is not a significant issue; faster processing does not lead to an increase in returns.

-- Deeper Analysis
- Since linear correlations are weak, we check for non-linear patterns
  
<img width="1200" height="1263" alt="image" src="https://github.com/user-attachments/assets/32f8e81a-3ef6-4f17-88ce-77fc7b1c74af" />

**Key Insights:**
- Three key issues are responsible for 80% of return problems: operations in the West region (which have return rates that are 3.5 times higher), Same Day shipping (with a 1.8 times higher return rate), and the Machines category (which has an 11.3% return rate).
- Addressing these three areas could reduce overall return rates by about 40% and significantly enhance profitability.
- The immediate focus should be on the West region operations, as this issue has the largest impact on return rates and associated costs.

---
**Can we predict the probability of an order being returned based on factors like discount, product category, and profit?**

-- Predictive model

<img width="1350" height="756" alt="image" src="https://github.com/user-attachments/assets/2c080422-bc3e-490e-b2fe-836949244fcc" />

**Interpretation:**

- The **model's accuracy of 92.07%** is quite impressive, indicating that it will correctly predict whether there will be returns 92 times out of 100.  
- Orders from the **West region are significantly more likely to be returned**, at 64%, compared to the other areas.  
- The **home office segment is less likely to have returns**, with a coefficient of -0.0913.  
- The **corporate segment is more likely to have returns**, with a coefficient of +0.032.  
- The **office supplies category is less likely to be returned**, with a coefficient of -0.021.  
- The **technology category is more likely to be returned**, with a coefficient of +0.041.  

**Recommendations:**

- Consider regional pricing to account for higher return costs in the West region.
- Conduct a **root cause analysis (RCA)** to identify the potential reasons for the high returns in the West region.
- Regional return policy adjustments.
- Quality control enhancements.
