extends Node

var sprite
var tween

var initial_position
var initial_skew
var initial_rotation
var initial_scale

var cancel_time = 0.1

@export var SpritePath : NodePath = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if not SpritePath:
		push_error(self, " has no SpritePath metadata set. Please give the node metadata called SpritePath of type node path.")
		Debug.msg(Debug.ANIMATION, [self, " has no SpritePath metadata set. Please give the node metadata called SpritePath of type node path."])
		return
		
	sprite = get_node(SpritePath)

	initial_position = sprite.position
	initial_skew = sprite.skew
	initial_rotation = sprite.rotation
	initial_scale = sprite.scale

func get_default_anim_data():
	var default_anim_data = {
		"start_position" : sprite.position,
		"end_position" : sprite.position,
		"start_rotation" : sprite.rotation,
		"end_rotation" : sprite.rotation,
		"start_scale" : sprite.scale,
		"end_scale" : sprite.scale,
		"start_skew" : sprite.skew,
		"end_skew" : sprite.skew,
		"tween_type" : Tween.EASE_IN_OUT,
		"is_parallel" : true,
		"time_s" : 0.5
	}
	return default_anim_data

func create_anim_data(custom_anim_data = {}):
	var anim_data = get_default_anim_data() # Make a copy of the default data
	anim_data.merge(custom_anim_data, true)  # Merge it with the custom data passed to the function
	
	# Debugging: Create a list of strings representing each key-value pair
	var debug_messages = []
	debug_messages.append("2D Sprite Animation: ")
	for key in anim_data.keys():
		var value = anim_data[key]
		debug_messages.append(str(key) + ": " + str(value) + " -- ")
	
	# Call your debug message function with the list of key-value pairs
	Debug.msg(Debug.ANIMATION, debug_messages)
	
	return anim_data
	
func play_animation(anim_data = {}):
	if anim_data.is_empty():
		return
	
	var time = anim_data["time_s"]
	
	sprite.position = anim_data["start_position"]
	sprite.rotation = anim_data["start_rotation"]
	sprite.skew = anim_data["start_skew"]
	sprite.scale = anim_data["start_scale"]
	
	create_new_tween(anim_data["is_parallel"], anim_data["tween_type"])
	
	tween.tween_property(sprite, "position", anim_data["end_position"], time)
	tween.tween_property(sprite, "skew", anim_data["end_skew"], time)
	tween.tween_property(sprite, "rotation", anim_data["end_rotation"], time)
	tween.tween_property(sprite, "scale", anim_data["end_scale"], time)
	tween.play()
	
func create_new_tween(parallel, tween_type):
	if tween != null:
		if tween.is_running():
			tween.stop()
			
	tween = get_tree().create_tween()
	tween.set_parallel(parallel)
	tween.set_ease(tween_type)

func cancel():
	if tween != null:
		if tween.is_running():
			tween.stop()
	
	var new_animation = create_anim_data({
		"end_position" : initial_position,
		"end_skew" : initial_skew,
		"end_rotation" : initial_rotation,
		"end_scale" : initial_scale,
		"time_s" : cancel_time
	})
	
	play_animation(new_animation)
