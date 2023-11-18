extends "res://components/shared/scripts/actors/BaseState.gd"
class_name NpcFinishBlocking

@export var npc_path : NodePath = ""
var npc = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#super._ready()
	if not npc_path:
		push_error(self,  " requires an npc path set in its attributes")
		return
	
	npc = get_node(npc_path)

func begin(_data = {}):
	super.begin(_data)
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in FinishBlock state"])
	await get_tree().create_timer(npc.block_transition_time ).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc FinishBlock ending. Going to follow player..."])
	request_state_change.emit(self, Enums.ActorStates.FOLLOW_PLAYER, _data)
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc FinishBlock state ended."])
	
