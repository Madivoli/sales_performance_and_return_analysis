𝗖𝗛𝗘𝗖𝗞𝗜𝗡𝗚 𝗙𝗢𝗥 𝗢𝗨𝗧𝗟𝗜𝗘𝗥𝗦

To check for outliers in the dataset, I used the 𝗜𝗻𝘁𝗲𝗿𝗾𝘂𝗮𝗿𝘁𝗶𝗹𝗲 𝗥𝗮𝗻𝗴𝗲 (𝗜𝗤𝗥) 𝗺𝗲𝘁𝗵𝗼𝗱 and generated boxplots for the key numerical columns: 
- Sales,
- Quantity,
- Discount,
- Profit, and
- Days to Ship.

<br>

𝗢𝘂𝘁𝗹𝗶𝗲𝗿 𝗔𝗻𝗮𝗹𝘆𝘀𝗶𝘀 𝗦𝘂𝗺𝗺𝗮𝗿𝘆

1.	𝗦𝗮𝗹𝗲𝘀 (𝟭,𝟰𝟭𝟭 𝗼𝘂𝘁𝗹𝗶𝗲𝗿𝘀):
- 𝗙𝗶𝗻𝗱𝗶𝗻𝗴: We have a significant number of high-value sales. The 𝗺𝗮𝘅𝗶𝗺𝘂𝗺 𝘀𝗮𝗹𝗲 𝗶𝘀 $𝟮𝟮,𝟲𝟯𝟴, whereas the 𝟳𝟱𝘁𝗵 𝗽𝗲𝗿𝗰𝗲𝗻𝘁𝗶𝗹𝗲 𝗶𝘀 𝗼𝗻𝗹𝘆 $𝟮𝟭𝟬.𝟵𝟭.
- 𝗔𝗰𝘁𝗶𝗼𝗻: These aren't necessarily bad data; they represent bulk orders or high-ticket items (like Copiers). We should keep them, but be aware that they will skew average sales metrics.

<br>

2.	𝗣𝗿𝗼𝗳𝗶𝘁 (𝟮,𝟮𝟳𝟭 𝗼𝘂𝘁𝗹𝗶𝗲𝗿𝘀):
- 𝗙𝗶𝗻𝗱𝗶𝗻𝗴: This column has the most extreme spread, ranging from a 𝗹𝗼𝘀𝘀 𝗼𝗳 -$𝟲,𝟱𝟵𝟵 𝘁𝗼 𝗮 𝗽𝗿𝗼𝗳𝗶𝘁 𝗼𝗳 $𝟴,𝟯𝟵𝟵.
- 𝗔𝗰𝘁𝗶𝗼𝗻: These extreme losses are critical for our returns investigation. We need to see whether these large losses correlate with deep discounts or specific product categories.

<br>
  
3.	Discount (1,022 outliers):
- 𝗙𝗶𝗻𝗱𝗶𝗻𝗴:  Most discounts are 𝗯𝗲𝘁𝘄𝗲𝗲𝗻 𝟬% 𝗮𝗻𝗱 𝟮𝟬%. Any discount above 𝟱𝟬% (𝗜𝗤𝗥 𝘂𝗽𝗽𝗲𝗿 𝗯𝗼𝘂𝗻𝗱) 𝗶𝘀 𝗳𝗹𝗮𝗴𝗴𝗲𝗱 𝗮𝘀 𝗮𝗻 𝗼𝘂𝘁𝗹𝗶𝗲𝗿.
- 𝗔𝗰𝘁𝗶𝗼𝗻: We should investigate if these high-discount items are the ones being returned most frequently.

<br>

4.	Quantity (214 outliers):
- 𝗙𝗶𝗻𝗱𝗶𝗻𝗴:  Most customers buy 𝟮–𝟱 𝗶𝘁𝗲𝗺𝘀. Orders of 𝟭𝟬–𝟭𝟰 𝗶𝘁𝗲𝗺𝘀 𝗮𝗿𝗲 𝗳𝗹𝗮𝗴𝗴𝗲𝗱 𝗮𝘀 𝗼𝘂𝘁𝗹𝗶𝗲𝗿𝘀.

<br>

5.	Days to Ship (0 outliers):
- 𝗙𝗶𝗻𝗱𝗶𝗻𝗴:  Shipping is very consistent, ranging from 𝟬 𝘁𝗼 𝟴 𝗱𝗮𝘆𝘀, with no statistical outliers. This means our shipping process is stable.
