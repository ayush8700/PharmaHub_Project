-- Use master database and drop PharmaHubDB if it exists
USE [master]
GO

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE ('[' + name + ']' = N'PharmaHubDB' OR name = N'PharmaHubDB')))
DROP DATABASE PharmaHubDB
GO

-- Create PharmaHubDB database
CREATE DATABASE PharmaHubDB
GO

-- Use PharmaHubDB database
USE PharmaHubDB
GO

-- Drop tables if they already exist
IF OBJECT_ID('CardDetails') IS NOT NULL DROP TABLE CardDetails
GO

IF OBJECT_ID('PurchaseDetails') IS NOT NULL DROP TABLE PurchaseDetails
GO

IF OBJECT_ID('Products') IS NOT NULL DROP TABLE Products
GO

IF OBJECT_ID('Categories') IS NOT NULL DROP TABLE Categories
GO

IF OBJECT_ID('Users') IS NOT NULL DROP TABLE Users
GO

IF OBJECT_ID('Roles') IS NOT NULL DROP TABLE Roles
GO

IF OBJECT_ID('Login') IS NOT NULL DROP TABLE Login
GO

IF OBJECT_ID('AddressType') IS NOT NULL DROP TABLE AddressType
GO

IF OBJECT_ID('Countries') IS NOT NULL DROP TABLE Countries
GO

IF OBJECT_ID('States') IS NOT NULL DROP TABLE States
GO

IF OBJECT_ID('Address') IS NOT NULL DROP TABLE Address
GO

IF OBJECT_ID('usp_RegisterUser')  IS NOT NULL
DROP PROC usp_RegisterUser
GO

IF OBJECT_ID('usp_AddCategory') IS NOT NULL
DROP PROC usp_AddCategory
GO

IF OBJECT_ID('usp_AddProduct')  IS NOT NULL
DROP PROC usp_AddProduct
GO

IF OBJECT_ID('usp_UpdateBalance')  IS NOT NULL
DROP PROC usp_UpdateBalance
GO

IF OBJECT_ID('usp_InsertPurchaseDetails')  IS NOT NULL
DROP PROC usp_InsertPurchaseDetails
GO

IF OBJECT_ID('usp_GetProductsOnCategoryId')  IS NOT NULL
DROP PROC usp_GetProductsOnCategoryId
GO

IF OBJECT_ID('ufn_GetCardDetails')  IS NOT NULL
DROP FUNCTION ufn_GetCardDetails
GO

IF OBJECT_ID('ufn_GenerateNewProductId')  IS NOT NULL
DROP FUNCTION ufn_GenerateNewProductId
GO

IF OBJECT_ID('ufn_GetProductDetails')  IS NOT NULL
DROP FUNCTION ufn_GetProductDetails
GO

IF OBJECT_ID('ufn_GetAllProductDetails')  IS NOT NULL
DROP FUNCTION ufn_GetAllProductDetails
GO

IF OBJECT_ID('ufn_GetProductCategoryDetails')  IS NOT NULL
DROP FUNCTION ufn_GetProductCategoryDetails
GO

IF OBJECT_ID('ufn_ValidateUserCredentials')  IS NOT NULL
DROP FUNCTION ufn_ValidateUserCredentials
GO

IF OBJECT_ID('ufn_CheckEmailId')  IS NOT NULL
DROP FUNCTION ufn_CheckEmailId
GO

IF OBJECT_ID('ufn_GetCategories')  IS NOT NULL
DROP FUNCTION ufn_GetCategories
GO

IF OBJECT_ID('ufn_GenerateNewCategoryId')  IS NOT NULL
DROP FUNCTION ufn_GenerateNewCategoryId
GO

-- Create Roles table
CREATE TABLE Roles
(
    RoleId INT CONSTRAINT pk_RoleId PRIMARY KEY IDENTITY,
    RoleName VARCHAR(20) CONSTRAINT uq_RoleName UNIQUE
)
GO

-- Create Countries table
CREATE TABLE Countries
(
    CountryId INT CONSTRAINT pk_CountryId PRIMARY KEY IDENTITY,
    CountryName VARCHAR(20) CONSTRAINT uq_CountryName UNIQUE NOT NULL
)
GO

-- Create States table
CREATE TABLE States
(
    StateId INT CONSTRAINT pk_StateId PRIMARY KEY IDENTITY NOT NULL,
    CountryId INT CONSTRAINT fk_Country_States REFERENCES Countries(CountryId) NOT NULL,
    StateName VARCHAR(20) CONSTRAINT uq_StateName UNIQUE NOT NULL
)
GO

