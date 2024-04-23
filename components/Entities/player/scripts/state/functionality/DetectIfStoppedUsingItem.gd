extends Node

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if parent.active == false:
		return

	# Check for the "attack" action
	if Input.is_action_just_released("use_item"):
		parent.request_state_change.emit(parent, Enums.ActorStates.IDLE, {})
