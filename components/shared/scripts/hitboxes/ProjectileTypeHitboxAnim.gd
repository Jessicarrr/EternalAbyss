extends Node

@onready var hitbox = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_state_change(state, data):
	if state == Enums.ActorStates.ATK_SWING:
		var target = data["Entity"]
		#move_hitbox_toward_target(target)
