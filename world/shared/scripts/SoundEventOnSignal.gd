extends Node

@export var sound_volume : Enums.SoundVolumes = Enums.SoundVolumes.AVERAGE
@export var sound_description : Enums.SoundDescriptions = Enums.SoundDescriptions.NONE

func receive_signal(sound_maker : Node3D):
	WorldData.events.do_sound_event(sound_maker, sound_volume, sound_maker.global_position, sound_description)
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
