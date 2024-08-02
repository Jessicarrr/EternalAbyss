extends "res://entities/shared/scripts/BaseState.gd"

#@onready var weapon_handler = $WeaponHandler

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in cancel state w data: ", data])
	var atk_data = _data["Attack"]
	atk_data.cancel()
	await get_tree().create_timer(atk_data.cancel_time + 0.05).timeout
	
	go_to_idle_state()
	
func end():
	super.end()
	Debug.msg(Debug.PLAYER_STATES, ["Player cancel state ended."])
	
#func go_to_idle_state():
#	Debug.msg(Debug.PLAYER_STATES, ["Player windup state requesting to go to idle state."])
#	request_state_change.emit(Enums.ActorStates.IDLE)
	
func go_to_idle_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player cancel state requesting to go to idle state."])
	request_state_change.emit(self, Enums.ActorStates.IDLE)
