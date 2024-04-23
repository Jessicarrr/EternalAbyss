extends Node

@onready var parent = get_parent()
@onready var item_handler = $ItemHandler
	
func _input(_event):
	if parent.active == false:
		return
	
	# Check for the "attack" action
	if Input.is_action_just_pressed("use_item"):
		go_to_relevant_state()

func go_to_relevant_state():
	if item_handler.is_hotbar_item_food() == true:
		parent.request_state_change.emit(parent, Enums.ActorStates.EATING, {
			"item" : item_handler.hotbar_item
		})
		return


func _on_idle_began():
	if Input.is_action_pressed("use_item"):
		go_to_relevant_state()
