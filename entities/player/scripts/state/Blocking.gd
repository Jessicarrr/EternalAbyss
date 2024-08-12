extends "res://entities/shared/scripts/BaseState.gd"

var weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in blocking state w data: ", self.data])
	weapon = _data["Weapon"]
	
	#windup_timer = get_tree().create_timer(atk_data.windup_time + 0.05)
	#windup_timer.connect("timeout", on_timer_timeout)
	
func end():
	super.end()
	weapon = null
	Debug.msg(Debug.PLAYER_STATES, ["Player blocking state ended."])

func _on_use_item_input_use_item_released():
	Debug.msg(Debug.PLAYER_STATES, ["Blocking state requesting to go to block ending state"])
	request_state_change.emit(self, Enums.ActorStates.BLOCK_END,\
	{
		"Weapon" : weapon,
	})
