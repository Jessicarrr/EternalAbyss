extends "res://components/shared/scripts/items/ItemEffects/BaseItemEffect.gd"
class_name FakePhysics

@export_category("Up and down movement")
@export var pitch_offset_multiplier : float = 4
@export var max_pitch_offset : float = 400.0
@export var min_pitch_offset : float = -20.0
@export var weapon_move_down_only : bool = true
@export var deadzone : float = 2.5  # Rotation degrees where no movement should happen.

@export_category("Side to side movement")
@export var yaw_offset_multiplier : float = 1  # Adjust this to change the amount of side drag.
@export var catch_up_speed : float = 0.15 # Adjust this to change how fast the sword catches up to the target position.

var target_x_offset : float = 0.0
var last_yaw_rotation : float = 0.0

func _process(delta):
	if can_animate() == false:
		return
		
	super._process(delta)
		
	handle_camera_look_up_down()
	handle_camera_look_side_to_side(delta)

func calculate_delta_rotation(current_rotation, last_rotation):
	var delta = current_rotation - last_rotation

	# Adjusting for the boundary condition.
	if delta > 180:
		delta -= 360
	elif delta < -180:
		delta += 360

	return delta

func handle_camera_look_side_to_side(_delta):
	var yaw_rotation = camera.global_rotation_degrees.y
	
	# Calculate change in yaw rotation.
	var delta_yaw = calculate_delta_rotation(yaw_rotation, last_yaw_rotation)
	
	#print("Yaw Rotation: ", yaw_rotation, " Delta Yaw: ", delta_yaw)
	
	# Store the current yaw rotation for the next frame.
	last_yaw_rotation = yaw_rotation
	
	# Only adjust the target x offset if there's significant camera movement.
	if abs(delta_yaw) > 0.1:
		target_x_offset += delta_yaw * yaw_offset_multiplier
	else:
		# Gradually reset the target_x_offset back to 0 if there's little to no camera movement.
		target_x_offset = lerp(target_x_offset, 0.0, catch_up_speed)
	
	# Smoothly adjust offset.x towards the target using lerp.
	sprite.offset.x = lerp(sprite.offset.x, target_x_offset, catch_up_speed)

	
func handle_camera_look_up_down():
	var pitch_rotation = camera.rotation_degrees.x

	# If the pitch_rotation is within the deadzone, do not change pitch_offset.
	if abs(pitch_rotation) < deadzone:
		return
	
	# Adjust for the deadzone to avoid sudden jump.
	pitch_rotation -= sign(pitch_rotation) * deadzone

	var pitch_offset = pitch_rotation * pitch_offset_multiplier  # Default behavior.

	if weapon_move_down_only:
		pitch_offset = abs(pitch_offset)  # Force it to move down irrespective of the pitch rotation.
		# Clamp using max_pitch_offset for both up and down movements.
		pitch_offset = min(pitch_offset, max_pitch_offset)
	else:
		# Clamp the offset between the defined min and max values.
		pitch_offset = clamp(pitch_offset, min_pitch_offset, max_pitch_offset)
		
	#print("Pitch rotation: ", pitch_rotation, " Pitch offset: ", pitch_offset)
	sprite.offset.y = pitch_offset
