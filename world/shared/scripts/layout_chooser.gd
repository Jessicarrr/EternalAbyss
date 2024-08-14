extends Node3D
class_name LayoutChooser

# Called when the node enters the scene tree for the first time.
func _ready():
	var total_weight = 0
	var children = self.get_children()
	
	if children.size() < 1:
		return
	
	# Calculate the total weight
	for possibility in children:
		if possibility.has_meta("Weight"):
			total_weight += int(possibility.get_meta("Weight"))
		else:
			total_weight += 1  # Default weight if no "Weight" meta is found

	# Generate a random number within the total weight range
	var random_weight = randi_range(1, total_weight) # Generate a random number between 1 and total_weight
	var current_weight = 0
	var selected_possibility = null
	
	# Select the child based on the random weight
	for possibility in children:
		if possibility.has_meta("Weight"):
			current_weight += int(possibility.get_meta("Weight"))
		else:
			current_weight += 1  # Default weight if no "Weight" meta is found
		
		# If the current weight surpasses or matches the random weight, select this node
		if current_weight >= random_weight:
			print("Selected child: ", possibility.name)
			selected_possibility = possibility
			break
			
		
	for possibility in children:
		if possibility == selected_possibility:
			possibility.visible = true
			continue
			
		possibility.visible = false
		possibility.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
