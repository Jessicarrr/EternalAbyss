extends Control

# where the tab buttons go
@onready var tabs_buttons_container = $ColorRect/HBoxContainer

# where the actual settings go
@onready var tabs_content_container = $ColorRect/ScrollContainer/VBoxContainer

func _ready():
	create_tabs()

func create_tabs():
	var tab_button_prefab = preload("res://ui/settings_menu/scenes/tab.tscn")
	var tab_content_prefab = preload("res://ui/settings_menu/scenes/tab_settings_container.tscn")
	var all_settings_categories = Game.settings.get_all_settings_categories()
	var first_batch_of_settings = null

	for category in all_settings_categories:

		var tab_content_container = tab_content_prefab.instantiate()
		tabs_content_container.add_child(tab_content_container)
		tab_content_container.set_category_instance(category)
		tab_content_container.name = category.category_name + "Settings"

		if first_batch_of_settings == null:
			first_batch_of_settings = tab_content_container

		var new_tab_button = tab_button_prefab.instantiate()
		new_tab_button.tabs_container = tabs_content_container
		new_tab_button.tab_to_handle = tab_content_container
		new_tab_button.text = category.category_name
		new_tab_button.name = category.category_name + "TabButton"
		tabs_buttons_container.add_child(new_tab_button)

		await get_tree().process_frame
		tab_content_container.populate()

		tab_content_container.visible = false

	first_batch_of_settings.visible = true
