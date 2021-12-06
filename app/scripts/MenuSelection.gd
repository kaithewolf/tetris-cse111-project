extends Control

signal select_clicked(data, menu)
signal delete_clicked(data, menu)
var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(list):
	$Button.text = str(list)
	data = list


func _on_Button2_button_up():
	emit_signal("delete_clicked", data, get_parent().get_parent().get_parent().name)


func _on_Button_button_up():
	emit_signal("select_clicked", data, get_parent().get_parent().get_parent().name)
