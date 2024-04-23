extends RandomStreamPlayer3D
class_name NpcDamageStreamPlayer3D

func _on_hit(entity, weapon, damage):
	play_random()
