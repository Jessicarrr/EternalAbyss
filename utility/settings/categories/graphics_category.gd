extends SettingsCategory
class_name GraphicsCategory

var film_grain : BoolSetting = BoolSetting.new("Film Grain", "Adds a TV static like effect to the screen, which will show all the time.", false)
var film_grain_intensity : NumberRangeSetting\
		= NumberRangeSetting.new("Film Grain Intensity",\
		 "Determines how strong film grain is for the constant effect. Film grain setting must be on.",\
		  0, 100, 50, "%")

var film_grain_gameplay : BoolSetting\
		= BoolSetting.new("Film Grain - Gameplay",\
		 "Adds a TV static like effect to the screen, which will only show during relevant gameplay events.", true)
var film_grain_gameplay_intensity : NumberRangeSetting\
		= NumberRangeSetting.new("Film Grain - Gameplay Intensity",\
		 "Determines how strong film grain is for the gameplay only effect. Film grain gameplay setting must be on.",\
		  0, 100, 100, "%")

func _init():
	self.category_name = "Graphics"
	super()