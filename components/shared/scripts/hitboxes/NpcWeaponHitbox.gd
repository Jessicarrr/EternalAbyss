extends "res://components/shared/scripts/hitboxes/CombatHitbox.gd"
class_name NpcWeaponHitbox

@export var npc_path : NodePath = ""
var npc

@export var auto_disable_layers = [1, 5]

@onready var initial_scale = self.scale
@onready var initial_position = self.position

var disabled_position = Vector3(-1000, -1000, -1000)
var disabled_scale = Vector3(0.01, 0.01, 0.01)

var check_collisions = true

signal hitbox_disabled_by_collision

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = disabled_position
	
	if not npc_path:
		push_error(self, " a parent npc to be set.")
		return
		
	npc = get_node(npc_path)
	
	parent_entity = npc
	
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
	self.scale = disabled_scale
	self.position = disabled_position
	
func enable():
	check_collisions = true	
	self.scale = initial_scale
	self.position = initial_position
	enable_mesh()
	
	var overlapping_bodies = self.get_overlapping_bodies()

	for body in overlapping_bodies:
		_disable_on_body_entered(body)

	var overlapping_areas = self.get_overlapping_areas()

	for area in overlapping_areas:
		_disable_on_body_entered(area)

func _disable_on_body_entered(body):
	Debug.msg(Debug.COLLISIONS, [self, " (Before Checks) Collided with body ", body.get_name(), ", ", body.get_parent().get_name()])
	if check_collisions == false:
		return

	if body == npc or body.get_parent() == npc:
		return

	Debug.msg(Debug.COLLISIONS, [self, " Collided with body ", body.get_name(), ", ", body.get_parent().get_name()])
	
	for layer in auto_disable_layers:
		if body.get_collision_layer_value(layer) == true:
			disable()
			hitbox_disabled_by_collision.emit(body)
	
func _disable_on_area_entered(area):
	Debug.msg(Debug.COLLISIONS, [self, " (Before Checks) Collided with area ", area.get_name(), ", ", area.get_parent().get_name()])
	if check_collisions == false:
		return
		
	if area == npc or area.get_parent() == npc:
		return
		
	Debug.msg(Debug.COLLISIONS, [self, " Collided with area ", area.get_name(), ", ", area.get_parent().get_name()])
	
	for layer in auto_disable_layers:
		if area.get_collision_layer_value(layer) == true:
			disable()
			hitbox_disabled_by_collision.emit(area)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
