extends Node
class_name SpriteBasedSounds

@export var sprite_path : NodePath = ""
@export var stream_path : NodePath = ""
@export var footstep_sounds = [
	"res://sounds/enemies/skeleton/footsteps/FEETHmn_Footstep Stone Explorer Run Fast Dirt Outside 03_ESM_DGF.wav"
]
@export var relevant_animation = ""
@export var relevant_frames = [ 1 ]

var loaded_sounds = []

var sprite : AnimatedSprite3D = null
var stream : AudioStreamPlayer3D = null

func _load_sounds():
	for sound in footstep_sounds:
		loaded_sounds.append(load(sound))

# Called when the node enters the scene tree for the first time.
func _ready():
	if not sprite_path:
		push_error(self, " requires an animated sprite path")
		return
		
	if not stream_path:
		push_error(self, " requires an audio stream 3d to function")
	
	sprite = get_node(sprite_path)
	stream = get_node(stream_path)
	_load_sounds()
	sprite.animation_changed.connect(_on_animation_change)
	stream.bus = "ReverbBus"
	pass # Replace with function body.

func _on_animation_change():
	var anim = sprite.animation
	if anim == relevant_animation:
		sprite.frame_changed.connect(_on_frame_change)
	else:
		# Get all connections for the frame_changed signal
		var connections = sprite.frame_changed.get_connections()
		
		# Iterate through each connection
		for connection in connections:
			# Check if the callable is the method we want to disconnect
			if connection["callable"] == _on_frame_change:
				# Disconnect if the callable matches
				sprite.frame_changed.disconnect(_on_frame_change)
				break  # Assuming there's only one connection to this method, we can break after finding it


func _on_frame_change():
	var frame = sprite.frame
	if frame in relevant_frames:
		stream.stream = loaded_sounds[randi() % footstep_sounds.size()]
		stream.play()
