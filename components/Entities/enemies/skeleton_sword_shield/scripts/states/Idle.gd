extends "res://components/shared/scripts/actors/BaseState.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.NPC_STATES, ["Npc is in idle state"])
	
func end():
	Debug.msg(Debug.NPC_STATES, ["Npc idle state ended."])
	super.end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
