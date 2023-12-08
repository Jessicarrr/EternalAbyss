extends Control

@onready var hbox = $HBoxContainer
@export var gear_path : NodePath = ""
var gear
@onready var color_box_sample = $SampleColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	gear = Helpers.try_load_node(self, gear_path)
	
	if gear.is_node_ready() == false:
		await gear.ready
		
	if color_box_sample == null:
		return
		
	var hotbar_slots = gear.get_hotbar_slots()
	convert_hotbar_slots_to_ui(hotbar_slots)
	
	gear.hotbar_updated.connect(_on_hotbar_updated)

func _on_hotbar_updated(slots):
	clear_ui_slots()
	convert_hotbar_slots_to_ui(slots)

func clear_ui_slots():
	for thing in hbox.get_children():
		thing.queue_free()

func convert_hotbar_slots_to_ui(hotbar_slots):
	for slot in hotbar_slots:
		var new_box = color_box_sample.duplicate()
		hbox.add_child(new_box)
		new_box.visible = true
		Debug.msg(Debug.INVENTORY_UI, ["Hotbar slot is ", slot.get_name(), " w child count ", slot.get_children().size()])
		
		if slot.get_child_count() > 0:
			var first_child = slot.get_child(0)
			var icon = first_child.get_node_or_null("InventoryIcon")
			
			if icon == null:
				continue
			
			var new_icon = icon.duplicate()
			new_box.add_child(new_icon)
			
			# Calculate the scale factor needed to fit the icon within the new_box
			var texture_size = new_icon.texture.get_size()
			var scale_factor_x = new_box.size.x / texture_size.x
			var scale_factor_y = new_box.size.y / texture_size.y
			var scale_factor = min(scale_factor_x, scale_factor_y) # To maintain aspect ratio
			new_icon.scale = Vector2(scale_factor, scale_factor)

			# Center the icon in the new_box
			#new_icon.position = new_box.position + new_box.size / 2
			new_icon.position += new_box.size / 2
			
			new_icon.visible = true
			
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
