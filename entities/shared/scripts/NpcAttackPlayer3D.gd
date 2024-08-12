extends RandomStreamPlayer3D
class_name NpcAttackPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	self.bus = "ReverbBus"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_state_machine_state_changed(state, data):
	if state == Enums.ActorStates.ATK_SWING:
		play_random()
