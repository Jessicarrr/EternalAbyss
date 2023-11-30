extends Node
class_name Item

@export var sprite_path : NodePath = ""

var sprite

@export_category("Item Fluff")
@export var item_name = "[Un-named Item]"
@export var item_fluff_text = ""

@export_category("Item Effects")
@export var item_effect_node_paths = []

@export_category("Item Data")
@export var use_item_anim_path : NodePath
@export var use_item_time = 1.0
@export var usage_type = Enums.ItemUsages.NONE
@export var destroy_on_use = false

var usage_anim_node : Node = null
var currently_using_item = false

var equipped = false

signal use_item_started # now in the middle of using the item
signal use_item_ending # beginning to stop using the item
signal use_item_ended # finished using the item 
signal item_destroyed

func _ready():
	if use_item_anim_path:
		usage_anim_node = get_node(use_item_anim_path)
		
	if sprite == null:
		sprite = Helpers.try_load_node(self, sprite_path)
	
func equip():
	equipped = true
	
func unequip():
	equipped = false
	
func is_equipped():
	if sprite == null:
		sprite = Helpers.try_load_node(self, sprite_path)
	
	return sprite.visible

func apply_item_effect():
	pass
	
func stop_item_effect():
	pass

func can_use_item():
	if not use_item_anim_path or usage_anim_node == null:
		return false
		
	return true

func use_item():
	if can_use_item() == false:
		return
		
	if currently_using_item == true:
		return
		
	currently_using_item = true
	await usage_anim_node.starting_anim(self.use_item_time)
	use_item_started.emit(self)
	apply_item_effect()
	
	if destroy_on_use:  # Check if the item should be destroyed after use
		_destroy_item()
		
func stop_using_item():
	if can_use_item() == false:
		return
		
	if currently_using_item == false:
		return
	
	use_item_ending.emit(self)
	
	#await usage_anim_node.ending_anim(self.use_item_time) # can introduce a bug?
	usage_anim_node.ending_anim(self.use_item_time)
	await get_tree().create_timer(self.use_item_time).timeout
	use_item_ended.emit(self)
	
	stop_item_effect()
	currently_using_item = false
	
	if destroy_on_use:  # Check if the item should be destroyed after use
		_destroy_item()
		
func _destroy_item():
	# Add the logic to destroy the item here
	item_destroyed.emit(self)
	queue_free()  # This is a common way to remove a node in Godot
