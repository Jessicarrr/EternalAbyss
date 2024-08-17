extends Button

@export var tabs_container : Node
@export var tab_to_handle : Node

var all_tabs = null

func open_tab():
	if all_tabs == null:
		if tabs_container == null:
			push_warning("Tried to open a settings tab but the settings area given to the tab button was null?")
			return

		all_tabs = tabs_container.get_children()

	for tab in all_tabs:
		tab.visible = false

	tab_to_handle.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(open_tab)
