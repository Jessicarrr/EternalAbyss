extends Node

@export var camera : Camera3D
@export var directional_movement: Node
var player_moving = false
var player_sprinting = false
var head_bob_frequency_walking = 0.55 # seconds
var head_bob_frequency_sprinting = 0.4
var should_head_bob = true
var head_bob_intensity = 100 # 0 to 100 value

var head_bob_time = 0.0

var current_tween : Tween

#signal player_started_movement
#signal player_stopped_movement
#signal player_started_sprinting
#signal player_stopped_sprinting

func _on_player_started_movement():
	player_moving = true

func _on_player_stopped_movement():
	player_moving = false

func _on_player_started_sprinting():
	player_sprinting = true

func _on_player_stopped_sprinting():
	player_sprinting = false

func _on_option_head_bob_toggled(toggle_value):
	should_head_bob = toggle_value

func _on_option_head_bob_intensity(intensity_value):
	head_bob_intensity = float(intensity_value) / 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var head_bob_option = Game.settings.camera.head_bob
	var head_bob_intensity_option = Game.settings.camera.head_bob_intensity

	_on_option_head_bob_toggled(head_bob_option.get_value())
	_on_option_head_bob_intensity(head_bob_intensity_option.get_value())

	head_bob_option.setting_changed.connect(_on_option_head_bob_toggled)
	head_bob_intensity_option.setting_changed.connect(_on_option_head_bob_intensity)

	directional_movement.player_started_movement.connect(_on_player_started_movement)
	directional_movement.player_stopped_movement.connect(_on_player_stopped_movement)

	directional_movement.player_started_sprinting.connect(_on_player_started_sprinting)
	directional_movement.player_stopped_sprinting.connect(_on_player_stopped_sprinting)

	var player = await Helpers.get_player_when_ready()
	head_bob_frequency_walking = player.footstep_interval_walking
	head_bob_frequency_sprinting = player.footstep_interval_sprinting

func do_head_bob(delta):
	var frequency = head_bob_frequency_sprinting if player_sprinting else head_bob_frequency_walking
		
	# Update head_bob_time to complete one cycle every 'frequency' seconds
	head_bob_time += delta * (1.0 / frequency)
	if head_bob_time >= 1.0:
		head_bob_time -= 1.0
	
	# Use sin() with the correct cycle length
	var sin_value = sin(head_bob_time * PI * 2)
	
	var head_bob_offset = Vector3()
	head_bob_offset.y = -(sin_value * (head_bob_intensity / 100.0) * 0.05)
	head_bob_offset.z = -(sin_value * (head_bob_intensity / 100.0) * 0.015)
	
	# Only rotate around the x-axis for a slight up and down effect
	var rotation_offset_x = sin_value * (head_bob_intensity / 100.0) * 0.05
	
	# Apply the head bobbing offset to the camera's position
	camera.position += head_bob_offset
	
	# Apply the rotation offset only around the x-axis
	camera.rotation.x += deg_to_rad(rotation_offset_x)

var current_bob_time = 0
var bob_direction = 1
@onready var original_position = camera.position

func do_head_bob_simple(delta):
	var frequency = head_bob_frequency_sprinting\
			if player_sprinting else head_bob_frequency_walking
	frequency /= 2
	
	var max_bob = head_bob_intensity * 0.01  # Convert intensity to meters

	current_bob_time += delta * bob_direction
	var t = current_bob_time / frequency

	if t > 1.0 or t < 0.0:
		bob_direction *= -1
		current_bob_time = clamp(current_bob_time, 0.0, frequency)

	var vertical_bob = lerp(-max_bob, max_bob, t)
	var horizontal_bob = lerp(-max_bob * 0.5, max_bob * 0.5, t)

	camera.position = original_position + Vector3(
			horizontal_bob, vertical_bob, -abs(vertical_bob))

func tweened_head_bob():
	if should_head_bob == false or (player_moving or player_sprinting) == false:
		return
	
	var frequency = head_bob_frequency_sprinting\
			if player_sprinting else head_bob_frequency_walking
	var max_bob = head_bob_intensity * 0.01 / 3  # Convert intensity to meters
	
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_SINE)
	current_tween.set_ease(Tween.EASE_IN_OUT)
	
	# Vertical bob (down and up)
	current_tween.tween_property(camera, 
			"position:y", original_position.y - max_bob, frequency / 2)
	current_tween.tween_property(camera, 
			"position:y", original_position.y + max_bob, frequency / 2)
	#current_tween.play()

	## Forward and backward motion
	var forward_tween = create_tween()
	forward_tween.set_trans(Tween.TRANS_SINE)
	forward_tween.set_ease(Tween.EASE_IN_OUT)
	forward_tween.tween_property(camera,
			 "position:z", original_position.z - max_bob * 0.3, frequency / 2)
	forward_tween.tween_property(camera, 
			"position:z", original_position.z, frequency / 2)
	
	# Chain the next bob cycle
	
	current_tween.tween_callback(tweened_head_bob)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_head_bob and (player_moving or player_sprinting):
		if not current_tween or not current_tween.is_running():
			tweened_head_bob()
	else:
		if current_tween and current_tween.is_running():
			current_tween.stop()
		head_bob_time = 0.0
		camera.position = camera.position.lerp(Vector3(0,0,0), 0.1)
		# Reset rotation if not bobbing
		#camera.rotation_degrees = camera.rotation_degrees.lerp(Vector3(0, 0, 0), 0.4)
