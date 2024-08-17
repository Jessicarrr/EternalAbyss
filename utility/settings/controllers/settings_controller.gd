extends Resource
class_name SettingsController

# connects the settings ui to the settings back-end
# so we can keep a separation of concerns.

func connect_ui_to_backend(prefab, backend_setting):
	var data = backend_setting.get_extra_data()

	prefab.set_extra_data(data)
	prefab.set_value(backend_setting.get_value())