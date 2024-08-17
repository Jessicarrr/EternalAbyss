extends BaseSetting
class_name BoolSetting

func _init(_name = "[No name assigned]", _description = "[No description assigned]", _current = false):
	self.setting_name = _name
	self.description = _description
	self.type = Enums.SettingsType.BOOLEAN
	self._value = _current

func set_value(param_value : bool):
	self._value = param_value
	Debug.msg(Debug.SETTINGS, ["Set " + setting_name + " to " + str(param_value)])
	setting_changed.emit(param_value)

func get_value() -> bool:
	return self._value