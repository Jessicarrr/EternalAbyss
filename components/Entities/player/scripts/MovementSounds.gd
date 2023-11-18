extends Node

var footstep_sound_playing = false
var footstep_sound_delay = 0.55
@export var audio_stream: AudioStreamPlayer

var walk_stone_sounds = [
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 01_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 02_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 03_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 04_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 05_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 06_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 07_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 08_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 09_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 10_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 11_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 12_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 13_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 14_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 15_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 16_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 17_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 18_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 19_ESM_DGF.wav",
	"res://sounds/FEETHmn_Footstep Stone Adventurer Walk Rustle Light Bag 20_ESM_DGF.wav"
]

func play_movement_sound(velocity):
	if footstep_sound_playing:
		return
	else:
		footstep_sound_playing = true
		var rando_sound_effect \
			= walk_stone_sounds[randi() % walk_stone_sounds.size()]
			
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
	pass


func _on_directional_movement_player_ground_movement(velocity):
	play_movement_sound(velocity)
