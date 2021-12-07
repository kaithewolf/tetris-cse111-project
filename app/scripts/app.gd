extends Node2D
onready var Sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
onready var db_path = "res://tetris.db"
onready var db 
onready var user_menu = get_node("Menu")
onready var other_menu = get_node("Menu2")
onready var UserLabel = get_node("HBoxContainer/UserLabel")

var selected_user:String = "none"
var selected_table:String = "Sprint"
var selected_item:Dictionary= {}
var gameType:int = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func select_from_table(command):
	print(db.query(command))
	
	var list = []
	for i in range(0, db.query_result.size()):
		list.append(db.query_result[i])
	
	return list.duplicate()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	db = Sqlite.new()
	db.path = db_path
	db.open_db()
	
	update_menu()
	
	var command = """
	select * from Sprint_Leaderboard;
	"""
	var sprint_list = select_from_table(command)
	other_menu.populate_menu(sprint_list)
	other_menu.get_node("ScrollContainer").scroll_horizontal = true
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update_menu():
	user_menu.clear_menu()
	var command = """
	select * from Users;
	"""
	var username_list = select_from_table(command)
	user_menu.populate_menu(username_list)
	selected_user = "none"
	
func update_other_menu():
	var command:String
	other_menu.clear_menu()
	if selected_table == "Multiplayer":
		if selected_user == "none":
			command = "select * from MultiplayerGames;"
		else:
			command = "select * from Multiplayer where username = \'"+selected_user+"\';"
	else:
		if selected_user == "none":
			command = "select * from "+selected_table+"_Leaderboard"
		else:
			command = "select * from SinglePlayer where username = \'"+selected_user+"\' and gameType = "+str(gameType)+";"
	
	var menu_list = select_from_table(command)
	other_menu.populate_menu(menu_list)


func _on_No_User_button_up():
	selected_user = "none"
	update_other_menu()

func _on_SprintButton_button_up():
	selected_table = "Sprint"
	gameType = 1
	update_other_menu()


func _on_CheeseButton_button_up():
	selected_table = "Cheese"
	gameType = 3
	update_other_menu()



func _on_SurvivalButton_button_up():
	selected_table = "Survival"
	gameType = 4
	update_other_menu()


func _on_UltraButton_button_up():
	selected_table = "Ultra"
	gameType = 5
	update_other_menu()


func _on_LiveButton_button_up():
	selected_table = "Multiplayer"
	update_other_menu()

func _on_select_clicked(data, menu_name):
	if menu_name == "Menu":
		selected_user = str(data["username"])
		UserLabel.text = selected_user
	else:
		selected_item = data
		print(selected_item)
	update_other_menu()

func _on_delete_clicked(data, menu_name):
	print("delete clicked")
	var cmd:String
	if menu_name == "Menu":
		cmd = "delete from Users where username = \'"+data["username"]+"\';"
		print("delete User: "+str(db.query_with_bindings(cmd, data["username"])))
		update_menu()
		update_other_menu()
	else:
		if selected_user != "none":
			if selected_table == "Multiplayer":
				cmd = "delete from Multiplayer where recordID = ?;"
				print("delete Multiplayer: "+str(db.query_with_bindings(cmd, data["recordID"])))
			else:
				cmd = "delete from SinglePlayer where recordID = ?;"
				print("delete Singleplayer: "+str(db.query_with_bindings(cmd, data["recordID"])))
			
		elif selected_table == "Multiplayer":
			cmd = "delete from MultiplayerGames where MatchID = ?;"
			print("delete MultiplayerGames: "+str(db.query_with_bindings(cmd, data["MatchID"])))
			
	update_other_menu()

func edit_selection(table, text):
	var key_pairs = len(text.split(":"))
	if key_pairs % 2 == 1 or key_pairs == 0:
		print("invalid pairs")
		return
		
	var primary_key:String = ""
	if table == "Users":
		primary_key = "username"
	elif table == "MultiplayerGames":
		primary_key = "MatchID"
	else:
		primary_key = "recordID"
	
	var split_text = text.split(",")
	var text_arr = []
	for i in split_text:
		text_arr.append(i.strip_edges())
	
	var key_list = []
	var value_list = []
	for i in text_arr:
		i = i.split(":")
		i[0] = i[0].strip_edges()
		i[1] = i[1].strip_edges()
		key_list.append(i[0])
		value_list.append(i[1])
	
	var cmd_text = "update "+table+" "
	for i in range(len(key_list)):
		cmd_text += "set "+key_list[i]+" = ? "
	cmd_text += "where "+primary_key+" = ? ;"
	print(cmd_text)
	
	if table == "Users":
		value_list.append(selected_user)
	else:
		value_list.append(selected_item[primary_key])
	
	print(db.query_with_bindings(cmd_text, value_list))
	if table == "Users":
		update_menu()
	else:
		update_other_menu()

func _on_Menu_edit_button_pressed(text, menu_name):
	edit_selection("Users", text)


func _on_Menu_insert_button_pressed(text, menu_name):
	var arr = [text]
	var cmd = "insert into Users values(?);"
	print("insert User: "+str(db.query_with_bindings(cmd, arr)))
	update_menu()

#edit function syntax:  key:value, key:value ...
func _on_Menu2_edit_button_pressed(text:String, menu_name):
	if selected_table == "Multiplayer":
		if selected_user != "none":
			edit_selection("Multiplayer", text)
		else:
			edit_selection("MultiplayerGames", text)
		
	else:
		edit_selection("Singleplayer", text)

func _on_Menu2_insert_button_pressed(text, menu_name):
	print(menu_name)
