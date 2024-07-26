extends Node
class_name AdjustScale

@onready var control = get_parent()

# Base resolution and scale values.
var BASE_RESOLUTION: Vector2 = Vector2(1280, 720)
var BASE_SCALE: Vector2 = Vector2(6, 6)

# Adjust the scale based on the current resolution.
func adjust_scale():
	if control == null:
		push_warning("Could not scale equipped item because control data is not set (is null)")
		return
	
	var screen_size = DisplayServer.window_get_size()
	
	print("scaling for size ", screen_size)
	
	var x_scale_factor = screen_size.x / BASE_RESOLUTION.x
	var y_scale_factor = screen_size.y / BASE_RESOLUTION.y

	# Compute new scale values.
	var new_scale_x = BASE_SCALE.x * x_scale_factor
	var new_scale_y = BASE_SCALE.y * y_scale_factor

	# Apply the computed scale to the sprite.
	control.scale.x = new_scale_x
	control.scale.y = new_scale_y

# When node is ready, adjust the scale initially and connect to size_changed signal.
func _ready():
	adjust_scale()
	get_tree().get_root().size_changed.connect(adjust_scale)
