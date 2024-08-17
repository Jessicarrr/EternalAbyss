extends SettingsCategory
class_name AccessibilityCategory

var head_bob : BoolSetting\
		= BoolSetting.new("Head bob", "Moves the camera up and down when you walk or run.", true)

func _init():
	self.category_name = "Accessibility"
	super()