extends SettingsCategory
class_name CameraCategory

var head_bob : BoolSetting = BoolSetting.new(
	"Head bob",
	"Moves the camera up and down when you walk or run.",
	true)

var head_bob_intensity : NumberRangeSetting = NumberRangeSetting.new(
		"Head bob intensity",
		"Determines how much the camera moves when walking and running.",
		0, 100, 25, "%"
)



func _init():
	self.category_name = "Camera"
	super()
