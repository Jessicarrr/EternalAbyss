extends "res://components/shared/scripts/items/weapons/attack_animations/BaseWeaponAnimation.gd"
class_name SwordSlash1

# Constants (if these values won't change, use `const` instead of `var`)
const WINDUP_ROTATION = deg_to_rad(21.5)
const SWING_ROTATION = deg_to_rad(11)
const SWING_SKEW = deg_to_rad(73)

var recoil_skew = deg_to_rad(58)
var recoil_rotation = deg_to_rad(8)
var recoil_scale = Vector2(1.5, 2)
var recoil_position = Vector2(300, -55)
var recoil_time = 0.25

# Swing positions
var top_right_position = Vector2(200, -15)
var bottom_left_position = Vector2(-300, 10)

# Scaling factors
var original_scale = Vector2(1, 1)
var windup_scale = Vector2(0.75, 0.75)
var swing_scale = Vector2(2, 3)

# Timing for each phase
@export var windup_time = 0.3
@export var swing_time = 0.1
@export var recovery_time = 0.6

func windup():
	super.windup()
	
	Debug.msg(Debug.ANIMATION, ["Winding up..."])
	
	var new_anim_data = create_anim_data({
		"start_position" : initial_position,
		"start_skew" : initial_skew,
		"start_rotation" : initial_rotation,
		"start_scale" : initial_scale,
		
		"end_scale" : windup_scale,
		"end_rotation" : SWING_ROTATION,
		"end_position" : top_right_position,
		
		"time_s" : windup_time,
		"tween_type" : Tween.EASE_IN
	})
	
	windup_started.emit(self, new_anim_data)
	play_animation(new_anim_data)
	
func swing():
	super.swing()
	
	Debug.msg(Debug.ANIMATION, ["Done. Swinging... w sprite ", sprite])
	
	var new_anim_data = create_anim_data({
		"start_skew" : SWING_SKEW,
		"start_position" : top_right_position,
		"start_scale" : swing_scale,
		"start_rotation" : SWING_ROTATION,
		
		"end_position" : bottom_left_position,
		"end_skew" : SWING_SKEW,
		"end_scale" : swing_scale,
		"end_rotation" : SWING_ROTATION,
		
		"time_s" : swing_time,
		"tween_type" : Tween.EASE_IN_OUT
	})
	
	swing_started.emit(self, new_anim_data)
	play_animation(new_anim_data)
	
func recover():
	super.recover()
	
	sprite.position = initial_position + Vector2(-30, 100)
	sprite.scale = original_scale
	sprite.skew = 0
	sprite.rotation = deg_to_rad(0)
	
	Debug.msg(Debug.ANIMATION, ["Returning to initial position."])
	
	await get_tree().create_timer(recovery_time / 2).timeout
	
	var new_anim_data = create_anim_data({
		"start_position" : sprite.position,
		"start_skew" : sprite.skew,
		"start_rotation" : sprite.rotation,
		"start_scale" : sprite.scale,
		
		"end_position" : initial_position,
		"end_skew" : sprite.skew,
		"end_rotation" : sprite.rotation,
		"end_scale" : sprite.scale,
		
		"time_s" : recovery_time / 2
	})
	
	recovery_started.emit(self, new_anim_data)
	play_animation(new_anim_data)
	
func swing_recoil():
	super.swing_recoil()
	
	var new_anim_data = create_anim_data({
		"start_skew" : sprite.skew,
		"start_position" : sprite.position,
		"start_scale" : sprite.scale,
		"start_rotation" : sprite.rotation,
		
		"end_position" : recoil_position,
		"end_skew" : recoil_skew,
		"end_scale" : recoil_scale,
		"end_rotation" : recoil_rotation,
		
		"time_s" : recoil_time,
		"tween_type" : Tween.EASE_IN_OUT
	})
	
	play_animation(new_anim_data)
