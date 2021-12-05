extends Node2D

onready var selection = preload("res://scene/MenuSelection.tscn")
onready var control_obj = get_node("ScrollContainer/Control")
onready var control_node = Control.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func populate_menu(list):
	for tuple in list:
		var select = selection.instance()
		select.set_text(tuple)
		control_obj.add_child(select)
		select.set_owner(get_tree().get_edited_scene_root())
	control_obj.add_child(control_node)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
