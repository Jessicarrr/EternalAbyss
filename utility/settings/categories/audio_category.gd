extends SettingsCategory
class_name AudioCategory

var master_volume : NumberRangeSetting\
		= NumberRangeSetting.new("Test Setting", "Controls the volume of the whole game.", 0, 100, 50)

func _init():
	self.category_name = "Audio"
	super()