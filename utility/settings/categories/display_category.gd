extends SettingsCategory
class_name DisplayCategory

var fov : NumberRangeSetting = NumberRangeSetting.new(
		"FOV",
		"Field of View determines how much you can see on the screen at once. Can help with motion sickness.",
		70, 130, 80, ""
)

var window_type : MultiChoiceSetting = MultiChoiceSetting.new(
		"Window",
		"Choose the type of window for the game.",
		[ "Windowed", "Borderless", "Fullscreen" ]
)

var resolution : MultiChoiceSetting = MultiChoiceSetting.new(
		"Resolution",
		"Choose how large the window for this game should be.",
		[ "1920x1080", "1600x900", "1280x720", "pls implement" ]
)

func _init():
	self.category_name = "Display"
	super()