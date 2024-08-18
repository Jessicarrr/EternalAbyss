extends Node

@export var audio_stream: AudioStreamPlayer

var player_moving = false
var player_sprinting = false

var player = null

var last_footstep_sound = Time.get_ticks_msec()
@export var directional_movement : Node

var walk_stone_sounds = [
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_01.wav",
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_02.wav",
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_03.wav",
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_04.wav",
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_05.wav",
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_06.wav",
	"res://entities/actors/shared/sounds/footsteps/stone_brick/step_07.wav"
]

var sound_pool = []
signal sound_made

func grab_sound_from_sound_pool():
	if sound_pool.size() <= 0:
		sound_pool = walk_stone_sounds.duplicate()
		
	var random_sound = sound_pool[randi() % sound_pool.size()]
	sound_pool.erase(random_sound)
	return random_sound

func play_movement_sound():
	var rando_sound_effect = grab_sound_from_sound_pool()
		
	# Load the audio file into an AudioStream
	var audio_stream_resource = load(rando_sound_effect)
	
	# Set the stream to the loaded AudioStream
	audio_stream.stream = audio_stream_resource
	
	audio_stream.play()
	sound_made.emit()


func _process(_delta):
	if player_moving == false:
		return

	var wait_time_ms = (player.footstep_interval_sprinting if player_sprinting else player.footstep_interval_walking) * 1000

	if Helpers.has_enough_time_passed(wait_time_ms, last_footstep_sound) == false:
		return

	play_movement_sound()
	last_footstep_sound = Time.get_ticks_msec()
		
func _ready():
	player = await Helpers.get_player_when_ready()
	player.crouch_toggled.connect(_on_crouch_toggled)
	audio_stream.bus = "ReverbBus"

	directional_movement.player_started_movement.connect(_on_player_started_movement)
	directional_movement.player_stopped_movement.connect(_on_player_stopped_movement)

	directional_movement.player_started_sprinting.connect(_on_player_started_sprinting)
	directional_movement.player_stopped_sprinting.connect(_on_player_stopped_sprinting)
	

func _on_crouch_toggled(crouching):
	if crouching == true:
		audio_stream.bus = "SneakyBus"
		audio_stream.pitch_scale = 0.7
	else:
		audio_stream.bus = "ReverbBus"
		audio_stream.pitch_scale = 1.0

func _on_player_started_movement():
	player_moving = true

func _on_player_stopped_movement():
	player_moving = false

func _on_player_started_sprinting():
	player_sprinting = true

func _on_player_stopped_sprinting():
	player_sprinting = false