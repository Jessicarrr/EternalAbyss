extends Node

@onready var slots_node = $Slots
const metadata_name_slot_number = "SlotNumber"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	populate_slots()

func populate_slots():
	for i in range(0, slots_node.get_meta("NumSlots")):
		var new_node = Node.new()
		new_node.name = str(i)
		new_node.set_meta(metadata_name_slot_number, i)
		slots_node.add_child(new_node)

func get_next_free_slot():
	print("Finding available slot...")

	# Combine both slot lists for a single loop
	for slot in slots_node.get_children():
		# Check if the slot is empty
		if slot.get_child_count() == 0:
			print("Found available slot in ", slot.get_parent().name, " named ", slot.name)
			return slot
			
	print("No slots available")
	return null
	
func is_full():
	for slot in slots_node.get_children():
		# Check if the slot is empty
		if slot.get_child_count() == 0:
			print("Found available slot in ", slot.get_parent().name, " named ", slot.name)
			return false
	return true
	
func add_item(item):
	var slot = get_next_free_slot()
	
	if slot == null:
		if is_full() == true:
			return Enums.ContainerStates.FULL
		else:
			return Enums.ContainerStates.FAILED
	
	if item.get_parent() != null:
		item.get_parent().remove_child(item)
		
	slot.add_child(item)
	
	#print("Item added to the inventory. is it in the tree? hmm... ", item.is_inside_tree())
	
	#print("Ok, let's check its children just to be sure...")
	
	#Helpers.print_all_children_check_in_tree(item)
	
	return Enums.ContainerStates.ITEM_ADDED
	
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
			slot.remove_child(current_item)  # Removing the item without deleting it

		# Assign new item from UI data to slot
		if ui_item != null:
			slot.add_child(ui_item)

func get_num_slots():
	return slots_node.get_children().size()
	
func get_first_slot():
	return slots_node.get_child(0)
	
func get_last_slot():
	var num_slots = get_num_slots()
	var final_index = num_slots - 1
	return slots_node.get_child(final_index)
	
func get_slot(slot_number):
	for slot in slots_node.get_children():
		if slot.get_meta(metadata_name_slot_number) == slot_number:
			return slot
			
	return null
	
func slot_exists(slot_number):
	if get_slot(slot_number) != null:
		return true
		
	return false

func get_slots():
	var slots = []
	for slot in slots_node.get_children():
		slots.append(slot)
		
	return slots

func print_slots():
	for slot in slots_node.get_children():
		print("- Slot: ", slot.name)
		for item in slot.get_children():
			print("- - ", item.name)
