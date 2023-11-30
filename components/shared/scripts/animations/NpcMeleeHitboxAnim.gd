extends "res://components/shared/scripts/items/weapons/attack_animations/BaseHitboxAnimation.gd"
class_name NpcMeleeHitboxAnim

var forward_distance = 1
var animation_time = 0.3

var rotation = Vector3(0, 0, 0)

var max_distance = 2

func move_hitbox_toward_target(target):
	#get_parent().global_position = start_position
	hitbox_area3d.enable()
	var start_position = hitbox_area3d.global_position
	
	var target_position = PlayerDataExtra.player_instance.global_position # Get the global position of the target
	var direction = (target_position - start_position).normalized()  # Calculate the normalized direction vector
	var distance_to_target = start_position.distance_to(target_position)  # Calculate the distance to the target
	
	var move_distance = min(distance_to_target, max_distance)  # Calculate the actual movement distance
	var final_position = start_position + direction * move_distance  # Calculate the final position
	
	Debug.msg(Debug.ANIMATION, ["Npc starting hitbox anim"])
	var anim_data = create_anim_data({
		"start_global_position" : start_position,
		"end_global_position" : final_position,

		"start_scale" : hitbox_area3d.initial_scale,
		"end_scale" : hitbox_area3d.initial_scale,

		"start_rotation" : rotation,
		"end_rotation" : rotation,
		"time_s" : animation_time
	})
	
	Debug.msg(Debug.ANIMATION, ["Triggered"])
	#toggle_hitbox(true)
	play_animation(anim_data)
	await get_tree().create_timer(animation_time).timeout
	hitbox_area3d.disable()

func _on_state_change(state, data):
	if state == Enums.ActorStates.ATK_SWING:
		var target = data["Entity"]
		move_hitbox_toward_target(target)

func _ready():
	super._ready()
	
