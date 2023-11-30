extends "res://components/shared/scripts/actors/BaseState.gd"
class_name NpcAttackSwing

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
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in AttackSwing state"])
	await get_tree().create_timer(npc.swing_time).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc AttackSwing ending. Going to recovery..."])
	request_state_change.emit(self, Enums.ActorStates.ATK_RECOVERY, _data)
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc AttackSwing state ended."])
	
