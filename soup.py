import requests
from bs4 import BeautifulSoup

r = requests.get('https://jstris.jezevec10.com/u/kaithewolf')
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

tables = soup.find_all('table', attrs={"class":"table-hover"})

maps_created = tables[2]
multiplayer_game_table = tables[3]
multiplayer_game_table = multiplayer_game_table.find('tbody')
multiplayer_game = multiplayer_game_table.find_all("tr")

#for string in maps_created.stripped_strings:
#    print(repr(string))
#for string in multiplayer_game_table.stripped_strings:
#    print(repr(string))
game_list = []
find_multiplayer_id(game_list)
print(game_list)
