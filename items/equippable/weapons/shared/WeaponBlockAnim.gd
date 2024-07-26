extends "res://components/shared/scripts/items/UseItemAnimation.gd"

var block_position = Vector2(-150, -2)
var block_rotation = deg_to_rad(-83.1)
var block_scale = Vector2(1.5, 1.75)

func _ready():
	super._ready()

func starting_anim(time):
	super.starting_anim(time)
	
	var anim = create_anim_data({
		"start_position" : sprite.position,
		"start_rotation" : sprite.rotation,
		"start_scale" : sprite.scale,
		"start_skew" : sprite.skew,
		
		"end_position" : block_position,
		"end_rotation" : block_rotation,
		"end_scale" : block_scale,
		"end_skew" : initial_skew,
		
		"time_s" : time
	})
	
	play_animation(anim)
	await tween.finished
	
func ending_anim(time):
	super.ending_anim(time)
	
	var anim = create_anim_data({
		"start_position" : sprite.position,
		"start_rotation" : sprite.rotation,
		"start_scale" : sprite.scale,
		"start_skew" : sprite.skew,
		
		"end_position" : initial_position,
		"end_rotation" : initial_rotation,
		"end_scale" : initial_scale,
		"end_skew" : initial_skew,
		
		"time_s" : time
	})
	
	play_animation(anim)
	await tween.finished
