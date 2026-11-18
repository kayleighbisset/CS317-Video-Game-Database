DROP DATABASE IF EXISTS VideoGameDB;
CREATE DATABASE VideoGameDB;
USE VideoGameDB;

-- create tables (renamed the Match table name to GameMatch to avoid confusion)
CREATE TABLE Player (
PlayerID INT PRIMARY KEY,
UserName VARCHAR(50),
Email VARCHAR(100),
AccountLevel INT,
DateJoined DATE,
UNIQUE (UserName),
UNIQUE (Email)
);
CREATE TABLE Map (
MapID INT PRIMARY KEY,
MapName VARCHAR(50),
MapSize VARCHAR(50),
MaxPlayers INT
);
CREATE TABLE Weapon (
WeaponID INT PRIMARY KEY,
WeaponName VARCHAR(100),
WeaponType VARCHAR(50),
Rarity VARCHAR(30),
Damage INT
);
CREATE TABLE Leaderboard (
LeaderboardID INT PRIMARY KEY,
LeaderboardName VARCHAR(100),
SeasonNumber INT,
StartDate DATE,
EndDate DATE
);
CREATE TABLE GameMatch (
MatchID INT PRIMARY KEY,
MatchDate DATETIME,
GameMode VARCHAR(30),
PlayerCount INT,
Map_MapID INT,
FOREIGN KEY (Map_MapID) REFERENCES Map(MapID)
);
CREATE TABLE PlayerMatch (
Player_PlayerID INT,
Match_MatchID INT,
Placement INT,
Kills INT,
DamageDealt INT,
SurvivalTime INT,
Weapon_WeaponID INT,
PRIMARY KEY (Player_PlayerID, Match_MatchID),
FOREIGN KEY (Player_PlayerID) REFERENCES Player(PlayerID),
FOREIGN KEY (Match_MatchID) REFERENCES GameMatch(MatchID),
FOREIGN KEY (Weapon_WeaponID) REFERENCES Weapon(WeaponID)
);
CREATE TABLE LeaderboardEntry (
RankPosition INT,
Points INT,
Wins INT,
Player_PlayerID INT,
Leaderboard_LeaderboardID INT,
PRIMARY KEY (Player_PlayerID, Leaderboard_LeaderboardID),
FOREIGN KEY (Player_PlayerID) REFERENCES Player(PlayerID),
FOREIGN KEY (Leaderboard_LeaderboardID) REFERENCES Leaderboard(LeaderboardID)
);
-- insert sample data
INSERT INTO Player VALUES
(1, 'KJBisset', 'kjbisset@gmail.com', 20, '2026-01-15'),
(2, 'KayleeTrujillo', 'kayleetruj@gmail.com', 15, '2026-02-10'),
(3, 'PixelStorm', 'pixel@gmail.com', 25, '2026-03-05'),
(4, 'BlazeKnight', 'blaze@gmail.com', 12, '2026-01-28'),
(5, 'FrostByte', 'frost@gmail.com', 18, '2026-02-01'),
(6, 'GhostRider', 'ghost@gmail.com', 22, '2026-02-05'),
(7, 'LunarFox', 'lunar@gmail.com', 14, '2026-02-12'),
(8, 'IronFalcon', 'iron@gmail.com', 30, '2026-02-20'),
(9, 'CyberNinja', 'cyber@gmail.com', 16, '2026-02-24'),
(10, 'StormChaser', 'storm@gmail.com', 24, '2026-03-01');

INSERT INTO Map VALUES
(1, 'Storm Island', 'Large', 100),
(2, 'Neon City', 'Small', 40),
(3, 'Crystal Canyon', 'Medium', 60),
(4, 'Frozen Outpost', 'Small', 40),
(5, 'Desert Ruins', 'Large', 100),
(6, 'Sky Fortress', 'Medium', 60),
(7, 'Lava Valley', 'Large', 80),
(8, 'Moon Base', 'Small', 30),
(9, 'Jungle Temple', 'Medium', 50),
(10, 'Harbor District', 'Large', 100);

