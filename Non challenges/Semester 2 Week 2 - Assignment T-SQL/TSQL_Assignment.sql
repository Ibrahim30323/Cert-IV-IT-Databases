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

  DECLARE @NUM_OF_CUSTOMERS_DELETED INT
  EXEC DELETE_ALL_CUSTOMERS 
  PRINT @NUM_OF_CUSTOMERS_DELETED

  SELECT * FROM CUSTOMER

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
   --     ELSE IF ERROR_NUMBER() IN (50040, 50050)

   --    THROW
   --     ELSE
          BEGIN
            DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
            THROW 50000, @ERRORMESSAGE, 1
          END
   END CATCH
END
--------------------------------------------------------


-- Exec Q3:
EXEC ADD_PRODUCT @pprodid = 1300, @pprodname = 'Asparagus', @pprice = 20 

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
      THROW 50000, @ERRORMESSAGE, 1       
    IF @@Rowcount >= 2
      THROW 50000, @ERRORMESSAGE, 1      
END CATCH
END

---------------------------------------------------------------------


-- Exec Q4:

DECLARE @NROWS INT 
EXEC @NROWS = DELETE_ALL_PRODUCTS
PRINT (CONCAT('Number of Rows Deleted from the PRODUCT table: ', @NROWS)) 

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
          SET @pReturnString = 'Teddy';

          INSERT INTO CUSTOMER (CUSTID, CUSTNAME, SALES_YTD, STATUS)
             VALUES (@pcustid, @pReturnString, 99999.99, 'ALIVE');  
  
          IF @pcustid IS NULL 
             THROW  50060, 'Customer ID not found', 1  
 
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
EXEC GET_CUSTOMER_STRING  999, @String OUTPUT
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
       
       SET @pReturnString = 'ORANGE'
       IF @pprodid IS NULL
         THROW 50090, 'Product ID not found', 1

       INSERT INTO PRODUCT (PRODID, PRODNAME, SELLING_PRICE, SALES_YTD)
         VALUES (@pprodid, @pReturnString, 999.99, 99999.99);    
         
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
EXEC GET_PROD_STRING  999, @ReturnString OUTPUT
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
      WHERE PRODID = @pprodid

      IF @@ROWCOUNT = 0
       THROW 50100, 'Product ID not found', 1
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
@pqty MONEY

AS
BEGIN
  BEGIN TRY

       -- Exception
       IF @pqty <= 0 OR @pqty >= 1000 
         THROW 50140, 'Sale Quantity outside valid range', 1
       ---------------------------------------

       -- Updating Customer table status value to OK 
       DECLARE @CUST_STATUS_VALUE_UPDATED NVARCHAR(7) = 'OK'

       UPDATE CUSTOMER 
       SET STATUS = @CUST_STATUS_VALUE_UPDATED
       WHERE CUSTID = @pcustid
       --------------------------------------

       -- Exception
       IF @CUST_STATUS_VALUE_UPDATED <> 'OK' 
         THROW 50150, 'Customer status is not OK', 1 
       --------------------------------------
             
       
       -- Updating Customer table Sales YTD
       EXEC UPD_CUST_SALESYTD @pcustid = @pcustid, @pamt = @pqty 
       -- Updating Product table Product YTD 
       EXEC UPD_PROD_SALESYTD @pprodid = @pprodid, @pamt = @pqty 

       -- Exception
       IF @pcustid <> 999
         THROW 50160, 'Customer ID not found', 1
       -------------------------------------

       -- Exception
       IF @pprodid <> 999
         THROW 50170, 'Product ID not found', 1  
       -------------------------------------
              
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q10:

EXEC ADD_SIMPLE_SALE @pcustid = 999, @pprodid = 999, @pqty = 520  
     
-------------------------------------------------------------------

-- Test Statements for Q10:

-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- DROP PROCEDURE ADD_SIMPLE_SALE

-----------------------------------------------------------------------

-- Q11:

GO
IF OBJECT_ID('SUM_CUSTOMER_SALESYTD') IS NOT NULL
DROP PROCEDURE SUM_CUSTOMER_SALESYTD;
GO

CREATE PROC SUM_CUSTOMER_SALESYTD
-- No parameters

