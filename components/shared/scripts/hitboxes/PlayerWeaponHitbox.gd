extends "res://components/shared/scripts/hitboxes/CombatHitbox.gd"
class_name PlayerWeaponHitbox

@export var parent_item_path : NodePath = ""
var parent_item = null

@export var auto_disable_layers = [ 1 ]

@onready var initial_scale = self.scale
@onready var initial_position = self.position
@onready var player = PlayerDataExtra.player_instance

var check_collisions = true

signal hitbox_disabled_by_collision

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_entity = PlayerDataExtra.player_instance
	
	if not parent_item_path:
		push_error(self, " needs a parent item path set")
		return
		
	parent_item = get_node(parent_item_path)
	
	if auto_disable_layers.size() > 0:
		self.body_entered.connect(_disable_on_body_entered)
		self.area_entered.connect(_disable_on_area_entered)
	
func is_disabled():
	if check_collisions == false:
		return true
		
	
		
	return false
	
func is_enabled():
	if check_collisions == true:
		return true
	return false
	
func disable():
	check_collisions = false
	disable_mesh()
	self.scale = Vector3.ZERO
	self.position = initial_position
	
func enable():
	check_collisions = true	
	self.scale = initial_scale
	enable_mesh()
	
	var overlapping_bodies = self.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		_disable_on_body_entered(body)
		
	var overlapping_areas = self.get_overlapping_areas()
	
	for area in overlapping_areas:
		_disable_on_body_entered(area)

func _disable_on_body_entered(body):
	if check_collisions == false:
		return

	if body == PlayerDataExtra.player_instance or body.get_parent() == PlayerDataExtra.player_instance:
		return

	print("Collided with body ", body.get_name(), ", ", body.get_parent().get_name())
	
	for layer in auto_disable_layers:
		if body.get_collision_layer_value(layer) == true:
			disable()
			hitbox_disabled_by_collision.emit(body)
	
func _disable_on_area_entered(area):
	if check_collisions == false:
		return
		
	if area == PlayerDataExtra.player_instance or area.get_parent() == PlayerDataExtra.player_instance:
		return
		
	print("Collided with area ", area.get_name(), ", ", area.get_parent().get_name())
	
	for layer in auto_disable_layers:
		if area.get_collision_layer_value(layer) == true:
			disable()
			hitbox_disabled_by_collision.emit(area)


