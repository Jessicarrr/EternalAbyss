extends Node

@onready var parent = get_parent()

signal use_item_pressed
signal use_item_released
	
func _input(_event):
	if parent.active == false:
		return
	
	# Check for the "attack" action
	if Input.is_action_just_pressed("use_item"):
		use_item_pressed.emit()
	
	if Input.is_action_just_released("use_item"):
		use_item_released.emit()

func _on_idle_began():
	if Input.is_action_pressed("use_item"):
		use_item_pressed.emit()
