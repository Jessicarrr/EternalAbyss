extends Node
#
## Define a flag to keep track of whether the mouse button is pressed
#var is_attack_pressed = false
#
## Define a flag to ensure the "Mouse Held" event is triggered only once
#var attack_held_event_triggered = false
#
## Define a threshold to differentiate between a press and a hold (in seconds)
#var hold_threshold = 0.5
#
## Variable to keep track of elapsed time since the mouse was pressed
#var elapsed_time = 0.0
#
#signal attack_pressed
#signal attack_held
#
#func _input(event):
#	if event.is_action_pressed("attack"):
#		# Set the flag and reset the elapsed_time
#		is_attack_pressed = true
#		elapsed_time = 0.0
#		attack_held_event_triggered = false
#		Debug.msg(Debug.COMBAT, ["Attack pressed"])
#		attack_pressed.emit()
#
#	elif event.is_action_released("attack"):
#		# Reset the flag
#		is_attack_pressed = false
#
#func _process(delta):
#	if is_attack_pressed:
#		# Increment the elapsed time
#		elapsed_time += delta
#
#		# Check if the elapsed time exceeds the hold threshold
#		if elapsed_time >= hold_threshold and not attack_held_event_triggered:
#			Debug.msg(Debug.COMBAT, ["Mouse Held"])
#			attack_held_event_triggered = true  # Set flag to prevent multiple triggers
#			attack_held.emit()
#
#	else:
#		# Reset the elapsed time if the mouse is not being pressed
#		elapsed_time = 0.0
