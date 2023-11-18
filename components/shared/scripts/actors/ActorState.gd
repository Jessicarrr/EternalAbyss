extends Node

var _state = Enums.ActorStates.IDLE
		
var valid_transitions = {
	Enums.ActorStates.IDLE: [
		Enums.ActorStates.ATK_WINDUP,
		Enums.ActorStates.STAGGERED
		
	],
	Enums.ActorStates.ATK_WINDUP: [
		Enums.ActorStates.ATK_SWING, #swing after windup
		Enums.ActorStates.IDLE, # attack cancelled
		Enums.ActorStates.STAGGERED # staggered by enemy
	],
	Enums.ActorStates.ATK_SWING: [
		Enums.ActorStates.ATK_RECOVERY, # didnt attack, recover
		Enums.ActorStates.ATK_WINDUP # attack for a combo swing
	],
	Enums.ActorStates.ATK_RECOVERY: [ # recovery after swinging
		Enums.ActorStates.IDLE, # goes to idle if all went well
		Enums.ActorStates.STAGGERED # can get staggered while recovering
	],
	Enums.ActorStates.STAGGERED: [
		Enums.ActorStates.IDLE # staggered can only go to idle
	]
	# ... any other states and their valid transitions
}
		
func set_state(proposed_state: Enums.ActorStates):
	if can_transition_to_state(proposed_state) == false:
		Debug.msg(Debug.STATES, ["Cannot change state from ", Helpers.state_name(_state), " to ", Helpers.state_name(proposed_state)])
		return false
		
	Debug.msg(Debug.STATES, ["Changed state from ", Helpers.state_name(_state), " to ", Helpers.state_name(proposed_state)])
	_state = proposed_state
	
	return true
	
func can_transition_to_state(proposed) -> bool:
	# Check if the current state exists in the dictionary
	if _state in valid_transitions:
		# Check if the proposed state is a valid transition from the current state
		return proposed in valid_transitions[_state]
	return false
	
func get_state():
	return _state
