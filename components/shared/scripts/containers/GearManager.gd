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

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	print_game_items()
	print_items()
	spawn_item("3d Sword")
	print_items()
	print_game_items()
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


func spawn_item(item_name: String) -> Node:
	var item = find_item_by_name(item_name)
	
	if not item:
		print("Could not find the item called '%s'." % item_name)
		return null

	var slot_info = get_next_free_slot()
	var slot = slot_info.slot
	var container = slot_info.container
	
	if slot == null:
		return null

	print("Spawn the item called ", item_name)
	
	var duplicate_item = item.duplicate()
	container.add_item(duplicate_item)
	
	#if slot == active_hotbar_slot:
	#	show_item_in_first_person(duplicate_item)
	
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
