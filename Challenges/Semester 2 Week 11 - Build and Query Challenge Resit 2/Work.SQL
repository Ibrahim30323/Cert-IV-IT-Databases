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


-- Task 3 Write and Execute the Data Modelling Language

INSERT INTO Organisation (OrgID, OrganisationName)
VALUES ('DODG', 'Dod & Gy Widget Importers'),
 ('SWUT', 'Swinburne University of Technology');

INSERT INTO Client (ClientID, Name, Phone, OrgId)
VALUES (12, 'James Hallinan', 035555-1234, 'SWUT'), 
 (15, 'Anh Nguyen', 035555-2345, 'DODG'), 
 (18, 'Karen Mok', 035555-3456, 'SWUT'), 
 (21, 'Tim Baird', 035555-4567, 'DODG'),
 (23, 'Ibrahim Oztas', 035555-1234, 'SWUT');


INSERT INTO MenuItem (ItemID, Description, ServesPerUnit, UnitPrice) 
VALUES (3214, 'Tropical Pizza - Large', 2, 16)
 (3216, 'Tropical Pizza - Small', 1, 12)
 (3218, 'Tropical Pizza - Family', 4, 23)
 (4325, , , ,)
 (4236, , , ,)
 (4327, , , ,)


 ('Tropical Pizza - Large'), ('Tropical Pizza - Small'), ('Tropical Pizza - Family'), ('Can - Coke Zero'), ('Can - Lemonade'), ('Can - Harden Up');

INSERT INTO MenuItem (ServesPerUnit)
VALUES (2), (1), (4), (1), (1), (1);

INSERT INTO MenuItem (UnitPrice)
VALUES (16.00), (12.00), (23.00), (2.50), (2.50), (7.50);

INSERT INTO Order (OrderDate)
VALUES (20/09/2021), (14/09/2021), (27/09/2021), (20/09/2021), (30/09/2021);

INSERT INTO Order (DeliveryAddress)
VALUES ('Room TB225 - SUT - 1 John Street, Hawthorn, 3122'), ('Room ATC009 - SUT - 1 John Street, Hawthorn, 3122'), ('Room TB225 - SUT - 1 John Street, Hawthorn, 3122'), ('The George - 1 John Street, Hawthorn, 3122'), ('Room TB225 - SUT - 1 John Street, Hawthorn, 3122');

INSERT INTO OrderLine (ClientId)
VALUES (12), (12), (21), (21), (21), (21), (21), (21), (21), (15), (15), (18), (18);

INSERT INTO OrderLine (OrderDate)
VALUES (20/09/2021), (20/09/2021), (14/09/2021), (14/09/2021), (14/09/2021), (14/09/2021), (27/09/2021), (27/09/2021), (27/09/2021), (20/09/2021), (20/09/2021), (30/09/2021), (30/09/2021);

INSERT INTO OrderLine (Qty)
VALUES (2), (1), (1), (1), (4), (2), (1), (1), (2), (2), (1), (1), (1);



---------------------------------------------------------------


https://github.com/Ibrahim30323/Cert-IV-IT-Databases.git









