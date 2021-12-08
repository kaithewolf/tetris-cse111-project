extends Node2D
onready var point = preload("res://scene/Point.tscn")
onready var y_axis = get_node("y_axis")
onready var x_axis = get_node("x_axis")
var x_offset = 150
var y_offset = -50
#max range of graph, to be mapped onto
var x_axis_end = 700
var y_axis_end = 400

var number_scale = [100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1, 0.5, 0.1]
var date_scale  = ["year","6months", "month", "2week", "week", "day"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	graph_points()

func create_axes(xmin, ymin, xmax, ymax):
	var scale_value:float
	var length = len(number_scale)
	#find appropriate scale (if it's too small for the large number, go 2 smaller
	for i in range(length):
		if xmax - xmin > number_scale[i] and i < length-2:
			scale_value = number_scale[i+1]
			break
		if i == length-1:
			scale_value = number_scale[i]
	print(scale_value)
	
	#draw x axis based on scale value
	var x_axis_pos = []
	#lowest number
	var min_size = floor(xmin/scale_value)*scale_value
	var max_size = ceil(xmax/scale_value)*scale_value
	var total_size = min_size
	
	#place each label
	while total_size <= max_size:
		var new_label = Label.new()
		new_label.rect_position = Vector2(float(total_size-min_size)/(max_size-min_size)*x_axis_end+x_offset, 0)
		new_label.text = str(total_size)
		add_child(new_label)
		new_label.set_owner(self)
		total_size += scale_value
		

func graph_points():
	var x_list = [100, 400, 900]
	var y_list = [100, 400, 900]
	var xmin = x_list.min()
	var xmax = x_list.max()
	var ymin = y_list.min()
	var ymax = y_list.max()
	
	create_axes(xmin, ymin, xmax, ymax)
	#scale each point onto the graph
	for i in range(len(x_list)):
		var new_point = point.instance()
		
		new_point.position = Vector2(float(x_list[i]-xmin)/(xmax-xmin)*x_axis_end + x_offset, -float(y_list[i]-ymin)/(ymax-ymin)*y_axis_end + y_offset)
		self.add_child(new_point)
		new_point.set_owner(self)
		var x_str = x_axis.text+": "+str(x_list[i])
		var y_str = y_axis.text+": "+str(y_list[i])
		new_point.set_data(x_str, y_str)
#	pass
