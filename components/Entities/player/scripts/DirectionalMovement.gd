extends Node

@export_subgroup("Script Dependencies")
@export var player: CharacterBody3D
@export var camera: Camera3D

# Movement-related variables
@export_subgroup("Movement Properties")
@export var walking_speed = 95  # Speed of the player
@export var run_speed_modifier = 60
@export var backwards_movement_multiplier = 0.55
@export var jump_force = 4  # Jump strength
@export var gravity_power = 20

var current_velocity: Vector3  # Current velocity of the player
var current_gravity := 0.0  # Current gravity affecting the player
var was_on_floor_previously := false  # Was the player on the floor in the last frame?
var can_jump := true  # Can the player perform a jump?

signal player_ground_movement #Emit a signal if the player is walking on the ground


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $DevModeMovement.dev_mode_active:
		return
	
	var captured_input = capture_movement_input()  # Capture the player's movement input
	
	apply_gravity(delta)  # Apply gravity to the player
	handle_jumping()
	
	var movement_speed = walking_speed
	
	if is_sprinting():
		movement_speed += run_speed_modifier
		
	if is_moving_backwards(captured_input):
		movement_speed *= backwards_movement_multiplier
	
	move(captured_input, movement_speed, delta)

	# Check if the player has landed on the floor
	if player.is_on_floor() and current_gravity > 1 and !was_on_floor_previously:
		camera.position.y = -0.1
	was_on_floor_previously = player.is_on_floor()
	
func move(movement_input, player_speed, delta):
	# Calculate the final velocity
	current_velocity = movement_input.normalized() * player_speed * delta
	var final_velocity: Vector3
	current_velocity = player.transform.basis * current_velocity
	final_velocity = player.velocity.lerp(current_velocity, delta * 10)
	final_velocity.y = -current_gravity
	player.velocity = final_velocity
	player.move_and_slide()
	try_emit_movement_signal()

# Misc input related to directional movement
func is_sprinting():
	return Input.is_action_pressed("shift")
	
func is_moving_backwards(captured_input):
	if captured_input.z > 0:
		return true
		
	return false

# Capture the player's movement input
func capture_movement_input() -> Vector3:
	var input: Vector3 = Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	return input

# Handle jumping logic
func handle_jumping():
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			current_gravity = -jump_force
		can_jump = false
		
# Apply gravity to the player
func apply_gravity(delta):
	current_gravity += gravity_power * delta
	if current_gravity > 0 and player.is_on_floor():
		can_jump = true
		current_gravity = 0
		
# Detect if the player is walking, emit signal if they are
func try_emit_movement_signal():
	# Get the actual velocity after collision resolution
	var actual_velocity = player.velocity
	
	# Remove the vertical component (y-axis) as we're only interested in horizontal movement
	actual_velocity.y = 0
	
	# Emit walking signal if conditions are met
	if player.is_on_floor() and actual_velocity.length() > 0.1:
		player_ground_movement.emit(actual_velocity)

