extends "res://components/shared/scripts/actors/BaseState.gd"

#@onready var weapon_handler = $WeaponHandler

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in recovery state w data: ", self.data])
	var atk_data = _data["Attack"]
	atk_data.recover()
	await get_tree().create_timer(atk_data.recovery_time + 0.05).timeout
	
	go_to_idle_state()
	
func end():
	super.end()
	Debug.msg(Debug.PLAYER_STATES, ["Player recovery state ended."])
	
#func go_to_idle_state():
#	Debug.msg(Debug.PLAYER_STATES, ["Player windup state requesting to go to idle state."])
#	request_state_change.emit(self, Enums.ActorStates.IDLE)
	
func go_to_idle_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player recoivery state requesting to go to idle state."])
	request_state_change.emit(self, Enums.ActorStates.IDLE)
