-- Ibrahim Oztas
-- 103577332



/* Task 1 Convert ERD to Relational Schema

Organisation(OrgID, OrganisationName)
PK (OrgID)

Order(DateTimePlaced, DeliveryAddress)
PK (DateTimePlaced)

OrderLine(Qty)

Client(ClientID, Name, Phone)
PK (ClientID)

MenuItem(ItemID, Description, ServesPerUnit, UnitPrice)
PK (ItemID)


*/


-- Task 2 Write and Execute the Data Definition Language

 CREATE DATABASE Build_and_Query_Challenge_Resit_2;

 USE Build_and_Query_Challenge_Resit_2;

CREATE TABLE Organisation (
    OrgID NVARCHAR(4),
    OrganisationName NVARCHAR(200) UNIQUE NOT NULL,
    PRIMARY KEY (OrgID)
)

CREATE TABLE Client (
    ClientID INT,
    Name NVARCHAR(100) NOT NULL,
    Phone NVARCHAR (15) NOT NULL UNIQUE,
    OrgID NVARCHAR(4),
    FOREIGN KEY (OrgID) REFERENCES Organisation(OrgID),  
    PRIMARY KEY (ClientID)
)

CREATE TABLE MenuItem (
    ItemID INT,
    Description NVARCHAR(100) NOT NULL UNIQUE,
    ServesPerUnit INT NOT NULL,
    UnitPrice MONEY NOT NULL, 
    PRIMARY KEY (ItemID)
)

 CREATE TABLE Order_ (
     ClientID INT FOREIGN KEY REFERENCES Client(ClientID), 
     OrderDate DATE,
     DeliveryAddress NVARCHAR(MAX) NOT NULL
     PRIMARY KEY (ClientID, OrderDate)
)

CREATE TABLE OrderLine (
    ItemID INT,
    ClientID INT, 
    OrderDate DATE,
    Qty INT NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES MenuItem(ItemID),
    FOREIGN KEY (ClientID, OrderDate) REFERENCES Order_(ClientID, OrderDate),
    PRIMARY KEY (ItemID, ClientID, OrderDate)
)

--- Other useful code:

SELECT 
    *
FROM
    information_schema.tables;

DROP TABLE Organisation
DROP TABLE Client
DROP TABLE MenuItem
DROP TABLE ORDER_
DROP TABLE OrderLine

---------------------------------------------------------------















