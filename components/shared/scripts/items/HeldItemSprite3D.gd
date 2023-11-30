extends Sprite3D
class_name HeldItemSprite3D

@onready var item = get_parent()

@export var distance_in_front = 0.18

var default_rotation = Vector3(deg_to_rad(-11.2), deg_to_rad(-113), deg_to_rad(32.2))
var current_rotation = default_rotation

@export var default_position_offset = Vector3(0.2, -0.01, 0) # right, down, forward offsets
var position_offset = default_position_offset

var tween : Tween

func do_animation():
	pass
	
func place_obj_in_front():
	var camera_global_transform = PlayerDataExtra.player_camera.global_transform

	# Calculate forward, right, and up directions
	var forward_dir = camera_global_transform.basis.z.normalized() * -1
	var right_dir = camera_global_transform.basis.x.normalized()
	var up_dir = camera_global_transform.basis.y.normalized()

	# Calculate the new position with position offsets
	# Adjust the position_offset as needed for animations like swing or stab
	var new_pos = camera_global_transform.origin +\
				  forward_dir * (distance_in_front + position_offset.z) +\
				  right_dir * position_offset.x +\
				  up_dir * position_offset.y
				
	self.global_position = new_pos

	# Convert the camera rotation to a Quat
	var camera_rot_quat = Quaternion(camera_global_transform.basis)

	# Create a Basis from the Euler angles
	var holding_rot_basis = Basis.from_euler(current_rotation)

	# Convert the Basis to a Quat
	var holding_rot_quat = Quaternion(holding_rot_basis)

	# Combine the rotations
	var combined_rot = camera_rot_quat * holding_rot_quat

	# Apply the combined rotation to the sword
	self.global_rotation = combined_rot.get_euler()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if item.is_equipped() == false:
		return
		
	place_obj_in_front()
	
func create_new_tween(parallel, tween_type):
	stop_current_animation()
			
	tween = get_tree().create_tween()
	tween.set_parallel(parallel)
	tween.set_ease(tween_type)
	
func get_default_anim_data():
	var default_anim_data = {
		"start_position" : position_offset,
		"end_position" : position_offset,
		"start_rotation" : current_rotation,
		"end_rotation" : current_rotation,
		"tween_type" : Tween.EASE_IN_OUT,
		"is_parallel" : true,
		"time_s" : 0.1
	}
	return default_anim_data

func create_anim_data(custom_anim_data = {}):
	var anim_data = get_default_anim_data() # Make a copy of the default data
	anim_data.merge(custom_anim_data, true)  # Merge it with the custom data passed to the function
	
	# Debugging: Create a list of strings representing each key-value pair
	var debug_messages = []
	debug_messages.append("3D Hitbox Anim: ")
	for key in anim_data.keys():
		var value = anim_data[key]
		debug_messages.append(str(key) + ": " + str(value) + " -- ")
	
	# Call your debug message function with the list of key-value pairs
	Debug.msg(Debug.ANIMATION, debug_messages)
	
	return anim_data

func play_animation(anim_data = {}):
	if anim_data.is_empty():
		return
	
	position_offset = anim_data["start_position"]
	current_rotation = anim_data["start_rotation"]
	
	var time = anim_data["time_s"]
	create_new_tween(anim_data["is_parallel"], anim_data["tween_type"])
	tween.tween_property(self, "position_offset", anim_data["end_position"], time)
	tween.tween_property(self, "current_rotation", anim_data["end_rotation"], time)
	tween.play()

func play_anim_return_to_default():
	stop_current_animation()
	
	var anim_data = create_anim_data({
		"start_position" : position_offset,
		"end_position" : default_position_offset,
		"start_rotation" : current_rotation,
		"end_rotation" : default_rotation
	})
	
	play_animation(anim_data)

func stop_current_animation():
	if tween != null:
		if tween.is_running():
			tween.stop()
