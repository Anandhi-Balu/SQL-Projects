/***********************************************/
/*            Blinkit Sales Analysis           */
/***********************************************/

-- 1. Data Cleaning: Standardize the Item_Fat_Content column by converting variations like 'LF' and 'low fat' to 'Low Fat', and 'reg' to 'Regular' for consistency.
SET SQL_SAFE_UPDATES = 0;
UPDATE blinkit_data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;
SET SQL_SAFE_UPDATES = 1;
SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data;


-- 2. Calculate the total revenue generated, expressed in millions.
SELECT CAST(SUM(total_sales) / 1000000.0 AS DECIMAL (10 , 2 )) AS Total_Revenue
FROM blinkit_data;


-- 3. Calculate the average revenue per sale, rounded to nearest integer.
SELECT ROUND(AVG(Total_Sales)) AS Avg_revenue
FROM blinkit_data;

-- Rounded "down" to nearest lowest integer.
SELECT FLOOR(AVG(Total_Sales)) AS Avg_revenue
FROM blinkit_data;
-- Rounded "up" to nearest highest integer.
SELECT CEIL(AVG(Total_Sales)) AS Avg_revenue
FROM blinkit_data;


-- 4. Calculate the total number of orders/items sold.
SELECT COUNT(*) AS No_of_items_sold
FROM blinkit_data;


-- 5. Calculate the average customer rating.
SELECT ROUND(AVG(Rating), 1) AS Avg_Rating
FROM blinkit_data;
-- or
SELECT CAST(AVG(Rating) AS DECIMAL (5 , 1 )) AS Avg_Rating
FROM blinkit_data;


-- 6. Analyze the impact of fat content on total sales.
SELECT Item_Fat_Content, CAST(SUM(Total_Sales) AS DECIMAL (10 , 2 )) AS Total_Revenue,
ROUND((SUM(Total_Sales)*100 /SUM(SUM(Total_Sales)) OVER()),2) AS Sales_Percentage
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY 2 DESC;


-- 7. Identify the performance of different item types in terms of total sales.
SELECT Item_Type, CAST(SUM(Total_Sales) AS DECIMAL (10 , 2 )) AS Total_Revenue
FROM blinkit_data
GROUP BY Item_Type
ORDER BY 2 DESC;


-- 8. Compare total sales across different outlets segmented by fat content.
SELECT 
    Outlet_Location_Type,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales END),2) AS 'Low Fat',
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Total_Sales END),2) AS 'Regular'
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;


-- 9. Evaluate how the age of outlet influences total sales.
SELECT 
    Outlet_Establishment_Year,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY 1;


-- 10. Analyze the correlation between outlet size and total sales.
SELECT 
    Outlet_Size,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue,
	ROUND((SUM(Total_Sales)*100 /SUM(SUM(Total_Sales)) OVER()),2) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY 2 DESC;


-- 11. Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of Items, Average Rating) broken down by different outlet types.
SELECT 
    Outlet_Type,
    ROUND(SUM(Total_Sales), 0) AS Total_Revenue,
    ROUND(AVG(Total_Sales), 0) AS Avg_Sales,
    COUNT(*) AS Order_count,
    ROUND(AVG(Rating),2) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Revenue DESC;



