CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE returns (
    Order_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    User_ID VARCHAR(50),
    Order_Date DATE,
    Return_Date DATE,
    Product_Category VARCHAR(50),
    Product_Price DECIMAL(10,2),
    Order_Quantity INT,
    Return_Reason VARCHAR(255),
    Return_Status VARCHAR(20),
    Days_to_Return INT,
    User_Age INT,
    User_Gender VARCHAR(10),
    User_Location VARCHAR(50),
    Payment_Method VARCHAR(50),
    Shipping_Method VARCHAR(50),
    Discount_Applied DECIMAL(5,2)
);
SELECT * FROM returns;

SELECT *
FROM returns
WHERE Return_Status IS NULL OR Product_Category IS NULL;

SELECT Order_ID, COUNT(*) 
FROM returns
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Category-wise return%
SELECT Product_Category,
       SUM(CASE WHEN Return_Status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Return_Percentage
FROM returns
GROUP BY Product_Category;

-- Location-wise return %
SELECT User_Location,
       SUM(CASE WHEN Return_Status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Return_Percentage
FROM returns
GROUP BY User_Location;

-- Payement method vs Return %
SELECT Payment_Method,
       SUM(CASE WHEN Return_Status = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Return_Percentage
FROM returns
GROUP BY Payment_Method;

-- Customer Behavior * Top customer by return count --
SELECT User_ID, COUNT(*) AS Total_Returns
FROM returns
WHERE Return_Status = 'Returned'
GROUP BY User_ID
ORDER BY Total_Returns DESC
LIMIT 10;

-- Return reasons distribution
SELECT Return_Reason, COUNT(*) AS Total
FROM returns
WHERE Return_Status = 'Returned'
GROUP BY Return_Reason
ORDER BY Total DESC;

SELECT Product_ID, COUNT(*) AS Total_Orders
FROM returns
GROUP BY Product_ID
ORDER BY Total_Orders DESC;

-- High Risk Products (Return Risk Score Base) 
SELECT Product_Category,
       COUNT(*) AS Total_Orders,
       SUM(CASE WHEN Return_Status = 'Returned' THEN 1 ELSE 0 END) AS Returned_Orders,
       (SUM(CASE WHEN Return_Status = 'Returned' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) * 100 AS Return_Percentage
FROM returns
GROUP BY Product_Category
ORDER BY Return_Percentage DESC;


