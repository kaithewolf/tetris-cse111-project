extends Node2D
onready var Sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
onready var db_path = "res://tetris.db"
onready var db 
onready var user_menu = get_node("Menu")
onready var other_menu = get_node("Menu2")

var selected_user:String = "none"
var selected_table:String = "Sprint"

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
	
	var command = """
	select * from Users;
	"""
	var username_list = select_from_table(command)
	user_menu.populate_menu(username_list)
	
	command = """
	select * from Sprint_Leaderboard;
	"""
	var sprint_list = select_from_table(command)
	other_menu.populate_menu(sprint_list)
	other_menu.get_node("ScrollContainer").scroll_horizontal = true
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SprintButton_button_up():
	var command:String
	if selected_user == "none":
		command = """
		select * from Sprint_Leaderboard
		"""
	else:
		command = "select * from SinglePlayer where username = "+selected_user+" and gameType = 1;"
	
	other_menu.clear_menu()
	var menu_list = select_from_table(command)
	other_menu.populate_menu(menu_list)



func _on_CheeseButton_button_up():
	var command:String
	if selected_user == "none":
		command = """
		select * from Cheese_Leaderboard
		"""
	else:
		command = "select * from SinglePlayer where username = "+selected_user+" and gameType = 3;"
	
	other_menu.clear_menu()
	var menu_list = select_from_table(command)
	other_menu.populate_menu(menu_list)


func _on_No_User_button_up():
	selected_user = "none"
