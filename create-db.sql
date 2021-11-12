.headers on
--put your code here
create table Users(
 username varchar(255) primary key);

create table Leaderboards(
 rank int primary key,
 username varchar(255) ,
 record int ,
 timeSet varchar(255),
 gameType int );

create table SinglePlayer(
 recordID int primary key,
 username varchar(255) ,
 gameTime varchar(255),
 date_played datetime,
 piecesDropped int,
 gameType int );

create table Multiplayer(
 recordID int primary key,
 username varchar(255) ,
 gameTime varchar(255),
 attackSent int,
 piecesDropped int,
 b2b int);

create table MultiplayerGames(
 MatchID varchar(255),
 roomID varchar(255),
 gameMode int,
 datePlayed datetime);

create table PlayersinMultiplayerGames(
 MatchID varchar(255),
 listOfPlayers varchar(255));

create table customMap(
 MapID int primary key,
 MapName varchar(255),
 createdBy varchar(255),
 difficulty int,
 finishCondition int );

create table PlayersInMap(
 MapID int primary key,
 player varchar(255) );

create table MapLeaderboard(
 MapID int primary key,
 rank int ,
 username varchar(255) ,
 record varchar(255),
 dateSet datetime);

create table GameType(
 g_id int primary key,
 g_name varchar(255));

create table FinishCondition(
 f_id int primary key,
 f_name varchar(255));

.headers off