INSERT INTO Weapon VALUES
(1, 'Storm Rifle', 'Assault Rifle', 'Rare', 35),
(2, 'Thunder Shotgun', 'Shotgun', 'Epic', 90),
(3, 'Shadow Sniper', 'Sniper Rifle', 'Legendary', 120),
(4, 'Viper SMG', 'SMG', 'Uncommon', 22),
(5, 'Frost Pistol', 'Pistol', 'Common', 18),
(6, 'Solar Launcher', 'Launcher', 'Epic', 105),
(7, 'Crimson Bow', 'Bow', 'Rare', 65),
(8, 'Pulse Carbine', 'Assault Rifle', 'Epic', 42),
(9, 'Iron Revolver', 'Pistol', 'Rare', 50),
(10, 'Phantom DMR', 'Marksman Rifle', 'Legendary', 75);

INSERT INTO Leaderboard VALUES
(1, 'Season 1 Rankings', 1, '2026-01-01', '2026-03-31'),
(2, 'Season 2 Rankings', 2, '2026-04-01', '2026-06-30'),
(3, 'Season 3 Rankings', 3, '2026-07-01', '2026-09-30');

INSERT INTO GameMatch VALUES
(1, '2026-03-10 18:30:00', 'Solo', 3, 1),
(2, '2026-03-12 20:00:00', 'Solo', 3, 2),
(3, '2026-03-15 19:15:00', 'Solo', 3, 3),
(4, '2026-03-18 21:00:00', 'Solo', 3, 4),
(5, '2026-03-23 17:45:00', 'Solo', 3, 5),
(6, '2026-03-27 20:30:00', 'Solo', 3, 6),
(7, '2026-04-03 18:10:00', 'Solo', 3, 7),
(8, '2026-04-09 19:50:00', 'Solo', 3, 8),
(9, '2026-04-18 16:20:00', 'Solo', 3, 9),
(10, '2026-04-26 22:05:00', 'Solo', 3, 10);

INSERT INTO PlayerMatch VALUES
(1, 1, 1, 6, 900, 1200, 1),
(2, 1, 2, 4, 650, 1100, 2),
(3, 1, 3, 2, 400, 900, 3),
(1, 2, 2, 3, 500, 1000, 2),
(2, 2, 1, 7, 950, 1250, 3),
(3, 2, 3, 1, 300, 800, 4),
(4, 3, 1, 8, 1020, 1320, 6),
(1, 3, 2, 5, 780, 1140, 3),
(5, 3, 3, 2, 410, 850, 7),
(6, 4, 1, 6, 890, 1250, 9),
(2, 4, 2, 4, 610, 1080, 5),
(7, 4, 3, 1, 270, 720, 10),
(8, 5, 1, 9, 1170, 1400, 2),
(3, 5, 2, 3, 560, 1070, 7),
(9, 5, 3, 2, 390, 790, 3),
(10, 6, 1, 7, 980, 1270, 5),
(1, 6, 2, 5, 730, 1100, 6),
(6, 6, 3, 1, 310, 680, 1),
(4, 7, 1, 6, 930, 1290, 10),
(8, 7, 2, 3, 520, 970, 4),
(2, 7, 3, 2, 450, 820, 8),
(5, 8, 1, 8, 1080, 1360, 2),
(7, 8, 2, 4, 640, 1020, 4),
(9, 8, 3, 1, 240, 710, 6),
(3, 9, 1, 5, 870, 1230, 1),
(10, 9, 2, 4, 600, 1090, 8),
(4, 9, 3, 2, 370, 800, 2),
(6, 10, 1, 7, 1010, 1340, 5),
(1, 10, 2, 3, 590, 1000, 10),
(8, 10, 3, 2, 420, 830, 7);

INSERT INTO LeaderboardEntry VALUES
(1, 2500, 8, 1, 1),
(2, 2200, 6, 2, 1),
(3, 1800, 4, 3, 1),
(4, 1650, 3, 4, 1),
(5, 1500, 3, 5, 1),
(6, 1400, 2, 6, 1),
(7, 1300, 2, 7, 1),
(8, 1200, 1, 8, 1),
(9, 1100, 1, 9, 1),
(10, 1000, 1, 10, 1);

-- verification
SHOW TABLES;
SELECT * FROM Player;
SELECT * FROM Map;
SELECT * FROM Weapon;
SELECT * FROM GameMatch;
SELECT * FROM PlayerMatch;
SELECT * FROM Leaderboard;
SELECT * FROM LeaderboardEntry;
