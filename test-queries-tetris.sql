SELECT username
FROM Leaderboards
WHERE gameType = 1;

SELECT listOfPlayers
FROM PlayersInMultiplayerGames
WHERE MatchID = 'EGDFH';

SELECT username, gameTime
FROM SinglePlayer
WHERE gameTime < 50
    AND piecesDropped > 100;

SELECT Users.username, gameTime, gameType
FROM Users, SinglePlayer
WHERE Users.username = SinglePlayer.username
    AND Users.username = 'jimothynoob';

INSERT INTO Users
Values ('nateqwq');

INSERT INTO SinglePlayer
Values (20568, 'nateqwq', 120.64, '2021-08-04', 152, 1);

UPDATE Users
Set username = 'amscrubpls'
WHERE username = 'nateqwq';

UPDATE SinglePlayer
Set username = 'amscrubpls'
WHERE username = 'nateqwq';

INSERT INTO customMap
Values (85024, 'This is a trap', 'amscrubpls', 10.11, 1);

DELETE FROM Users
WHERE username = 'hi0000';
DELETE FROM SinglePlayer
WHERE username = 'hi0000';
DELETE FROM PlayersInMultiplayerGames
WHERE listOfPlayers = 'hi0000';
DELETE FROM MapLeaderboard
WHERE username = 'hi0000';
DELETE FROM Multiplayer
WHERE username = 'hi0000';
DELETE FROM PlayersInMap
WHERE player = 'hi0000';
DELETE FROM Leaderboards
WHERE username = 'hi0000';


