extends Node

var dev_mode_active = false
var dev_speed = 200
@export var dev_lowest_speed = 10
@export var dev_highest_speed = 250

var player: CharacterBody3D  # Reference to the player
var collider: CollisionShape3D  # Reference to the collider

# Reference to the parent script
var directional_movement_script

func _input(event):
	if Input.is_action_just_pressed("dev_speed_up"):
		dev_speed += 10
	if Input.is_action_just_pressed("dev_slow_down"):
		dev_speed -= 10
		
	if dev_speed < 10:
		dev_speed = dev_lowest_speed
	if dev_speed > dev_highest_speed:
		dev_speed = dev_highest_speed
	

# Called when the node enters the scene tree for the first time.
func _ready():
	directional_movement_script = get_parent()
	player = directional_movement_script.player
	collider = player.get_node("Collider")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_dev_mode_toggle()
	
	if dev_mode_active:
		handle_dev_mode_movement(delta)
		
	pass
	
func check_for_dev_mode_toggle():
	if Input.is_action_just_pressed("toggle_dev_mode"):
		dev_mode_active = !dev_mode_active
		collider.disabled = dev_mode_active  # Disable or enable the collider
		
# Handle movement when dev mode is active
func handle_dev_mode_movement(delta):
	var move_dir = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("move_forward"):
		move_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		move_dir.z += 1
	if Input.is_action_pressed("move_left"):
		move_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		move_dir.x += 1
	
	# Store the vertical movement separately
	var vertical_move = Vector3(0, 0, 0)
	if Input.is_action_pressed("jump"):
		vertical_move.y += 1
	if Input.is_action_pressed("shift"):
		vertical_move.y -= 1
	
	move_dir = move_dir.normalized() * dev_speed * delta
	vertical_move = vertical_move.normalized() * dev_speed * delta
	
	# Make the horizontal movement relative to the camera's orientation
	var camera_transform = get_parent().camera.global_transform
	move_dir = camera_transform.basis * move_dir
	
	# Combine the horizontal and vertical movements
	move_dir += vertical_move
	
	# Directly set the player's velocity
	directional_movement_script.player.velocity = move_dir
	directional_movement_script.player.move_and_slide()

