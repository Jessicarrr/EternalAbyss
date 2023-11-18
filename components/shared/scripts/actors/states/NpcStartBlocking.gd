extends "res://components/shared/scripts/actors/BaseState.gd"
class_name NpcStartBlocking

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
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in StartBlock state"])
	await get_tree().create_timer(npc.block_transition_time ).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc StartBlock ending. Going to blocking..."])
	request_state_change.emit(self, Enums.ActorStates.BLOCKING, _data)
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc StartBlock state ended."])
	
