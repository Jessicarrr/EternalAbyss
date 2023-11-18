extends "res://components/shared/scripts/actors/BaseState.gd"

#@onready var weapon_handler = $WeaponHandler
var atk_data
var weapon

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in recoil state w data: ", data])
	atk_data = _data["Attack"]
	weapon = _data["Weapon"]
	atk_data.swing_recoil()
	await atk_data.tween.finished
	
	go_to_recovery_state()
	
func end():
	super.end()
	Debug.msg(Debug.PLAYER_STATES, ["Player recoil state ended."])
	
#func go_to_idle_state():
#	Debug.msg(Debug.PLAYER_STATES, ["Player windup state requesting to go to idle state."])
#	request_state_change.emit(Enums.ActorStates.IDLE)
	
func go_to_recovery_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player cancel state requesting to go to idle state."])
	request_state_change.emit(self, Enums.ActorStates.ATK_RECOVERY, {
		"Weapon" : weapon,
		"Attack" : atk_data
	})
