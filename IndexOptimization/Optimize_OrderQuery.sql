-- Example: Optimize query using index
-- Before creating index, check execution plan for scans
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId_OrderDate
ON dbo.Orders (CustomerId, OrderDate);
