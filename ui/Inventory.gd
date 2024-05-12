extends Control

@onready var row_2 = $VBoxContainer/TopRow
@onready var row_1 = $VBoxContainer/MiddleRow
@onready var row_3 = $VBoxContainer/BottomRow
@onready var vbox = $VBoxContainer
@onready var hotbar_ui = $Hotbar
@onready var equipment_box = $EquipmentVBox
@onready var drop_item_rect_1 = $DropItemRect

@export var gear_path : NodePath = ""
var gear

@export var slots_per_row = 8

@onready var sample_color_rect = $SampleColorRect

signal request_inv_and_hb_update

var active_hotbar_slot = null

var currently_dragged_item = {
	"item" : null,
	"sprite2d" : null,
	"from_slot" : null
}

signal swapped_slot_items

func _process(_delta):
	if currently_dragged_item.sprite2d == null:
		return
		
	var mouse_position = get_viewport().get_mouse_position()
		
	currently_dragged_item.sprite2d.position = mouse_position

# Called when the node enters the scene tree for the first time.
func _ready():
	gear = Helpers.try_load_node(self, gear_path)
	
	if gear.is_node_ready() == false:
		await gear.ready

	var inventory_slots = gear.get_inventory_slots()
	match_inventory_slot_count(inventory_slots)
	put_items_in_inventory_slots()
	
	var hotbar_slots = gear.get_hotbar_slots()
	match_hotbar_slot_count(hotbar_slots)
	put_items_in_hotbar_slots()
	
	add_listeners_to_ui()

	gear.inventory_updated.connect(_on_inventory_update)
	gear.hotbar_updated.connect(_on_hotbar_update)
	connect_drop_item_rects()
	
	var active_ui_slot = await get_active_ui_slot()
	highlight_active_slot(active_ui_slot)
	active_hotbar_slot = active_ui_slot
	
	gear.hotbar.active_slot_changed.connect(_on_active_hotbar_slot_changed)

func get_active_ui_slot(index = -1):
	if gear.hotbar.is_node_ready() == false:
		await gear.hotbar.ready
		
	var slot_number = -1
		
	if index == -1:
		slot_number = gear.hotbar.active_hotbar_slot_number
	else:
		slot_number = index
		
	var slot_ui = get_hotbar_slot_by_index(slot_number)
	return slot_ui

func highlight_active_slot(slot_ui):
	slot_ui.color = slot_ui.on_color
	
func remove_highlight_from_frontend_slot(slot):
	if active_hotbar_slot == null:
		return
		
	active_hotbar_slot.color = active_hotbar_slot.off_color

func update_slot_highlight(new_slot_number):
	var newly_active_ui_slot = await get_active_ui_slot(new_slot_number)
	
	if newly_active_ui_slot == null:
		push_warning("Could not find a ui hotbar slot for the corresponding index", new_slot_number)
		return
		
	highlight_active_slot(newly_active_ui_slot)
	remove_highlight_from_frontend_slot(active_hotbar_slot)
	
	active_hotbar_slot = newly_active_ui_slot
	

func _on_active_hotbar_slot_changed(slot_number):
	update_slot_highlight(slot_number)

func connect_drop_item_rects():
	drop_item_rect_1.mouse_clicked.connect(_drop_item_rect_clicked)
	return
	
func _drop_item_rect_clicked(_node):
	if currently_dragged_item.item == null:
		return
		
	currently_dragged_item.item.drop()
	currently_dragged_item.sprite2d.queue_free()
	currently_dragged_item.sprite2d = null
	currently_dragged_item.item = null
	

func add_listeners_to_hotbar_ui():
	for slot in hotbar_ui.get_children():
		add_listener_to_rect(slot)
	
func add_listener_to_rect(rect):
	if rect.is_connected("mouse_clicked", _on_mouse_click_ui_slot):
		return
	
	rect.mouse_clicked.connect(_on_mouse_click_ui_slot)
	
	return
	
