extends BaseSetting
class_name MultiChoiceSetting

func _init(_name = "[No name assigned]", _description = "[No description assigned]", _options = [ "High", "Medium", "Low" ]):
	self.setting_name = _name
	self.description = _description
	self.type = Enums.SettingsType.MULTI_CHOICE
	#self.options = _options #old

	_extra_data.options = _options

	_handle_set_options()

func _handle_set_options():
	if _extra_data.options.size() < 1:
		push_warning("Initialized MultiChoiceSetting with an empty options array. current_value will be null. Setting name: " + setting_name)
		self._value = null
		return

	self._value = _extra_data.options[0]

func set_value(param_value : String):
	if not _extra_data.options.has(param_value):
		push_error("Could not set multi choice value because the value does not exist.")
		return

	self._value = param_value
	Debug.msg(Debug.SETTINGS, ["Set " + setting_name + " to " + str(param_value)])
	setting_changed.emit(param_value)

func add_value(param_value : String) -> bool:
	if _extra_data.options.has(param_value):
		push_error("Cannot add the same value twice to the same multi choice option. Value: '" + param_value + "'")
		return false

	_extra_data.options.append(param_value)
	return true

func remove_value(param_value : String) -> bool:
	if not _extra_data.options.has(param_value):
		return false

	_extra_data.options.erase(param_value)
	return true

func get_possible_values():
	return _extra_data.options

func get_value() -> String:
	return self._value
