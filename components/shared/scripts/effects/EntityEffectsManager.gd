extends Node

var categories_and_effects = {}

func _on_child_entered_tree(the_child):
	update_child_list()
	
func _on_child_exiting_tree(the_child):
	remove_node(the_child)
	# check if there are any left in the category
		
func update_child_list():
	categories_and_effects.clear()
	
	for child in self.get_children():
		var effect_type = child.effect_type
		
		if categories_and_effects.has(effect_type) == false:
			categories_and_effects.effect_type = []
		
		categories_and_effects.effect_type.append(child)

func remove_node(node_to_remove):
	for key in categories_and_effects:
		var node_list = categories_and_effects[key]
		
		for node in node_list:
			if node == node_to_remove:
				node_list.erase(node)
				return

# Called when the node enters the scene tree for the first time.
func _ready():
	self.child_entered_tree.connect(_on_child_entered_tree)
	self.child_exiting_tree.connect(_on_child_exiting_tree)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
