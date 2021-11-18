.headers on

-- get sprint leaderboard
SELECT modeRank, username, record
FROM Leaderboards
WHERE gameType = 1
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

--delete vod of bad play (ashamed 10 apm game)
DELETE FROM Multiplayer
WHERE recordID = 34293;

-- add a new map
INSERT INTO customMap
Values (85024, 'This is a trap', 'amscrubpls', 10.11, 1);

-- delete map, triggers delete_map, removes all associated with map
DELETE FROM customMap
WHERE MapName = "T-Spins";


-- delete a user, triggers del_user
--DELETE FROM Users
--WHERE username = 'hi0000';


