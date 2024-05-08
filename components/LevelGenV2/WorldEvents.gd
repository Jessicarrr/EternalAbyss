extends Node

signal sound_event

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func do_sound_event(source, volume : float, sound_global_position : Vector3, description : Enums.SoundDescriptions = Enums.SoundDescriptions.NONE):
	sound_event.emit(source, volume, sound_global_position, description)
	var description_name
	
	for key in Enums.SoundDescriptions.keys():
		if Enums.SoundDescriptions[key] == description:
			description_name = key
	
	Debug.msg(Debug.EVENTS, ["Sound event emitted. Source: ", source.get_name(), " volume: ", volume, " pos: ", sound_global_position, ". description: " + description_name])
