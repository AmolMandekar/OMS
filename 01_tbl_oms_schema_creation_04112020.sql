USE master ;  
GO  
CREATE DATABASE OMS  
GO 
----------------------------------------------------------------------------------------------------------------------------------
USE OMS
GO
CREATE SCHEMA common
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.Country
(
	CountryID TINYINT IDENTITY(1,1) NOT NULL,
	CountryName VARCHAR(200),
	CountryShortName VARCHAR(100),
	IsActive BIT NOT NULL CONSTRAINT DF_Country_IsActive DEFAULT(1),
	CONSTRAINT PK_Country PRIMARY KEY (CountryID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.[State]
(
	StateID TINYINT IDENTITY(1,1) NOT NULL,
	StateName VARCHAR(200),
	CountryID TINYINT NOT NULL,
	IsActive BIT NOT NULL CONSTRAINT DF_State_IsActive DEFAULT(1),
	CONSTRAINT PK_State PRIMARY KEY (StateID),
	CONSTRAINT FK_State_ToCountry FOREIGN KEY (CountryID) REFERENCES [common].[Country](CountryID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.[District]
(
	DistrictID SMALLINT IDENTITY(1,1) NOT NULL,
	DistrictName VARCHAR(200),
	StateID TINYINT NOT NULL,
	IsActive BIT NOT NULL CONSTRAINT DF_District_IsActive DEFAULT(1),
	CONSTRAINT PK_District PRIMARY KEY (DistrictID),
	CONSTRAINT FK_District_ToState FOREIGN KEY (StateID) REFERENCES [common].[State](StateID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.[City]
(
	CityID INT IDENTITY(1,1) NOT NULL,
	CityName VARCHAR(200),
	DistrictID SMALLINT NOT NULL,
	IsActive BIT NOT NULL CONSTRAINT DF_City_IsActive DEFAULT(1),
	CONSTRAINT PK_City PRIMARY KEY (CityID),
	CONSTRAINT FK_City_ToDistrict FOREIGN KEY (DistrictID) REFERENCES [common].[District](DistrictID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.[Currency]
(
	CurrencyID TINYINT IDENTITY(1,1) NOT NULL,
	CurrencyName VARCHAR(200) NOT NULL,
	CurrencyCode CHAR(3) NOT NULL,
	CurrencySymbol NVARCHAR(1) NOT NULL,
	CountryID TINYINT NOT NULL,
	CONSTRAINT PK_Currency PRIMARY KEY (CurrencyID),
	CONSTRAINT FK_Currency_ToCountry FOREIGN KEY (CountryID) REFERENCES [common].[Country](CountryID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.[AddressType]
(
	AddressTypeID TINYINT IDENTITY(1,1) NOT NULL,
	[Description] VARCHAR(250) NOT NULL,
	CONSTRAINT PK_AddressType PRIMARY KEY (AddressTypeID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE common.[OrderStatus]
(
	OrderStatusID TINYINT IDENTITY(1,1) NOT NULL,
	[Description] VARCHAR(250) NOT NULL,
	CONSTRAINT PK_OrderStatus PRIMARY KEY (OrderStatusID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA prdt
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE prdt.ProductCategory
(
	ProductCategoryID SMALLINT IDENTITY(1,1) NOT NULL,
	ShortDesc VARCHAR(50) NOT NULL,
	[Description] VARCHAR(250) NULL,
	CONSTRAINT PK_ProductCategory PRIMARY KEY (ProductCategoryID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA splr
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE splr.Supplier
(
	SupplierID INT IDENTITY(1,1) NOT NULL,
	ComanyName VARCHAR(250) NOT NULL,
	ContactName VARCHAR(100) NOT NULL,
	Address1 VARCHAR(250) NOT NULL,
	Address2 VARCHAR(250) NULL,
	CountryID TINYINT NOT NULL,
	StateID TINYINT NOT NULL,
	DistrictID SMALLINT NOT NULL,
	CityID INT NOT NULL,
	LandlineNo VARCHAR(50) NULL,
	MobileNo VARCHAR(15) NOT NULL,
	Fax VARCHAR(30) NULL,
	CreatedOn DATETIME NOT NULL CONSTRAINT DF_Supplier_CreatedOn DEFAULT GETDATE(),
	ModifiedOn DATETIME NULL,
	CONSTRAINT PK_Supplier PRIMARY KEY (SupplierID),
	CONSTRAINT FK_Supplier_ToCountry FOREIGN KEY (CountryID) REFERENCES [common].[Country](CountryID),
	CONSTRAINT FK_Supplier_ToState FOREIGN KEY (StateID) REFERENCES [common].[State](StateID),
	CONSTRAINT FK_Supplier_ToDistrict FOREIGN KEY (DistrictID) REFERENCES [common].[District](DistrictID),
	CONSTRAINT FK_Supplier_ToCity FOREIGN KEY (CityID) REFERENCES [common].[City](CityID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE prdt.Product
(
	ProductID INT IDENTITY(1,1) NOT NULL,
	ProductName VARCHAR(250) NOT NULL,
	ProductDesc VARCHAR(500) NULL,
	ProductCategoryID SMALLINT NOT NULL,
	SupplierID INT NOT NULL,
	[Weight] NUMERIC(23,2) NULL,
	Height NUMERIC(23,2) NULL,
	QtyInStock INT NOT NULL CONSTRAINT DF_Product_QtyInStock DEFAULT(0),
	BuyPrice NUMERIC(23,2) NOT NULL CONSTRAINT DF_Product_BuyPrice DEFAULT(0),
	MSRP NUMERIC(23,2) NOT NULL CONSTRAINT DF_Product_MSRP DEFAULT(0),
	SKU VARCHAR(50) NOT NULL,
	Barcode CHAR(15) NOT NULL,
	IsDiscontinued BIT CONSTRAINT DF_Product_IsDiscontinued DEFAULT(0),
	CreatedOn DATETIME NOT NULL CONSTRAINT DF_Product_CreatedOn DEFAULT GETDATE(),
	ModifiedOn DATETIME NULL,
	CONSTRAINT PK_Product PRIMARY KEY (ProductID),
	CONSTRAINT FK_Product_ToProductCategory FOREIGN KEY (ProductCategoryID) REFERENCES [prdt].[ProductCategory](ProductCategoryID),
	CONSTRAINT FK_Product_ToSupplier FOREIGN KEY (SupplierID) REFERENCES [splr].[Supplier](SupplierID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE prdt.ProductImage
(
	ProductImageID INT IDENTITY(1,1) NOT NULL,
	ProductID INT NOT NULL,
	ImageName VARCHAR(250) NULL,
	ImageUrl VARCHAR(5000) NOT NULL,
	CreatedOn DATETIME NOT NULL CONSTRAINT DF_ProductImage_CreatedOn DEFAULT GETDATE(),
	ModifiedOn DATETIME NULL,
	CONSTRAINT PK_ProductImage PRIMARY KEY (ProductImageID),
	CONSTRAINT FK_ProductImage_ToProduct FOREIGN KEY (ProductID) REFERENCES [prdt].[Product](ProductID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA byr
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE byr.Buyer
(
	BuyerID INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	MiddleName VARCHAR(50) NULL,
	LastName VARCHAR(50) NOT NULL,
	EmailID VARCHAR(256) NULL,
	LandlineNo VARCHAR(50) NULL,
	MobileNo VARCHAR(15) NOT NULL,
	IsActive BIT NOT NULL CONSTRAINT DF_Buyer_IsActive DEFAULT(1),
	CreatedOn DATETIME NOT NULL CONSTRAINT DF_Buyer_CreatedOn DEFAULT GETDATE(),
	ModifiedOn DATETIME NULL,
	CONSTRAINT PK_Buyer PRIMARY KEY (BuyerID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE byr.BuyerAddresses
(
	AddressID INT IDENTITY(1,1) NOT NULL,
	BuyerID INT NOT NULL,
	AddressTypeID TINYINT NOT NULL,
	Address1 VARCHAR(250) NOT NULL,
	Address2 VARCHAR(250) NULL,
	CountryID TINYINT NOT NULL,
	StateID TINYINT NOT NULL,
	DistrictID SMALLINT NOT NULL,
	CityID INT NOT NULL,
	PincodeNo INT NULL,
	CreatedOn DATETIME NOT NULL CONSTRAINT DF_BuyerAddresses_CreatedOn DEFAULT GETDATE(),
	ModifiedOn DATETIME NULL,
	CONSTRAINT PK_BuyerAddresses PRIMARY KEY (AddressID),
	CONSTRAINT FK_BuyerAddresses_ToBuyer FOREIGN KEY (BuyerID) REFERENCES [byr].[Buyer](BuyerID),
	CONSTRAINT FK_BuyerAddresses_ToCountry FOREIGN KEY (CountryID) REFERENCES [common].[Country](CountryID),
	CONSTRAINT FK_BuyerAddresses_ToState FOREIGN KEY (StateID) REFERENCES [common].[State](StateID),
	CONSTRAINT FK_BuyerAddresses_ToDistrict FOREIGN KEY (DistrictID) REFERENCES [common].[District](DistrictID),
	CONSTRAINT FK_BuyerAddresses_ToCity FOREIGN KEY (CityID) REFERENCES [common].[City](CityID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA Ord
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE ord.[Order]
(
OrderID INT IDENTITY(1,1) NOT NULL,
BuyerID INT NOT NULL,
OrderDateTime DATETIME NOT NULL,
TotalAmount NUMERIC(23,2) NOT NULL CONSTRAINT DF_Order_TotalAmount DEFAULT(0),
TotalDiscountAmount NUMERIC(23,2) NOT NULL CONSTRAINT DF_Order_TotalDiscountAmount DEFAULT(0),
TotalNetAmount NUMERIC(23,2) NOT NULL CONSTRAINT DF_Order_TotalNetAmount DEFAULT(0),
CurrencyID TINYINT NOT NULL,
OrderStatusId TINYINT NOT NULL,
CreatedOn DATETIME NOT NULL CONSTRAINT DF_Order_CreatedOn DEFAULT GETDATE(),
ModifiedOn DATETIME NULL,
CONSTRAINT PK_Order PRIMARY KEY (OrderID),
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA trn
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE trn.Payment
(
	PaymentID INT IDENTITY(1,1) NOT NULL,
	BuyerID INT NOT NULL,
	PaymentDateTime DATETIME NOT NULL,
	Amount NUMERIC(23,2) NOT NULL CONSTRAINT DF_Payment_Amount DEFAULT(0),
	OrderID INT NULL,
	CONSTRAINT PK_Payment PRIMARY KEY (PaymentID),
	CONSTRAINT FK_Payment_ToOrder FOREIGN KEY (OrderID) REFERENCES [ord].[Order](OrderID),
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE prdt.OrderProduct
(
	OrderProductID INT IDENTITY(1,1) NOT NULL,
	OrderID INT NOT NULL,
	ProductID INT NOT NULL,
	Qty INT NOT NULL CONSTRAINT DF_OrderProduct_Qty DEFAULT(0),
	Amount NUMERIC(23,2) NOT NULL CONSTRAINT DF_OrderProduct_Amount DEFAULT(0),
	DiscountAmount NUMERIC(23,2) NOT NULL CONSTRAINT DF_OrderProduct_DiscountAmount DEFAULT(0),
	NetAmount NUMERIC(23,2) NOT NULL CONSTRAINT DF_OrderProduct_NetAmount DEFAULT(0),
	CreatedOn DATETIME NOT NULL CONSTRAINT DF_OrderProduct_CreatedOn DEFAULT GETDATE(),
	ModifiedOn DATETIME NULL
	CONSTRAINT PK_OrderProduct PRIMARY KEY (OrderProductID),
	CONSTRAINT FK_OrderProduct_ToOrder FOREIGN KEY (OrderID) REFERENCES [ord].[Order](OrderID),
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE schema applog
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE applog.CRUDErrors
(
	crudErrorsID INT IDENTITY(1,1) NOT NULL,
	CallerUserID INT NOT NULL,
	CalledSpName VARCHAR(300) NOT NULL,
	SpParameter VARCHAR(2000) NULL,
	SpErrorMsg VARCHAR(4000) NULL,
	SpCalledOn DATETIME NULL,
 CONSTRAINT PK_CRUDErrors PRIMARY KEY (crudErrorsID) 
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE SCHEMA [audit]
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE ord.OrdersAudit
(
	OrderAuditID INTEGER IDENTITY(1,1) NOT NULL,
	OrderID INT,
	BuyerID INT,
	OrderDateTime DATETIME,
	TotalAmount NUMERIC(23,2),
	TotalDiscountAmount NUMERIC(23,2),
	TotalNetAmount NUMERIC(23,2),
	CurrencyID TINYINT,
	OrderStatusId TINYINT,
	ModifiedBy INT,
	ModifiedOn datetime,
	CONSTRAINT PK_OrdersAudit PRIMARY KEY (OrderAuditID)
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE prdt.OrdersProductAudit
(
	OrderProductAuditID INT IDENTITY(1,1) NOT NULL,
	OrderProductID INT,
	OrderID INT,
	ProductID INT,
	Qty INT,
	Amount NUMERIC(23,2),
	DiscountAmount NUMERIC(23,2),
	NetAmount NUMERIC(23,2),
	ModifiedBy DATETIME,
	ModifiedOn DATETIME
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE [ord].[tblTypeOrder] AS TABLE  
(  
	OrderID INT,
	BuyerID INT,
	OrderDateTime DATETIME,
	TotalAmount NUMERIC(23,2),
	TotalDiscountAmount NUMERIC(23,2),
	TotalNetAmount NUMERIC(23,2),
	CurrencyID TINYINT,
	OrderStatusId TINYINT,
	CreatedOn DATETIME,
	ModifiedOn DATETIME
)
GO
----------------------------------------------------------------------------------------------------------------------------------
CREATE TYPE prdt.tblTypeOrderProduct AS TABLE
(
	OrderProductID INT,
	OrderID INT,
	ProductID INT,
	Qty INT,
	Amount NUMERIC(23,2),
	DiscountAmount NUMERIC(23,2),
	NetAmount NUMERIC(23,2),
	CreatedOn DATETIME,
	ModifiedOn DATETIME
)
GO