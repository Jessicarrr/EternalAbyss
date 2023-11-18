extends Node

@onready var hitbox : Area3D = get_parent()
@export var weapon_path : NodePath = ""
var weapon_node = null
@onready var audio_stream = $AudioStreamPlayer

func _on_body_entered(body):
	var body_parent = body.get_parent()
	if body == PlayerDataExtra.player_instance or body_parent == PlayerDataExtra.player_instance:
		return
	
	if body.get_collision_layer_value(4) == false:
		return
		
	var rando_sound = weapon_node.impact_sounds[randi() % weapon_node.impact_sounds.size()]
	var loaded_sound = load(rando_sound)
	
	# Set the stream to the loaded AudioStream
	audio_stream.stream = loaded_sound
	
	audio_stream.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not weapon_path:
		push_error(self, " has no weapon path attribute set")
		return
		
	weapon_node = get_node(weapon_path)
	
	#hitbox.body_entered.connect(_on_body_entered)
	audio_stream.bus = "ReverbBus"
	
