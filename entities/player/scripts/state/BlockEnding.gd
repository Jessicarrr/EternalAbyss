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
	Debug.msg(Debug.PLAYER_STATES, ["Player is in block ending w data: ", self.data])
	weapon = _data["Weapon"]
	
	if weapon.can_use_item() == false:
		push_error(self, "Can't leave block ending state because vars in ", self, " are not set")
		return
	
	weapon.use_item_ended.connect(_on_use_item_ended)
	weapon.stop_using_item()
	
	#Debug.msg(Debug.PLAYER_STATES, ["Block ending state requesting to go to idle state."])
	#request_state_change.emit(self, Enums.ActorStates.IDLE)

func _on_use_item_ended(_thing):
	Debug.msg(Debug.PLAYER_STATES, ["Block ending state requesting to go to idle state."])
	weapon.use_item_ended.disconnect(_on_use_item_ended)
	request_state_change.emit(self, Enums.ActorStates.IDLE)
	

func end():
	super.end()
	weapon = null
	Debug.msg(Debug.PLAYER_STATES, ["Player block ending state ended"])
