extends "res://components/shared/scripts/actors/BaseState.gd"

var entity = null


signal move_npc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	entity = data["Entity"]
	Debug.msg(Debug.NPC_STATES, ["Npc is in follow state"])
	
func end():
	Debug.msg(Debug.NPC_STATES, ["Npc follow state ended."])
	entity = null
	super.end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	
