extends "res://components/shared/scripts/actors/BaseState.gd"
class_name NpcAttackWindup

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
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in AttackWindup state"])
	await get_tree().create_timer(npc.windup_time).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc AttackWindup ending. Going to swinging..."])
	request_state_change.emit(self, Enums.ActorStates.ATK_SWING, _data)
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc AttackWindup state ended."])
	
