USE superstore_project;

SELECT COUNT(*) AS total_records
FROM orders;
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    COUNT(DISTINCT `Customer ID`) AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders;

SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        (SUM(Profit) / SUM(Sales)) * 100, 2
    ) AS Profit_Margin_Percentage
FROM orders;

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        (SUM(Profit) / SUM(Sales)) * 100, 2
    ) AS Profit_Margin
FROM orders
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        (SUM(Profit) / SUM(Sales)) * 100, 2
    ) AS Profit_Margin
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        (SUM(Profit) / SUM(Sales)) * 100, 2
    ) AS Profit_Margin
FROM orders
GROUP BY Segment
ORDER BY Total_Sales DESC;

SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS Order_Month,
    ROUND(SUM(Sales), 2) AS Monthly_Sales,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM orders
GROUP BY DATE_FORMAT(`Order Date`, '%Y-%m')
ORDER BY Order_Month;

SELECT
    COUNT(*) AS Future_Dated_Records,
    MIN(`Order Date`) AS First_Future_Date,
    MAX(`Order Date`) AS Last_Future_Date
FROM orders
WHERE `Order Date` > CURDATE();

CREATE OR REPLACE VIEW orders_valid AS
SELECT *
FROM orders
WHERE `Order Date` <= CURDATE();

SELECT
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS Profit_Margin
FROM orders_valid
GROUP BY `Sub-Category`
ORDER BY Total_Profit DESC;

SELECT
    Discount,
    COUNT(*) AS Total_Records,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2
    ) AS Profit_Margin
FROM orders_valid
GROUP BY Discount
ORDER BY Discount;

SELECT
    `Product Name`,
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders_valid
GROUP BY `Product Name`, `Sub-Category`
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

SELECT
    YEAR(`Order Date`) AS Order_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin
FROM orders_valid
GROUP BY YEAR(`Order Date`)
ORDER BY Order_Year;

SELECT
    `Ship Mode`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Profit_Margin
FROM orders_valid
GROUP BY `Ship Mode`
ORDER BY Total_Profit DESC;

SELECT
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders_valid
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Profit DESC
LIMIT 10;

SELECT
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders_valid
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Profit ASC
LIMIT 10;

USE superstore_project;

SHOW TABLES;
USE superstore_project;

SELECT COUNT(*) AS Total_Return_Records
FROM returns;

SELECT *
FROM returns
LIMIT 10;

SELECT COUNT(*) AS Total_Return_Records
FROM returns;

SELECT
    COUNT(DISTINCT o.`Order ID`) AS Total_Orders,
    COUNT(DISTINCT r.`Order ID`) AS Returned_Orders,
    ROUND(
        COUNT(DISTINCT r.`Order ID`) * 100.0 /
        COUNT(DISTINCT o.`Order ID`),
        2
    ) AS Return_Rate_Percentage
FROM orders_valid o
LEFT JOIN returns r
    ON o.`Order ID` = r.`Order ID`
WHERE r.Returned = 'Yes'
   OR r.Returned IS NULL;
   
   SELECT
    o.Category,
    COUNT(DISTINCT o.`Order ID`) AS Total_Orders,
    COUNT(DISTINCT r.`Order ID`) AS Returned_Orders,
    ROUND(
        COUNT(DISTINCT r.`Order ID`) * 100.0 /
        COUNT(DISTINCT o.`Order ID`),
        2
    ) AS Return_Rate
FROM orders_valid o
LEFT JOIN returns r
    ON o.`Order ID` = r.`Order ID`
    AND r.Returned = 'Yes'
GROUP BY o.Category
ORDER BY Return_Rate DESC;

SELECT
    o.Region,
    COUNT(DISTINCT o.`Order ID`) AS Total_Orders,
    COUNT(DISTINCT r.`Order ID`) AS Returned_Orders,
    ROUND(
        COUNT(DISTINCT r.`Order ID`) * 100.0 /
        COUNT(DISTINCT o.`Order ID`),
        2
    ) AS Return_Rate
FROM orders_valid o
LEFT JOIN returns r
    ON o.`Order ID` = r.`Order ID`
    AND r.Returned = 'Yes'
GROUP BY o.Region
ORDER BY Return_Rate DESC;