func _on_mouse_click_ui_slot(the_slot):
	# Check if the slot has an item reference.
	if not "item_ref" in the_slot:
		print("Huh?")
		return
		
	var newly_clicked_item = the_slot.item_ref
	
	# Print the current item in the slot before swapping.
	print("Before: ", str(newly_clicked_item))
	
	var dragged_item = currently_dragged_item.item
	
	if newly_clicked_item == null and dragged_item == null:
		return
		
	if newly_clicked_item != null and dragged_item == null:
		currently_dragged_item.item = newly_clicked_item
		
		var sprite = currently_dragged_item.item.get_node_or_null("InventoryIcon")
		if sprite != null:
			var duped_sprite = sprite.duplicate()
			currently_dragged_item.sprite2d = duped_sprite
			currently_dragged_item.sprite2d.visible = true
			add_child(duped_sprite)
		the_slot.remove_item()
		
	elif newly_clicked_item == null and dragged_item != null:
		if the_slot.can_put_item(dragged_item) == true:
			the_slot.put_item(dragged_item)
			currently_dragged_item.sprite2d.queue_free()
			currently_dragged_item.item = null
		
	elif newly_clicked_item != null and dragged_item != null:
		if the_slot.can_put_item(dragged_item) == true:
			the_slot.remove_item()
			the_slot.put_item(dragged_item)
			currently_dragged_item.sprite2d.queue_free()
			currently_dragged_item.sprite2d = null
			currently_dragged_item.item = newly_clicked_item
			var sprite = currently_dragged_item.item.get_node_or_null("InventoryIcon")
			if sprite != null:
				var duped_sprite = sprite.duplicate()
				add_child(duped_sprite)
				var path = duped_sprite.get_path()
				currently_dragged_item.sprite2d = duped_sprite
				currently_dragged_item.sprite2d.visible = true
		
	print("Before update: ", str(the_slot.item_ref))
	
	var inv_data = pack_inventory_data_to_array()
	var hb_data = pack_hotbar_data_to_array()
		
	request_inv_and_hb_update.emit(inv_data, hb_data)

	# Print the current item in the slot after swapping.
	print("After: ", str(the_slot.item_ref))
	
func _on_mouse_click_ui_slot2(the_slot):
	# Check if the slot has an item reference.
	if not "item_ref" in the_slot:
		print("Huh?")
		return
	
	# Print the current item in the slot before swapping.
	print("Before: ", str(the_slot.item_ref))
	
	# Swap the items between the slot and the currently dragged item.
	var slotted_item = the_slot.remove_item()
	var dragged_item = currently_dragged_item.item
	_remove_dragged_item_sprite()
	
	the_slot.put_item(dragged_item)
	_update_dragged_item_state(the_slot)
	
	var inv_data = pack_inventory_data_to_array()
	var hb_data = pack_hotbar_data_to_array()
		
	request_inv_and_hb_update.emit(inv_data, hb_data)

	# Print the current item in the slot after swapping.
	print("After: ", str(the_slot.item_ref))

func pack_inventory_data_to_array():
	var data = []
	
	for rect in row_1.get_children():
		data.append(rect.item_ref)
		
	for rect in row_2.get_children():
		data.append(rect.item_ref)
		
	for rect in row_3.get_children():
		data.append(rect.item_ref)
		
	return data
	
func pack_hotbar_data_to_array():
	var data = []
	
	for rect in hotbar_ui.get_children():
		data.append(rect.item_ref)
		
	return data

# Handle the sprite of the currently dragged item.
func _remove_dragged_item_sprite():
	if currently_dragged_item.sprite2d != null:
		currently_dragged_item.sprite2d.queue_free()
		currently_dragged_item.sprite2d = null

# Update the state of the currently dragged item.
func _update_dragged_item_state(the_slot):
	if currently_dragged_item.item == null:
		currently_dragged_item.from_slot = null
	else:
		currently_dragged_item.from_slot = the_slot
		_duplicate_dragged_item_sprite()

# Duplicate the sprite of the dragged item, if available.
func _duplicate_dragged_item_sprite():
	var sprite = currently_dragged_item.item.get_node_or_null("InventoryIcon")
	if sprite != null:
		var duplicated_sprite = sprite.duplicate()
		currently_dragged_item.sprite2d = duplicated_sprite
		add_child(duplicated_sprite)
	
