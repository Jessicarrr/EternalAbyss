extends Node

# Define your signals
signal attack_clicked
signal attack_held

# Variable to track when the attack action was pressed
var attack_pressed_time = null

# Threshold for attack hold duration in seconds
var attack_held_threshold = 0.3

func _ready():
	# Ensure this node is processing input
	set_process_input(true)

func _input(_event):
	# Check for the "attack" action
	if Input.is_action_pressed("attack") and Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:
		if attack_pressed_time == null:  # This prevents the timestamp from continuously updating while the button is held down
			attack_pressed_time = Time.get_ticks_msec()
	else:
		# Only execute if we have a recorded press time
		if attack_pressed_time != null:
			# Calculate the duration the attack action was pressed for
			var duration_pressed = (Time.get_ticks_msec() - attack_pressed_time) / 1000.0  # Convert to seconds
			
			# Emit the appropriate signal based on duration
			if duration_pressed < attack_held_threshold: 
				emit_signal("attack_clicked")
			else:
				emit_signal("attack_held")
			
			# Reset the press time after handling
			attack_pressed_time = null
