extends AudioStreamPlayer
class_name RandomStreamPlayer

@export var possible_sounds = [
]

var loaded_sounds = []

@export var pitch_min = 0.95
@export var pitch_max = 1.05

# Called when the node enters the scene tree for the first time.
func _ready():
	for sound in possible_sounds:
		loaded_sounds.append(load(sound))
	
	pass # Replace with function body.

func play_random():
	var random_sound = loaded_sounds.pick_random()
	self.stream = random_sound
	self.pitch_scale = randf_range(pitch_min, pitch_max)
	self.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
