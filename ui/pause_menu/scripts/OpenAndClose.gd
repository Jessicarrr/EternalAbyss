extends Node

@onready var menu = get_parent()

func _input(_event):
	if Input.is_action_just_pressed("pause_menu_toggle") == false:
		return

	if menu.visible == true:
		menu.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return

	if menu.visible == false:
		menu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return