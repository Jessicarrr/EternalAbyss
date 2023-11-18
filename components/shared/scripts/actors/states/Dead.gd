extends "res://components/shared/scripts/actors/BaseState.gd"
class_name DeadState

func begin(_data = {}):
	Debug.msg(Debug.GENERAL_STATES, ["Entered the dead state"])
	super.begin(_data)
	
func end():
	super.end()
