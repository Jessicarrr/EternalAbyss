extends Node

var loading = false
var loaded_sounds = []
@onready var last_time_ms = Time.get_ticks_msec()
@onready var camera = get_node(get_meta("CameraPath"))
var sound_delay_s = 10
var min_delay_s = 10
var max_delay_s = 20
var sound_queue = []

var min_distance_from_camera = 4
var max_distance_from_camera = 8

var decibel_modifier = -26

func populate_sound_queue():
	sound_queue.clear()
	sound_queue = loaded_sounds.duplicate()
	sound_queue.shuffle()
	
func get_random_sound_from_queue():
	if sound_queue.size() <= 0:
		populate_sound_queue()
		
	return sound_queue.pop_front()

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_random_delay()
	_load_level_sounds()
	LevelData.level_changed.connect(_load_level_sounds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _should_play_random_sound() == false:
		return
		
	if loaded_sounds.size() <= 0:
		Debug.msg(Debug.AUDIO, ["Couldnt play rando sound because no sounds loaded"])
		return
	
	Debug.msg(Debug.AUDIO, ["ABuot to play rando sound"])
	play_random_sound()
	
func play_random_sound():
	Debug.msg(Debug.AUDIO, ["Playing rando sound"])
	var random_sound = get_random_sound_from_queue()
	var random_position = _get_random_position()
	
	var audio_player = AudioStreamPlayer3D.new()
	add_child(audio_player)
	await get_tree().process_frame
	audio_player.stream = random_sound
	audio_player.global_transform.origin = random_position
	audio_player.bus = "FarAway"
	audio_player.volume_db = decibel_modifier
	
	audio_player.play()
	audio_player.finished.connect(remove_sound_node.bind(audio_player))
	
	
func _get_random_position():
	var minimum = min_distance_from_camera
	var maximum = max_distance_from_camera
	
	return camera.global_transform.origin +\
		Vector3(\
			randf_range(-1, 1),\
			 0,\
			randf_range(-1, 1))\
		.normalized() * randf_range(minimum, maximum)
	
func _should_play_random_sound():
	var current_time_ms = Time.get_ticks_msec()
	var time_passed_ms = current_time_ms - last_time_ms
	var time_passed_s = floor(time_passed_ms / 1000.0)
	
	if time_passed_s >= sound_delay_s:
		_generate_random_delay()
		last_time_ms = Time.get_ticks_msec()
		Debug.msg(Debug.AUDIO, ["Should play random sound == true. Next delay is ", sound_delay_s, "s"])
		return true
		
	return false

func _load_level_sounds():
	if loading == true:
		return
		
	loading = true
	loaded_sounds.clear()
	var level_data = LevelData.get_current_level()
	var ambient_sounds = level_data["AmbientSounds"]
	
	for sound in ambient_sounds:
		loaded_sounds.append(load(sound))
		
	populate_sound_queue()
	
	loading = false
	
func _generate_random_delay():
	sound_delay_s = randi_range(min_delay_s, max_delay_s)
	
func remove_sound_node(node):
	node.queue_free()
	Debug.msg("Sound node removed")
