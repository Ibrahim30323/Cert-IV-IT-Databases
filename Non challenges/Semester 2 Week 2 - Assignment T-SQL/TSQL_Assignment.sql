IF OBJECT_ID('Sale') IS NOT NULL
DROP TABLE SALE;

IF OBJECT_ID('Product') IS NOT NULL
DROP TABLE PRODUCT;

IF OBJECT_ID('Customer') IS NOT NULL
DROP TABLE CUSTOMER;

IF OBJECT_ID('Location') IS NOT NULL
DROP TABLE LOCATION;

GO

CREATE TABLE CUSTOMER (
CUSTID	INT
, CUSTNAME	NVARCHAR(100)
, SALES_YTD	MONEY
, STATUS	NVARCHAR(7)
, PRIMARY KEY	(CUSTID) 
); 


CREATE TABLE PRODUCT (
PRODID	INT
, PRODNAME	NVARCHAR(100)
, SELLING_PRICE	MONEY
, SALES_YTD	MONEY
, PRIMARY KEY	(PRODID)
);

CREATE TABLE SALE (
SALEID	BIGINT
, CUSTID	INT
, PRODID	INT
, QTY	INT
, PRICE	MONEY
, SALEDATE	DATE
, PRIMARY KEY 	(SALEID)
, FOREIGN KEY 	(CUSTID) REFERENCES CUSTOMER
, FOREIGN KEY 	(PRODID) REFERENCES PRODUCT
);

