-- Create and populate sample table
CREATE TABLE dbo.Customers (
    CustomerId INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    City NVARCHAR(50)
);

INSERT INTO dbo.Customers (CustomerId, CustomerName, City) VALUES
(1, 'John Doe', 'New York'),
(2, 'Jane Smith', 'Los Angeles'),
(3, 'Robert Brown', 'Chicago');
