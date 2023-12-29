extends CollisionShape3D
class_name RemoveOnDeathCollisionShape3D

signal disable_toggled

func _on_state_changed_to_dead():
	#var parent = get_parent()
	#self.shape.radius = 0.001
	self.set_deferred("disabled", true)
	#parent.set_collision_mask_value(6, false)
	#parent.set_collision_mask_value(4, false)


func _on_state_changed(state, _data):
	if state == Enums.ActorStates.DEAD or state == Enums.ActorStates.DORMANT:
		disable_toggled.emit(true)
		self.set_deferred("disabled", true)
	else:
		disable_toggled.emit(false)
		self.set_deferred("disabled", false)
	pass # Replace with function body.
