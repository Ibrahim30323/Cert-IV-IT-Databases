/*
Ibrahim Oztas
Student ID: 103577332
*/


/* Task 1

Client(ClientID, DateTimePlaced, Name, Phone, OrgID,)
PRIMARY KEY (ClientID, DateTimePlaced)
FOREIGN KEY (OrgID) REFERENCES Organisation
FOREIGN KEY (DateTimePlaced) REFERENCES Order

MenuItem(ItemId, Description, ServesPerUnit, UnitPrice)
PRIMARY KEY (ItemId)

Organisation(OrgId, OrganisationName, ClientID)
PRIMARY KEY (OrgId)
FOREIGN KEY (ClientID) REFERENCES Client

Order_(DateTimePlaced, DeliveryAddress, ClientId, ItemId)
PRIMARY KEY (DateTimePlaced, ClientId, ItemId) 
FOREIGN KEY (ClientID) REFERENCES Client
FOREIGN KEY (ItemId) REFERENCES OrderLine

OrderLine(Qty, ItemId, DateTimePlaced, ClientID)
PRIMARY KEY (ItemId, DateTimePlaced, ClientID)
FOREIGN KEY (ItemId) REFERENCES MenuItem
FOREIGN KEY (DateTimePlaced) REFERENCES Order
FOREIGN KEY (ClientID) REFERENCES Order

*/

-- Task 2
-- DDL:

-- OrderDate Column is same thing as DateTimePlaced

CREATE DATABASE Build_and_Query_Challenge_Resit_3
USE Build_and_Query_Challenge_Resit_3

CREATE TABLE MenuItem (
    ItemId INT,
    Description NVARCHAR(100) NOT NULL UNIQUE,
    ServesPerUnit INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    PRIMARY KEY (ItemId),
    CONSTRAINT CHK_SERVES_PER_UNIT CHECK (ServesPerUnit > 0) 
);


CREATE TABLE Client (
          ClientID INT,
          Name NVARCHAR(100) NOT NULL,
          Phone NVARCHAR(15) NOT NULL UNIQUE,
          OrgID NVARCHAR(4) FOREIGN KEY REFERENCES Organisation(OrgID),
          OrderDate DATE FOREIGN KEY REFERENCES Order_(OrderDate),
          PRIMARY KEY(ClientID, OrderDate)
); 


CREATE TABLE Organisation (
       OrgID NVARCHAR(4),
       OrganisationName NVARCHAR(200) UNIQUE NOT NULL, 
       ClientID INT FOREIGN KEY REFERENCES Client(ClientID),
       PRIMARY KEY (OrgID)
);


CREATE TABLE Order_ (
    OrderDate DATE, 
    DeliveryAddress NVARCHAR(Max) NOT NULL, 
    ClientID INT,
    ItemId INT,
    PRIMARY KEY (OrderDate, ClientID, ItemId), 
    FOREIGN KEY (ClientID) REFERENCES Client,
    FOREIGN KEY (ItemId) REFERENCES OrderLine
    );

CREATE TABLE OrderLine (
    Qty INT NOT NULL, 
    ItemId INT, 
    OrderDate DATE, 
    ClientID INT,
    PRIMARY KEY (ItemId, OrderDate, ClientID),
    FOREIGN KEY (ItemId) REFERENCES MenuItem,
    FOREIGN KEY (ClientID, OrderDate) REFERENCES Order_,
    CONSTRAINT CHK_QTY CHECK (Qty > 0)
    );


DROP TABLE Client
DROP TABLE MenuItem
DROP TABLE Organisation
DROP TABLE Order_
DROP TABLE OrderLine


















