extends BaseSetting
class_name NumberRangeSetting

func _init(_name = "[No name assigned]", _description = "[No description assigned]", _min = 0, _max = 100, _current = 50, _units = "%"):
	self.setting_name = _name
	self.description = _description
	self.type = Enums.SettingsType.RANGE
	self._value = _current

	_extra_data.min_value = _min
	_extra_data.max_value = _max
	_extra_data.units = _units

func get_string_representation():
	return str(self._value) + _extra_data.units

func set_value(param_value : int):
	if param_value < _extra_data.min_value || param_value > _extra_data.max_value:
		push_warning("Tried to set number range value beyond its normal limits. The value was clamped.")
		clamp(param_value, _extra_data.min_value, _extra_data.max_value)

	self._value = param_value
	Debug.msg(Debug.SETTINGS, ["Set " + setting_name + " to " + str(param_value)])
	setting_changed.emit(param_value)

func get_value() -> int:
	return self._value