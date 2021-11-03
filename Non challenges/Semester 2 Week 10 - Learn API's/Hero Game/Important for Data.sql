CREATE DATABASE Hero_Battle_Project;
USE Hero_Battle_Project;

CREATE TABLE Game_History (
    Play_ID INT(Max),
    Date_Played DATE,
    Time_Played TIME,
    Winner_Or_Loser NVARCHAR
);


CREATE TABLE Hero (
    Play_ID INT(Max) PRIMARY KEY FOREIGN KEY REFERENCES Game_History(Play_ID),
    Hero_Name NVARCHAR(Max),
    Dice_Min_Value INT(Max),
    Random_Dice_Value_Used INT(Max),
    Dice_Max_Value INT(Max),
    Uses_Left INT(Max)
);

CREATE TABLE Hero_Attack (
    Play_ID INT(Max) PRIMARY KEY FOREIGN KEY REFERENCES Hero(Play_ID),
    Hero_Name NVARCHAR(Max) PRIMARY KEY FOREIGN KEY REFERENCES Hero(Hero_Name),
    Villain_Name NVARCHAR(Max),
    Random_Dice_Value_Used INT(MAX) FOREIGN KEY REFERENCES Hero(Random_Dice_Value_Used)
);

CREATE TABLE Villain (
    Play_ID INT(Max) PRIMARY KEY FOREIGN KEY REFERENCES Hero_Attack(Play_ID),
    Villain_Name NVARCHAR(Max) PRIMARY KEY FOREIGN KEY REFERENCES Hero_Attack(Villain_Name),
    Lives INT(Max),
    Random_Dice_Min_Value INT(Max),
    Random_Dice_Value_Used INT(Max),
    Random_Dice_Max_Value INT(Max),
    Boolean BIT
);

CREATE TABLE Villain_Attack (
    Play_ID INT(Max) PRIMARY KEY FOREIGN KEY REFERENCES Villain(Play_ID),
    Villain_Name NVARCHAR(Max) PRIMARY KEY FOREIGN KEY REFERENCES Villain(Villain_Name),
    Hero_Name NVARCHAR(Max) FOREIGN KEY REFERENCES Hero_Attack(Hero_Name),
    Random_Dice_Value_Used INT(Max) PRIMARY KEY FOREIGN KEY REFERENCES Villain(Random_Dice_Value_Used) 
);















































