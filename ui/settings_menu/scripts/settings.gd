extends Control

enum OptionType { 
	BOOLEAN,
	RANGE,
	DROPDOWN,
}

@onready var prefabs = {
	Enums.SettingsType.BOOLEAN: preload("res://ui/settings_menu/scenes/widgets/checkbox.tscn"),
	Enums.SettingsType.RANGE: preload("res://ui/settings_menu/scenes/widgets/slider.tscn"),
	Enums.SettingsType.MULTI_CHOICE: preload("res://ui/settings_menu/scenes/widgets/dropdown.tscn")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
