extends Node2D
onready var point = preload("res://scene/Point.tscn")
onready var y_axis = get_node("y_axis")
onready var x_axis = get_node("x_axis")
var x_offset = 150
var y_offset = -50
#max range of graph, to be mapped onto
var x_axis_end = 700
var y_axis_end = 400
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	graph_points()

func graph_points():
	var x_list = [0, 400, 900]
	var y_list = [0, 400, 900]
	var xmin = x_list.min()
	var xmax = x_list.max()
	var ymin = y_list.min()
	var ymax = y_list.max()
	
	#scale each point onto the graph
	for i in range(len(x_list)):
		var new_point = point.instance()
		
		new_point.position = Vector2(float(x_list[i])/xmax*x_axis_end + x_offset, -float(y_list[i])/ymax*y_axis_end + y_offset)
		self.add_child(new_point)
		new_point.set_owner(self)
		var x_str = x_axis.text+": "+str(x_list[i])
		var y_str = y_axis.text+": "+str(y_list[i])
		new_point.set_data(x_str, y_str)
#	pass