CREATE TABLE LOCATION (
  LOCID	NVARCHAR(5)
, MINQTY	INTEGER
, MAXQTY	INTEGER
, PRIMARY KEY 	(LOCID)
, CONSTRAINT CHECK_LOCID_LENGTH CHECK (LEN(LOCID) = 5)
, CONSTRAINT CHECK_MINQTY_RANGE CHECK (MINQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_RANGE CHECK (MAXQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_GREATER_MIXQTY CHECK (MAXQTY >= MINQTY)
);

IF OBJECT_ID('SALE_SEQ') IS NOT NULL
DROP SEQUENCE SALE_SEQ;
CREATE SEQUENCE SALE_SEQ;


-- Q1:
GO
IF OBJECT_ID('ADD_CUSTOMER') IS NOT NULL
DROP PROCEDURE ADD_CUSTOMER;
GO

CREATE PROCEDURE ADD_CUSTOMER 
  @PCUSTID INT, 
  @PCUSTNAME NVARCHAR(100) 
  
AS

BEGIN
    BEGIN TRY

        IF @PCUSTID < 1 OR @PCUSTID > 499
            THROW 50020, 'Customer ID out of range', 1

        INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS) 
        VALUES (@PCUSTID, @PCUSTNAME, 0, 'OK');

    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = @PCUSTID
            THROW 50010, 'Duplicate customer ID', 1
        ELSE IF ERROR_NUMBER() = 50020
            THROW
        ELSE
            BEGIN
                DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
                THROW 50000, @ERRORMESSAGE, 1
            END
    END CATCH

END
-------------------------------------------------------------------


-- Exec Q1:
EXEC ADD_CUSTOMER @pcustid = 13, @pcustname = 'Sheen';

----------------------------------------------------------------

-- Test Statements for Q1:
SELECT * FROM CUSTOMER

--------------------------------------------------------------

-- Q2:
GO
IF OBJECT_ID('DELETE_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_CUSTOMERS;
GO


CREATE PROCEDURE DELETE_ALL_CUSTOMERS
   -- No Parameters 
AS
BEGIN
BEGIN TRY
       DELETE FROM CUSTOMER;
       RETURN @@Rowcount
END TRY

BEGIN CATCH
  DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
      IF @@Rowcount >= 2
      THROW 50000, @ERRORMESSAGE, 1       
END CATCH
END
-------------------------------------------------------------

-- Test Statements for Q2: 

-- DECLARE @NUM_OF_CUSTOMERS_DELETED INT
-- EXEC DELETE_ALL_CUSTOMERS 
-- PRINT @NUM_OF_CUSTOMERS_DELETED

-----------------------------------------------------------------------------

-- Exec Q2:
BEGIN
DECLARE @NROWS INT 

  EXEC @NROWS = DELETE_ALL_CUSTOMERS 
  PRINT (CONCAT('Number of Rows Deleted from the CUSTOMER table: ', @NROWS)) 
END
---------------------------------------------------------------------------

-- Q3:
GO
IF OBJECT_ID('ADD_PRODUCT') IS NOT NULL
DROP PROCEDURE ADD_PRODUCT;
GO

CREATE PROC ADD_PRODUCT 
  @pprodid INT,
  @pprodname nvarchar(100),
  @pprice money
AS
BEGIN
   BEGIN TRY
         IF @pprodid < 1000 OR @pprodid > 2500
          THROW 50040, 'Product ID out of range', 1  
         IF @pprice > 999.99 OR @pprice < 0
          THROW 50050, 'Price out of range', 1  
       INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
       VALUES (@pprodid, @pprodname, @pprice, 0);
   END TRY

   BEGIN CATCH
        IF ERROR_NUMBER() = 2627
          THROW 50030, 'Duplicate product ID', 1
        ELSE IF ERROR_NUMBER() IN (50040, 50050)

            THROW
        ELSE
          BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
          END
   END CATCH
END
--------------------------------------------------------


-- Exec Q3:
EXEC ADD_PRODUCT @pprodid = 2100, @pprodname = 'Asparagus', @pprice = 20 

---------------------------------------------------------------------------

-- Test Statements for Q3:

-- SELECT * FROM PRODUCT 
-- DROP TABLE PRODUCT
-- DROP PROC ADD_PRODUCT
-- DELETE FROM PRODUCT

---------------------------------------------------------------------------




-- Q4:
GO
IF OBJECT_ID('DELETE_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE DELETE_ALL_PRODUCTS;
GO

CREATE PROC DELETE_ALL_PRODUCTS
 -- No Parameters  
AS

BEGIN
BEGIN TRY
       DELETE FROM PRODUCT;
       RETURN @@Rowcount
END TRY

BEGIN CATCH
  DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
      IF @@Rowcount >= 2
      THROW 50000, @ERRORMESSAGE, 1       
END CATCH
END

---------------------------------------------------------------------


-- Exec Q4:
BEGIN
DECLARE @NROWS INT 
EXEC @NROWS = DELETE_ALL_PRODUCTS
PRINT (CONCAT('Number of Rows Deleted from the PRODUCT table: ', @NROWS)) 
END
---------------------------------------------------------------------------

-- Test Statements for Q4:

-- SELECT * FROM PRODUCT
-- DROP PROCEDURE DELETE_ALL_PRODUCTS;

-----------------------------------------------------------------------


-- Q5:
GO
IF OBJECT_ID('GET_CUSTOMER_STRING') IS NOT NULL
DROP PROCEDURE GET_CUSTOMER_STRING;
GO

CREATE PROC GET_CUSTOMER_STRING 
  @pcustid INT, 
  @pReturnString NVARCHAR(1000) OUTPUT
AS

BEGIN
BEGIN TRY
        DECLARE @CUSTID INT = @pcustid
          IF @CUSTID <= 998 OR @CUSTID >= 1000
             THROW  50060, 'Customer ID not found', 1  
          INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS)
             VALUES (@pcustid, 'Teddy', 99999.99, 'ALIVE');  
          SELECT CUSTNAME FROM CUSTOMER WHERE CUSTID = @pcustid
END TRY

BEGIN CATCH
         BEGIN
           DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
           THROW 50000, @ERRORMESSAGE, 1
         END
END CATCH
END

-------------------------------------------------------

-- Exec Q5:
DECLARE @String NVARCHAR(1000)
EXEC GET_CUSTOMER_STRING  @pcustid = 999, @pReturnString = @String OUT
PRINT @String


---------------------------------------------------------------------------

-- Test Statements for Q5:

-- SELECT * FROM PRODUCT
-- SELECT * FROM CUSTOMER
-- DROP PROCEDURE GET_CUSTOMER_STRING
-- DELETE FROM CUSTOMER

-----------------------------------------------------------------------


-- Q6:
GO
IF OBJECT_ID('UPD_CUST_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_CUST_SALESYTD;
GO

CREATE PROC UPD_CUST_SALESYTD
@pcustid INT, 
@pamt MONEY

AS
BEGIN
  BEGIN TRY
     UPDATE CUSTOMER
     SET SALES_YTD = @pamt
     WHERE CUSTID = @pcustid
     
     IF @@ROWCOUNT = 0
       THROW 50070, 'No rows updated', 1
     IF @pamt < -999.99 OR  @pamt > 999.99
       THROW 50080, 'Amount out of range', 1
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

------------------------------------------------------------------------

-- Exec Q6:

EXEC UPD_CUST_SALESYTD @pcustid = 999, @pamt = 500


---------------------------------------------------------------------------

-- Test Statements for Q6:

-- SELECT * FROM CUSTOMER
-- DROP PROCEDURE UPD_CUST_SALESYTD
-- DELETE FROM CUSTOMER

-----------------------------------------------------------------------

-- Q7:
GO
IF OBJECT_ID('GET_PROD_STRING') IS NOT NULL
DROP PROCEDURE GET_PROD_STRING;
GO

CREATE PROC GET_PROD_STRING
@pprodid INT, 
@pReturnString NVARCHAR(1000) OUTPUT

AS
BEGIN
  BEGIN TRY
       
       DECLARE @PRODUCT_ID INT = @pprodid
       IF @PRODUCT_ID <> 999
         THROW 50090, 'Product ID not found', 1
       INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
         VALUES (@pprodid, 'ORANGE', 999.99, 99999.99); 
       SELECT PRODNAME FROM PRODUCT WHERE PRODID = @pprodid    
         
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

----------------------------------------------------------------

-- Exec Q7:

DECLARE @ReturnString NVARCHAR(1000)
EXEC GET_PROD_STRING @pprodid = 999, @pReturnString = @ReturnString OUT
PRINT @ReturnString


-------------------------------------------------------------------

-- Test Statements for Q7:

-- SELECT * FROM PRODUCT
-- DROP PROCEDURE GET_PROD_STRING
-- DELETE FROM PRODUCT

-----------------------------------------------------------------------


-- Q8:
GO
IF OBJECT_ID('UPD_PROD_SALESYTD') IS NOT NULL
DROP PROCEDURE UPD_PROD_SALESYTD;
GO

CREATE PROC UPD_PROD_SALESYTD
@pprodid INT, 
@pamt Money

AS
BEGIN
  BEGIN TRY
      
      UPDATE PRODUCT
      SET SALES_YTD = @pamt
      WHERE PRODID = @pprodid;

      IF @@ROWCOUNT = 0
       THROW 50100, 'No rows updated', 1
      IF @pamt < -999.99 OR @pamt > 999.99
       THROW 50110, 'Amount out of range', 1

  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

----------------------------------------------------------------

-- Exec Q8:

EXEC UPD_PROD_SALESYTD @pprodid = 999, @pamt = 430


-------------------------------------------------------------------

-- Test Statements for Q8:

-- SELECT * FROM PRODUCT
-- DROP PROCEDURE UPD_PROD_SALESYTD
-- DELETE FROM PRODUCT

-----------------------------------------------------------------------


-- Q9:
GO
IF OBJECT_ID('UPD_CUSTOMER_STATUS') IS NOT NULL
DROP PROCEDURE UPD_CUSTOMER_STATUS;
GO

CREATE PROC UPD_CUSTOMER_STATUS
@pcustid INT, 
@pstatus NVARCHAR(7)

AS
BEGIN
  BEGIN TRY

       UPDATE CUSTOMER
       SET STATUS = @pstatus
       WHERE CUSTID = @pcustid

       IF @@ROWCOUNT = 0
         THROW 50120, 'Customer ID not found', 1
       IF @pstatus = 'OK' OR @pstatus = 'SUSPEND'
         THROW 50130, 'Invalid Status Value', 1  
      
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

----------------------------------------------------------------

-- Exec Q9:

EXEC UPD_CUSTOMER_STATUS @pcustid = 999, @pstatus = 'LIVING'


-------------------------------------------------------------------

-- Test Statements for Q9:

-- SELECT * FROM CUSTOMER
-- DROP PROCEDURE UPD_CUSTOMER_STATUS
-- DELETE FROM CUSTOMER

-----------------------------------------------------------------------


-- Q10:
GO
IF OBJECT_ID('ADD_SIMPLE_SALE') IS NOT NULL
DROP PROCEDURE ADD_SIMPLE_SALE;
GO

CREATE PROC ADD_SIMPLE_SALE
@pcustid INT, 
@pprodid INT,
@pqty INT

AS
BEGIN
  BEGIN TRY

      
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

----------------------------------------------------------------

-- Exec Q10:

EXEC ADD_SIMPLE_SALE 


-------------------------------------------------------------------

-- Test Statements for Q10:

-- SELECT * FROM CUSTOMER
-- DROP PROCEDURE ADD_SIMPLE_SALE
-- DELETE FROM CUSTOMER

-----------------------------------------------------------------------