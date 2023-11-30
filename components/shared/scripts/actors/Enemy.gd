extends Node3D
class_name Enemy

@export var visibility_range = 8
@export var walk_speed = 2

@onready var prev_pos = global_position

func has_moved():
	var cur_pos = self.global_position
	var moved = false
	
	if cur_pos.x != prev_pos.x or cur_pos.z != prev_pos.z:
		moved = true
		
	prev_pos = cur_pos
	return moved

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
