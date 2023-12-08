extends "res://components/shared/scripts/containers/BaseInventory.gd"

@export var equipment_helper : Node
@export var camera : Camera3D

var active_hotbar_slot = null

signal hotbar_item_changed

func _ready():
	super._ready()  # This calls the _ready function of the base class
	change_active_hotbar_slot(0)
	
func change_active_hotbar_slot(slot_number):
	for slot in slots_node.get_children():
		if slot.name == str(slot_number):
			let_go_of_item()
			active_hotbar_slot = slot
			hold_item()
			print("Set active hotbar slot to ", slot_number)
			
			hotbar_item_changed.emit(get_selected_hotbar_item())
			
			return true
			
	print("Tried to set invalid hotbar slot: ", slot_number)
	return false
	
func get_selected_hotbar_item():
	if active_hotbar_slot == null:
		return null
	
	if active_hotbar_slot.get_child_count() <= 0:
		return null
		
	var item = active_hotbar_slot.get_child(0)
	return item
	
func hold_item():
	var item = get_selected_hotbar_item()
	
	if item == null:
		return
		
	item.equip()
	
func let_go_of_item():
	var item = get_selected_hotbar_item()
	
	if item == null:
		return
		
	item.unequip()
	
func refresh_held_item():
	let_go_of_item()
	hold_item()
	
func update_from_ui(data):
	var slots = get_slots()
	
	# Ensure data length matches slots count
	if data.size() != slots.size():
		print("Data size and slots count mismatch.")
		return

	for i in range(slots.size()):
		var ui_item = data[i]
		var slot = slots[i]

		# Clear the current slot
		if slot.get_child_count() > 0:
			var current_item = slot.get_child(0)
			
			if slot == active_hotbar_slot:
				let_go_of_item()
			
			slot.remove_child(current_item)  # Removing the item without deleting it

		# Assign new item from UI data to slot
		if ui_item != null:
			slot.add_child(ui_item)
			
			if slot == active_hotbar_slot:
				hold_item()
				
	hotbar_item_changed.emit(get_selected_hotbar_item())
	
#func remove_first_person_item():
#	if active_hotbar_slot == null:
#		print("Couldnt deactivate hotbar slot coz slot is null")
#		return
#
#	if active_hotbar_slot.get_child_count() <= 0:
#		return
#
#	var item = active_hotbar_slot.get_child(0)
#
#	if item == null:
#		print("Couldnt deactivate hotbar slot coz item is null")
#		return
#
#	item.sprite.visible = false
#
#	var type = equipment_helper.get_equipment_type(item)
#
#	if type == Enums.EquipmentType.MAIN_HAND:
#		print("turning off item anim")
#		item.deactivate_animation(camera)
#
#	pass
#
#func activate_first_person_item():
#	if active_hotbar_slot == null:
#		print("Couldnt activate hotbar slot coz slot is null")
#		return
#
#	if active_hotbar_slot.get_child_count() <= 0:
#		return
#
#	var item = active_hotbar_slot.get_child(0)
#
#	if item == null:
#		print("Couldnt activate hotbar slot coz item is null")
#		return
#
#	item.sprite.visible = true
#
#	var type = equipment_helper.get_equipment_type(item)
#
#	if type == Enums.EquipmentType.MAIN_HAND:
#		print("activating animation with camera ", camera)
#		item.activate_animation(camera)
	
func add_item(item):
	var result = super.add_item(item)
	
	if result != Enums.ContainerStates.ITEM_ADDED:
		return	
		
	if item.get_parent() == active_hotbar_slot:
		print("Item is inside the active hot bar slot")
		refresh_held_item()
		hotbar_item_changed.emit(item)
	else:
		print("item wasnt in the active htotbar slot")
