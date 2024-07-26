extends "res://components/shared/scripts/actors/BaseState.gd"

var cancelled = false
var windup_timer = null


func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in windup state w data: ", self.data])
	var weapon = self.data["Weapon"]
	weapon.sprite.windup()
	windup_timer = get_tree().create_timer(weapon.windup_time + 0.05)
	windup_timer.connect("timeout", on_timer_timeout)
	
func end():
	super.end()
	Debug.msg(Debug.PLAYER_STATES, ["Player windup state ended."])
	
	cancelled = false
	
	if windup_timer != null:
		windup_timer.disconnect("timeout", on_timer_timeout)
		
	windup_timer = null
	
func go_to_swing_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player windup state requesting to go to swinging state."])
	request_state_change.emit(self, Enums.ActorStates.ATK_SWING, self.data)

func go_to_cancelled_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player windup state requesting to go to cancelled state."])
	request_state_change.emit(self, Enums.ActorStates.ATK_CANCEL, self.data)

func on_timer_timeout():
	if cancelled == false and active == true:
		go_to_swing_state()
		
func _on_input_attack_cancelled():
	if active == false:
		return
		
	cancelled = true
	go_to_cancelled_state()
	
