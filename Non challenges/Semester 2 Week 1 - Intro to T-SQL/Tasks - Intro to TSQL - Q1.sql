--Name: Ibrahim Oztas
--Student ID: 103577332
--Group: 2

CREATE PROCEDURE MULTIPLY @NUMBER_VARIABLE1 int, @NUMBER_VARIABLE2 int AS 



BEGIN
    SELECT CONCAT('The product of ', @NUMBER_VARIABLE1 , ' and ' , @NUMBER_VARIABLE2 , ' is ' , @NUMBER_VARIABLE1 * @NUMBER_VARIABLE2);
 
END;


EXEC MULTIPLY @NUMBER_VARIABLE1 = 4, @NUMBER_VARIABLE2 = 4;

-- Below outputs a table with shows my already made procedures
select name, modify_date from sys.procedures 

DROP procedure MULTIPLY













