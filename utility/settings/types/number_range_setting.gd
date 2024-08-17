extends BaseSetting
class_name NumberRangeSetting

var min_value = 0
var max_value = 100
var units = ""

func _init(_name = "[No name assigned]", _description = "[No description assigned]", _min = 0, _max = 100, _current = 50, _units = "%"):
	self.setting_name = _name
	self.description = _description
	self.type = Enums.SettingsType.RANGE

	self.min_value = _min
	self.max_value = _max
	self._value = _current
	self.units = _units

func get_string_representation():
	return str(self._value) + units

func set_value(param_value : int):
	if param_value < min_value || param_value > max_value:
		push_warning("Tried to set number range value beyond its normal limits. The value was clamped.")
		clamp(param_value, min_value, max_value)

	self._value = param_value
	Debug.msg(Debug.SETTINGS, ["Set " + setting_name + " to " + str(param_value)])

func get_value() -> int:
	return self._value