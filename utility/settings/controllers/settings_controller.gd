extends Resource
class_name SettingsController

# connects the settings ui to the settings back-end
# so we can keep a separation of concerns.

func connect_ui_to_backend(prefab, backend_setting):
	if backend_setting is NumberRangeSetting:
		prefab.units = backend_setting.units
		prefab.set_min_max(backend_setting.min_value, backend_setting.max_value)

	if backend_setting is MultiChoiceSetting:
		prefab.set_multi_choice_options(backend_setting.options)

	prefab.set_value(backend_setting.get_value())