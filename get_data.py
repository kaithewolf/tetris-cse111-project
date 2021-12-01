import requests
import sqlite3
from sqlite3 import Error
from bs4 import BeautifulSoup
import json


def openConnection(_dbFile):
    print("++++++++++++++++++++++++++++++++++")
    print("Open database: ", _dbFile)

    conn = None
    try:
        conn = sqlite3.connect(_dbFile)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")

    return conn

def closeConnection(_conn, _dbFile):
    print("++++++++++++++++++++++++++++++++++")
    print("Close database: ", _dbFile)

    try:
        _conn.close()
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")

def execute(_conn, string):
    try:
        _conn.execute(string)
        _conn.commit()
        print("success")
    except Error as e:
        print(e)

def executemany(_conn, string, tup):
    try:
        cur = _conn.cursor()
        cur.executemany(string, tup)
        _conn.commit()
        print("success")
    except Error as e:
        print(e)

def print_select(_conn, string):
    try:
        cur = _conn.cursor()
        cur.execute(string)
        table = cur.fetchall()

        for row in table:
            r_string = '|'.join(str(s) for s in row)
            print(r_string)
    except Error as e:
        print(e)

def parse_leaderboard(parsed):
        count = 0
        parsed_list = []
        for result in parsed:
            name = result["name"]
            dateSet = result["ts"].split()[0]
            rank = result["pos"]
            record = result["game"]
            parsed_list.append((rank, name, record, dateSet))
            count += 1
            if count > 99:
                break
        return parsed_list
        
def main():
    database = r"tetris.db"

    # create a database connection
    conn = openConnection(database)
    with conn:
        #Single Player Leaderboards, top 100 of each
        sprint_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/1?mode=1&offset=0")
        sprint_parsed = json.loads(sprint_results.text.encode('utf8'))
        sprint_list = parse_leaderboard(sprint_parsed)
        command = '''
        INSERT INTO Sprint_Leaderboard(modeRank,username,record,date_played)
        values
            (?, ? ,? ,?);
        '''
        print("insert sprint:")
        executemany(conn, command, sprint_list)
        
        cheese_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/3?mode=1&offset=0")
        cheese_parsed = json.loads(cheese_results.text.encode('utf8'))
        cheese_list = parse_leaderboard(cheese_parsed)
        command = '''
        INSERT INTO Cheese_Leaderboard(modeRank,username,record,date_played)
        values
            (?, ? ,? ,?);
        '''
        print("insert cheese:")
        executemany(conn, command, cheese_list)
        
        survival_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/4?mode=1&offset=0")
        survival_parsed = json.loads(survival_results.text.encode('utf8'))
        survival_list = parse_leaderboard(survival_parsed)
        command = '''
        INSERT INTO Survival_Leaderboard(modeRank,username,record,date_played)
        values
            (?, ? ,? ,?);
        '''
        print("insert survival:")
        executemany(conn, command, survival_list)

        ultra_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/5?mode=1&offset=0")
        ultra_parsed = json.loads(ultra_results.text.encode('utf8'))
        ultra_list = parse_leaderboard(ultra_parsed)
        command = '''
        INSERT INTO Ultra_Leaderboard(modeRank,username,record,date_played)
        values
            (?, ? ,? ,?);
        '''
        print("insert ultra:")
        executemany(conn, command, ultra_list)

        #Map Leaderboards, grab first n maps
        map_list = []
        map_leaderboard_list = []
        for i in range(20):
            #map api
            map_api = requests.get("https://jstris.jezevec10.com/maps/api/"+str(i+1))
            if map_api.ok:
                map_api_parsed = json.loads(map_api.text.encode('utf8'))

                #map leaderboard page
                #get name of creator
                map_results = requests.get("https://jstris.jezevec10.com/map/"+str(i+1))
                map_page = BeautifulSoup(map_results.content, 'html.parser')
                map_header = map_page.find("table")
                name_section = map_header.find_all("tr")[-1]
                creator = str(name_section.find_all("td")[-1].text)
                map_list.append((map_api_parsed["id"], map_api_parsed["name"], creator, map_api_parsed["finish"]))

                #get leaderboard table attributes into tuples
                leaderboard_table = map_page.find_all("table")[-1]
                table_body = leaderboard_table.find("tbody")
                table_rows = table_body.find_all("tr")
                rank = 1
                for row in table_rows:
                    elements = row.find_all("td")
                    name = elements[1].text.strip()
                    time = elements[2]
                    pieces_placed = elements[3]
                    date = elements[6].text.split()[0]
                    record = elements[7].find("a")
                    if record == None:
                        record = -1
                    else:
                        record = record["href"].split("/")[-1]
                    map_leaderboard_list.append((map_api_parsed["id"], rank, name, record, date))
                    rank += 1
    for tup in map_list:
        print(tup)
    for tup in map_leaderboard_list:
        print(tup)

    closeConnection(conn, database)


if __name__ == '__main__':
    main()

