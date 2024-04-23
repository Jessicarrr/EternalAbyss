extends Node

@onready var camera = get_node(get_meta("Camera"))
@onready var player = get_node(get_meta("Player"))

var mouse_sensitivity = 700
var mouse_captured := true

var rotation_target: Vector3
var input_mouse: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_controls(delta)
	
	# Rotation
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	player.rotation.y = lerp_angle(player.rotation.y, rotation_target.y, delta * 25)


func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		input_mouse = event.relative / mouse_sensitivity
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

func handle_controls(_delta):
	# Mouse capture
	if Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
	
	if Input.is_action_just_pressed("mouse_capture_exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_captured = false
		input_mouse = Vector2.ZERO
