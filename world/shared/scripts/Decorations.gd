extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	var queue = []
	
	# Add the root node to the queue
	queue.append(self)
	
	while queue.size() > 0:
		# Dequeue the front node and process its children
		var current_node = queue.pop_front()
		
		for child in current_node.get_children():
			# Add each child to the queue for future processing
			queue.append(child)
			
			if !child.has_meta("PercentChance"):
				continue
			
			var chance = child.get_meta("PercentChance")
			
			if rng.randf_range(0.0, 100.0) < chance:
				child.visible = true
			else:
				child.visible = false
				child.queue_free()

