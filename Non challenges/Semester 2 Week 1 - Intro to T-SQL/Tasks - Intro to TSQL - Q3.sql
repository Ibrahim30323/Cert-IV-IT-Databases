CREATE TABLE Account (
    AcctNo INT,
    Fname TEXT, 
    Lname TEXT, 
    CreditLimit INT, 
    Balance INT,
    PRIMARY KEY (AcctNo));

CREATE TABLE _Log (
    OrigAcct INT, 
    LogDateTime DATETIME, 
    RecAcct INT, 
    Amount INT,
    PRIMARY KEY (OrigAcct, LogDateTime),
    FOREIGN KEY (OrigAcct) REFERENCES Account (AcctNo),
    FOREIGN KEY (RecAcct) REFERENCES Account (AcctNo)
); 

    INSERT INTO Account (AcctNo, Fname, Lname, CreditLimit, Balance)
    VALUES (4232, 'Ted', 'Bisdolc', 4000, 300),
           (4231, 'Sheen', 'Leedson', 4000, 600),
           (4236, 'Toad', 'Tol', 4000, 420);

SELECT * FROM Account
DROP TABLE account
DROP TABLE _Log

DROP PROCEDURE doing_bank_transfering

CREATE PROC doing_bank_transfering (
     @TransactFromAcctNumber AS INT,
     @TransferToAcctNumber AS INT,
     @AnAmount AS INT
)
AS
BEGIN
    UPDATE Account
    SET Balance = Balance - @AnAmount
    WHERE AcctNo = @TransactFromAcctNumber
END;
BEGIN
    UPDATE Account
    SET Balance = Balance + @AnAmount
    WHERE AcctNo = @TransferToAcctNumber
END;
BEGIN
    INSERT INTO _Log(OrigAcct, LogDateTime, RecAcct, Amount)
    VALUES (@TransactFromAcctNumber, GETDATE(), @TransferToAcctNumber, @AnAmount);
END;

EXEC doing_bank_transfering @TransactFromAcctNumber = 4232, @TransferToAcctNumber = 4236, @AnAmount = 30
                              -- Ted gives Toad 30 dollars
SELECT * FROM Account;
SELECT * FROM _Log;











