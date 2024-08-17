extends Node

@export var main_container : Node = get_parent()
@export var settings_menu : Node

@export var continue_btn : Button
@export var settings_btn : Button
@export var quit_btn : Button

func handle_continue():
	main_container.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return

func handle_settings():
	if settings_menu.visible == false:
		settings_menu.visible = true
		return

	settings_menu.visible = false

func handle_quit():
	# TODO: make a box that asks whether to quit to menu or quit to desktop
	# Box should be dynamic with the ability to set its text,
	# and set its button functions dynamically
	pass

func _ready():
	continue_btn.pressed.connect(handle_continue)
	settings_btn.pressed.connect(handle_settings)
	quit_btn.pressed.connect(handle_quit)