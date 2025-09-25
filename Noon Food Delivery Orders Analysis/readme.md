# Noon Food Delivery Orders Analysis

This project involved a comprehensive analysis of a food delivery orders dataset, analysing customer behavior and sales trends to identify key insights. 

Tool used: MySQL Workbench

### SQL Challenges & Solutions:

**1. Top 3 outlets by Cuisine type without using limit or top function.**
```sql
WITH CTE AS (SELECT Cuisine, Restaurant_id, COUNT(*) AS No_of_orders FROM orders
GROUP BY Cuisine, Restaurant_id)
SELECT * FROM 
  (SELECT *, row_number() over (partition by cuisine order by No_of_orders desc) AS rn FROM CTE)a 
  WHERE rn<=3;
```
**2. Count of new customers acquired everyday from the launch date.**
```sql
WITH CTE AS (SELECT Customer_code, CAST(MIN(Placed_at) as date) AS First_order_date
FROM orders
 GROUP BY Customer_code
 ORDER BY first_order_date)
 SELECT first_order_date, COUNT(customer_code) AS New_customer_count FROM CTE
 GROUP BY first_order_date
 ORDER BY first_order_date;
 ```
**3. Count of all the users acquired in January and placed only one order in January.**
```sql
SELECT COUNT(Customer_code) AS jan_users FROM
    (SELECT Customer_code FROM orders WHERE MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025
            AND Customer_code NOT IN 
            (SELECT DISTINCT Customer_code FROM orders WHERE NOT (MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025))
    GROUP BY Customer_code
    HAVING COUNT(Customer_code) = 1) a;
```  
**4. List of all the customers with no order in the last 7 days but were acquired one month ago with their order on promo.**
```sql
WITH CTE AS (SELECT Customer_code, MIN(Placed_at) AS first_order_date, MAX(Placed_at) AS last_order_date FROM orders
GROUP BY Customer_code),
max_date AS (SELECT max(placed_at) AS dataset_max_date FROM orders)
SELECT CTE.*, orders.Promo_code_Name AS first_order_promo
FROM CTE INNER JOIN ORDERS ON CTE.Customer_code=orders.Customer_code AND CTE.first_order_date=orders.Placed_at 
CROSS JOIN max_date
WHERE last_order_date < DATE_SUB(max_date.dataset_max_date, INTERVAL 7 DAY) 
AND first_order_date < DATE_SUB(max_date.dataset_max_date, INTERVAL 1 MONTH) AND orders.Promo_code_Name IS NOT NULL;
```
**5. Growth team is planning to create a trigger that will target customers after their every third order with a personalized communication and they have asked to create a query for this.**
```sql
WITH CTE AS (SELECT Customer_code, Placed_at, 
	row_number() OVER (partition by Customer_code order by Placed_at) AS order_number 
FROM orders)
SELECT * FROM CTE
WHERE order_number%3=0;
```
**6. List of the customers who placed more than 1 order and all their orders are on a promo only.**
```sql
SELECT Customer_code, COUNT(*) AS no_of_orders 
FROM orders
GROUP BY Customer_code
HAVING COUNT(*)>1 AND COUNT(*)=COUNT(Promo_code_Name);
```
**7. What percent of customers were organically acquired in jan 2025 (placed their first order without promo code)**
```sql
WITH CTE AS (SELECT Customer_code, Promo_code_Name, 
    row_number() over(partition by Customer_code order by Placed_at) AS rn FROM orders
	WHERE MONTH(Placed_at)=1)
SELECT COUNT(CASE WHEN rn=1 AND Promo_code_Name IS NULL THEN Customer_code END)*100/COUNT(distinct Customer_code) AS organic_customers
FROM CTE;
```
