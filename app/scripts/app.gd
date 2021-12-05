extends Node2D

onready var user_menu = get_node("Menu")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var list = ["kaithewolf", "nateqwq", "uwuwuwu", "guhhh"]
	user_menu.populate_menu(list)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