AS
BEGIN
  BEGIN TRY

      DECLARE @ANSWER INT
      SET @ANSWER = (SELECT SUM(SALES_YTD) Over (Order By CUSTID) as Customer_Sales_Summed_up  
      FROM CUSTOMER) 
      RETURN @ANSWER

  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q11:

DECLARE @TotalSUM INT
EXEC @TotalSUM = SUM_CUSTOMER_SALESYTD
PRINT @TotalSUM

-------------------------------------------------------------------

-- Test Statements for Q11:

-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- DROP SUM_CUSTOMER_SALESYTD

-----------------------------------------------------------------------

-- Q12:

GO
IF OBJECT_ID('SUM_PRODUCT_SALESYTD') IS NOT NULL
DROP PROCEDURE SUM_PRODUCT_SALESYTD;
GO

CREATE PROC SUM_PRODUCT_SALESYTD
-- No parameters

AS
BEGIN
  BEGIN TRY

      DECLARE @ANSWER INT
      SET @ANSWER = (SELECT SUM(SALES_YTD) Over(Order By PRODID) as Product_Sales_Summed_up  
      FROM PRODUCT) 
      RETURN @ANSWER

  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q12:

DECLARE @TotalSUM INT
EXEC @TotalSUM = SUM_PRODUCT_SALESYTD
PRINT @TotalSUM

-------------------------------------------------------------------

-- Test Statements for Q12:

-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- DROP SUM_PRODUCT_SALESYTD

-----------------------------------------------------------------------

-- Q13:

GO
IF OBJECT_ID('GET_ALL_CUSTOMERS') IS NOT NULL
DROP PROCEDURE GET_ALL_CUSTOMERS;
GO

CREATE PROCEDURE GET_ALL_CUSTOMERS 
@POUTCUR CURSOR VARYING OUTPUT 


AS

BEGIN
  BEGIN TRY

    SET @POUTCUR = CURSOR FOR         
    SELECT * FROM CUSTOMER;        
    OPEN @POUTCUR;    

  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q13:

DECLARE 
    @POUTCUR_ CURSOR

DECLARE
    @database_id INT, 
    @database_name  VARCHAR(255);

EXEC GET_ALL_CUSTOMERS @POUTCUR = @POUTCUR OUTPUT

FETCH NEXT FROM @POUTCUR INTO 
      @database_id, 
      @database_name;

WHILE @@FETCH_STATUS = 0
BEGIN
   PRINT @database_name + ' id:' + CAST(@database_id AS VARCHAR(10));

   FETCH NEXT FROM @POUTCUR INTO 
      @database_id, 
      @database_name;
END;

CLOSE @POUTCUR;

DEALLOCATE @POUTCUR;
GO

-------------------------------------------------------------------

/* Note: Q13 went well but I dont know why it
 didnt display the customer details */

-- Test Statements for Q13:

-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- DROP GET_ALL_CUSTOMERS

-----------------------------------------------------------------------

-- Q14:

GO
IF OBJECT_ID('GET_ALL_PRODUCTS') IS NOT NULL
DROP PROCEDURE GET_ALL_PRODUCTS;
GO

CREATE PROCEDURE GET_ALL_PRODUCTS
@pOutCur CURSOR VARYING OUTPUT 


AS

BEGIN
  BEGIN TRY

    SET @pOutCur = CURSOR FOR         
    SELECT * FROM PRODUCT;        
    OPEN @pOutCur;    

  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q14:

DECLARE 
    @pOutCur_ CURSOR

DECLARE
    @database_id INT, 
    @database_name VARCHAR(255);

EXEC GET_ALL_PRODUCTS @pOutCur = @pOutCur OUTPUT

FETCH NEXT FROM @pOutCur INTO 
   @database_id, @database_name;

WHILE @@FETCH_STATUS = 0
BEGIN
   PRINT @database_name + ' id:' + CAST(@database_id AS VARCHAR(10));

   FETCH NEXT FROM @pOutCur INTO 
      @database_id, 
      @database_name;
END;

CLOSE @pOutCur;

DEALLOCATE @pOutCur;
GO

-------------------------------------------------------------------

/* Note: Q14 went well but I dont know why it
 didnt display the customer details */

-- Test Statements for Q14:

-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- DROP GET_ALL_CUSTOMERS

