extends AudioStreamPlayer3D
class_name RandomStreamPlayer3D

@export var possible_sounds = [
]

var loaded_sounds = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for sound in possible_sounds:
		loaded_sounds.append(load(sound))
	
	pass # Replace with function body.

func play_random():
	var random_sound = loaded_sounds.pick_random()
	self.stream = random_sound
	self.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
