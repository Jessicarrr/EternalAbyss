extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_parameter("opacity", 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_health_health_changed(hitpoints, max_hitpoints):
	var player_health_percentage = float(hitpoints) / float(max_hitpoints)
	#print("Math: ", hitpoints, " / ", max_hitpoints, " = ", player_health_percentage)
	
	# Calculate intensity based on health percentage
	var intensity = 0.0
	var max_intensity = 0.3  # The highest possible opacity
	if player_health_percentage <= 0.5:
		# Scale intensity from 0 to max_intensity as health goes from 50% to 0%
		intensity = (0.5 - player_health_percentage) * 2.0 * max_intensity

	# Update shader parameters
	self.material.set_shader_parameter("opacity", intensity)
