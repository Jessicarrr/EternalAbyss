extends Node

func print_all_children(node, indentation = ""):
	# Print information about the current node
	print("%sNode: %s, Type: %s" % [indentation, node.name, node.get_class()])

	# Recursively do the same for each child
	for child in node.get_children():
		print_all_children(child, indentation + "-")
		
func print_all_children_check_in_tree(node, indentation = ""):
		# Print information about the current node
	print("%sNode: %s, Type: %s. Is inside tree? %s" % [indentation, node.name, node.get_class(), node.is_inside_tree()])

	# Recursively do the same for each child
	for child in node.get_children():
		print_all_children_check_in_tree(child, indentation + "-")

func state_name(state_value: int) -> String:
	# Iterate through the keys and values of the enum
	for key in Enums.ActorStates.keys():
		if Enums.ActorStates[key] == state_value:
			return key
	return "Unknown"
	
func should_chance_succeed(chance_float):
	var result = randf_range(0.0, 1.0)
	
	if result < chance_float:
		return true
		
	return false

func has_enough_time_passed(time_requirement, last_time):
	var current_time = Time.get_ticks_msec()
	var time_elapsed = current_time - last_time
	
	if time_elapsed > time_requirement:
		return true
		
	return false

func try_load_node(origin : Node, node_path : NodePath):
	if not node_path:
		push_error(origin.get_path(), " requires a node path to be set.")
		return null
		
	var node : Node = origin.get_node(node_path)
	
	if not node:
		push_error(origin.get_path(), " node path doesn't lead to a node.")
	
	return node
