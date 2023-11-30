extends Node

@onready var parent = get_parent()
var knockback_velocity = Vector3.ZERO
var knockback_duration = 0.5 # Duration of the knockback in seconds
var knockback_timer = 0.0

func _on_hit(entity, weapon, damage):
	# Calculate the direction vector from the parent to the entity
	var direction = (entity.global_transform.origin - parent.global_transform.origin).normalized()

	# Add an upward component to the direction
	var upward_force = Vector3(0, 1, 0) # Upward direction in Godot
	var knockback_upward_strength = 0.5 # Adjust the strength of the upward force

	# Combine the backward and upward directions
	var knockback_direction = direction + upward_force * knockback_upward_strength
	knockback_direction = knockback_direction.normalized() # Normalize the combined direction

	# Define the knockback strength (can be adjusted)
	var knockback_strength = 2.0

	# Set the knockback velocity
	knockback_velocity = knockback_direction * knockback_strength

	# Reset the knockback timer
	knockback_timer = knockback_duration


func _physics_process(delta):
	if knockback_timer > 0:
		# Apply a portion of the knockback velocity
		parent.velocity += knockback_velocity * delta / knockback_duration
		knockback_timer -= delta
		parent.move_and_slide()

	# Your existing movement code
	# Ensure this code works well with the knockback effect
	
