extends Node

@onready var slots_node = $Slots
	
# Called when the node enters the scene tree for the first time.
func _ready():
	populate_slots()

func populate_slots():
	for i in range(0, slots_node.get_meta("NumSlots")):
		var new_node = Node.new()
		new_node.name = str(i)
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
	


func print_slots():
	for slot in slots_node.get_children():
		print("- Slot: ", slot.name)
		for item in slot.get_children():
			print("- - ", item.name)
