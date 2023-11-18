# This script is in charge of taking the 2d weapon animation and translating
# its movement to 3d, in order to make hitboxes work in the 3d world
# automatically with any 2d weapon sprite.

extends "res://components/shared/scripts/animations/BaseHitboxAnimation.gd"

# Called when the node enters the scene tree.
func _ready():

	# Connects the body_entered signal to the _on_body_entered function for collision detection.
	hitbox_area3d.body_entered.connect(_on_body_entered)







	
func _on_swing(anim_data = {}):
	if anim_data.is_empty():
		return

	Debug.msg(Debug.ANIMATION, ["Playing 3d swing animation"])

	var start_position_2d = anim_data["start_position"]
	var end_position_2d = anim_data["end_position"]

	# Converts the start and end positions from 2D to 3D coordinates.
	var start_position_3d = _2d_to_3d(anim_data["start_position"])
	var end_position_3d = _2d_to_3d(anim_data["end_position"])

	Debug.msg(Debug.ANIMATION, ["Camera rotation: ", camera.global_rotation])

	# Calculate the rotational offset based on the screen center.
	var screen_size = DisplayServer.screen_get_size()
	var screen_center = Vector2(screen_size.x / 2, screen_size.y / 2)

	var start_position_relative_to_center = anim_data["start_position"] + screen_center
	var end_position_relative_to_center = anim_data["end_position"] + screen_center

	Debug.msg(Debug.ANIMATION, ["3d start position in general: ", start_position_3d])
	Debug.msg(Debug.ANIMATION, ["3d end position in general: ", end_position_3d])
	Debug.msg(Debug.ANIMATION, ["2d Start position relative to center: ", start_position_relative_to_center])
	Debug.msg(Debug.ANIMATION, ["2d end position relative to center: ", end_position_relative_to_center])
 
	var sideways_direction
	var vertical_direction
	
	if anim_data["start_position"].x > anim_data["end_position"].x:
		sideways_direction = Vector3.LEFT
	else:
		sideways_direction = Vector3.RIGHT
		
	if anim_data["start_position"].y > anim_data["end_position"].y:
		vertical_direction = Vector3.DOWN
	else:
		vertical_direction = Vector3.UP
	
	

	# Use these angles to create new rotations.
	#var start_rotation = camera.global_rotation.rotated(Vector3.FORWARD, start_offset_angle)
	#var end_rotation = camera.global_rotation.rotated(Vector3.FORWARD, end_offset_angle)
	
	var anim_time = anim_data["time_s"] + 1

	# Prepares the 3D animation data using the converted positions and other parameters.
	var anim_data_3d = create_anim_data({
		"start_position" : start_position_3d,
		"end_position" : end_position_3d,
		"start_rotation" : camera.global_rotation,
		"end_rotation" : camera.global_rotation,
		"start_scale" : obj.scale,
		"end_scale" : obj.scale,
		#"time_s" : anim_data["time_s"]
		"time_s" : anim_time
	})

	# Activates the hitbox and plays the 3D animation.
	toggle_hitbox(true)
	play_animation(anim_data_3d)
	# Waits for the animation to complete before deactivating the hitbox.
	await get_tree().create_timer(anim_time).timeout
	toggle_hitbox(false)
	
# Placeholder function for handling area entered event.
func _on_area_entered(area):
	Debug.msg(Debug.COLLISIONS, ["Collided with ", area, " belonging to ", area.get_parent()])
	
# Handles collision with a body, potentially for damage calculation or effects.
func _on_body_entered(body):
	Debug.msg(Debug.COLLISIONS, ["Collided with ", body, " belonging to ", body.get_parent()])
	

	
# Converts a 2D position on the screen to a corresponding 3D world position.
#func _2d_to_3d(position_2d):
#	var extra_depth = 0.05  # Small depth value to ensure the 3D point is slightly offset.
#	var depth = (collision_shape.scale.x / 2) + extra_depth
#	var screen_size = DisplayServer.screen_get_size()
#	var screen_center = Vector2(screen_size.x / 2, screen_size.y / 2)
#	var vertical_offset = 75
#	# Adjusts the 2D position to account for screen center and vertical offset.
#	var corrected_position = Vector2(screen_center.x + position_2d.x, screen_center.y + position_2d.y - vertical_offset)
#
#
#	# Projects the corrected 2D position into a 3D world position using the camera.
#	var world_point = camera.project_position(corrected_position, depth)
#
#	var distance_to_camera = world_point.distance_to(camera.global_position)
#
#
#	var world_point_corrected = world_point.move_toward(Vector3.BACK, distance_to_camera)
#	world_point_corrected = world_point.move_toward(Vector3.FORWARD, depth*2)
#	Debug.msg(Debug.ANIMATION, ["weird corrected world point position in general: ", world_point_corrected])
#	#Debug.msg(Debug.ANIMATION, ["Camera position for 3d anim: ", camera.global_transform.origin])
#	return world_point_corrected
