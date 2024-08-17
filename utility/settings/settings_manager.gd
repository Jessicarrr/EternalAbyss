extends Resource
class_name SettingsManager

# Dynamic settings where technically any script can add a setting to the game. Just call the Game autoload script.
# Game.settings.graphics.add_bool_setting etc

var graphics = GraphicsCategory.new()
var audio = AudioCategory.new()
var accessibility = AccessibilityCategory.new()
#var audio = SettingsCategory.new("Audio")
#var _accessibility_instance = SettingsCategory.new("Accessibility")

# Called when the node enters the scene tree for the first time.
func _init():
	var thing = graphics.get_all_settings()
	print("The instance: " + JSON.stringify(thing))

func get_all_settings_categories():
	var categories = []
	var property_list = get_property_list()

	for property in property_list:
		var prop_name = property.name
		var prop_value = self.get(prop_name)

		if prop_value is SettingsCategory:
			settings.append(prop_value)

	return categories


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
