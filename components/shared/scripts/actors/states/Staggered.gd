extends "res://components/shared/scripts/actors/BaseState.gd"
class_name StaggeredState

var base_stagger_time_s = 0.2
var extra_time_per_damage = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	
	var total_stagger_time = _data["StaggerTime"]
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in staggered state, staggered for ", total_stagger_time, " seconds"])
	await get_tree().create_timer(total_stagger_time).timeout
	
	Debug.msg(Debug.NPC_STATES, ["Npc stagger timer ended. Going to idle..."])
	request_state_change.emit(self, Enums.ActorStates.IDLE, {})
	
func end():
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc staggered state ended."])
	
