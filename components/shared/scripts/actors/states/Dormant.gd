extends "res://components/shared/scripts/actors/BaseState.gd"
class_name DormantState

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
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in Dormant state"])
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc Dormant state ended."])
	


func _on_npc_block_hitbox_on_hit():
	pass # Replace with function body.
