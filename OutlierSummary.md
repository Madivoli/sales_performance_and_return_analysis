𝗖𝗛𝗘𝗖𝗞𝗜𝗡𝗚 𝗙𝗢𝗥 𝗢𝗨𝗧𝗟𝗜𝗘𝗥𝗦

To check for outliers in the dataset, I used the 𝗜𝗻𝘁𝗲𝗿𝗾𝘂𝗮𝗿𝘁𝗶𝗹𝗲 𝗥𝗮𝗻𝗴𝗲 (𝗜𝗤𝗥) 𝗺𝗲𝘁𝗵𝗼𝗱 and generated boxplots for the key numerical columns: Sales, Quantity, Discount, Profit, and Days to Ship.

Outlier Analysis Summary

1.	Sales (1,411 outliers): * Finding: We have a significant number of high-value sales. The maximum sale is $22,638, whereas the 75th percentile is only $210.91.
o	Action: These aren't necessarily "bad" data; they represent bulk orders or high-ticket items (like Copiers). We should keep them but be aware they will skew "Average Sales" metrics.
2.	Profit (2,271 outliers): * Finding: This column has the most extreme spread, ranging from a loss of -$6,599 to a profit of $8,399.
o	Action: These extreme losses are critical for our "Returns Investigation." We need to see if these huge losses correlate with high discounts or specific product categories.
3.	Discount (1,022 outliers):
o	Finding: Most discounts are between 0% and 20%. Any discount above 50% (IQR upper bound) is flagged as an outlier.
o	Insight: We should investigate if these high-discount items are the ones being returned most frequently.
4.	Quantity (214 outliers):
o	Finding: Most customers buy 2–5 items. Orders of 10–14 items are flagged as outliers.
5.	Days to Ship (0 outliers):
o	Finding: Shipping is very consistent, ranging from 0 to 8 days, with no statistical outliers. This means our shipping process is stable.
