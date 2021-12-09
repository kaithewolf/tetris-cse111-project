extends Node2D
onready var point = preload("res://scene/Point.tscn")
onready var y_axis = get_node("y_axis")
onready var x_axis = get_node("x_axis")
onready var title = get_node("title")
var x_offset = 150*scale[0]
var y_offset = -50*scale[1]
#max range of graph, to be mapped onto
var x_graph_end = 700*scale[0]
var y_graph_end = 400*scale[1]
var x_axis_end
var y_axis_end

var number_scale = [100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1, 0.5, 0.1]

#lookup month list index = month
var month_days_list  = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
var date_scale = [365, 183, 92, 31]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_axes(xmin, ymin, xmax, ymax, date_list):
	var xscale_value:float
	var yscale_value:float
	var length = len(number_scale)
	
	var min_year
	var max_year
	var min_month
	var max_month
	var min_day
	var max_day
	
	if len(date_list) > 0:
		var min_txt = date_list[0].split("-")
		var max_txt = date_list[-1].split("-")
		
		min_year = int(min_txt[0])
		max_year = int(max_txt[0])
		min_month = int(min_txt[1])
		max_month = int(max_txt[1])
		min_day = int(min_txt[2])
		max_day = int(max_txt[2])
		
		for i in range(len(date_scale)-1):
			if xmax - xmin > date_scale[i] and i < length-2:
				xscale_value = date_scale[i+1]
				break
			if i == length-1:
				xscale_value = date_scale[i]
	else:#find appropriate scale (if it's too small for the large number, go 2 smaller
		for i in range(length):
			if xmax - xmin > number_scale[i] and i < length-2:
				xscale_value = number_scale[i+1]
				break
			if i == length-1:
				xscale_value = number_scale[i]
	
	length = len(number_scale)
	for i in range(length-1):
		if ymax - ymin > number_scale[i] and i < length-2:
			yscale_value = number_scale[i+1]
			break
		if i == length-1:
			yscale_value = number_scale[i]
	
	var min_size
	var max_size
	var total_size
	#draw x axis based on scale value
	if len(date_list) > 0:
		min_size = min_day - month_days_list[min_month-1]
		max_size = month_days_list[max_month-1] - max_day + xmax
	else:
		min_size = floor(xmin/xscale_value)*xscale_value
		max_size = ceil(xmax/xscale_value)*xscale_value
		
	x_axis_end = max_size
	total_size = min_size #start at minimum
	
	#place each x label
	while total_size <= max_size:
		var new_label = Label.new()
		new_label.rect_position = Vector2(float(total_size-min_size)/(max_size-min_size)*x_graph_end+x_offset, 0)
		
		if len(date_list) > 0:
			new_label.text = str(min_year)+"-"+str(min_month)+"-1"
		else:
			new_label.text = str(total_size)
		new_label.align = Label.ALIGN_CENTER
		new_label.set_h_grow_direction(2)
		$runtime.add_child(new_label)
		new_label.set_owner(self)
		
		if len(date_list) > 0:
			total_size += xscale_value
			if min_month < 12:
				min_month += floor(xscale_value/30)
			else:
				min_month = 12-min_month
				min_year += 1
		else:
			total_size += xscale_value #increase each position
		
	#draw y axis based on scale value
	min_size = floor(ymin/yscale_value)*yscale_value
	max_size = ceil(ymax/yscale_value)*yscale_value
	y_axis_end = max_size
	total_size = min_size #start at minimum
	
	#place each y label 
	while total_size <= max_size:
		var new_label = Label.new()
		new_label.rect_position = Vector2(50*scale[1], (-float(total_size-min_size)/(max_size-min_size)*y_graph_end + y_offset))
		new_label.text = str(total_size)
		new_label.align = Label.ALIGN_CENTER
		new_label.set_h_grow_direction(0)
		$runtime.add_child(new_label)
		new_label.set_owner(self)
		total_size += yscale_value #increase each position
	
func graph_points(x_list, y_list, x_axis_txt:String, y_axis_txt:String, title_txt:String, data):
	var xmin = x_list.min()
	var xmax = x_list.max()
	var ymin = y_list.min()
	var ymax = y_list.max()
	
	var date_list = []
	if "date_played" in data[0]:
		for i in data:
			date_list.append(i["date_played"])
	
	create_axes(xmin, ymin, xmax, ymax, date_list)
	#scale each point onto the graph
	x_axis.text = x_axis_txt
	y_axis.text = y_axis_txt
	title.text = title_txt
	for i in range(len(x_list)):
		var new_point = point.instance()
		new_point.position = Vector2(float(x_list[i]-xmin)/(x_axis_end-xmin)*x_graph_end + x_offset, -float(y_list[i]-ymin)/(y_axis_end-ymin)*y_graph_end + y_offset)
		$runtime.add_child(new_point)
		new_point.set_owner($runtime)
		var x_str = x_axis.text+": "+str(x_list[i])
		var y_str = y_axis.text+": "+str(y_list[i])
		if len(date_list) > 0:
			new_point.set_data(date_list[i], y_str)
		else:
			new_point.set_data(x_str, y_str)

func clear_graph():
	#delete all points
	for n in $runtime.get_children():
			$runtime.remove_child(n)
			n.queue_free()
			
