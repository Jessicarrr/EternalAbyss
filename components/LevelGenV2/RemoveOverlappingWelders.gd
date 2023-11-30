extends Node

func are_objs_adjacent(obj1, obj2):
	var pos1 = obj1.global_transform.origin
	var pos2 = obj2.global_transform.origin
	
	var tolerance = 0.01  # A small number to account for floating-point errors
	
	if abs(pos1.x - pos2.x) < tolerance and abs(pos1.y - pos2.y) < tolerance and abs(pos1.z - pos2.z) < tolerance:
		return true
	return false

func remove_overlapping_welders():
	var welders = []
	
	var root_of_current_scene = self
	while root_of_current_scene.get_parent() != null:
		root_of_current_scene = root_of_current_scene.get_parent()
	
	_find_welders(root_of_current_scene, welders)
	
	for i in range(welders.size()):
		var welder1 = welders[i]
		for j in range(i + 1, welders.size()):
			var welder2 = welders[j]
			if are_objs_adjacent(welder1, welder2):
				welder2.queue_free()
				welders.erase(j)
				j -= 1  # Adjust the index after removal

func _find_welders(node, welders):
	if "welder" in node.name.to_lower():
		welders.append(node)
	for child in node.get_children():
		_find_welders(child, welders)

func _on_generator_generation_finished(arg):
	#remove_overlapping_welders()
	pass
	
