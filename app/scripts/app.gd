extends Node2D
var Sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db_path = "res://tetris.db"
var db
onready var user_menu = get_node("Menu")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	db = Sqlite.new()
	db.path = db_path
	db.open_db()
	var command = "select * from Users;"
	print(db.query(command))
	
	var list = []
	for i in range(0, db.query_result.size()):
		list.append(db.query_result[i]["username"])
	
	user_menu.populate_menu(list)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
