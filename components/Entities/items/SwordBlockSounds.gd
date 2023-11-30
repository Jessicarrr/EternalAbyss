extends Node
class_name SwordBlockSounds

var is_blocking = false

@export var audio_path : NodePath = ""
var audio

@export var block_sounds = [
	""
]

var loaded_sounds = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if not audio_path:
		push_error(self.get_path(), " requires an audio stream path to be set.")
		return
		
	audio = get_node(audio_path)
	audio.bus = "ReverbBus"
	
	for sound_path in block_sounds:
		loaded_sounds.append(load(sound_path))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_rando_sound():
	if audio == null:
		return
		
	if loaded_sounds.size() <= 0:
		return
		
	var rando_sound = loaded_sounds[randi() % loaded_sounds.size()]
	audio.stream = rando_sound
	audio.play()

func _on_player_block_hitbox_area_entered(area):
	#print("[swordblock] area_entered")
	play_rando_sound()


func _on_use_item_started(_item):
	#print("[swordblock] is_blocking tru")
	is_blocking = true


func _on_use_item_ended(_item):
	#print("[swordblock] is_blocking false")
	is_blocking = false
