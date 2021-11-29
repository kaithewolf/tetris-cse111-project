.headers on

-- get sprint leaderboard
SELECT modeRank, username, record
FROM Leaderboards
WHERE gameType = 1
ORDER BY modeRank ASC;

-- get survival leaderboard
SELECT modeRank, username, record
FROM Leaderboards
WHERE gameType = 4
ORDER BY modeRank ASC;

-- get players in a multiplayer game session
SELECT listOfPlayers
FROM PlayersInMultiplayerGames
WHERE MatchID = 'EGDFH';

--get all users with over 2 pieces per second
SELECT username, gameTime
FROM SinglePlayer
WHERE piecesDropped/gameTime > 2;

--get a user's pieces per second across multiple single player games
SELECT Users.username, gameTime, gameType, piecesDropped/gameTime as pps
FROM Users, SinglePlayer
WHERE Users.username = SinglePlayer.username
    AND Users.username = 'jimothynoob';

--get all users with over or equal 30 attack per minute
SELECT username, attackSent/gameTime
FROM Multiplayer
WHERE attackSent/gameTime >= 30;

--insert a new user
INSERT INTO Users
Values ('nateqwq');

--add a new single player game record
INSERT INTO SinglePlayer
Values (20568, 'nateqwq', 120.64, '2021-08-04', 152, 1);

--edit user name
UPDATE Users
Set username = 'amscrubpls'
WHERE username = 'nateqwq';

UPDATE Users
Set username = 'mpPlonker'
WHERE username = 'jimothynoob';

--delete vod of bad play (ashamed 10 apm game)
DELETE FROM Multiplayer
WHERE recordID = 34293;

-- add a new map
INSERT INTO customMap
Values (85024, 'This is a trap', 'amscrubpls', 10.11, 1);

-- delete map, triggers delete_map, removes all associated with map
DELETE FROM customMap
WHERE MapName = "T-Spins";


--MP over SP ratio of all games
--pps is calculated as such:
--  pieces dropped / game time

SELECT username, MPpps/SPpps AS ratio
FROM Users, (SELECT AVG(piecesDropped/gameTime) AS MPpps
      FROM Multiplayer
      WHERE username = "jimothynoob"),
      (SELECT AVG(piecesDropped/gameTime) AS SPpps
      FROM SinglePlayer
      WHERE username = "jimothynoob")
WHERE Users.username = "jimothynoob";

--MP over SP pps, grouped by date
SELECT username, MPpps/SPpps AS ratio
FROM Users, (SELECT AVG(piecesDropped/gameTime) AS MPpps, datePlayed
      FROM Multiplayer M, MultiplayerGames MG, PlayersInMultiplayerGames P
      WHERE username = "jimothynoob" and M.recordID = P.MatchRecord and P.MatchID = MG.MatchID
      GROUP BY MG.datePlayed)
      LEFT JOIN 
      (SELECT AVG(piecesDropped/gameTime) AS SPpps, date_played
      FROM SinglePlayer
      WHERE username = "jimothynoob"
      GROUP BY date_played)
WHERE Users.username = "jimothynoob" and date_played = datePlayed;

--attack per minute (apm) calculation
--apm is calculated as such:
--  (attacks sent / game time) * 60
SELECT Users.username, APM
FROM Users, (SELECT AVG(attackSent/gameTime) * 60 as APM
             FROM Multiplayer
             WHERE username = "keitar431")
WHERE Users.username = "keitar431";



--attack per piece (app) calculation
--app is calculated as such:
--  (attacks sent / pieces dropped)
SELECT Users.username, APP
FROM Users, (SELECT AVG(CAST(attackSent as FLOAT)/CAST(piecesDropped as FLOAT)) as APP
             FROM Multiplayer
             WHERE username = "upDog")
WHERE Users.username = "upDog";

--showing percentile of highest b2b
SELECT DISTINCT Multiplayer.username, b2b, 1 - PERCENT_RANK() OVER (ORDER BY b2b DESC) AS Percentb2b
FROM Multiplayer;


-- delete a user, triggers del_user
DELETE FROM Users
WHERE username = 'hi0000';

-- delete multiplayer game, associated records are also deleted
DELETE FROM MultiplayerGames
WHERE MatchID = "TYULK";