func add_listeners_to_ui():
	for rect in row_1.get_children():
		add_listener_to_rect(rect)
		
	for rect in row_2.get_children():
		add_listener_to_rect(rect)
		
	for rect in row_3.get_children():
		add_listener_to_rect(rect)
		
	for rect in hotbar_ui.get_children():
		add_listener_to_rect(rect)
	return
	
func match_inventory_slot_count(inventory_slots):
	var inventory_slot_count = inventory_slots.size()
	
	if inventory_slot_count == get_num_inventory_slots():
		return
	
	if get_num_inventory_slots() < inventory_slot_count:
		var difference = inventory_slot_count - get_num_inventory_slots()
		
		for i in range(0, difference):
			var new_slot = add_inventory_slot()
			new_slot.slot_ref = inventory_slots[i]
			
func match_hotbar_slot_count(hotbar_slots):
	var slot_count = hotbar_slots.size()
	
	if slot_count == get_num_hotbar_slots():
		return
		
	if get_num_hotbar_slots() < slot_count:
		var difference = slot_count - get_num_hotbar_slots()
		
		for i in range(0, difference):
			var new_slot = add_hotbar_slot()
			new_slot.slot_ref = hotbar_slots[i]
	
func get_num_inventory_slots():
	return row_1.get_child_count() + row_2.get_child_count() + row_3.get_child_count()
	
func get_num_hotbar_slots():
	return hotbar_ui.get_child_count()

func get_inventory_slot_by_index(index):
	if index < slots_per_row:
		return row_1.get_child(index)
	if index < slots_per_row * 2:
		var node_index = index - slots_per_row
		return row_2.get_child(node_index)
	if index < slots_per_row * 3:
		var node_index = index - (slots_per_row * 2)
		return row_3.get_child(node_index)
		
	return null
	
func get_hotbar_slot_by_index(index):
	return hotbar_ui.get_child(index)

func put_items_in_hotbar_slots():
	var slots = gear.get_hotbar_slots()
	
	for i in range(0, slots.size()):
		var ui_slot = get_hotbar_slot_by_index(i)
		var hotbar_slot = slots[i]
		
		if hotbar_slot.get_child_count() <= 0:
			ui_slot.put_item(null)
			continue
		
		var item = hotbar_slot.get_child(0)
			
		ui_slot.put_item(item)

func put_items_in_inventory_slots():
	var inventory_slots = gear.get_inventory_slots()
	
	for i in range(0, inventory_slots.size()):
		var ui_slot = get_inventory_slot_by_index(i)
		var inventory_slot = inventory_slots[i]
		
		if inventory_slot.get_child_count() <= 0:
			ui_slot.put_item(null)
			continue
		
		var item = inventory_slot.get_child(0)
			
		ui_slot.put_item(item)
		
func add_hotbar_slot():
	var new_color_rect = sample_color_rect.duplicate()
	hotbar_ui.add_child(new_color_rect)
	new_color_rect.visible = true
	
	return new_color_rect
		
func add_inventory_slot():
	var next_row = get_next_available_row()
	
	if next_row == null:
		return null
		
	var new_color_rect = sample_color_rect.duplicate()
	next_row.add_child(new_color_rect)
	new_color_rect.visible = true
	
	return new_color_rect

func get_next_available_row():
	if row_1.get_child_count() < slots_per_row:
		return row_1
		
	if row_2.get_child_count() < slots_per_row:
		return row_2
		
	if row_3.get_child_count() < slots_per_row:
		return row_3
	
	return null

func _on_inventory_update(slots):
	match_inventory_slot_count(slots)
	put_items_in_inventory_slots()
	add_listeners_to_ui()
	return
	
func _on_hotbar_update(slots):
	match_hotbar_slot_count(slots)
	put_items_in_hotbar_slots()
	add_listeners_to_ui()
	return

func _input(_event):
	# Check for the "attack" action
	if Input.is_action_just_pressed("open_player_menu"):
		if vbox.visible == false:
			equipment_box.visible = true
			vbox.visible = true
			drop_item_rect_1.visible = true
			Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
			return
			
		vbox.visible = false
		equipment_box.visible = false
		drop_item_rect_1.visible = false
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