-- Create Login table with consistent data types and corrected constraint name
CREATE TABLE Login
(
    LoginId INT CONSTRAINT pk_LoginId PRIMARY KEY IDENTITY,
    EmailId VARCHAR(50) CONSTRAINT uq_EmailId UNIQUE NOT NULL,
    UserPassword VARCHAR(15) NOT NULL,
    RoleId INT CONSTRAINT fk_Role_Login REFERENCES Roles(RoleId) -- Changed to INT
)
GO

-- Create Users table with corrected column name
CREATE TABLE Users
(
    UserId INT CONSTRAINT pk_UserId PRIMARY KEY IDENTITY,
    LoginId INT CONSTRAINT fk_Login_Users REFERENCES Login(LoginId),
    FirstName VARCHAR(20) NOT NULL,
    SecondName VARCHAR(20) NOT NULL,
    Gender CHAR(1) CONSTRAINT chk_Gender CHECK(Gender='F' OR Gender='M') NULL,
    DateOfBirth DATE NULL
)
GO

-- Create AddressType table
CREATE TABLE AddressType
(
    AddressTypeId INT CONSTRAINT pk_AddressTypeId PRIMARY KEY IDENTITY,
    AddressTypeName VARCHAR(20) NOT NULL
)
GO

-- Create Address table with unique constraint names
CREATE TABLE Address
(
    AddressId INT CONSTRAINT pk_AddressId PRIMARY KEY IDENTITY,
    UserId INT CONSTRAINT fk_User_Address REFERENCES Users(UserId),
    AddressTypeId INT CONSTRAINT fk_AddressType_Address REFERENCES AddressType(AddressTypeId),
    MobileNo VARCHAR(12) NOT NULL,
    AlternateMobileNo VARCHAR(12) NULL,
    Address VARCHAR(100) NOT NULL,
    Town VARCHAR(20) NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    StateId INT CONSTRAINT fk_State_Address REFERENCES States(StateId),
    CountryId INT CONSTRAINT fk_Country_Address REFERENCES Countries(CountryId) -- Unique constraint name
)
GO

-- Create Categories table
CREATE TABLE Categories
(
    CategoryId TINYINT CONSTRAINT pk_CategoryId PRIMARY KEY IDENTITY,
    CategoryName VARCHAR(20) CONSTRAINT uq_CategoryName UNIQUE NOT NULL
)
GO

-- Create Products table
CREATE TABLE Products
(
    ProductId CHAR(4) CONSTRAINT pk_ProductId PRIMARY KEY CONSTRAINT chk_ProductId CHECK(ProductId LIKE 'P%'),
    ProductName VARCHAR(50) CONSTRAINT uq_ProductName UNIQUE NOT NULL,
    CategoryId TINYINT CONSTRAINT fk_Category_Products REFERENCES Categories(CategoryId),
    Price NUMERIC(8, 2) CONSTRAINT chk_Price CHECK(Price > 0) NOT NULL,
    QuantityAvailable INT CONSTRAINT chk_QuantityAvailable CHECK (QuantityAvailable >= 0) NOT NULL
)
GO

-- Create PurchaseDetails table with corrected reference to EmailId
CREATE TABLE PurchaseDetails
(
    PurchaseId BIGINT CONSTRAINT pk_PurchaseId PRIMARY KEY IDENTITY(1000, 1),
    EmailId VARCHAR(50) CONSTRAINT fk_Email_PurchaseDetails REFERENCES Login(EmailId),
    ProductId CHAR(4) CONSTRAINT fk_Product_PurchaseDetails REFERENCES Products(ProductId),
    QuantityPurchased SMALLINT CONSTRAINT chk_QuantityPurchased CHECK(QuantityPurchased > 0) NOT NULL,
    DateOfPurchase DATETIME CONSTRAINT chk_DateOfPurchase CHECK(DateOfPurchase <= GETDATE()) DEFAULT GETDATE() NOT NULL
)
GO

-- Create CardDetails table
CREATE TABLE CardDetails
(
    CardNumber NUMERIC(16) CONSTRAINT pk_CardNumber PRIMARY KEY,
    NameOnCard VARCHAR(40) NOT NULL,
    CardType CHAR(6) NOT NULL CONSTRAINT chk_CardType CHECK (CardType IN ('A', 'M', 'V')),
    CVVNumber NUMERIC(3) NOT NULL,
    ExpiryDate DATE NOT NULL CONSTRAINT chk_ExpiryDate CHECK(ExpiryDate >= GETDATE()),
    Balance DECIMAL(10, 2) CONSTRAINT chk_Balance CHECK(Balance >= 0)
)
GO




