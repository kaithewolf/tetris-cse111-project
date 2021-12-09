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

var number_scale = [100000, 50000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1, 0.5]

#lookup month list index = month
var month_days_list  = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
var date_scale = [1825, 365, 183, 92, 46, 28, 14, 7]


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
		
		#find appropriate scale (if it's too small for the large number, go 2 smaller
		for i in range(0, len(date_scale)-1):
			if xmax - xmin > date_scale[i] and i < length-2:
				xscale_value = date_scale[i+1]
				break
			else:
				xscale_value = date_scale[i]
	else:
		#find number scale
		for i in range(0, length-1):
			if xmax - xmin > number_scale[i] and i < length-2:
				xscale_value = number_scale[i+1]
				break
			else:
				xscale_value = number_scale[i]
	
	length = len(number_scale)
	for i in range(0, length-1):
		if ymax - ymin > number_scale[i] and i < length-2:
			yscale_value = float(number_scale[i+1])
			break
		else:
			yscale_value = number_scale[i]
	
	var min_size
	var max_size
	var total_size
	#draw x axis based on scale value
	if len(date_list) > 0:
		min_size = min_day - month_days_list[min_month-1]
	else:
		min_size = floor(xmin/xscale_value)*xscale_value
	
	max_size = ceil(xmax/xscale_value)*xscale_value
	
	if max_size == min_size:
		max_size += 1
	x_axis_end = max_size
	total_size = min_size #start at minimum
	
	print(ceil(x_axis_end/xscale_value))
	#place each x label
	while total_size <= max_size:
		var new_label = Label.new()
		new_label.rect_position = Vector2(float(total_size-min_size)/(max_size-min_size)*x_graph_end+x_offset, 0)
		
		if len(date_list) > 0:
			new_label.text = str(min_year)+"-"+str(min_month)+"-"+str(min_day)
		else:
			new_label.text = str(total_size)
		new_label.align = Label.ALIGN_CENTER
		new_label.set_h_grow_direction(2)
		$runtime.add_child(new_label)
		new_label.set_owner(self)
		
		total_size += xscale_value #increase each position
		if len(date_list) > 0:
			if min_month + floor(xscale_value/30) <= 12:
				if floor(xscale_value/30) > 0:
					min_month += floor(xscale_value/30)
				elif min_day + xscale_value < month_days_list[min_month-1]:
					min_day += xscale_value
				else:
					min_day = min_day+xscale_value - month_days_list[min_month-1]
					min_month += 1
			else:
				min_month = min_month+floor(xscale_value/30) - 12
				min_year += 1
		
	#draw y axis based on scale value
	min_size = floor(ymin/float(yscale_value))*yscale_value
	max_size = ceil(ymax/yscale_value)*yscale_value
	if max_size == min_size:
		max_size += 1
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
	
	if ymin == null:
		ymin = 0
	if ymax == null:
		ymax = ymin+1
	
	var date_list = []
	if "date_played" in data[0]:
		for d in data:
			date_list.append(d["date_played"])
	
	create_axes(xmin, ymin, xmax, ymax, date_list)
	if x_axis_end == xmin:
		x_axis_end += 1
	if y_axis_end == ymin:
		y_axis_end += 1
	#scale each point onto the graph
	x_axis.text = x_axis_txt
	y_axis.text = y_axis_txt
	title.text = title_txt
	for i in range(len(x_list)):
		var new_point = point.instance()
		if x_list[i] != null and y_list[i] != null:
			new_point.position = Vector2(float(x_list[i]-xmin)/(x_axis_end-xmin)*x_graph_end + x_offset, -float(y_list[i]-ymin)/(y_axis_end-ymin)*y_graph_end + y_offset)
			$runtime.add_child(new_point)
			new_point.set_owner($runtime)
			var x_str = x_axis.text+": "+str(x_list[i])
			var y_str = y_axis.text+": "+str(y_list[i])
			new_point.set_data(data[i])

func clear_graph():
	#delete all points
	for n in $runtime.get_children():
			$runtime.remove_child(n)
			n.queue_free()
			
