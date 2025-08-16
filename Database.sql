DROP DATABASE IF EXISTS SalesDB;
CREATE DATABASE SalesDB;
USE SalesDB;

CREATE TABLE Regions (
    RegionID INT PRIMARY KEY AUTO_INCREMENT,
    RegionName VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    CostPerUnit DECIMAL(10,2)  -- added for profit analysis
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(50),
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATE NOT NULL,
    RegionID INT,
    ProductID INT,
    CustomerID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (RegionID) REFERENCES Regions(RegionID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Regions (RegionName) VALUES 
('East'), ('West'), ('North'), ('South');

-- Products (with costs)
INSERT INTO Products (ProductName, Category, CostPerUnit) VALUES
('Laptop', 'Electronics', 650.00),
('Smartphone', 'Electronics', 500.00),
('Desk Chair', 'Furniture', 90.00),
('Water Bottle', 'Accessories', 10.00);

-- Customers (linked to regions)
INSERT INTO Customers (CustomerName, Email, Phone, City, RegionID) VALUES
('Ravi Kumar', 'ravi.kumar@example.com', '9876543210', 'Delhi', 1),
('Sneha Sharma', 'sneha.sharma@example.com', '9876501234', 'Mumbai', 2),
('Amit Singh', 'amit.singh@example.com', '9876009876', 'Lucknow', 3),
('Priya Verma', 'priya.verma@example.com', '9876012345', 'Chennai', 4);

-- Orders 
INSERT INTO Orders (OrderDate, RegionID, ProductID, CustomerID, Quantity, UnitPrice, Discount) VALUES
('2024-01-15', 1, 1, 1, 10, 800.00, 50.00),  
('2024-02-10', 2, 2, 2, 15, 600.00, 10.00),  
('2024-03-20', 3, 3, 3, 7, 120.00, 0.00),    
('2024-04-05', 4, 4, 4, 20, 15.00, 0.00),    
('2025-01-20', 1, 1, 1, 12, 810.00, 0.00),  
('2025-02-14', 2, 2, 2, 14, 605.00, 5.00),  
('2025-03-18', 3, 3, 3, 8, 125.00, 0.00),  
('2025-04-12', 4, 4, 4, 18, 16.00, 2.00);   


SELECT 
    o.OrderID, o.OrderDate, c.CustomerName, r.RegionName, 
    p.ProductName, o.Quantity, o.UnitPrice, o.Discount,
    (o.Quantity * o.UnitPrice - o.Discount) AS TotalSales,
    (o.Quantity * (o.UnitPrice - p.CostPerUnit) - o.Discount) AS Profit
FROM Orders o
JOIN Regions r ON o.RegionID = r.RegionID
JOIN Products p ON o.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate;
