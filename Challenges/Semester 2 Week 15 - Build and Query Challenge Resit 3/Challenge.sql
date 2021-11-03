/*
Ibrahim Oztas
Student ID: 103577332
*/

CREATE DATABASE Build_and_Query_Challenge_Resit_3
USE Build_and_Query_Challenge_Resit_3

/*
Client(ClientID, DateTimePlaced, Name, Phone, OrgID, )
PRIMARY KEY (ClientID, DateTimePlaced)
FOREIGN KEY (OrgID) REFERENCES Organisation
FOREIGN KEY (DateTimePlaced) REFERNCES Order

MenuItem(ItemId, Description, ServesPerUnit, UnitPrice)
PRIMARY KEY (ItemId)

Organisation(OrgId, OrganisationName, ClientID)
PRIMARY KEY (OrgId)
FOREIGN KEY (ClientID) REFERENCES Client

Order(DateTimePlaced, DeliveryAddress, ClientId)
PRIMARY KEY (DateTimePlaced, ClientId) 
FOREIGN KEY (ClientID) REFERENCES Client

OrderLine(Qty, ItemId, DateTimePlaced, ClientID)
PRIMARY KEY (ItemId, DateTimePlaced, ClientID)
FOREIGN KEY (ItemId) REFERENCES MenuItem
FOREIGN KEY (DateTimePlaced) REFERENCES Order

*/




















