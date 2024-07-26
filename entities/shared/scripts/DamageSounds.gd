extends Node
class_name DamageSounds

@export var audio_stream : AudioStreamPlayer3D = null
@export var thing_to_track : CharacterBody3D

@export var damage_sounds = [
	"res://sounds/footsteps/stone_brick/step_1.wav"
]

var loaded_damage_sounds = [
	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	_load()
	thing_to_track.on_hit.connect(_on_hit)

func _on_hit(_dmg):
	if audio_stream == null:
		return

	if loaded_damage_sounds.size() <= 0:
		return
		
	var rando_sound = loaded_damage_sounds[randi() % loaded_damage_sounds.size()]
	audio_stream.stream = rando_sound
	audio_stream.play()

func _load():
	if audio_stream == null:
		return
		
	audio_stream.bus = "ReverbBus"
	
	for sound in damage_sounds:
		loaded_damage_sounds.append(load(sound))
		
	if loaded_damage_sounds.size() <= 0:
		push_error(self, " could not load any sounds for some reason")
		return


	

