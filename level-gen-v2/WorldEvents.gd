extends Node

signal sound_event
signal world_gen_complete
	
func do_sound_event(source, volume : float, sound_global_position : Vector3, description : Enums.SoundDescriptions = Enums.SoundDescriptions.NONE):
	sound_event.emit(source, volume, sound_global_position, description)
	var description_name
	
	for key in Enums.SoundDescriptions.keys():
		if Enums.SoundDescriptions[key] == description:
			description_name = key
	
	Debug.msg(Debug.EVENTS, ["Sound event emitted. Source: ", source.get_name(),
			 " volume: ", volume, " pos: ", sound_global_position,
			 ". description: " + description_name])

func do_world_gen_complete_event():
	world_gen_complete.emit()
