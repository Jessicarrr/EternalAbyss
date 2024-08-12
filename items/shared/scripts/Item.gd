extends CharacterBody3D
class_name Item

@export var sprite_path : NodePath = ""

var sprite
@onready var inventory_icon = $InventoryIcon
@onready var ground_sprite = $GroundSprite
@onready var collision_shape = $CollisionShape3D

@export_category("Item Fluff")
@export var item_name = "[Un-named Item]"
@export var item_fluff_text = ""

@export_category("Item Effects")
@export var item_effect_node_path : NodePath = ""

@export_category("Item Data")
@export var use_item_anim_path : NodePath
@export var use_item_time = 1.0
@export var usage_type = Enums.ItemUsages.NONE
@export var destroy_on_use = false
@export var equipment_type = Enums.EquipmentType.NONE

var usage_anim_node : Node = null
var currently_using_item = false
var item_effects = null

var equipped = false

var gravity = -9.8

var knockback_velocity = Vector3.ZERO
var knockback_duration = 0.3 # Duration of the knockback in seconds
var knockback_timer = 0.0
var friction = 0.1

var physics_enabled = false

signal use_item_started # now in the middle of using the item
signal use_item_ending # beginning to stop using the item
signal use_item_ended # finished using the item 
signal item_destroyed
signal item_dropped
signal item_picked_up
signal on_equipped
signal on_unequipped

func should_do_physics():
	if WorldData.layout_node == null:
		return false
	
	if physics_enabled == false:
		return false
		
	if  WorldData.layout_node.is_ancestor_of(self):
		return true
		
	return false

func _physics_process(delta):
	if should_do_physics() == false:
		return
	
	# Apply gravity
	if not is_on_floor() or knockback_timer > 0:
		velocity.y += gravity * delta
		
	if is_on_floor() == true:
		velocity.x = lerp(velocity.x, 0.0, friction)
		velocity.z = lerp(velocity.z, 0.0, friction)
		
	# Move the item
	move_and_slide()

func impulse_towards(direction):
	# Modify the upward force for a more natural arc
	var upward_force = Vector3(0, 1, 0) 
	var knockback_upward_strength = 0.1 # Reduced for a more natural arc

	# Combine the backward and upward directions
	var knockback_direction = direction + upward_force * knockback_upward_strength
	knockback_direction = knockback_direction.normalized()

	# Define the knockback strength
	var knockback_strength = 3.0

	# Apply the knockback as an initial impulse
	knockback_velocity = knockback_direction * knockback_strength

	velocity.x = knockback_velocity.x
	velocity.z = knockback_velocity.z
	velocity.y = knockback_velocity.y

func _ready():
	if use_item_anim_path:
		usage_anim_node = get_node(use_item_anim_path)
		
	if sprite == null:
		sprite = Helpers.try_load_node(self, sprite_path)
		
	if item_effect_node_path:
		item_effects = Helpers.try_load_node(self, item_effect_node_path)
	
func equip():
	equipped = true
	
	if sprite == null:
		sprite = Helpers.try_load_node(self, sprite_path)
	sprite.visible = true
	on_equipped.emit()
	
func unequip():
	equipped = false
	
	if sprite == null:
		sprite = Helpers.try_load_node(self, sprite_path)
	sprite.visible = false
	on_unequipped.emit()
	
func is_equipped():
	if sprite == null:
		sprite = Helpers.try_load_node(self, sprite_path)
	
	return sprite.visible

func apply_item_effect():
	pass
	
func stop_item_effect():
	pass

func item_has_animation():
	if not use_item_anim_path or usage_anim_node == null:
		return false
		
	return true

func is_in_3d_world():
	if collision_shape != null and collision_shape.disabled == false and ground_sprite.visible == true:
		return true
		
	return false

func remove_from_3d_world(source_entity = null):
	if source_entity == null:
		source_entity = PlayerDataExtra.player_camera
		
	physics_enabled = false
	
	collision_shape.set_deferred("disabled", true)
	ground_sprite.visible = false
	
	self.global_position = source_entity.global_position
	WorldData.layout_node.remove_child(self)
	

func put_in_3d_world():
	WorldData.layout_node.add_child(self)
	
	while collision_shape == null:
		await get_tree().create_timer(0.2).timeout
	
	if collision_shape.is_node_ready() == false:
		await collision_shape.ready
	
	collision_shape.set_deferred("disabled", false)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	ground_sprite.visible = true
	physics_enabled = true
	

func drop(source_entity = null):
	if source_entity == null:
		source_entity = PlayerDataExtra.player_camera
		
	self.unequip()
		
	put_in_3d_world()
		
	self.global_position = source_entity.global_position
	impulse_towards(-source_entity.global_transform.basis.z.normalized())
	item_dropped.emit()
	
func prepare_for_pickup():
	collision_shape.set_deferred("disabled", true)
	ground_sprite.visible = false
	item_picked_up.emit()

func use_item():
	#if can_use_item() == false:
	#	return
		
	if currently_using_item == true:
		return
		
	currently_using_item = true
	
	if usage_anim_node != null:
		await usage_anim_node.starting_anim(self.use_item_time)
	else:
		await get_tree().create_timer(use_item_time).timeout
		
	if currently_using_item == false:
		return
		
	use_item_started.emit(self)
	apply_item_effect()
	
	if destroy_on_use:  # Check if the item should be destroyed after use
		_destroy_item()
		
func stop_using_item():
	#if can_use_item() == false:
	#	return
		
	if currently_using_item == false:
		return
	
	
	
	use_item_ending.emit(self)
	
	#await usage_anim_node.ending_anim(self.use_item_time) # can introduce a bug?
	if usage_anim_node:
		usage_anim_node.ending_anim(self.use_item_time)
		
	currently_using_item = false
		
	await get_tree().create_timer(self.use_item_time).timeout
	use_item_ended.emit(self)
	
	stop_item_effect()
	currently_using_item = false

		
func _destroy_item():
	# Add the logic to destroy the item here
	item_destroyed.emit(self)
	queue_free()  # This is a common way to remove a node in Godot
