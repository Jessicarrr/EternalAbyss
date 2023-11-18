extends "res://components/shared/scripts/actors/BaseState.gd"
class_name NpcBlockStagger

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func begin(_data = {}):
	super.begin(_data)
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in BlockStagger state"])
	await get_tree().create_timer(_data["StaggerTime"]).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc BlockStagger ending. Going to follow player..."])
	request_state_change.emit(self, Enums.ActorStates.BLOCKING, _data)
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc BlockStagger state ended."])
	


func _on_npc_block_hitbox_on_hit():
	pass # Replace with function body.
