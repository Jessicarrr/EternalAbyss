extends SettingsCategory
class_name AccessibilityCategory

var head_bob : BoolSetting\
		= BoolSetting.new("Master volume", "Controls the volume of the whole game.", true)

func _init():
	self.category_name = "Accessibility"
	super()