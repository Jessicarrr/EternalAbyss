extends Node

@onready var camera = get_node(get_meta("Camera"))
@onready var player = get_node(get_meta("Player"))

var mouse_sensitivity = 700

var rotation_target: Vector3
var input_mouse: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Rotation
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	player.rotation.y = lerp_angle(player.rotation.y, rotation_target.y, delta * 25)


func _input(event):
	if event is InputEventMouseMotion:
		# Process mouse motion for camera and player rotation
		if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:
			input_mouse = event.relative / mouse_sensitivity
			rotation_target.y -= event.relative.x / mouse_sensitivity
			rotation_target.x -= event.relative.y / mouse_sensitivity
		
		# Pass the event to the GUI, allowing for tooltips, etc.
		#get_tree().input_event(event)
		#Input.parse_input_event(event)
