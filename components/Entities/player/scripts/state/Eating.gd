extends "res://components/shared/scripts/actors/BaseState.gd"

var item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in eating state"])
	
	item = _data["item"]
	item.use_item()
	await get_tree().create_timer(item.use_item_time).timeout
	
	if active == false:
		return
	
	request_state_change.emit(self, Enums.ActorStates.IDLE, {})
	
func end():
	item.stop_using_item()
	item = null
	
	Debug.msg(Debug.PLAYER_STATES, ["Player eating state ended."])
	super.end()
