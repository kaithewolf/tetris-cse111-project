import requests
from bs4 import BeautifulSoup

r = requests.get('https://jstris.jezevec10.com/u/RBLX')
page = r.content 
soup = BeautifulSoup(page, 'html.parser')

def find_multiplayer_id(game_list):
    count = 0
    for id in multiplayer_game:
        multiplayer_id = id.find('td')
        for string in multiplayer_id.stripped_strings:
            game_list.append(string)
        count = count + 1
        if count > 9:
            break

def find_map_id(map_list):
    for id in maps_created:
        map_id_a = id.find('a')
        map_id_link = map_id_a['href']
        map_id = map_id_link.split("/")[-1] #id is the last (-1) element of url
        map_list.append(map_id)



tables = soup.find_all('table', attrs={"class":"table-hover"})

#maps table is has class = maps
maps_created = soup.find('table', attrs={"class":"maps"})
maps_created_body = maps_created.find('tbody')
maps_created = maps_created_body.find_all("tr")

#multiplayer table is last table in profile page
multiplayer_game_table = tables[-1]
multiplayer_game_table_body = multiplayer_game_table.find('tbody')
multiplayer_game = multiplayer_game_table_body.find_all("tr")

#for string in maps_created.stripped_strings:
#    print(repr(string))
#for string in multiplayer_game_table.stripped_strings:
#    print(repr(string))

#use game_list to go into each game, and get each player in each match
game_list = []
find_multiplayer_id(game_list)
print(game_list)

#get map id's for map api calls
map_id_list = []
find_map_id(map_id_list)
print(map_id_list)

game = requests.get('https://jstris.jezevec10.com/games/'+str(game_list[0]))
game_page = BeautifulSoup(game.content, 'html.parser')
player_table = game_page.find('tbody')
player_table = player_table.find_all("tr")


