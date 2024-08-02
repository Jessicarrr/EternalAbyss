extends Node

@onready var npc = get_parent()

func try_damage_player():
	var player = PlayerDataExtra.player_instance
	
	if player == null:
		push_error(self.get_path(), " - why was the player null?")
		
	var npc_pos = npc.global_position
	var player_pos = player.global_position
	
	if npc_pos.distance_to(player_pos) > npc.attack_range:
		return
	
	if player.has_method("hit") == false:
		return
		
	var damage = randi_range(npc.damage_min, npc.damage_max)
	
	player.hit(npc, damage)
	return

func _on_state_changed(state, data):
	if state != Enums.ActorStates.ATK_SWING:
		return
	
	try_damage_player()
	
