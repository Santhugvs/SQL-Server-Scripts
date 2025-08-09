/*
File: usp_GetCustomerOrders.sql
Author: Santhosh Kumar V
Date: 2025-08-09
Purpose: Fetch customer orders with optional date range filter.
Usage: EXEC dbo.usp_GetCustomerOrders @CustomerId = 1, @FromDate = '2024-01-01';
*/
CREATE PROCEDURE dbo.usp_GetCustomerOrders
  @CustomerId INT,
  @FromDate DATE = NULL,
  @ToDate DATE = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SELECT o.OrderId, o.OrderDate, o.Total
  FROM dbo.Orders o
  WHERE o.CustomerId = @CustomerId
    AND (@FromDate IS NULL OR o.OrderDate >= @FromDate)
    AND (@ToDate IS NULL OR o.OrderDate <= @ToDate);
END
GO
