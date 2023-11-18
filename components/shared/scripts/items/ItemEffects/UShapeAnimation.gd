extends "res://components/shared/scripts/items/ItemEffects/BaseItemEffect.gd"
class_name WeaponWalkingAnimation

var time_passed : float = 0.0

var original_offset : Vector2 = Vector2()
var amplitude : float = 2
var frequency_multiplier : float = 3.75

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Assuming that the base frequency multiplier is designed for walking speed.
var walk_velocity : float = 1.45
var run_velocity : float = 2.45

var phase : float = 0.0

var previous_position : Vector3 

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	original_offset = sprite.offset
	
	if can_animate() == false:
		previous_position = Vector3(0, 0, 0)
		return
		
	previous_position = camera.global_transform.origin

# In the _process function:
func _process(delta):
	if can_animate() == false:
		return
	
	var delta_position = camera.global_transform.origin - previous_position
	var horizontal_velocity = Vector3(delta_position.x, 0, delta_position.z)  # Set Y component to 0
	var current_velocity = horizontal_velocity.length() / delta
	previous_position = camera.global_transform.origin
	#print("trying to do u shape animation w velocity ", current_velocity)
	# Scale the frequency by the velocity.
	var scaled_frequency = frequency_multiplier * (current_velocity / walk_velocity)

	# Increment the phase by the scaled frequency.
	phase += scaled_frequency * delta

	if current_velocity > 0:
		sprite.offset.x = original_offset.x - amplitude * sin(phase)
		#sprite.offset.y = -(original_offset.y + amplitude * abs(sin(phase)))
	else:
		if sprite.offset.distance_to(original_offset) > 0.01:
			sprite.offset = sprite.offset.lerp(original_offset, 0.1)
