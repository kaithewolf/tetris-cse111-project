extends Node2D
onready var point = preload("res://scene/Point.tscn")
onready var y_axis = get_node("y_axis")
onready var x_axis = get_node("x_axis")
var x_offset = 150*scale[0]
var y_offset = -50*scale[1]
#max range of graph, to be mapped onto
var x_graph_end = 700*scale[0]
var y_graph_end = 400*scale[1]
var x_axis_end
var y_axis_end

var number_scale = [100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1, 0.5, 0.1]
var date_scale  = ["year","6months", "month", "2week", "week", "day"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_axes(xmin, ymin, xmax, ymax):
	var xscale_value:float
	var yscale_value:float
	var length = len(number_scale)
	#find appropriate scale (if it's too small for the large number, go 2 smaller
	for i in range(length):
		if xmax - xmin > number_scale[i] and i < length-2:
			xscale_value = number_scale[i+1]
			break
		if i == length-1:
			xscale_value = number_scale[i]
	
	for i in range(length):
		if ymax - ymin > number_scale[i] and i < length-2:
			yscale_value = number_scale[i+1]
			break
		if i == length-1:
			yscale_value = number_scale[i]
	
	
	#draw x axis based on scale value
	var min_size = floor(xmin/xscale_value)*xscale_value
	var max_size = ceil(xmax/xscale_value)*xscale_value
	x_axis_end = max_size
	var total_size = min_size #start at minimum
	
	#place each label
	while total_size <= max_size:
		var new_label = Label.new()
		new_label.rect_position = Vector2(float(total_size-min_size)/(max_size-min_size)*x_graph_end+x_offset, 0)
		new_label.text = str(total_size)
		$runtime.add_child(new_label)
		new_label.set_owner(self)
		total_size += xscale_value #increase each position
		
	#draw y axis based on scale value
	min_size = floor(ymin/yscale_value)*yscale_value
	max_size = ceil(ymax/yscale_value)*yscale_value
	y_axis_end = max_size
	total_size = min_size #start at minimum
	
	#place each y label 
	while total_size <= max_size:
		var new_label = Label.new()
		new_label.rect_position = Vector2(0, (-float(total_size-ymin)/(ymax-ymin)*y_graph_end + y_offset -10*scale[1]))
		new_label.text = str(total_size)
		$runtime.add_child(new_label)
		new_label.set_owner(self)
		total_size += yscale_value #increase each position
	
func graph_points(x_list, y_list, data):
	var xmin = x_list.min()
	var xmax = x_list.max()
	var ymin = y_list.min()
	var ymax = y_list.max()
	
	create_axes(xmin, ymin, xmax, ymax)
	#scale each point onto the graph
	for i in range(len(x_list)):
		var new_point = point.instance()
		
		new_point.position = Vector2(float(x_list[i]-xmin)/(x_axis_end-xmin)*x_graph_end + x_offset, -float(y_list[i]-ymin)/(y_axis_end-ymin)*y_graph_end + y_offset)
		$runtime.add_child(new_point)
		new_point.set_owner($runtime)
		var x_str = x_axis.text+": "+str(x_list[i])
		var y_str = y_axis.text+": "+str(y_list[i])
		new_point.set_data(x_str, y_str)

func clear_graph():
	#delete all points
	for n in $runtime.get_children():
			$runtime.remove_child(n)
			n.queue_free()
			
