IF OBJECT_ID('VEHICLE7332DATABASE') IS NOT NULL
     DROP TABLE VEHICLE7332

GO

CREATE TABLE  VEHICLE7332 (
 RegNo         varchar,
 Model         varchar,
 Kilometers    INT,
 PurchaseDate  DATE );

 