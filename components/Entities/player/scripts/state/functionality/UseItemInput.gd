extends Node

@onready var parent = get_parent()

signal use_button_pressed
signal use_button_released
	
func _input(_event):
	if parent.active == false:
		return
	
	# Check for the "attack" action
	if Input.is_action_just_pressed("use_item"):
		use_button_pressed.emit()
		return
		
	if Input.is_action_just_released("use_item"):
		use_button_released.emit()
		return

func is_pressing_use_button():
	return Input.is_action_pressed("use_item")
