extends Resource
class_name SettingsCategory

@export var category_name = "None"

func _init():
	Debug.msg(Debug.SETTINGS_INIT, ["Settings category added: '" + category_name + "'"])

func get_all_settings():
	var settings = []
	var property_list = get_property_list()

	for property in property_list:
		var prop_name = property.name
		var prop_value = self.get(prop_name)

		if prop_value is BaseSetting:
			settings.append(prop_value)

	return settings

