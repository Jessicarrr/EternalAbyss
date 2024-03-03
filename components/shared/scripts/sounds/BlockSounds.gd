extends Node

@export var block_hitbox_path : NodePath = ""
@export var audio_stream_path : NodePath = ""

@export var block_sounds_paths = [
]

var loaded_block_sounds = []
var block_hitbox
var audio_stream

func load_sounds():
	for sound in block_sounds_paths:
		loaded_block_sounds.append(load(sound))

# Called when the node enters the scene tree for the first time.
func _ready():
	if not block_hitbox_path:
		push_error(self, " requires a block hitbox to be set.")
		
	if not audio_stream_path:
		push_error(self, " requires an audio stream to be set.")
		
	block_hitbox = get_node(block_hitbox_path)
	audio_stream = get_node(audio_stream_path)
	
	load_sounds()
	audio_stream.bus = "ReverbBus"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_npc_block_hitbox_on_hit(dmg):
	if audio_stream == null:
		return

	if loaded_block_sounds.size() <= 0:
		return
		
	var rando_sound = loaded_block_sounds[randi() % loaded_block_sounds.size()]
	audio_stream.stream = rando_sound
	audio_stream.play()
