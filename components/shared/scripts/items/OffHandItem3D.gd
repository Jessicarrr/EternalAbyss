extends Item
class_name OffHandItem

signal equipped_in_offhand_slot
signal unequipped_in_offhand_slot

# Called when the node enters the scene tree for the first time.
func _ready():
	equipment_type = Enums.EquipmentType.OFF_HAND
	pass # Replace with function body.
