extends Node

@onready var parent = get_parent()

func _on_enemy_ray_cast_3d_gained_player_visibility():
	if parent.active == false:
		return
		
	Debug.msg(Debug.NPC_STATES, ["Player has been detected via the raycast"])
	parent.request_state_change.emit(parent, Enums.ActorStates.FOLLOW_PLAYER, {})
