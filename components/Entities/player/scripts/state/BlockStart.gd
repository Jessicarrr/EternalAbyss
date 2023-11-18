extends "res://components/shared/scripts/actors/BaseState.gd"

var weapon

var let_go_of_block = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in block start state w data: ", self.data])
	weapon = _data["Weapon"]
	weapon.use_item()
	await weapon.use_item_started
	
	if let_go_of_block == true:
		return
	
	Debug.msg(Debug.PLAYER_STATES, ["Block start state requesting to go to blocking state"])
	request_state_change.emit(self, Enums.ActorStates.BLOCKING,\
	{
		"Weapon" : weapon,
	})
	
	#windup_timer = get_tree().create_timer(atk_data.windup_time + 0.05)
	#windup_timer.connect("timeout", on_timer_timeout)
	
func end():
	super.end()
	weapon = null
	let_go_of_block = false
	Debug.msg(Debug.PLAYER_STATES, ["Player block start state ended."])


func _on_use_item_input_use_item_released():
	let_go_of_block = true
	
	Debug.msg(Debug.PLAYER_STATES, ["Block start state requesting to go to block ending state"])
	request_state_change.emit(self, Enums.ActorStates.BLOCK_END,\
	{
		"Weapon" : weapon,
	})
