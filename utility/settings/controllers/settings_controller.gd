extends Resource
class_name SettingsController

# connects the settings ui to the settings back-end
# so we can keep a separation of concerns.

func _on_widget_value_changed(new_value, setting):
	setting.set_value(new_value)

func connect_ui_to_backend(prefab, backend_setting):
	var data = backend_setting.get_extra_data()

	prefab.set_extra_data(data)
	prefab.set_value(backend_setting.get_value())

	prefab.widget_value_changed.connect(self._on_widget_value_changed.bind(backend_setting))