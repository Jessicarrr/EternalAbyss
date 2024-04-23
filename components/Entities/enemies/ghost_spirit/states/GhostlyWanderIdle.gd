extends "res://components/shared/scripts/actors/BaseState.gd"
class_name GhostlyIdleState

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.NPC_STATES, ["Ghost is in idle state"])
	
func end():
	Debug.msg(Debug.NPC_STATES, ["Ghost idle state ended."])
	super.end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

