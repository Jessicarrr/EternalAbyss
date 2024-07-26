extends RandomStreamPlayer3D
class_name RandomStreamPlayer3DWithSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
func receive_signal():
	play_random()
