extends SettingsCategory
class_name AccessibilityCategory

var subtitles_sound : BoolSetting = BoolSetting.new(
	"Subtitles for sounds",
	"Text displays on screen describing what the player can hear.",
	false)

# Color blindness
# TODO: implement it
# https://github.com/paulloz/godot-colorblindness
var color_blind_mode : MultiChoiceSetting = MultiChoiceSetting.new(
		"Color blind mode",
		"Various shaders to colour the screen in order to compensate for common types of colour blindness.",
		[ "None", "Type A", "Type B", "Type C", "Type D" ]
)

# Color blindness
# TODO: implement it
# https://github.com/paulloz/godot-colorblindness
var font : MultiChoiceSetting = MultiChoiceSetting.new(
		"Fonts",
		"Make the game easier to read by changing the font.",
		[ "Alagard (default)", "Non pixel art", "Monospaced font" ]
)

func _init():
	self.category_name = "Accessibility"
	super()