extends TextureProgressBar

@export var health_node_path : NodePath = ""
var health_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not health_node_path:
		push_error(self, "  requires a health node to be set.")
		return

	health_node = get_node(health_node_path)
	self.value = health_node.current_hitpoints
	self.max_value = health_node.max_hitpoints
	health_node.health_changed.connect(_on_health_health_changed)

func _on_health_health_changed(current_hp, max_hp):
	self.value = current_hp
	self.max_value = max_hp