-----------------------------------------------------------------------


-- Q15:

GO
IF OBJECT_ID('ADD_LOCATION') IS NOT NULL
DROP PROCEDURE ADD_LOCATION;
GO

CREATE PROCEDURE ADD_LOCATION
@ploccode NVARCHAR(5),
@pminqty INTEGER,  
@pmaxqty INTEGER

AS

BEGIN
  BEGIN TRY

       INSERT INTO LOCATION (LOCID, MINQTY, MAXQTY)
       VALUES (@ploccode, @pminqty, @pmaxqty)

       IF ERROR_NUMBER() = 2627
        THROW 50030, 'Duplicate Location ID', 1

       IF LEN(@ploccode) >= 6 
        THROW 50190, 'Location Code length invalid', 1
    
       IF @pminqty < 0 OR @pminqty > 999
        THROW 50200, 'Minimum Qty out of range', 1

       IF @pmaxqty < 0 OR @pmaxqty >= 999
        THROW 50210, 'Maximum Qty out of range', 1  

       IF @pmaxqty < @pminqty
        THROW 50220, 'Minimum Qty Larger than Maximum Qty', 1 
        
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q15:

  EXEC ADD_LOCATION @ploccode = 'locnn', @pminqty = 30, @pmaxqty = 40        

-------------------------------------------------------------------

-- Test Statements for Q15:

-- SELECT * FROM LOCATION
-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- DROP ADD_LOCATION
-- DROP TABLE LOCATION

-----------------------------------------------------------------------

-- Q16:

GO
IF OBJECT_ID('ADD_COMPLEX_SALE') IS NOT NULL
DROP PROCEDURE ADD_COMPLEX_SALE;
GO

CREATE PROCEDURE ADD_COMPLEX_SALE
@pcustid Int,
@pprodid Int,
@pqty Int,
@pdate Date

AS

BEGIN
  BEGIN TRY

    DECLARE @CUST_STATUS_VALUE NVARCHAR(7) = 'OK'
    
    -- Exception
    IF @CUST_STATUS_VALUE <> 'OK'
     THROW 50240, 'Customer status is not OK', 1
    -----------------------------------------

    -- Exception
    IF @pqty <= 0 OR @pqty >= 1000 
     THROW 50230, 'Sale Quantity outside valid range', 1
    -----------------------------------------

     -- Exception
    IF @pdate <> '2006-02-22'
      THROW 50250, 'Date not valid', 1
    -----------------------------------------

    -- Exception
    IF @pprodid <> 999
      THROW 50260, 'Customer ID not found', 1
    -----------------------------------------

    -- Exception
    IF @pcustid <> 999
      THROW 50270, 'Product ID not found', 1
    -----------------------------------------

    INSERT INTO SALE (SALEID, CUSTID, PRODID, QTY, PRICE, SALEDATE)
    VALUES (@pprodid, @pcustid, @pprodid, @pqty, 30 ,@pdate);

    -- Updating Customer table Sales YTD
       EXEC UPD_CUST_SALESYTD @pcustid = @pcustid, @pamt = @pqty 
    -- Updating Product table Product YTD 
       EXEC UPD_PROD_SALESYTD @pprodid = @pprodid, @pamt = @pqty 

        
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q16:

  EXEC ADD_COMPLEX_SALE @pcustid = 999, @pprodid = 999, @pqty = 200, @pdate = '2006-02-22'        

-------------------------------------------------------------------

-- Test Statements for Q16:

-- SELECT * FROM LOCATION
-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- SELECT * FROM SALE
-- DROP ADD_COMPLEX_SALE
-- DROP TABLE LOCATION

-----------------------------------------------------------------------


-- Q17:

GO
IF OBJECT_ID('GET_ALLSALES') IS NOT NULL
DROP PROCEDURE GET_ALLSALES;
GO

CREATE PROCEDURE GET_ALLSALES
@POUTCUR CURSOR VARYING OUTPUT
AS
BEGIN

   SET @POUTCUR = CURSOR
   FOR SELECT * FROM SALE;

   OPEN @POUTCUR;

END
GO

-- Exec Q17:
DECLARE 
    @POUTCUR CURSOR

DECLARE
    @database_id INT, 
    @database_name  VARCHAR(255);

