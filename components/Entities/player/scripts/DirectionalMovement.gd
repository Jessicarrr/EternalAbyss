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
@export var crouch_speed_multiplier = 0.6

var current_velocity: Vector3  # Current velocity of the player
var current_gravity := 0.0  # Current gravity affecting the player
var was_on_floor_previously := false  # Was the player on the floor in the last frame?
var can_jump := true  # Can the player perform a jump?

# New variables to track previous frame's status
var was_moving_previously := false
var was_sprinting_previously := false

var current_stamina_movement_speed = 1.0

var crouching = false

@export var stamina_percent_to_movement_penalty = {
	0.50 : 0.7, # 50% stamina, 90% movement speed (10% slower)
	0.25 : 0.4, # 25% stamina, 70% movement speed (30% slower)
	0.0 : 0.1 # 0% stamina, 40% movement speed (60% slower)
}

# New signals
signal player_started_movement
signal player_stopped_movement
signal player_started_sprinting
signal player_stopped_sprinting

signal player_ground_movement #Emit a signal if the player is walking on the ground

func _ready():
	player.crouch_started.connect(_on_crouch_started)
	player.crouch_ended.connect(_on_crouch_ended)
	
func _on_crouch_started():
	crouching = true
	
func _on_crouch_ended():
	crouching = false

func get_movement_penalty_for_current_stamina(current_stamina, max_stamina) -> float:
	#print("!! cur stam = ", current_stamina, " and max is ", max_stamina)
	var stamina_percentage = float(current_stamina) / max_stamina
	#print("!! stam percentage is ", stamina_percentage)
	
	var sorted_keys = stamina_percent_to_movement_penalty.keys()
	sorted_keys.sort()

	var penalty = 1.0  # Default to no penalty
	for key in sorted_keys:
		if stamina_percentage <= key:
			penalty = stamina_percent_to_movement_penalty[key]
			break

	#print("!! current stamina movement speed = ", penalty)
	
	return penalty


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $DevModeMovement.dev_mode_active:
		return
	
	
	
	var captured_input = capture_movement_input()  # Capture the player's movement input
	
	# Emit signals for starting and stopping movement
	var is_moving_now = captured_input.length_squared() > 0
	if is_moving_now and !was_moving_previously:
		player_started_movement.emit()
	elif !is_moving_now and was_moving_previously:
		player_stopped_movement.emit()
	was_moving_previously = is_moving_now

	# Emit signals for starting and stopping sprinting
	var is_sprinting_now = is_sprinting()
	if is_sprinting_now and !was_sprinting_previously:
		player_started_sprinting.emit()
	elif !is_sprinting_now and was_sprinting_previously:
		player_stopped_sprinting.emit()
	was_sprinting_previously = is_sprinting_now
	
	apply_gravity(delta)  # Apply gravity to the player
	handle_jumping()
	
	var movement_speed = walking_speed
	
	if is_sprinting():
		movement_speed += run_speed_modifier
		
	if is_moving_backwards(captured_input):
		movement_speed *= backwards_movement_multiplier
	
	movement_speed *= current_stamina_movement_speed
	
	if crouching == true:
		movement_speed *= crouch_speed_multiplier
	
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

func _on_endurance_stamina_changed(current_stamina, max_stamina):
	
	current_stamina_movement_speed =\
	 get_movement_penalty_for_current_stamina(current_stamina, max_stamina)
	
