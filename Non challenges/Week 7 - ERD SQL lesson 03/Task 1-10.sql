/* Parent relation: */
CREATE TABLE PROJECT (
    ProjCode int PRIMARY KEY,
    ProjectTitle varchar(max)
);

/* Child relation: */
CREATE TABLE WORKER (
    WID int PRIMARY KEY,
    WName varchar(max),
    Gender varchar(max),
    ProjID int FOREIGN KEY REFERENCES PROJECT(ProjCode) 
); 

INSERT INTO PROJECT (ProjCode, ProjectTitle)
 VALUES (1, 'Project One'),
        (2, 'Project Two'),
        (3, 'Project Three');      


INSERT INTO WORKER (WID, WName, Gender, ProjID)
 VALUES (21, 'Dave Jones', 'M', 2),
        (22, 'Emma Quilt', 'F', 2),
        (23, 'Fred Gingers', 'M', 1),
        (24, 'Pat Smith', 'M', 2),
        (25, 'Ibrahim Oztas', 'M', 3),
        (26, 'Abdullah Kent', 'M', 3);
      





SELECT * FROM PROJECT;
SELECT * FROM WORKER;

DROP TABLE PROJECT;
DROP TABLE WORKER;
