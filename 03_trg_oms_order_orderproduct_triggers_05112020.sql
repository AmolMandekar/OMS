----------------------------------------------------------------------------------------------------------------------------------
USE OMS
GO
DROP TRIGGER IF EXISTS ord.trg_OrderAuditRecords
GO
CREATE TRIGGER ord.trg_OrderAuditRecords on ord.[Order]
AFTER UPDATE, INSERT
AS
BEGIN
  INSERT INTO ord.OrdersAudit 
  (OrderID,	BuyerID, OrderDateTime,	TotalAmount, TotalDiscountAmount, TotalNetAmount, CurrencyID, OrderStatusId, ModifiedBy, ModifiedOn)
  SELECT i.OrderID, i.BuyerID, i.OrderDateTime, i.TotalAmount, i.TotalDiscountAmount, i.TotalNetAmount, i.CurrencyID, i.OrderStatusId, i.BuyerID, GETDATE() 
  FROM  ord.[Order] t 
  INNER JOIN INSERTED i ON t.OrderID=i.OrderID 
END
GO
----------------------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS prdt.trg_OrderProductAuditRecords
GO
CREATE TRIGGER prdt.trg_OrderProductAuditRecords on prdt.[OrderProduct]
AFTER UPDATE, INSERT
AS
BEGIN
  INSERT INTO prdt.OrdersProductAudit 
  (OrderProductID,	OrderID, ProductID,	Qty, Amount, DiscountAmount, NetAmount, ModifiedBy, ModifiedOn)
  SELECT i.OrderProductID, i.OrderID, i.ProductID, i.Qty, i.Amount, i.DiscountAmount, i.NetAmount, NULL, GETDATE() 
  FROM  prdt.OrderProduct t 
  INNER JOIN INSERTED i ON t.OrderProductID=i.OrderProductID 
END
GO
----------------------------------------------------------------------------------------------------------------------------------