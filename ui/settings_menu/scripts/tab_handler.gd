extends Button

@export var tabs_container : Node
@export var tab_to_handle : Node

@onready var all_tabs = tabs_container.get_children()

func open_tab():
	for tab in all_tabs:
		tab.visible = false

	tab_to_handle.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(open_tab)
