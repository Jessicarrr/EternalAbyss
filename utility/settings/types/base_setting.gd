extends Resource
class_name BaseSetting

var setting_name = ""
var description = ""
var type : Enums.SettingsType
var _value : Variant
var _extra_data : Dictionary = {}

func _init(_name = "[No name assigned]", _description = "[No description assigned]", _current = null):
	self.name = _name
	self.description = _description
	self.type = Enums.SettingsType.NONE
	self._value = _current

func set_value(param_value):
	self._value = param_value

func get_value() -> Variant:
	return self._value

func _to_string():
	return self.get_class() + ": '" + setting_name + "'', " + str(_value)

func get_extra_data():
	return _extra_data