extends HeldItemSprite3D
class_name StabSwordSprite3D

var windup_rotation = Vector3(deg_to_rad(-19.6), deg_to_rad(-85.0), deg_to_rad(86.9))
var windup_position = Vector3(0.25, -0.11, -0.2) # right, down, forward offsets

var swing_position = Vector3(0.05, 0, 0.2) # right, down, forward offsets

signal on_windup_start
signal on_swing_start
signal on_recovery_start

func windup():
	var anim_data = create_anim_data({
		"start_position" : default_position_offset,
		"end_position" : windup_position,
		"start_rotation" : default_rotation,
		"end_rotation" : windup_rotation,
		"time_s" : get_parent().windup_time
	})
	play_animation(anim_data)
	on_windup_start.emit()
	
func swing():
	var anim_data = create_anim_data({
		"start_position" : windup_position,
		"end_position" : swing_position,
		"time_s" : get_parent().swing_time,
		"tween_type" : Tween.EASE_OUT,
	})
	play_animation(anim_data)
	on_swing_start.emit()
	
func recovery():
	var anim_data = create_anim_data({
		"start_position" : self.position_offset,
		"end_position" : self.default_position_offset,
		"start_rotation" : self.current_rotation,
		"end_rotation" : self.default_rotation,
		"time_s" : get_parent().recovery_time
	})
	play_animation(anim_data)
	on_recovery_start.emit()
