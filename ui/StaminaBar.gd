extends TextureProgressBar

@export var endurance_node_path : NodePath = ""
var endurance_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not endurance_node_path:
		push_error(self, "  requires an endurance node to be set.")
		return

	endurance_node = get_node(endurance_node_path)
	self.value = endurance_node.current_stamina
	self.max_value = endurance_node.max_stamina
	endurance_node.stamina_changed.connect(_on_stamina_changed)

func _on_stamina_changed(current_stamina, max_stamina):
	self.value = current_stamina
	self.max_value = max_stamina
