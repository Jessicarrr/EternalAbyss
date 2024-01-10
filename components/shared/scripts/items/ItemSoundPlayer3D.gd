extends AudioStreamPlayer3D
class_name ItemSoundPlayer3D

@export var item_path : NodePath = ""
var item

# Called when the node enters the scene tree for the first time.
func _ready():
	item = Helpers.try_load_node(self, item_path)
	
	if "equipped_in_offhand_slot" in item:
		item.equipped_in_offhand_slot.connect(_on_item_equipped)
		
	if "unequipped" in item:
		item.on_unequipped.connect(_on_item_unequipped)
		
	if "equipped" in item:
		item.on_equipped.connect(_on_item_equipped)
		
	if "unequipped_in_offhand_slot" in item:
		item.unequipped_in_offhand_slot.connect(_on_item_unequipped)

func _on_item_equipped():
	self.play()
	return
	
func _on_item_unequipped():
	self.stop()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
