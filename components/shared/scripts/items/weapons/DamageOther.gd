extends Node

@onready var parent = get_parent()

func _on_sprite_3d_on_swing_start():
	var damage_min = parent.damage_min
	var damage_max = parent.damage_max
	
	var swing_time = parent.swing_time
	
	await get_tree().create_timer(swing_time).timeout
	
	var entity_seen = PlayerDataExtra.player_instance.get_thing_im_looking_at()
	
	Debug.msg(Debug.COLLISIONS, ["Player damaging thing, looking at ", entity_seen.get_name(), entity_seen.get_parent().get_name()])
	
	if entity_seen.has_method("hit") == false:
		return
		
	if entity_seen.global_position.distance_to(PlayerDataExtra.player_instance.global_position) > parent.range:
		return
		
	var damage = randi_range(damage_min, damage_max)
	
	entity_seen.hit(PlayerDataExtra.player_instance, parent, damage)
