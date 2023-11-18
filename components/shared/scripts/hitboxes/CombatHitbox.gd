extends Area3D
class_name CombatHitbox

@export var parent_entity_path : NodePath = ""
var parent_entity = null
@onready var collision_shape = $CollisionShape3D
@onready var mesh = get_node_or_null("MeshInstance3D")

func has_parent_entity():
	if parent_entity == null:
		return false
		
	return true

func enable_mesh():
	if Debug.SHOW_HITBOXES == false:
		return
		
	if mesh != null:
		mesh.visible = true
		
func disable_mesh():
	if Debug.SHOW_HITBOXES == false:
		return
		
	if mesh != null:
		mesh.visible = false

#func toggle_monitoring(state):
#	collision_shape.disabled = !state
#
#	if state == true:
#		collision_shape.scale = collision_scale
#	else:
#		collision_shape.scale = Vector3(0, 0, 0)
#		collision_shape.global_position = Vector3(0, 0, 0)
#
#	if Debug.SHOW_HITBOXES == true:
#		var mesh = get_node_or_null("MeshInstance3D")
#
#		if mesh == null:
#			return
#
#		mesh.visible = state

# Called when the node enters the scene tree for the first time.
func _ready():
	if not parent_entity_path:
		push_error(self, " - CombatHitbox requires a parent entity to be set.")
		return
		
	#var enable = !collision_shape.disabled
	#toggle_monitoring(enable)
	parent_entity = get_node(parent_entity_path)

