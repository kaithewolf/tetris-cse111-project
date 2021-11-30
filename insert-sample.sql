.headers on
--put your code here
insert into Users(username)
values('keitar431'),
('jimothynoob'),
('hi0000'),
('upDog'),
('guuuuhhhh');

insert into Sprint_Leaderboard(modeRank,username,record,timeSet)
values
    (1, 'jimothynoob', 30.67, '2021-11-30'),
    (2, 'keitar431', 45.99, '2021-12-10'),
    (3, 'hi0000', 65.99, '2021-10-30'),
    (4, 'upDog', 95.34, '2020-09-12'),
    (1, 'guuuuhhhh', 56.78, '2021-10-31');

insert into SinglePlayer(
 recordID,
 username,
 gameTime,
 date_played,
 piecesDropped,
 gameType)
 values
     (13459, 'jimothynoob', 30.67, '2021-11-30', 100, 1),
     (13851, 'jimothynoob', 45.4, '2021-11-29', 105, 1),
     (15684, 'keitar431', 45.99, '2021-12-10', 105, 1),
     (17803, 'hi0000', 65.99, '2021-10-30', 109, 1),
     (13950, 'upDog', 95.34, '2020-09-12', 103, 1),
     (13850, 'guuuuhhhh', 56.78, '2021-10-31', 40, 4);

insert into Multiplayer(
 recordID,
 username,
 gameTime,
 attack,
 attackSent,
 received,
 piecesDropped,
 b2b )
 values
     (23840, 'jimothynoob', 93.31, 120, 99, 10, 130, 16),
     (34920, 'keitar431', 93.10, 100, 60, 40, 95, 5),
     (34293, 'hi0000', 34.50, 10, 5, 99, 30, 2),
     (49604, 'upDog', 35.20, 30, 28, 40, 20, 0);

insert into MultiplayerGames(
 MatchID  ,
 roomID  ,
 gameMode ,
 datePlayed )
 values
     ('EGDFH', 'SJED120', 1, '2021-11-30'),
     ('TYULK', 'SLEOD130', 1, '2021-11-08');

insert into PlayersinMultiplayerGames(
 MatchID  ,
 listOfPlayers  ,
 MatchRecord )
 values
     ('EGDFH', 'jimothynoob', 23840),
     ('EGDFH', 'keitar431', 34920),
     ('TYULK', 'hi0000', 34293),
     ('TYULK', 'upDog', 49604);

insert into customMap(
 MapID   ,
 MapName  ,
 createdBy  ,
 difficulty ,
 finishCondition  )
 values
     (74830, 'T-Spins', 'guuuuhhhh', 33.2, 1),
     (12345, 'Scuffed PC', 'jimothynoob', 55.34, 2),
     (23456, 'testing s z spin', 'guuuuhhhh', 67.7, 2);

insert into PlayersInMap(
 MapID ,
 player)
 values
     (74830, 'hi0000'),
     (74830, 'jimothynoob'),
     (12345, 'jimothynoob'),
     (23456, 'guuuuhhhh');

insert into MapLeaderboard(
 MapID,
 mapRank,
 username,
 record,
 dateSet)
 values
     (74830, 1, 'hi0000',  0.56, '2021-12-05'),
     (74830, 2, 'jimothynoob', 0.65, '2021-10-15'),
     (12345, 1, 'jimothynoob', 0.35, '2021-10-16'),
     (23456, 1, 'guuuuhhhh', 2.5, '2021-11-10');

insert into GameType(g_id, g_name)
 values
     (1,'sprint'),
     (3,'cheese'),
     (4,'survival'),
     (5,'ultra');

insert into FinishCondition(f_id   , f_name  )
values
    (1, 'clear_blocks'),
    (2, 'pc');

.headers off