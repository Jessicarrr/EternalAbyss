extends Node

signal sound_event

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func do_sound_event(source : Enums.SoundSources, volume : float, sound_global_position : Vector3):
	sound_event.emit(source, volume, sound_global_position)
