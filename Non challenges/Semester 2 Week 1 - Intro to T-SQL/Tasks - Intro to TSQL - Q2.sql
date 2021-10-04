CREATE FUNCTION _ADD 
    (
        @number1 AS INT,
        @number2 AS INT   
    )
               
RETURNS INT
  

AS
BEGIN
   DECLARE
    @number3 AS INT;
    SET @number3 = @number1 + @number2;
    RETURN @number3;
END;  


BEGIN
   SELECT 'The sum of 4 and 6 is ' + CAST(dbo._ADD(4, 6) AS VARCHAR);
END;




DROP FUNCTION dbo._ADD;

/*Create a stored function called 'ADD' that takes 2 numbers as parameters and returns the 
sum of the numbers ( as a suitable numeric datatype ) 
Write an anonymous block that calls the stored function, and outputs the result in the 
following format 
e.g. The sum of 1 and 5 is */
