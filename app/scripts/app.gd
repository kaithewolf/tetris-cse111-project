extends Node2D
onready var Sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
onready var db_path = "res://tetris.db"
onready var db 
onready var user_menu = get_node("Menu")
onready var other_menu = get_node("Menu2")
onready var UserLabel = get_node("HBoxContainer/UserLabel")
onready var SelectedLabel = get_node("SelectedLabel")

var selected_user:String = "none"
var selected_table:String = "Sprint"
var selected_item:Dictionary= {}
var selected_graph = "none"
var gameType:int = 1


var x_axis:String
var y_axis:String
var y_title:String

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func select_from_table(command):
	print(db.query(command))
	
	var list = []
	for i in range(0, db.query_result.size()):
		list.append(db.query_result[i])
	
	return list.duplicate()

func select_with_param(command, arr):
	print(db.query_with_bindings(command, arr))
	
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
	reset_buttons()
	
	var command = """
	select * from Sprint_Leaderboard;
	"""
	var sprint_list = select_from_table(command)
	other_menu.populate_menu(sprint_list)
	other_menu.get_node("ScrollContainer").scroll_horizontal = true
	pass # Replace with function body.

#user menu
func update_menu():
	user_menu.clear_menu()
	var command = """
	select * from Users
	order by username ASC;
	"""
	var username_list = select_from_table(command)
	user_menu.populate_menu(username_list)
	selected_user = "none"
	
#other menu
func update_other_menu():
	var command:String
	other_menu.clear_menu()
	if selected_table == "Multiplayer":
		if selected_user == "none":
			command = "select * from MultiplayerGames;"
		else:
			command = "select * from Multiplayer where username = \'"+selected_user+"\';"
	elif selected_table == "MapDownstack":
		if selected_user == "none":
			command = "select * from CustomMap;"
		else:
			command = "select * from MapDownstack where username = \'"+selected_user+"\';"
	else:
		if selected_user == "none":
			command = "select * from "+selected_table+"_Leaderboard"
		else:
			command = "select * from SinglePlayer where username = \'"+selected_user+"\' and gameType = "+str(gameType)+";"
	
	var menu_list = select_from_table(command)
	other_menu.populate_menu(menu_list)


func _on_No_User_button_up():
	selected_user = "none"
	UserLabel.text = "none"
	update_other_menu()

func _on_SprintButton_button_up():
	selected_table = "Sprint"
	if selected_graph == "performance":
		_on_PerformanceButton_button_up()
	gameType = 1
	update_other_menu()


func _on_CheeseButton_button_up():
	selected_table = "Cheese"
	if selected_graph == "performance":
		_on_PerformanceButton_button_up()
	gameType = 3
	update_other_menu()



func _on_SurvivalButton_button_up():
	selected_table = "Survival"
	if selected_graph == "performance":
		_on_PerformanceButton_button_up()
	gameType = 4
	update_other_menu()


func _on_UltraButton_button_up():
	selected_table = "Ultra"
	if selected_graph == "performance":
		_on_PerformanceButton_button_up()
	gameType = 5
	update_other_menu()


func _on_LiveButton_button_up():
	selected_table = "Multiplayer"
	if selected_graph == "performance":
		_on_PerformanceButton_button_up()
	update_other_menu()

func _on_MapButton_button_up():
	selected_table = "MapDownstack"
	update_other_menu()
#when a selectoin is clicked on
func _on_select_clicked(data, menu_name):
	if menu_name == "Menu":
		selected_user = str(data["username"])
		UserLabel.text = selected_user
	else:
		selected_item = data
		print(selected_item)
		SelectedLabel.text = str(selected_item)
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
			elif selected_table == "MapDownstack":
				cmd = "delete from MapDownstack where recordID = ?;"
				print("delete Multiplayer: "+str(db.query_with_bindings(cmd, data["recordID"])))
			else:
				cmd = "delete from SinglePlayer where recordID = ?;"
				print("delete Singleplayer: "+str(db.query_with_bindings(cmd, data["recordID"])))
			
		elif selected_table == "Multiplayer":
			cmd = "delete from MultiplayerGames where MatchID = ?;"
			print("delete MultiplayerGames: "+str(db.query_with_bindings(cmd, data["MatchID"])))
			
	update_other_menu()

func edit_selection(table, text):
	#check correct number of key:value pairs, or only 1 item
	var split_text = text.split(",")
	for i in range(len(split_text)):
		if split_text[i].count(":") != 1:
			print("invalid pairs")
			return
	
	var primary_key:String = ""
	if table == "Users":
		primary_key = "username"
	elif table == "MultiplayerGames":
		primary_key = "MatchID"
	else:
		if selected_item.has("recordID"):
			primary_key = "recordID"
		else:
			print("invalid table")
			return 
	
	#split text into each key value pair
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
	
	var cmd_text = "update "+table+" set "
	for i in range(len(key_list)):
		if i < len(key_list) - 1:
			cmd_text += key_list[i]+" = ?, "
		else:
			cmd_text += key_list[i]+" = ? "
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
			
	elif selected_table == "MapDownstack":
		edit_selection("MaptDownstack", text)
		
	else:
		edit_selection("Singleplayer", text)

#insert syntax: value1, value2, ....
func _on_Menu2_insert_button_pressed(text, menu_name):
	var table
	
	var values_list = text.split(",")
	for i in range(len(values_list)):
		values_list[i] = values_list[i].strip_edges()
	print(values_list)
	
	if selected_table == "Multiplayer":
		if selected_user != "none":
			table = "Multiplayer"
		else:
			table = "MultiplayerGames"
			
	else:
		table = "Singleplayer"
	
	var cmd_text = "insert into "+table+" values("
	for i in range(len(values_list)):
		if i == len(values_list)-1:
			cmd_text += "?);"
		else:
			cmd_text += "?, "
	
	print(db.query_with_bindings(cmd_text, values_list))
	update_other_menu()
	

