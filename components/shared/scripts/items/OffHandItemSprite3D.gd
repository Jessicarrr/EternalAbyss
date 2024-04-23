extends HeldItemSprite3D

@export var offhand_position_offset = Vector3(-0.01, -0.01, 0) # right, down, forward offsets

func _on_equip_in_offhand_slot():
	position_offset = offhand_position_offset
	
func _on_unequip_in_offhand_slot():
	position_offset = default_position_offset
