extends Node

var tween
var obj

func get_default_anim_data():
	var default_anim_data = {
		"start_position" : obj.position,
		"end_position" : obj.position,
		"start_rotation" : obj.rotation,
		"end_rotation" : obj.rotation,
		"start_global_rotation" : obj.global_rotation,
		"end_global_rotation" : obj.global_rotation,
		"start_scale" : obj.scale,
		"end_scale" : obj.scale,
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

func create_new_tween(parallel, tween_type):
	if tween != null:
		if tween.is_running():
			tween.stop()
			
	tween = get_tree().create_tween()
	tween.set_parallel(parallel)
	tween.set_ease(tween_type)

func play_animation(anim_data = {}):
	if anim_data.is_empty():
		return
	
	var time = anim_data["time_s"]
	
	var use_global_rotation
	if anim_data["start_rotation"] != anim_data["end_rotation"]:
		use_global_rotation = false
	else:
		use_global_rotation = true
	
	
	obj.position = anim_data["start_position"]
	
	if use_global_rotation == false:
		obj.rotation = anim_data["start_rotation"]
	else:
		obj.global_rotation = anim_data["start_global_rotation"]
		
	obj.scale = anim_data["start_scale"]
	
	create_new_tween(anim_data["is_parallel"], anim_data["tween_type"])
	
	tween.tween_property(obj, "position", anim_data["end_position"], time)
	
	if use_global_rotation == false:
		tween.tween_property(obj, "rotation", anim_data["end_rotation"], time)
	else:
		tween.tween_property(obj, "rotation", anim_data["end_global_rotation"], time)
	
	
	
	tween.tween_property(obj, "scale", anim_data["end_scale"], time)
	tween.play()
