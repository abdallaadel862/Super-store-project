create database Superstore

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY ([Customer_ID]) REFERENCES Customers ([Customer_ID]);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_Details_Orders
FOREIGN KEY ([Order_ID]) REFERENCES Orders ([Order_ID]);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_Details_Products
FOREIGN KEY ([Product_ID]) REFERENCES Products ([Product_ID]);

SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM Products
SELECT * FROM OrderDetails


SELECT * FROM Customers WHERE Customer_ID IS NULL
SELECT * FROM Orders WHERE Order_ID IS NULL
SELECT * FROM Products WHERE Product_ID IS NULL
SELECT * FROM Orderdetails WHERE Order_ID IS NULL OR Product_ID IS NULL

SELECT o.Order_ID ,c.Customer_Name
FROM Orders o
LEFT JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL

SELECT od.Order_ID
FROM OrderDetails od 
LEFT JOIN Orders o ON od.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL

SELECT od.Product_ID
FROM OrderDetails od
LEFT JOIN Products p ON od.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL

SELECT COUNT(DISTINCT Customer_ID) AS UniqueCustomers, COUNT(*) AS TotalCustomers
FROM Customers

SELECT COUNT(DISTINCT Order_ID) AS UniqueOrders, COUNT(*) AS TotalOrders
FROM Orders

SELECT COUNT(DISTINCT Product_ID) AS UniqueOrders, COUNT(*) AS TotalProducts
FROM Products

SELECT COUNT(*) AS JoinedCount
FROM OrderDetails od
JOIN Orders o   ON od.Order_ID   = o.Order_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Products p ON od.Product_ID = p.Product_ID;

SELECT COUNT(*) AS OrderDetailsCount FROM OrderDetails;




-- KPI
--1total Sales

SELECT SUM(Sales) AS Total_Sales
FROM OrderDetails;

-- 2Unique Orders

SELECT COUNT(DISTINCT [Order_ID]) AS Unique_Orders
FROM Orders;

-- 3Unique Customers

SELECT COUNT(DISTINCT [Customer_ID]) AS Unique_Customers
FROM Customers;

-- 4Average Order Value (AOV)

SELECT
    (SELECT SUM(Sales) FROM OrderDetails) /
    (SELECT CAST(COUNT(DISTINCT [Order_ID]) AS FLOAT) FROM Orders) AS AOV;

-- 5Sales Trend Over Time (Month-over-Month)
SELECT
    FORMAT(o.[Order_Date], 'yyyy-MM') AS Month,
    SUM(od.Sales) AS Monthly_Sales
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
GROUP BY
    FORMAT(o.[Order_Date], 'yyyy-MM')
ORDER BY
    Month;

-- 6Average Items per Order (UPO / "Units Per Order")

SELECT
    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(DISTINCT [Order_ID]) FROM Orders) AS Avg_Items_Per_Order
FROM OrderDetails;



--2 Customer analysis


-- 1Top 10 Customers by Sales
SELECT TOP 10
    c.[Customer_Name],
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
JOIN
    Customers AS c ON o.[Customer_ID] = c.[Customer_ID]
GROUP BY
    c.[Customer_Name]
ORDER BY
    Total_Sales DESC;

-- 2Top 10 Customers by Order Count
SELECT TOP 10
    c.[Customer_Name],
    COUNT(DISTINCT o.[Order_ID]) AS Order_Count
FROM
    Orders AS o
JOIN
    Customers AS c ON o.[Customer_ID] = c.[Customer_ID]
GROUP BY
    c.[Customer_Name]
ORDER BY
    Order_Count DESC;

-- 3Customer Acquisition Trend (New Customers per Month)

SELECT
    FORMAT(Order_Date, 'yyyy-MM') AS Month,
    COUNT(*) AS New_Customers
FROM Orders
GROUP BY FORMAT(Order_Date, 'yyyy-MM')
ORDER BY Month;

-- 4Distribution of customers by Segment

SELECT
    Segment,
    COUNT(DISTINCT [Customer_ID]) AS Customer_Count
FROM Customers
GROUP BY Segment
ORDER BY Customer_Count DESC;


--3GEOGRAPHICAL ANALYSIS

-- 1Top 10 Cities by Sales
SELECT TOP 10
    o.City,
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
JOIN
    Customers AS c ON o.[Customer_ID] = c.[Customer_ID]
