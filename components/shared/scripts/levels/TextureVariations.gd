extends Node

@onready var layout_node = get_node(get_meta("LayoutPath"))
var rng = RandomNumberGenerator.new()

func iterate_over_nodes(cur_node : Node):
	if cur_node != null and cur_node.has_meta("Variations"):
		var all_variations = cur_node.get_meta("Variations").duplicate()

		# Randomly select a texture variation
		var random_index = rng.randi_range(0, all_variations.size() - 1)
		var chosen_variation_path = all_variations[random_index]
		var chosen_variation = load(chosen_variation_path)
			
		var mesh_instance = cur_node as MeshInstance3D
		var material = mesh_instance.get_active_material(0).duplicate() as StandardMaterial3D
		mesh_instance.set_surface_override_material(0, material)  # Assign the new unique material instance
		material.albedo_texture = chosen_variation
	
	# Recursively process all children
	for child in cur_node.get_children():
		iterate_over_nodes(child)

func _on_generator_generation_finished(_data):
	rng.randomize()
	#iterate_over_nodes(layout_node)
