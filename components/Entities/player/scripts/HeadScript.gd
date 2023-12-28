extends Node3D

@onready var player = get_parent()
@onready var default_position = self.transform.origin
var crouched_position = Vector3(0, 0.23, 0)
var crouched = false

func _on_crouch_started():
	self.transform.origin = crouched_position
	crouched = true
	
func _on_crouch_ended():
	self.transform.origin = default_position
	crouched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.crouch_started.connect(_on_crouch_started)
	player.crouch_ended.connect(_on_crouch_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
