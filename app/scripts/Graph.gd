extends Node2D
onready var point = preload("res://scene/Point.tscn")
var x_offset = 150
var y_offset = -50
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	graph_points()

func graph_points():
	var x_list = [0, 50, 100]
	var y_list = [0, 50, 100]
	for i in range(len(x_list)):
		var new_point = point.instance()
		new_point.position = Vector2(x_list[i]+x_offset, -y_list[i]+y_offset)
		self.add_child(new_point)
		new_point.set_owner(self)
#	pass
