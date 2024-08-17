extends Control
class_name BaseSettingsLoader

var category_instance : SettingsCategory = null

var prefabs = {
	Enums.SettingsType.BOOLEAN: preload("res://ui/settings_menu/scenes/widgets/checkbox.tscn"),
	Enums.SettingsType.RANGE: preload("res://ui/settings_menu/scenes/widgets/slider.tscn"),
	Enums.SettingsType.MULTI_CHOICE: preload("res://ui/settings_menu/scenes/widgets/dropdown.tscn")
}

func set_category_instance(instance : SettingsCategory):
	self.category_instance = instance

func _on_widget_value_changed(new_value, setting):
	setting.set_value(new_value)

func populate():
	var all_settings = category_instance.get_all_settings()
	var controller = SettingsController.new()

	for setting in all_settings:
		var type = setting.type
		var prefab = prefabs[type]

		var prefab_instance = prefab.instantiate()

		var label_node : Label = prefab_instance.get_node("Label")

		self.add_child(prefab_instance)
		await get_tree().process_frame
		
		label_node.text = setting.setting_name
		label_node.tooltip_text = setting.description

		controller.connect_ui_to_backend(prefab_instance, setting)

		prefab_instance.widget_value_changed.connect(self._on_widget_value_changed.bind(setting))

		
		

