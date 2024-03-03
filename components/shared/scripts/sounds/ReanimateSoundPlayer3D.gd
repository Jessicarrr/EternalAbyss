extends RandomStreamPlayer3D
class_name ReanimateSoundPlayer3D

func _on_state_changed(state, data):
	if state == Enums.ActorStates.REANIMATING:
		play_random()
