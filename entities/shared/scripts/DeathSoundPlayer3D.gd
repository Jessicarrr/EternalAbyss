extends RandomStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()




func _on_state_machine_state_changed_to_dead():
	play_random()