GROUP BY
    o.City
ORDER BY
    Total_Sales DESC;

-- 2 Bottom 10 Cities by Sales

SELECT TOP 10
    o.City,
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
JOIN
    Customers AS c ON o.[Customer_ID] = c.[Customer_ID]
GROUP BY
    o.City
ORDER BY
    Total_Sales ASC; 

-- 3 Sales by State
SELECT
    o.State,
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
JOIN
    Customers AS c ON o.[Customer_ID] = c.[Customer_ID]
GROUP BY
    o.State
ORDER BY
    Total_Sales DESC;

-- 4 Sales by Region

SELECT
    o.Region,
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
JOIN
    Customers AS c ON o.[Customer_ID] = c.[Customer_ID]
GROUP BY
    o.Region
ORDER BY
    Total_Sales DESC;



--4PRODUCT ANALYSIS


-- 1 Top 10 Best-Selling Products by Sales
SELECT TOP 10
    p.[Product_Name],
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Products AS p ON od.[Product_ID] = p.[Product_ID]
GROUP BY
    p.[Product_Name]
ORDER BY
    Total_Sales DESC;

-- 2 Top 10 Best-Selling Products by Count (Popularity)

SELECT TOP 10
    p.[Product_Name],
    COUNT(od.[Product_ID]) AS Total_Units_Sold 
FROM
    OrderDetails AS od
JOIN
    Products AS p ON od.[Product_ID] = p.[Product_ID]
GROUP BY
    p.[Product_Name]
ORDER BY
    Total_Units_Sold DESC;

-- 3 Bottom 10 Worst-Selling Products
SELECT TOP 10
    p.[Product_Name],
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Products AS p ON od.[Product_ID] = p.[Product_ID]
GROUP BY
    p.[Product_Name]
ORDER BY
    Total_Sales ASC;

-- 4 Sales by Product Category
SELECT
    p.Category,
    SUM(od.Sales) AS Total_Sales
FROM
    OrderDetails AS od
JOIN
    Products AS p ON od.[Product_ID] = p.[Product_ID]
GROUP BY
    p.Category
ORDER BY
    Total_Sales DESC;



--5 Order ANALYSIS


-- 1 Average Order Value (AOV) per Month Trend

SELECT
    FORMAT(o.[Order_Date], 'yyyy-MM') AS Month,
    SUM(od.Sales) / COUNT(DISTINCT o.[Order_ID]) AS AOV
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
GROUP BY
    FORMAT(o.[Order_Date], 'yyyy-MM')
ORDER BY
    Month;

-- 2 Busiest Month for Orders (Top 3)
SELECT TOP 3
    FORMAT([Order_Date], 'yyyy-MM') AS Month,
    COUNT(DISTINCT [Order_ID]) AS Total_Orders
FROM
    Orders 
GROUP BY
    FORMAT([Order_Date], 'yyyy-MM')
ORDER BY
    Total_Orders DESC;

-- 3 Orders by Day of Week
SELECT
    DATENAME(WEEKDAY, [Order_Date]) AS Day_Of_Week,
    COUNT(DISTINCT [Order_ID]) AS Total_Orders
FROM
    Orders 
GROUP BY
    DATENAME(WEEKDAY, [Order_Date])
ORDER BY
    Total_Orders DESC;

-- 4 Average Products per Order (UPO) Trend
SELECT
    FORMAT(o.[Order_Date], 'yyyy-MM') AS Month,CAST(COUNT(od.[Product_ID]) AS FLOAT) / COUNT(DISTINCT o.[Order_ID]) AS UPO_Trend
FROM
    OrderDetails AS od
JOIN
    Orders AS o ON od.[Order_ID] = o.[Order_ID]
GROUP BY
    FORMAT(o.[Order_Date], 'yyyy-MM')
ORDER BY
    Month;

-- 5 Ship Mode Percentage
WITH ShipModeCounts AS (
    SELECT
        [Ship_Mode],
        COUNT(DISTINCT [Order_ID]) AS Total_Orders
    FROM Orders
    GROUP BY [Ship_Mode]
)
SELECT
    [Ship_Mode],
    Total_Orders,
    (Total_Orders * 100.0 / SUM(Total_Orders) OVER()) AS Percentage
FROM ShipModeCounts
ORDER BY Percentage DESC;

