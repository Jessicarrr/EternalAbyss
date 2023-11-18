# Extends the Base3dAnimation script, which likely contains common 3D animation logic.
extends "res://components/shared/scripts/animations/Base3dAnimation.gd"

# Automatically initializes variables upon the node's ready state.
@onready var camera = PlayerDataExtra.player_camera
@onready var player = PlayerDataExtra.player_instance
@onready var hitbox_area3d : Area3D = get_parent()
@onready var mesh = hitbox_area3d.get_node("MeshInstance3D")
@onready var collision_shape = hitbox_area3d.get_node("CollisionShape3D")

var distance_in_front = 0.08

func get_position_relative_to_center(direction, offset):
	place_obj_in_front()
	var forward_dir = camera.global_transform.basis.z.normalized() * -1
	var right_dir = camera.global_transform.basis.x.normalized()
	var up_dir = camera.global_transform.basis.y.normalized()
	var target_direction = forward_dir * direction.z + right_dir * direction.x + up_dir * direction.y
	var position = obj.global_position + target_direction * offset
	return position

func get_center_position():
	place_obj_in_front()
	return obj.global_position

func place_obj_in_front():
	obj.global_position = camera.global_position
	obj.global_rotation = camera.global_rotation
	var forward_dir = camera.global_transform.basis.z.normalized() * -1
	var new_pos = obj.global_position + forward_dir * distance_in_front
	obj.global_position = new_pos
	
func get_start_position(anim_data = {}):
	return anim_data["start_position"]
	
func get_end_position(anim_data = {}):
	return anim_data["end_position"]

func get_vertical_direction(anim_data = {}):
	var start_position = get_start_position(anim_data)
	var end_position = get_end_position(anim_data)
	
	if start_position.y > end_position.y:
		return Vector2.DOWN
	else:
		return Vector2.UP
		
func get_horizontal_direction(anim_data = {}):
	var start_position = get_start_position(anim_data)
	var end_position = get_end_position(anim_data)
	
	if start_position.x > end_position.x:
		return Vector2.LEFT
	else:
		return Vector2.RIGHT

func cancel():
	if tween != null:
		if tween.is_running():
			tween.stop()
	#toggle_hitbox(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	obj = hitbox_area3d

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_swing(_anim_node, anim_data = {}):
	if anim_data.is_empty():
		return	

# Placeholder function for recovery phase of the animation.
func _on_recovery(_anim_node, _anim_data = {}):
	pass
	
# Placeholder function for windup phase of the animation.
func _on_windup(_anim_node, _anim_data = {}):
	pass


