import requests
import sqlite3
from sqlite3 import Error
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
        _conn.executemany(string, tup)
        _conn.commit()
        print("success")
    except Error as e:
        print(e)

def print_select(_conn, string, number):
    try:
        cur = _conn.cursor()
        cur.execute(string)
        table = cur.fetchall()

        for row in table:
            r_string = '|'.join(str(s) for s in row)
            print(r_string)
    except Error as e:
        print(e)

def main():
    database = r"tetris.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        #Single Player Leaderboards, top 100 of each
        sprint_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/1?mode=1&offset=0")
        sprint_parsed = json.loads(sprint_results.text.encode('utf8'))

        count = 0

        for result in sprint_parsed:
            name = result["name"]
            dateSet = result["ts"].split()[0]
            rank = result["pos"]
            record = result["game"]
            print(name)
            count += 1
            if count > 99:
                break

        cheese_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/3?mode=1&offset=0")
        cheese_parsed = json.loads(cheese_results.text.encode('utf8'))
        count = 0
        for result in cheese_parsed:
            print(result)
            count += 1
            if count > 99:
                break
        #survival_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/4?mode=1&offset=0")
        #ultra_results = requests.get("http://jstris.jezevec10.com/api/leaderboard/5?mode=1&offset=0")


    closeConnection(conn, database)


if __name__ == '__main__':
    main()

