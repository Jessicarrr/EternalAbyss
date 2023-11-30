extends Area3D
class_name CombatHitbox

@export var parent_entity_path : NodePath = ""
var parent_entity = null
@onready var collision_shape = $CollisionShape3D
@onready var mesh = get_node_or_null("MeshInstance3D")

func _ready():
	if not parent_entity_path:
		push_error(self.get_path(), " requires a parent entity path to be set.")
		return
		
	parent_entity = get_node(parent_entity_path)

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
