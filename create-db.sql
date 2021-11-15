.headers on
drop table MultiplayerGames;
drop table SinglePlayer;
drop table MapLeaderboard;
drop table Leaderboards;
drop table PlayersinMultiplayerGames;
drop table PlayersInMap;

--put your code here
create table Users(
 username varchar(255) primary key);

create table Leaderboards(
 modeRank int,
 username varchar(255) ,
 record float ,
 timeSet varchar(255),
 gameType int,
 primary key (modeRank, gameType));

create table SinglePlayer(
 recordID int primary key,
 username varchar(255) ,
 gameTime float,
 date_played date,
 piecesDropped int,
 gameType int );

create table Multiplayer(
 recordID int primary key,
 username varchar(255) ,
 gameTime float,
 attackSent int,
 piecesDropped int,
 b2b int);

create table MultiplayerGames(
 MatchID varchar(255),
 roomID varchar(255),
 gameMode int,
 datePlayed date);

create table PlayersinMultiplayerGames(
 MatchID varchar(255),
 listOfPlayers varchar(255),
 MatchRecord int);

create table customMap(
 MapID int primary key,
 MapName varchar(255),
 createdBy varchar(255),
 difficulty float,
 finishCondition int );

create table PlayersInMap(
 MapID int,
 player varchar(255));

create table MapLeaderboard(
 MapID int,
 mapRank int,
 username varchar(255) ,
 record float,
 dateSet date,
primary key (MapID, mapRank));

create table GameType(
 g_id int primary key,
 g_name varchar(255));

create table FinishCondition(
 f_id int primary key,
 f_name varchar(255));

.headers off