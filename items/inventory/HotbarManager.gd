extends "res://items/inventory/BaseInventory.gd"

@export var equipment_helper : Node
@export var camera : Camera3D

var active_hotbar_slot = null
var active_hotbar_slot_number = 0

@export var use_action_queue = true
var queued_slot_data = {
	"slot_number" : -1,
	"wrap_around" : false
}
var current_state = null

@export var state_machine_node_path : NodePath
var state_machine

signal hotbar_item_changed
signal active_slot_changed

var state_blacklist_for_changing_hotbar_slots = [
	Enums.ActorStates.DEAD,
	Enums.ActorStates.ATK_SWING,
	Enums.ActorStates.ATK_WINDUP,
	Enums.ActorStates.ATK_RECOVERY,
	Enums.ActorStates.ATK_CANCEL,
	Enums.ActorStates.ATK_RECOIL,
	Enums.ActorStates.BLOCK_START,
	Enums.ActorStates.BLOCKING,
	Enums.ActorStates.BLOCK_STAGGER,
	Enums.ActorStates.EATING,
	Enums.ActorStates.DRINKING
]

func _ready():
	super._ready()  # This calls the _ready function of the base class
	change_active_hotbar_slot(0)
	state_machine = Helpers.try_load_node(self, state_machine_node_path)
	state_machine.state_changed.connect(_on_state_changed)
	
func _on_state_changed(state, data):
	if state == Enums.ActorStates.DEAD:
		queued_slot_data.slot_number = -1
		queued_slot_data.wrap_around = false
		
	current_state = state
	
func _process(_delta):
	if use_action_queue == false:
		return
		
	if queued_slot_data.slot_number == -1:
		return
	
	if current_state in state_blacklist_for_changing_hotbar_slots:
		return
		
	handle_slot_change_input(queued_slot_data.slot_number, queued_slot_data.wrap_around)
	
func change_active_hotbar_slot(slot_number):
	var slot = get_slot(slot_number)
	
	if slot == null:
		return false
		
	let_go_of_item()
	active_hotbar_slot = slot
	active_hotbar_slot_number = slot_number
	hold_item()
	print("Set active hotbar slot to ", slot_number)
	
	hotbar_item_changed.emit(get_selected_hotbar_item())
	active_slot_changed.emit(slot_number)
	
	return true
	
func handle_slot_change_input(intended_slot : int, wrap_around : bool):
	if current_state in state_blacklist_for_changing_hotbar_slots:
		if use_action_queue == false:
			return
			
		queued_slot_data.slot_number = intended_slot
		queued_slot_data.wrap_around = wrap_around
		return
	
	if slot_exists(intended_slot) == false:
		if wrap_around == false:
			return
			
		var going_forward = false
		
		if intended_slot > active_hotbar_slot_number:
			going_forward = true
			
		if going_forward == true:
			intended_slot = get_first_slot().get_meta(metadata_name_slot_number)
		else :
			intended_slot = get_last_slot().get_meta(metadata_name_slot_number)
			
	change_active_hotbar_slot(intended_slot)
	queued_slot_data.slot_number = -1
	queued_slot_data.wrap_around = false
	
func _input(event):
	if Input.is_action_just_released("hotbar_go_right"):
		var intended_hotbar_slot = active_hotbar_slot_number + 1

		handle_slot_change_input(intended_hotbar_slot, true)
		return
		
	if Input.is_action_just_released("hotbar_go_left"):
		var intended_hotbar_slot = active_hotbar_slot_number - 1
		
		handle_slot_change_input(intended_hotbar_slot, true)
		return
		
	for i in range(1, 10):
		var input_name = "hotbar_slot_" + str(i)
		
		if Input.is_action_just_pressed(input_name):
			var corresponding_hotbar_slot = i - 1
			handle_slot_change_input(corresponding_hotbar_slot, false)
	
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
