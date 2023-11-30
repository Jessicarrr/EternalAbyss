extends "res://components/shared/scripts/animations/Base2dAnimation.gd"
class_name SwordBlockHit

var scale_mult = 1.5
var anim_start_time = 0.05
var anim_end_time = 0.2
var total_anim_time = anim_start_time + anim_end_time

var should_stop_animation_early = false

var start_scale = Vector3(1, 1, 1)

signal anim_started
signal anim_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	

func block_hit_animation():
	anim_started.emit(total_anim_time)
	start_scale = sprite.scale
	var max_scale = Vector2(sprite.scale.x * scale_mult, sprite.scale.y * scale_mult)
	
	var anim_data = create_anim_data({
		"start_scale" : start_scale,
		"end_scale" : max_scale,
		"time_s" : anim_start_time
	})
	
	play_animation(anim_data)
	
#	if should_stop_animation_early == true:
#		sprite.scale = start_scale
#		should_stop_animation_early = false
#		anim_ended.emit()
#		return
	
	anim_data = create_anim_data({
		"start_scale" : max_scale,
		"end_scale" : start_scale,
		"time_s" : anim_end_time
	})
	
	play_animation(anim_data)
	await tween.finished
	should_stop_animation_early = false
	anim_ended.emit(total_anim_time)

#func _on_use_item_started(_item):
#	pass # Replace with function body.

#func _on_use_item_ending(_item):
#	should_stop_animation_early = true
#	if tween != null:
#		if tween.is_running():
#			tween.stop()
#			sprite.scale = start_scale
#			anim_ended.emit()

func _on_player_block_hitbox_area_entered(area):
	block_hit_animation()