EXEC GET_ALLSALES @POUTCUR = @POUTCUR OUTPUT

WHILE @@FETCH_STATUS = 0
BEGIN
   PRINT @database_name + ' id:' + CAST(@database_id AS VARCHAR(10));

   FETCH NEXT FROM @POUTCUR INTO 
      @database_id, 
      @database_name;
END;

CLOSE @POUTCUR;

DEALLOCATE @POUTCUR;
GO

/* Note: Q17 went well but I dont know why it
 didnt display the complex sale details */

-- Test Statements for Q17:

-- SELECT * FROM LOCATION
-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- SELECT * FROM SALE
-- DROP GET_ALLSALES
-- DROP TABLE LOCATION

-----------------------------------------------------------------------

-- Q18:

GO
IF OBJECT_ID('COUNT_PRODUCT_SALES') IS NOT NULL
DROP PROCEDURE COUNT_PRODUCT_SALES;
GO

CREATE PROCEDURE COUNT_PRODUCT_SALES
@pdays Int

AS

BEGIN
  BEGIN TRY
 
     DECLARE @ANSWER INT
      SET @ANSWER = (SELECT SUM(QTY) Over (Order By SALEID) as Product_Sales_Summed_up  
      FROM SALE) 
      RETURN @ANSWER


  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q18:
  DECLARE @pdays_ INT
  EXEC @pdays_ = COUNT_PRODUCT_SALES @pdays = 03
  PRINT @pdays_
-------------------------------------------------------------------

-- Test Statements for Q18:

-- SELECT * FROM LOCATION
-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- SELECT * FROM SALE
-- DROP COUNT_PRODUCT_SALES
-- DROP TABLE LOCATION

-----------------------------------------------------------------------


-- Q19:

GO
IF OBJECT_ID('DELETE_SALE') IS NOT NULL
DROP PROCEDURE DELETE_SALE;
GO

CREATE PROCEDURE DELETE_SALE
-- No Parameters 

AS

BEGIN
  BEGIN TRY

      SELECT PRICE*QTY AS total_price
      FROM SALE

  -- Updating Customer table Sales YTD
       EXEC UPD_CUST_SALESYTD @pcustid = 999, @pamt = 0 
  -- Updating Product table Product YTD 
       EXEC UPD_PROD_SALESYTD @pprodid = 999, @pamt = 0 

  IF NOT EXISTS (SELECT 1 FROM SALE WHERE SALEID = 999)
   THROW 50280, 'No Sale Rows Found', 1
  ELSE DELETE FROM SALE WHERE SALEID = 999;
        
    (SELECT MIN(SALEID) FROM SALE WHERE SALEID = 999)

    RETURN 999;

  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q19:
  DECLARE @SaleID_Value INT
  EXEC DELETE_SALE
  PRINT @SaleID_Value
 
-------------------------------------------------------------------

-- Test Statements for Q19:

-- SELECT * FROM LOCATION
-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- SELECT * FROM SALE
-- DROP DELETE_SALE
-- DROP TABLE SALE

-----------------------------------------------------------------------

-- Q22:

GO
IF OBJECT_ID('DELETE_PRODUCT') IS NOT NULL
DROP PROCEDURE DELETE_PRODUCT
GO

CREATE PROCEDURE DELETE_PRODUCT
 @pProdid Int

AS

BEGIN
  BEGIN TRY
        
      

       -- Exception
       IF @pprodid <> 999
         THROW 50320, 'Product cannot be deleted as sales exist', 1 
       -------------------------------------

       -- Exception
       IF @pprodid <> 999
         THROW 50320, 'Product ID not found', 1  
       -------------------------------------

        DELETE FROM PRODUCT;

      
  END TRY
  BEGIN CATCH
      BEGIN
         DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
         THROW 50000, @ERRORMESSAGE, 1
      END
  END CATCH
END

-- Exec Q19:
  EXEC DELETE_PRODUCT @pProdid = 999
  
-------------------------------------------------------------------

-- Test Statements for Q19:

-- SELECT * FROM LOCATION
-- SELECT * FROM CUSTOMER
-- SELECT * FROM PRODUCT
-- SELECT * FROM SALE
-- DROP DELETE_SALE
-- DROP TABLE SALE

-----------------------------------------------------------------------