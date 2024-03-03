extends Node

var damage_sounds = [
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 03_DDUMAIS_NONE.wav",
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 04_DDUMAIS_NONE.wav",
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 05_DDUMAIS_NONE.wav",
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 06_DDUMAIS_NONE.wav",
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 07_DDUMAIS_NONE.wav",
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 09_DDUMAIS_NONE.wav",
	"res://sounds/player/receive_damage/GOREStab_Designed Slash Gore 11_DDUMAIS_NONE.wav"
]

var loaded_sounds = []

var windup_sound_playing = false
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer

var swing_sound_skip_seconds = 0.02

func _ready():
	for sound in damage_sounds:
		loaded_sounds.append(sound)
		
	audio_stream.bus = "ReverbBus"

func play_damage_sounds():
	var rando_sound_effect = loaded_sounds[randi() % loaded_sounds.size()]
	
	# Load the audio file into an AudioStream
	var audio_stream_resource = load(rando_sound_effect)
	
	# Set the stream to the loaded AudioStream
	audio_stream.stream = audio_stream_resource
	
	audio_stream.play()


func _on_hit(_entity, _dmg):
	play_damage_sounds()
