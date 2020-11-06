USE OMS
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name='crud_GenerateOrders')
BEGIN
	DROP PROCEDURE ord.crud_GenerateOrders
END
GO
CREATE PROCEDURE ord.crud_GenerateOrders
(  
      @tblOrderTableType [ord].tblTypeOrder Readonly,
	  @tblOrderProductTableType [prdt].tblTypeOrderProduct Readonly
)  
AS  
BEGIN  

	SET NOCOUNT ON

	DECLARE @ord_cnt TINYINT = 0
	DECLARE @ordprdt_cnt TINYINT = 0
	DECLARE @msg VARCHAR(8000)= ''
	DECLARE @msgCode INT = 1  /* 1 = Success, 0 = Failed, -1 = Something went wrong */

	BEGIN TRY

	--Starts validation
	 IF NOT EXISTS (SELECT 1 FROM @tblOrderTableType)
	 BEGIN
		SELECT @msg='ERROR: Orders should not be blank', @msgCode = 0
		GOTO OUTMSG
	 END

	 IF NOT EXISTS (SELECT 1 FROM @tblOrderProductTableType)
	 BEGIN
		SELECT @msg='ERROR: Products related to specific order should not be blank', @msgCode = 0
		GOTO OUTMSG
	 END
	 --End validation
	
	BEGIN TRANSACTION
		BEGIN	
			MERGE ord.[Order]  AS dbOrder
			USING @tblOrderTableType AS tblTypeOrd  
			ON (dbOrder.OrderID = tblTypeOrd.OrderID)  
  
			WHEN MATCHED THEN  
			UPDATE 
			SET  
			BuyerID = tblTypeOrd.BuyerID,   
			OrderDateTime = tblTypeOrd.OrderDateTime,  
			TotalAmount = tblTypeOrd.TotalAmount,  
			TotalDiscountAmount = tblTypeOrd.TotalDiscountAmount,  
			TotalNetAmount = tblTypeOrd.TotalNetAmount ,
			CurrencyID = tblTypeOrd.CurrencyID,
			OrderStatusId = tblTypeOrd.OrderStatusId,
			ModifiedOn = tblTypeOrd.ModifiedOn
			WHEN NOT MATCHED THEN  
			INSERT 
			(
				BuyerID,OrderDateTime,TotalAmount,TotalDiscountAmount,TotalNetAmount,CurrencyID,OrderStatusId
			)  
			VALUES 
			(
				tblTypeOrd.BuyerID,tblTypeOrd.OrderDateTime,tblTypeOrd.TotalAmount,tblTypeOrd.TotalDiscountAmount,
				tblTypeOrd.TotalNetAmount,tblTypeOrd.CurrencyID,tblTypeOrd.OrderStatusId
			);

			SELECT @ord_cnt = @@ROWCOUNT

			MERGE prdt.[OrderProduct]  AS dbOrderProduct
			USING @tblOrderProductTableType AS tblTypeOrdPrdt  
			ON (dbOrderProduct.OrderProductID = tblTypeOrdPrdt.OrderProductID)  
  
			WHEN MATCHED THEN  
			UPDATE 
			SET  
			OrderID = tblTypeOrdPrdt.OrderID,   
			ProductID = tblTypeOrdPrdt.ProductID,  
			Qty = tblTypeOrdPrdt.Qty,  
			Amount = tblTypeOrdPrdt.Amount,  
			DiscountAmount = tblTypeOrdPrdt.DiscountAmount ,
			NetAmount = tblTypeOrdPrdt.NetAmount,
			ModifiedOn = tblTypeOrdPrdt.ModifiedOn
			WHEN NOT MATCHED THEN  
			INSERT 
			(
				OrderID,ProductID,Qty,Amount,DiscountAmount,NetAmount
			)  
			VALUES 
			(
				tblTypeOrdPrdt.OrderID,tblTypeOrdPrdt.ProductID,tblTypeOrdPrdt.Qty,tblTypeOrdPrdt.Amount,
				tblTypeOrdPrdt.DiscountAmount,tblTypeOrdPrdt.NetAmount
			);
			SELECT @ordprdt_cnt = @@ROWCOUNT
		END
		IF (@ord_cnt<>0 AND @ordprdt_cnt<>0)
		BEGIN
			COMMIT TRANSACTION
			SELECT @msg = 'SUCCESS : Bonus created successfully in the system !', @msgCode = 1
		END
		ELSE 
		BEGIN
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION
            SELECT @msg = 'ERROR : Unexpected database error, no changes made'
                , @msgCode = -1
            GOTO OUTMSG
		END

			OUTMSG:
            SELECT	@msg as msg, @msgCode as msgCode
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION

		SELECT 'Awww snap.. something went wrong. Please contact administrator or try again later!' AS msg, -1 as msgCode
	END CATCH
END 

-- Declaring the variable of user defined table type  
DECLARE @tblTypeOrder ord.tblTypeOrder
DECLARE @tblTypeOrderProduct prdt.tblTypeOrderProduct
--  select * from @tblTypeOrder
--Inserting some records  
INSERT INTO @tblTypeOrder 
(OrderID,BuyerID,OrderDateTime,TotalAmount,TotalDiscountAmount,TotalNetAmount,CurrencyID,OrderStatusId,ModifiedOn)	
VALUES
(0,1,'2020-11-05 10:33:26.793',100,10,90,1,1,'2020-11-05 10:33:26.793')  
,(3,2,'2020-11-06 10:33:26.793',500,10,490,1,1,'2020-11-06 10:33:26.793')
,(0,1,'2020-11-07 10:33:26.793',11100,10,11090,1,1,'2020-11-07 10:33:26.793')
,(0,1,'2020-11-07 10:33:26.793',1500,10,1490,1,1,'2020-11-07 10:33:26.793')
,(5,3,'2020-11-08 10:33:26.793',1100,10,1090,1,1,'2020-11-08 10:33:26.793')
,(0,1,'2020-11-08 10:33:26.793',200,10,110,1,1,'2020-11-08 10:33:26.793')
,(6,4,'2020-11-09 10:33:26.793',10,10,0,1,1,'2020-11-09 10:33:26.793')
,(7,5,'2020-11-09 10:33:26.793',50,10,40,1,1,'2020-11-09 10:33:26.793')
,(0,7,'2020-11-09 10:33:26.793',1020,10,1010,1,1,'2020-11-09 10:33:26.793')
,(9,9,'2020-11-09 10:33:26.793',1000,10,900,1,1,'2020-11-09 10:33:26.793')
	  
INSERT INTO @tblTypeOrderProduct
(OrderProductID,OrderID,ProductID,Qty,Amount,DiscountAmount,NetAmount,ModifiedOn)
VALUES 
(1,1,1,100,10,2,8,NULL),(0,2,3,200,10,190,8,NULL),(3,3,4,400,10,390,8,NULL)
,(4,4,4,500,10,490,8,NULL),(5,5,5,600,10,590,8,NULL),(2,6,6,100,10,90,8,NULL)
,(6,7,7,100,10,400,8,NULL)
       
-- Executing procedure  
EXEC ord.crud_GenerateOrders  @tblTypeOrder,@tblTypeOrderProduct  
SELECT * FROM ord.[Order]