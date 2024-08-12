extends RandomStreamPlayer3D
class_name NpcIdleSoundPlayer3D

@export var min_delay_between_sounds = 2.0
@export var max_delay_between_sounds = 4.0

var should_do_sounds = true

@onready var next_sound_time = get_next_sound_time(0)

func get_next_sound_time(sound_length_s):
	var next_sound = randf_range(min_delay_between_sounds, max_delay_between_sounds)
	next_sound = (sound_length_s + next_sound) * 1000
	return Time.get_ticks_msec() + next_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	self.bus = "ReverbBus"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_do_sounds == false:
		return
		
	var current_time = Time.get_ticks_msec()
	
	if current_time < next_sound_time:
		return
		
	play_random()
	var audio_length = self.stream.get_length()
	
	next_sound_time = get_next_sound_time(audio_length)
	
func _on_state_changed(state, data):
	if state == Enums.ActorStates.DORMANT or state == Enums.ActorStates.DEAD:
		should_do_sounds = false
	else:
		should_do_sounds = true
