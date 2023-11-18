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
