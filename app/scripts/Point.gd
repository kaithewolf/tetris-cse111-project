extends Node2D
onready var fill = get_node("Filled Circle")
onready var data_label = get_node("Data")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Data.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_data(data:Dictionary):
	var key_list = data.keys()
	for i in range(0, len(key_list)-1):
		data_label.text += str(key_list[i])+": "+str(data[key_list[i]])+"\n"

func _on_Node2D_mouse_entered():
	fill.visible = true
	data_label.visible = true




func _on_Node2D_mouse_exited():
	fill.visible = false
	data_label.visible = false
	
