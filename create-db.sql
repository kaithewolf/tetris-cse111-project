.headers on
drop table Users;
drop table Leaderboards;
drop table SinglePlayer;
drop table Multiplayer;
drop table MultiplayerGames;
drop table PlayersinMultiplayerGames;
drop table MapLeaderboard;
drop table customMap;
drop table PlayersInMap;

--create table
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


--trigger
CREATE TRIGGER if not exists del_user
   AFTER DELETE ON Users
BEGIN
    delete from Leaderboards where username = old.username;
    delete from SinglePlayer where username = old.username;
    delete from Multiplayer where username = old.username;
    delete from PlayersinMultiplayerGames where listOfPlayers = old.username;
    delete from MapLeaderboard where username = old.username;
    delete from customMap where createdBy = old.username;
    delete from PlayersInMap where player = old.username;
END;

CREATE TRIGGER if not exists update_user
   AFTER UPDATE ON Users
BEGIN
    update Leaderboards set username = new.username where username = old.username;
    update SinglePlayer set username = new.username where username = old.username;
    update Multiplayer set username = new.username where username = old.username;
    update PlayersinMultiplayerGames set listOfPlayers = new.username where listOfPlayers = old.username;
    update MapLeaderboard set username = new.username where username = old.username;
    update customMap set createdBy = new.username where createdBy = old.username;
    update PlayersInMap set player = new.username where player = old.username;
END;


CREATE TRIGGER if not exists delete_match
   AFTER DELETE ON MultiplayerGames
BEGIN
    delete from PlayersinMultiplayerGames where PlayersinMultiplayerGames.MatchID = old.MatchID;
END;

CREATE TRIGGER if not exists no_more_records
   AFTER DELETE ON PlayersinMultiplayerGames
   WHEN (SELECT count(old.MatchID) FROM PlayersinMultiplayerGames) == 0
BEGIN
    delete from MultiplayerGames where MultiplayerGames.MatchID = old.MatchID;
END; 

CREATE TRIGGER if not exists delete_multiplayer_record
   AFTER DELETE ON multiplayer
BEGIN
    delete from PlayersinMultiplayerGames where PlayersinMultiplayerGames.MatchRecord = old.recordID;
END;


CREATE TRIGGER if not exists delete_map
   AFTER DELETE ON customMap 
BEGIN
    delete from MapLeaderboard where MapLeaderboard.MapID = old.MapID;
    delete from PlayersInMap where PlayersInMap.MapID = old.MapID;
END;

/* CREATE TRIGGER if not exists insert_to_rank
    AFTER INSERT ON SinglePlayer
    WHEN new.gameTime < (SELECT gameTime FROM SinglePlayer s 
                        WHERE s.username = new.username and s.gameType = new.gameType
                        and new.gameType <> 5)
        OR
        new.gameTime > (SELECT gameTime FROM SinglePlayer s 
                        WHERE s.username = new.username and s.gameType = new.gameType
                        and new.gameType = 5)
        OR
        new.username not in (SELECT username FROM Leaderboards)
    
BEGIN
        CASE new.username in (SELECT username FROM Leaderboards)
            UPDATE Leaderboards
            SET record = new.gameTime
            WHERE Leaderboards.username = new.username
            and Leaderboards.gameType = new.gameType
        ELSE
            INSERT INTO Leaderboards
            values (0, new.username, new.gameTime, new.date_played, new.gameType)
    END
END; */


.headers off