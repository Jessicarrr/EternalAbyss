extends ColorRect
class_name InventorySlot

var item_ref
var slot_ref

signal mouse_clicked

@export var equipment_type = Enums.EquipmentType.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_process_input(true)  # Ensure that input events are processed

func can_put_item(item):
	if equipment_type == Enums.EquipmentType.NONE:
		return true
	
	if not "equipment_type" in item:
		return false
		
	if equipment_type != item.equipment_type:
		return false
		
	return true

func remove_item():
	var the_item = item_ref
	
	item_ref = null
	
	if get_child_count() >= 1:
		var relevant_children = []
		var relevant_child = null
		
		for child in get_children():
			if child is Sprite2D:
				relevant_children.append(child)
				
		for child in relevant_children:
			child.queue_free()
	
	return the_item

func manipulate_icon_size(icon):
	var texture_size = icon.texture.get_size()
	var scale_factor_x = self.size.x / texture_size.x
	var scale_factor_y = self.size.y / texture_size.y
	var scale_factor = min(scale_factor_x, scale_factor_y) # To maintain aspect ratio
	icon.scale = Vector2(scale_factor, scale_factor)

func put_item(item):
	if item_ref == item:
		return false
		
	if item == null and (item_ref != null or get_child_count() > 1):
		remove_item()
		return
		
	self.tooltip_text = ""
	
	var icon = item.get_node_or_null("InventoryIcon")
	
	if icon == null:
		push_error("Tried to put item into ui inv slot ", self, " but the item has no InventoryIcon node")
		return false
		
	# Calculate the scale factor needed to fit the icon within the new_box
	#manipulate_icon_size(icon)
	
	var new_icon = icon.duplicate()
	self.add_child(new_icon)

	# Center the icon in the new_box
	new_icon.position += self.size / 2
	
	new_icon.visible = true
	
	var tooltip_text = Helpers.generate_item_text(item)

	self.tooltip_text = tooltip_text
	self.item_ref = item
	
	return

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mouse_clicked.emit(self)
