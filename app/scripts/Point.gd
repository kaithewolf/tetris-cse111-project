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
func set_data(x_str:String, y_str:String):
	data_label.text = x_str+"\n"+y_str

func _on_Node2D_mouse_entered():
	fill.visible = true
	data_label.visible = true




func _on_Node2D_mouse_exited():
	fill.visible = false
	data_label.visible = false
	
