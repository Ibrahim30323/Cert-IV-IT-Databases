CREATE TABLE Headphone (
    [id] INT PRIMARY KEY,
    driverType VARCHAR(50),
    category VARCHAR(50) 
);


INSERT INTO Headphone ([id], driverType, category) VALUES (1, 'Dynamic', 'closed');
INSERT INTO Headphone ([id], driverType, category) VALUES (2, 'Ortho', 'open-ear');
INSERT INTO Headphone ([id], driverType, category) VALUES (3, 'BA', 'in-ear');
INSERT INTO Headphone ([id], driverType, category) VALUES (4, 'ElectroStat', 'open-ear');

SELECT * FROM Headphone; 