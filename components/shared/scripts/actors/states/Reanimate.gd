extends "res://components/shared/scripts/actors/BaseState.gd"
class_name ReanimateState

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
	
	await get_tree().create_timer(npc.reanimation_time).timeout
	request_state_change.emit(self, Enums.ActorStates.IDLE)
	
func end():
	super.end()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
