extends Node

var last_used_controller = Enums.ControllerTypes.KEYBOARD

func _input(event):
	if event is InputEventKey:
		last_used_controller = Enums.ControllerTypes.KEYBOARD
	elif event is InputEventJoypadButton:
		last_used_controller = Enums.ControllerTypes.GAMEPAD

func get_button_string_for_action(action):
	var input_map = InputMap.action_get_events(action)
	var fallback = "[No Keybind Assigned]"  # Fallback string if no matching input is found

	for event in input_map:
		if last_used_controller == Enums.ControllerTypes.KEYBOARD:
			if event is InputEventKey:
				return convert_event_to_text(event)  # Return keyboard button as a string
			# Set fallback for the first found event in case no keyboard key is bound
			elif fallback == "" and event is InputEventJoypadButton:
				fallback = convert_event_to_text(event)
		elif last_used_controller == Enums.ControllerTypes.GAMEPAD:
			if event is InputEventJoypadButton:
				return convert_event_to_text(event)  # Returns the Joypad button as a string
			# Set fallback for the first found event in case no gamepad button is bound
			elif fallback == "" and event is InputEventKey:
				fallback = convert_event_to_text(event)

	return fallback  # Return fallback if no appropriate event was found
	
func convert_event_to_text(event):
	var keycode := DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
	return OS.get_keycode_string(keycode)