func _on_GraphButton_button_up():
	$Graph.clear_graph()
	var data = []
	var arr = []
	var cmd:String
	#if len(y_axis)*len(x_axis) == 0:
	#	return
	if selected_graph != "none":
		if selected_graph == "performance" or selected_graph == "ratio":
			x_axis = "date"
		else:
			x_axis = "percentile"
		
		if selected_graph == "performance":
			if selected_table != "Multiplayer":
				cmd = "select min(julianday(date_played)) as mindate from Singleplayer where username = ? and gameType = ?;"
				arr = [selected_user, gameType]
			else:
				cmd = "select min(julianday(date_played)) as mindate from Multiplayer m, PlayersinMultiplayerGames pmg, MultiplayerGames mg where m.username = ? and m.recordID = pmg.MatchRecord and pmg.MatchID = mg.MatchID;"
				arr = [selected_user]
				
		elif selected_graph == "ratio":
			selected_table = "Multiplayer"
			cmd = "select min(julianday(date_played)) as mindate from Multiplayer m, PlayersinMultiplayerGames pmg, MultiplayerGames mg where m.username = ? and m.recordID = pmg.MatchRecord and pmg.MatchID = mg.MatchID;"
			arr = [selected_user]
		
		data = select_with_param(cmd, arr)
		
		if selected_graph != "percentile":
			if selected_table != "Multiplayer":
				cmd = "select julianday(date_played) - "+str(data[0]["mindate"])+" as date, date_played, "+y_axis+" as "+y_title+" from Singleplayer where username = ? and gameType = ? group by date order by date asc;"
				arr = [selected_user, gameType]
			else:
				cmd = "select julianday(date_played) - "+str(data[0]["mindate"])+" as date, date_played, "+y_axis+" as "+y_title+" from Multiplayer m, PlayersinMultiplayerGames pmg, MultiplayerGames mg where m.username = ? and m.recordID = pmg.MatchRecord and pmg.MatchID = mg.MatchID;"
				arr = [selected_user, gameType]
		else:
			selected_table = "Multiplayer"
			cmd = "SELECT DISTINCT Multiplayer.username, "+y_axis+" as "+y_title+", 1 - PERCENT_RANK() OVER (ORDER BY "+y_axis+" DESC) AS percentile FROM Multiplayer;"
			print(cmd)
			arr = [y_axis, y_axis]
	data = select_with_param(cmd, arr)
	var x_list = []
	var y_list = []
	for i in data:
		x_list.append(i[x_axis])
		y_list.append(i[y_title])
	
	var x_txt = x_axis
	var y_txt = y_title
	if gameType == 5:
		y_txt = "Score"
	var title_txt = selected_user+"\'s "+selected_table+" games' "+x_txt+" over "+y_txt
	if len(x_list)*len(y_list) != 0:
		print(data)
		$Graph.graph_points(x_list, y_list, x_txt, y_txt, title_txt, data)

func reset_buttons():
	for n in $RatioButton.get_children():
		n.visible = false
	for n in $PercentileButton.get_children():
		n.visible = false
	for n in $PerformanceButton.get_children():
		n.visible = false
	
func _on_RatioButton_button_up():
	reset_buttons()
	selected_graph = "ratio"
	for n in $RatioButton.get_children():
		n.visible = true


func _on_PerformanceButton_button_up():
	reset_buttons()
	selected_graph = "performance"
	for n in $PerformanceButton.get_children():
		n.visible = true
	
	if selected_table != "Multiplayer":
		$PerformanceButton/MultiplayerButtons.visible = false
	

func _on_PercentileButton_button_up():
	reset_buttons()
	selected_graph = "percentile"
	for n in $PercentileButton.get_children():
		n.visible = true
	x_axis = "percentile"



func _on_gameTime_button_up():
	y_axis = "gameTime"
	y_title = "game_time"

func _on_pps_button_up():
	y_axis = "piecesDropped/gameTime"
	y_title = "piecesDropped_per_second"
	


func _on_piecesDropped_button_up():
	y_axis = "piecesDropped"
	y_title = "pieces_dropped"

func _on_apm_button_up():
	y_axis = "CAST( CAST (attack as float) /gameTime as float) * 60"
	y_title = "attack_per_minute"


func _on_apb_button_up():
	y_axis = "CAST( CAST( attack as float)/piecesDropped as float)"
	y_title = "attack_per_block"


func _on_b2b_button_up():
	y_axis = "b2b"
	y_title = "back_to_back"

func _on_apbppb_button_up():
	var ppb = []
	var arr = [selected_user]
	#get best points per block from ultra
	var cmd = "select max(gameTime / cast(piecesDropped as float))/300 as ppb from SinglePlayer where username = ? and gameType = 5;"
	ppb = select_with_param(cmd, arr)
	
	y_axis = "CAST( attack as float)/piecesDropped/"+ str(ppb[0]["ppb"])
	y_title = "mp_over_sp_apb"

func _on_mppsspps_button_up():
	var spps = []
	var arr = [selected_user]
	#get best speed from sprint
	var cmd = "select max(cast(piecesDropped as float)/cast(gameTime as float)) as pps from SinglePlayer where username = ? and gameType = 1;"
	spps = select_with_param(cmd, arr)
	
	y_axis = "CAST(piecesDropped as float)/gameTime/"+str(spps[0]["pps"])
	y_title = "mp_over_sp_pps"


func _on_received_button_up():
	y_axis = "received"
	y_title = "lines_received"



