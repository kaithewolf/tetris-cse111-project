extends Node2D

onready var selection = preload("res://scene/MenuSelection.tscn")
onready var control_obj = get_node("ScrollContainer/Control")
onready var control_node = Control.new()
signal edit_button_pressed(text, menu_name)
signal insert_button_pressed(text, menu_name)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func populate_menu(list):
	for tuple in list:
		var select = selection.instance()
		select.connect("select_clicked", get_parent(), "_on_select_clicked")
		select.connect("delete_clicked", get_parent(), "_on_delete_clicked")
		select.set_text(tuple)
		control_obj.add_child(select)
		select.set_owner(get_tree().get_edited_scene_root())
	control_obj.add_child(control_node)
		
func clear_menu():
	for n in control_obj.get_children():
		control_obj.remove_child(n)
		n.queue_free()
	#reinstate last control node
	control_node = Control.new()


func _on_EditButton_button_up():
	emit_signal("edit_button_pressed", $LineEdit.text, self.name)


func _on_InsertButton_button_up():
	emit_signal("insert_button_pressed", $LineEdit.text, self.name)
