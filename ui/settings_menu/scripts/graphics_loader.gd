extends BaseSettingsLoader


# Called when the node enters the scene tree for the first time.
func _ready():
	var category = Game.settings.graphics

	set_category_instance(category)
	populate()