CREATE FUNCTION ufn_CheckEmailId
(
	@EmailId VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	
	DECLARE @ReturnValue BIT
	IF NOT EXISTS (SELECT EmailId FROM [Login] WHERE EmailId=@EmailId)
		SET @ReturnValue=1
	ELSE 
		SET @ReturnValue=0
	RETURN @ReturnValue
END
GO

CREATE FUNCTION ufn_ValidateUserCredentials
(
	@EmailId VARCHAR(50),
    @UserPassword VARCHAR(15)
)
RETURNS INT
AS
BEGIN
	DECLARE @RoleId INT
	SELECT @RoleId=RoleId FROM [Login] WHERE EmailId=@EmailId AND UserPassword=@UserPassword
	RETURN @RoleId
END
GO


CREATE FUNCTION ufn_GetCategories()
RETURNS TABLE 
AS
	RETURN (SELECT * FROM Categories)
GO

CREATE FUNCTION ufn_GetCardDetails(@CardNumber NUMERIC(16))
RETURNS TABLE 
AS
	RETURN (SELECT NameOnCard,CardType,CVVNumber,ExpiryDate,Balance 
			FROM CardDetails 
			WHERE CardNumber=@CardNumber)
GO

CREATE FUNCTION ufn_GetProductDetails(@CategoryId TINYINT)
RETURNS TABLE 
AS
RETURN (SELECT ProductId,ProductName,Price,QuantityAvailable,CategoryId 
		FROM Products 
		WHERE CategoryId=@CategoryId)
GO

CREATE FUNCTION ufn_GetAllProductDetails(@CategoryId TINYINT)
RETURNS TABLE 
AS
	 RETURN (SELECT ProductId, ProductName, Price, c.CategoryName, QuantityAvailable 
	         FROM Products p INNER JOIN Categories c
			 ON p.CategoryId = c.CategoryId
			 WHERE p.CategoryId = @CategoryId)
GO




CREATE FUNCTION ufn_GetProductCategoryDetails(@CategoryId TINYINT)
RETURNS TABLE 
AS
	 RETURN (SELECT ProductId, ProductName, Price, c.CategoryName, QuantityAvailable 
	         FROM Products p INNER JOIN Categories c
			 ON p.CategoryId = c.CategoryId
			 WHERE p.CategoryId = @CategoryId)
GO


CREATE FUNCTION ufn_GenerateNewProductId()
RETURNS CHAR(4)
AS
BEGIN
	DECLARE @ProductId CHAR(4)	
	IF NOT EXISTS(SELECT ProductId FROM Products)
		SET @ProductId='P100'		
	ELSE
		SELECT @ProductId='P'+CAST(CAST(SUBSTRING(MAX(ProductId),2,3) AS INT)+1 AS CHAR) FROM Products
	RETURN @ProductId	
END
GO

CREATE FUNCTION ufn_GenerateNewCategoryId()
RETURNS INT
AS
BEGIN
	DECLARE @CategoryId TINYINT	
	IF NOT EXISTS(SELECT ProductId FROM Products)
		SET @CategoryId ='1'		
	ELSE
		SELECT @CategoryId =MAX(CategoryId)+1 FROM Categories
	RETURN @CategoryId 	
END
GO


CREATE PROCEDURE usp_AddProduct
(
	@ProductId CHAR(4),
	@ProductName VARCHAR(50),
	@CategoryId TINYINT,
	@Price NUMERIC(8),
	@QuantityAvailable INT
)
AS
BEGIN
	BEGIN TRY
		IF (@ProductId IS NULL)
			RETURN -1
		IF (@ProductId NOT LIKE 'P%' or LEN(@ProductId)<>4)
			RETURN -2
		IF (@ProductName IS NULL)
			RETURN -3
		IF (@CategoryId IS NULL)
			RETURN -4
		IF NOT EXISTS(SELECT CategoryId FROM Categories WHERE CategoryId=@CategoryId)
			RETURN -5
		IF (@Price<=0 OR @Price IS NULL)
			RETURN -6
		IF (@QuantityAvailable<0 OR @QuantityAvailable IS NULL)
			RETURN -7
		INSERT INTO Products(ProductId, ProductName, CategoryId, Price, QuantityAvailable) VALUES 
		(@ProductId,@ProductName, @CategoryId, @Price, @QuantityAvailable)
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN -99
	END CATCH
END
GO


CREATE PROCEDURE usp_AddCategory
(
	@CategoryName VARCHAR(20),
    @CategoryId TINYINT OUT
)
AS
BEGIN
	SET @CategoryId = 0
	BEGIN TRY
		IF (@CategoryName IS NULL)
			RETURN -1
		IF EXISTS(SELECT CategoryId FROM Categories WHERE CategoryName=@CategoryName)
			RETURN -2	
		INSERT INTO Categories(CategoryName) VALUES (@CategoryName)
		SELECT @CategoryId=CategoryId from Categories where CategoryName = @CategoryName
		RETURN 1
	END TRY
	BEGIN CATCH
		SET @CategoryId = 0
		RETURN -99
	END CATCH
END
GO

CREATE PROCEDURE usp_UpdateBalance
(
	@CardNumber NUMERIC(16),
	@NameOnCard VARCHAR(40),
	@CardType CHAR(6),
	@CVVNumber NUMERIC(3),
	@ExpiryDate DATE,
	@Price DECIMAL(8)
)
AS
BEGIN
	DECLARE @TempUsersName VARCHAR(40), @TempCardType CHAR(6), @TempCVVNumber NUMERIC(3),
	@TempExpiryDate DATE, @Balance DECIMAL(8)
	BEGIN TRY
		IF (@CardNumber IS NULL)
			RETURN -1
		IF NOT EXISTS(SELECT * FROM CardDetails WHERE CardNumber=@CardNumber)
			RETURN -2
		SELECT @TempUsersName=NameOnCard, @TempCardType=CardType, @TempCVVNumber=CVVNumber,
		@TempExpiryDate=ExpiryDate, @Balance=Balance FROM CardDetails 
		WHERE CardNumber=@CardNumber
		IF ((@TempUsersName<>@NameOnCard) OR (@NameOnCard IS NULL))
			RETURN -3
		IF ((@TempCardType<>@CardType) OR (@CardType IS NULL))
			RETURN -4
		IF ((@TempCVVNumber<>@CVVNumber) OR (@CVVNumber IS NULL))
			RETURN -5			
		IF ((@TempExpiryDate<>@ExpiryDate) OR (@ExpiryDate IS NULL))
			RETURN -6
		IF ((@Balance<@Price) OR (@Price IS NULL))
			RETURN -7
		UPDATE Carddetails SET Balance=Balance-@Price WHERE CardNumber=@CardNumber
		RETURN 1
	END TRY
	BEGIN CATCH
		RETURN -99
	END CATCH
END
GO

CREATE PROCEDURE usp_InsertPurchaseDetails
(
	@EmailId VARCHAR(50),
	@ProductId CHAR(4),
	@QuantityPurchased INT,
	@PurchaseId BIGINT OUTPUT
)
AS
BEGIN
	SET @PurchaseId=0	
		BEGIN TRY
			IF (@EmailId IS NULL)
				RETURN -1
			IF NOT EXISTS (SELECT @EmailId FROM [Login] WHERE EmailId=@EmailId)
				RETURN -2
			IF (@ProductId IS NULL)
				RETURN -3
			IF NOT EXISTS (SELECT ProductId FROM Products WHERE ProductId=@ProductId)
				RETURN -4
			IF ((@QuantityPurchased<=0) OR (@QuantityPurchased IS NULL))
				RETURN -5
			INSERT INTO PurchaseDetails VALUES (@EmailId, @ProductId, @QuantityPurchased, DEFAULT)
			SELECT @PurchaseId=IDENT_CURRENT('PurchaseDetails')
			UPDATE Products SET QuantityAvailable=QuantityAvailable-@QuantityPurchased WHERE ProductId=@ProductId			
			RETURN 1
		END TRY
		BEGIN CATCH
			SET @PurchaseId=0			
			RETURN -99
		END CATCH
	END
GO

CREATE PROCEDURE usp_GetProductsOnCategoryId
(
	@CategoryId VARCHAR(20)
)
AS
	SELECT * FROM Products WHERE CategoryId = @CategoryId
GO


select * from CardDetails
select * from PurchaseDetails
select * from Products
select * from Categories
select * from Users
select * from Roles
select * from Login
select * from AddressType
select * from Address
select * from Countries
select * from States
