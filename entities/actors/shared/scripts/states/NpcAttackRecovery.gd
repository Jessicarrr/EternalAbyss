extends "res://entities/shared/scripts/BaseState.gd"
class_name NpcAttackRecovery

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
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in AttackRecovery state"])
	await get_tree().create_timer(npc.recovery_time).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc AttackRecovery ending. Going to swinging..."])
	request_state_change.emit(self, Enums.ActorStates.FOLLOW_PLAYER, _data)
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc AttackRecovery state ended."])
	
