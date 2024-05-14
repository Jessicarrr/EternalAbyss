extends ColorRect

var default_vignette_opacity = 0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_parameter("vignette_opacity", default_vignette_opacity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func invert(number):
	pass

func _on_health_health_changed(hitpoints, max_hitpoints):
	var player_health_percentage = float(hitpoints) / float(max_hitpoints)
	#print("Math: ", hitpoints, " / ", max_hitpoints, " = ", player_health_percentage)
	
	# Calculate intensity based on health percentage
	var intensity = default_vignette_opacity
	if player_health_percentage <= 0.5:
		# Scale intensity from 0 to 1 as health goes from 50% to 0%
		intensity = (0.5 - player_health_percentage) * 2.0
		# Add the default vignette opacity to the calculated intensity
		intensity += default_vignette_opacity
		# Clamp the intensity to ensure it's between default_vignette_opacity and 1.0
		intensity = clamp(intensity, default_vignette_opacity, 2.0)


	# Update shader parameters
	self.material.set_shader_parameter("vignette_opacity", intensity)

