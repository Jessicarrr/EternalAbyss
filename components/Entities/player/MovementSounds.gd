extends Node

@onready var player = get_parent().get_parent()
var footstep_sound_playing = false
var footstep_sound_delay = 0.55
@export var audio_stream: AudioStreamPlayer

var walk_stone_sounds = [
	"res://sounds/footsteps/stone_brick/step_01.wav",
	"res://sounds/footsteps/stone_brick/step_02.wav",
	"res://sounds/footsteps/stone_brick/step_03.wav",
	"res://sounds/footsteps/stone_brick/step_04.wav",
	"res://sounds/footsteps/stone_brick/step_05.wav",
	"res://sounds/footsteps/stone_brick/step_06.wav",
	"res://sounds/footsteps/stone_brick/step_07.wav"
]

var sound_pool = []

func grab_sound_from_sound_pool():
	if sound_pool.size() <= 0:
		sound_pool = walk_stone_sounds.duplicate()
		
	var random_sound = sound_pool[randi() % sound_pool.size()]
	sound_pool.erase(random_sound)
	return random_sound

func play_movement_sound(velocity):
	if footstep_sound_playing:
		return
	else:
		footstep_sound_playing = true
		var rando_sound_effect = grab_sound_from_sound_pool()
			
		# Load the audio file into an AudioStream
		var audio_stream_resource = load(rando_sound_effect)
		
		# Set the stream to the loaded AudioStream
		audio_stream.stream = audio_stream_resource
		
		audio_stream.bus = "ReverbBus"
		
		audio_stream.play()
		
		var velocity_magnitude = velocity.length()
		var scaled_footstep_delay = footstep_sound_delay / max(velocity_magnitude, 1) * 1.7
		
		await get_tree().create_timer(scaled_footstep_delay).timeout
		footstep_sound_playing = false
		
func _ready():
	player.crouch_toggled.connect(_on_crouch_toggled)

func _on_crouch_toggled(crouching):
	if crouching == true:
		audio_stream.bus = "SneakyBus"
		audio_stream.pitch_scale = 0.85
	else:
		audio_stream.bus = "ReverbBus"
		audio_stream.pitch_scale = 1.0

func _on_directional_movement_player_ground_movement(velocity):
	play_movement_sound(velocity)
