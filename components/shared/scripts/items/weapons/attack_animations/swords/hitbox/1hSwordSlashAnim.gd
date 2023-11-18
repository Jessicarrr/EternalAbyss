extends "res://components/shared/scripts/items/weapons/attack_animations/BaseHitboxAnimation.gd"
class_name HitboxSwordSlashAnim

var horizontal_distance = 0.35
var horizontal_distance_end_offset = -0.1
var animation_time_mult = 0.5

func right_to_left_swing(time_s):
	var total_time = time_s
	
	var right_position = get_position_relative_to_center(Vector3.RIGHT, horizontal_distance)
	var left_position = get_position_relative_to_center(Vector3.LEFT, horizontal_distance + horizontal_distance_end_offset)
	
	var anim_data = create_anim_data({
		"start_position" : right_position,
		"end_position" : left_position,
		
		"start_scale" : obj.scale,
		"end_scale" : obj.scale,
		
		"start_rotation" : camera.global_rotation,
		"end_rotation" : camera.global_rotation,
		"time_s" : total_time
		
	})
	
	#toggle_hitbox(true)
	hitbox_area3d.enable()
	play_animation(anim_data)
	await get_tree().create_timer(total_time).timeout
	hitbox_area3d.disable()
	#toggle_hitbox(false)
	
func left_to_right_swing(time_s):
	var total_time = time_s
	
	var left_position = get_position_relative_to_center(Vector3.LEFT, horizontal_distance)
	var right_position = get_position_relative_to_center(Vector3.RIGHT, horizontal_distance + horizontal_distance_end_offset)
	
	#Debug.msg(Debug.ANIMATION, ["Hitbox Left rotation: ", obj_left_rotation, ", right rotation: ", obj_right_rotation])
	
	var anim_data = create_anim_data({
		"start_position" : left_position,
		"end_position" : right_position,
		
		"start_scale" : obj.scale,
		"end_scale" : obj.scale,
		
		"start_global_rotation" : camera.global_rotation,
		"end_global_rotation" : camera.global_rotation,
		"time_s" : total_time
	})
	
	#toggle_hitbox(true)
	hitbox_area3d.enable()
	play_animation(anim_data)
	await get_tree().create_timer(total_time).timeout
	hitbox_area3d.disable()
	#toggle_hitbox(false)

func _on_swing(_anim_node, anim_data = {}):
	super._on_swing(anim_data)
	
	var time = anim_data["time_s"] * animation_time_mult
	
	var direction = get_horizontal_direction(anim_data)
	
	if direction == Vector2.LEFT:
		right_to_left_swing(time)
	else:
		left_to_right_swing(time)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
