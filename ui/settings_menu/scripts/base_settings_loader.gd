extends Control
class_name BaseSettingsLoader

var category_instance : SettingsCategory = null

var prefabs = {
	Enums.SettingsType.BOOLEAN: preload("res://ui/settings_menu/scenes/widgets/checkbox.tscn"),
	Enums.SettingsType.RANGE: preload("res://ui/settings_menu/scenes/widgets/slider.tscn"),
	Enums.SettingsType.MULTI_CHOICE: preload("res://ui/settings_menu/scenes/widgets/dropdown.tscn")
}

var controller = SettingsController.new()

func set_category_instance(instance : SettingsCategory):
	self.category_instance = instance

func populate():
	var all_settings = category_instance.get_all_settings()

	for setting in all_settings:
		var type = setting.type
		var prefab = prefabs[type]

		var prefab_instance = prefab.instantiate()

		var label_node : Label = prefab_instance.get_node("Label")

		self.add_child(prefab_instance)

		if prefab_instance.is_node_ready() == false:
			await prefab_instance.ready
		
		if label_node.is_node_ready() == false:
			await label_node.ready

		label_node.text = setting.setting_name
		prefab_instance.set_description(setting.description)

		controller.connect_ui_to_backend(prefab_instance, setting)

		
		

