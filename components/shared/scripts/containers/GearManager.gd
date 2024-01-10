extends Node

@export var equipment_visuals : CanvasLayer
@onready var items_list = self.get_meta("GameItems").instantiate().get_children()
@onready var inventory = $Inventory
@onready var equipment = $Equipment
@onready var hotbar = $Hotbar
@onready var equipment_slots = $Equipment/Slots
@onready var hotbar_slots = $Hotbar/Slots
@onready var inventory_slots = $Inventory/Slots

var equipped_weapon = null
var active_hotbar_slot = null

signal hotbar_updated
signal inventory_updated
signal equipment_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	
	spawn_item("Corroded Estoc")
		
	spawn_item("Salted Dried Fish")
	spawn_item("Salted Dried Fish")
	spawn_item("Torch")
		
	await get_tree().create_timer(1.0).timeout  # Wait for 1 second
	print("Active hotbar slot children: ", hotbar.active_hotbar_slot.get_children())
	pass # Replace with function body.
	
func print_game_items():
	print("Game items:")
	for item in items_list:
		print("- ", item)

func print_items():
	print("Inventory:")
	inventory.print_slots()
	#print_items_for_container("Equipment", equipment_slots)
	print("Hotbar:")
	hotbar.print_slots()

func find_item_by_name(item_name: String) -> Node:
	for item in items_list:
		if item.item_name.to_lower() == item_name.to_lower():
			return item
	return null

func get_next_free_slot() -> Dictionary:
	var result = {"slot": null, "container": null}

	if inventory.is_full() and hotbar.is_full():
		return result

	var slot = hotbar.get_next_free_slot()
	if slot:
		result.slot = slot
		result.container = hotbar
		return result

	slot = inventory.get_next_free_slot()
	if slot:
		result.slot = slot
		result.container = inventory
		
	return result

func has_free_slot():
	var slot = get_next_free_slot()
	
	if slot.slot == null or slot.container == null:
		return false
		
	return true

func _on_item_destroyed():
	
	inventory_updated.emit(get_inventory_slots())
	hotbar_updated.emit(get_hotbar_slots())

func add_item_to_inventory(item):
	var slot_info = get_next_free_slot()
	var slot = slot_info.slot
	var container = slot_info.container
	
	if slot == null:
		return false
	
	container.add_item(item)
	
	if container == hotbar:
		var slots = get_hotbar_slots()
		hotbar_updated.emit(slots)
		
	if container == inventory:
		inventory_updated.emit(get_inventory_slots())
		
	item.tree_exited.connect(_on_item_destroyed)
		
	return true

func get_hotbar_slots():
	return hotbar.get_slots()
	
func get_inventory_slots():
	return inventory.get_slots()

func spawn_item(item_name: String) -> Node:
	var item = find_item_by_name(item_name)
	
	if not item:
		print("Could not find the item called '%s'." % item_name)
		return null

	if has_free_slot() == false:
		return null
		
	var duplicate_item = item.duplicate()
	add_item_to_inventory(duplicate_item)
	
	return duplicate_item
	
# Check if a given item is a type of equipment
# e.g. weapon, armor, potion, etc
func is_equipment(item_instance) -> bool:
	if "equipment_type" in item_instance:
		return true
	return false
		
func get_equipment_type(item_instance):
	if !is_equipment(item_instance):
		return null
		
	return item_instance.equipment_type
func equip_item(item_instance):
	if item_instance == null:
		push_error("Tried to equip a null item?")
		return
	
	print("Trying to equip ", item_instance.name)
	
	if !is_equipment(item_instance):
		push_error("Tried to equip an item that is not equipment. (", item_instance.name, ")")
		return
		
	var type = get_equipment_type(item_instance)
	
	if type == null:
		push_error("Item type was null for some reason? ", item_instance.name)

	for slot in equipment_slots.get_children():
		# Ensure the slot has a slot_type variable or metadata
		if "slot_type" in slot:
			if slot.slot_type == Enums.EquipmentType.OFF_HAND:
				var parent = item_instance.get_parent()
				parent.remove_child(item_instance)
				slot.add_child(item_instance)
				print("Equipped ", item_instance.name)
				return
		else:
			print("Could not find slot type in slot")

	print("Couldn't find the correct slot :( couldn't equip.")

func swap_slots(from_slot, to_slot):
	var should_move_from_slot = from_slot.get_child_count() > 0
	var should_move_to_slot = to_slot.get_child_count() > 0

	var from_item = from_slot.get_child(0) if should_move_from_slot else null
	var to_item = to_slot.get_child(0) if should_move_to_slot else null

	var hotbar_changed = false

	# Handle item removal from the active hotbar slot
	if should_move_from_slot and from_slot == hotbar.active_hotbar_slot:
		hotbar.let_go_of_item()
		hotbar_changed = true

	# Swap items between slots
	if from_item:
		from_item.reparent(to_slot)
	if to_item:
		to_item.reparent(from_slot)

	# Handle new item in the active hotbar slot
	if to_slot == hotbar.active_hotbar_slot and from_item:
		hotbar.hold_item()
		hotbar_changed = true
	elif from_slot == hotbar.active_hotbar_slot and to_item:
		hotbar.hold_item()
		hotbar_changed = true

	# Emit signal if the hotbar changed
	if hotbar_changed:
		hotbar.hotbar_item_changed.emit(hotbar.get_selected_hotbar_item())


func _on_inventory_swapped_slot_items(from_slot, to_slot):
	#swap_slots(from_slot, to_slot)
	inventory_updated.emit(get_inventory_slots())
	hotbar_updated.emit(get_hotbar_slots())

func _on_request_inv_and_hb_update(inv_items, hb_items):
	inventory.update_from_ui(inv_items)
	hotbar.update_from_ui(hb_items)
	inventory_updated.emit(get_inventory_slots())
	hotbar_updated.emit(get_hotbar_slots())
	pass # Replace with function body.
