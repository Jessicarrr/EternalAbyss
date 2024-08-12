extends CollisionShape3D
class_name RemoveOnDeathCollisionShape3D

@onready var parent = get_parent()

signal disable_toggled

func _on_state_changed_to_dead():
	#var parent = get_parent()
	#self.shape.radius = 0.001
	#self.set_deferred("disabled", true)
	#parent.set_collision_mask_value(6, false)
	#parent.set_collision_mask_value(4, false)
	pass


func _on_state_changed(state, _data):
	match state:
		Enums.ActorStates.DEAD,\
		Enums.ActorStates.DORMANT,\
		Enums.ActorStates.REANIMATING:
			self.set_deferred("disabled", true)
		_:
			self.set_deferred("disabled", false)
