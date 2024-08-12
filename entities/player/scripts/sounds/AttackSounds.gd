extends Node

var windup_sounds = [
	"res://items/equippable/weapons/shared/sounds/windup1.wav",
	"res://items/equippable/weapons/shared/sounds/windup2.wav",
	"res://items/equippable/weapons/shared/sounds/windup3.wav"
]

var windup_sound_playing = false
@onready var audio_stream_1: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_2 : AudioStreamPlayer = $AudioStreamPlayer2
@onready var audio_stream_hit_obj : AudioStreamPlayer = $AudioStreamHitObj

var swing_sound_skip_seconds = 0.02

func play_swing_sound(data = {}):
	if data.has("Weapon") == false:
		return
		
	var weapon = data["Weapon"]
	var rando_sound_effect = weapon.swing_sounds[randi() % weapon.swing_sounds.size()]
	
	# Load the audio file into an AudioStream
	var audio_stream_resource = load(rando_sound_effect)
	
	# Set the stream to the loaded AudioStream
	audio_stream_2.stream = audio_stream_resource
	
	audio_stream_2.bus = "ReverbBus"
	audio_stream_2.play(swing_sound_skip_seconds)

	
	pass

func play_windup_sound():
	if windup_sound_playing:
		return

	windup_sound_playing = true
	var rando_sound_effect \
		= windup_sounds[randi() % windup_sounds.size()]
		
	# Load the audio file into an AudioStream
	var audio_stream_resource = load(rando_sound_effect)
	
	# Set the stream to the loaded AudioStream
	audio_stream_1.stream = audio_stream_resource
	
	audio_stream_1.bus = "ReverbBus"
	
	audio_stream_1.play()
	
	await get_tree().create_timer(0.5).timeout
	windup_sound_playing = false
	
func play_recoil_sound(data):
	if data.has("Weapon") == false:
		return
		
	var obj = data["Object"]
	
	if obj.get_collision_layer_value(1) == false:
		return
		
	var weapon = data["Weapon"]
	var rando_sound_effect = weapon.recoil_sounds[randi() % weapon.recoil_sounds.size()]
		
	# Load the audio file into an AudioStream
	var audio_stream_resource = load(rando_sound_effect)
	
	# Set the stream to the loaded AudioStream
	audio_stream_hit_obj.stream = audio_stream_resource
	
	audio_stream_hit_obj.bus = "ReverbBus"
	
	audio_stream_hit_obj.play()

func _on_player_state_machine_state_changed(state, data = {}):
	match state:
		Enums.ActorStates.ATK_WINDUP,\
		Enums.ActorStates.BLOCK_START:
			play_windup_sound()
		Enums.ActorStates.ATK_SWING:
			play_swing_sound(data)
		Enums.ActorStates.ATK_RECOIL:
			play_recoil_sound(data)
