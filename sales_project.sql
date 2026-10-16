
use sales_db;
-- KPI
SELECT 
    COUNT(Order_ID)            AS Total_Orders,
    ROUND(SUM(Sales_Amount),2) AS Total_Sales,
    ROUND(SUM(Profit),2)       AS Total_Profit,
    ROUND(AVG(Sales_Amount),2) AS Avg_Order_Value,
    ROUND(SUM(Profit)/SUM(Sales_Amount)*100, 2) AS Profit_Margin_Pct
FROM sales;
 -- Region-wise Performance-- 
 SELECT 
    Region,
    COUNT(Order_ID)            AS Orders,
    ROUND(SUM(Sales_Amount),2) AS Total_Sales,
    ROUND(SUM(Profit),2)       AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales_Amount)*100,2) AS Margin_Pct,
    RANK() OVER (ORDER BY SUM(Sales_Amount) DESC) AS Sales_Rank
FROM sales
GROUP BY Region
ORDER BY Total_Sales DESC;
 -- Category Analysis-- 
 SELECT 
    Category,
    Sub_Category,
    COUNT(*)                   AS Orders,
    ROUND(SUM(Sales_Amount),2) AS Revenue,
    ROUND(SUM(Profit),2)       AS Profit,
    ROUND(SUM(Profit)/SUM(Sales_Amount)*100,2) AS Margin_Pct
FROM sales
GROUP BY Category, Sub_Category
ORDER BY Revenue DESC;

-- Monthly trends -- 
 SELECT 
    YEAR(Order_Date)  AS Year,
    MONTH(Order_Date) AS Month_Num,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales_Amount),2) AS Monthly_Sales,
    ROUND(SUM(Profit),2)       AS Monthly_Profit,
    LAG(SUM(Sales_Amount)) OVER (ORDER BY YEAR(Order_Date), MONTH(Order_Date)) AS Prev_Month_Sales,
    ROUND((SUM(Sales_Amount) - LAG(SUM(Sales_Amount)) OVER 
        (ORDER BY YEAR(Order_Date), MONTH(Order_Date))) / 
        LAG(SUM(Sales_Amount)) OVER 
        (ORDER BY YEAR(Order_Date), MONTH(Order_Date)) * 100, 2) AS MoM_Growth_Pct
FROM sales
GROUP BY Year, Month_Num, Month_Name
ORDER BY Year, Month_Num;

-- Top 10 Products-- 
SELECT 
    Product_ID,
    Category,
    ROUND(SUM(Sales_Amount),2) AS Total_Sales,
    ROUND(SUM(Profit),2)       AS Total_Profit,
    SUM(Quantity)              AS Units_Sold
FROM sales
GROUP BY Product_ID, Category
ORDER BY Total_Sales DESC
LIMIT 10;


-- Customer Segmentation (RFM Basic)-- 

SELECT 
    Customer_ID,
    COUNT(Order_ID)            AS Frequency,
    ROUND(SUM(Sales_Amount),2) AS Monetary,
    MAX(Order_Date)            AS Last_Order,
    DATEDIFF(CURDATE(), MAX(Order_Date)) AS Recency_Days
FROM sales
GROUP BY Customer_ID
ORDER BY Monetary DESC
LIMIT 20;