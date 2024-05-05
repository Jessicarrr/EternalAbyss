extends InteractableObject
class_name Door

enum RelativePosition {
	BACK,
	FRONT,
	BOTH,
	NONE
}

var starting_rotation_door = Vector3(0, 0, 0)

@export var open_rotation_opened_from_front = -93.6
@export var open_rotation_opened_from_back = 93.6
@export var time_to_open_s = 0.85

@export var door_node_path : NodePath
var door_node

@export var front_area3d_node_path : NodePath
var front_area3d : Area3D

@export var back_area3d_node_path : NodePath
var back_area3d : Area3D

var is_door_open = false
@export var locked = false

var tween : Tween
var is_moving = false
signal started_moving
signal ended_moving
signal started_opening
signal started_closing

# Called when the node enters the scene tree for the first time.
func _ready():
	door_node = Helpers.try_load_node(self, door_node_path)
	
	back_area3d = Helpers.try_load_node(self, back_area3d_node_path)
	front_area3d = Helpers.try_load_node(self, front_area3d_node_path)
	
	starting_rotation_door = door_node.rotation
	
func create_new_tween():
	if tween != null:
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

func get_lookat_text():
	if self.has_meta("lookat_text") == true:
		return self.get_meta("lookat_text")
	return "Door"
	
func get_relative_position_of_interactor(interactor):
	var front_entities = front_area3d.get_overlapping_bodies()
	var back_entities = back_area3d.get_overlapping_bodies()
	var in_front = false
	var in_back = false
	
	for entity in front_entities:
		var parent = entity.get_parent()
		
		if interactor == parent or interactor == entity:
			in_front = true
			break
			
	for entity in back_entities:
		var parent = entity.get_parent()
		
		if interactor == parent or interactor == entity:
			in_back = true
			break
	
	if in_front == true and in_back == true:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["interactor ", interactor.get_name(), " found at both back n front"])
		return RelativePosition.BOTH
		
	if in_front == true:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["interactor ", interactor.get_name(), " found at front of door."])
		return RelativePosition.FRONT
		
	if in_back == true:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["interactor ", interactor.get_name(), " found at back of door"])
		return RelativePosition.BACK
		
	Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["interactor ", interactor.get_name(), " could not be found in the front or back area3d of door."])
	return RelativePosition.NONE

func open_instant(interactor_entity):
	print("Opening door...")
	var relative_position = get_relative_position_of_interactor(interactor_entity)
	
	if relative_position == RelativePosition.FRONT:
		door_node.rotate_y(deg_to_rad(open_rotation_opened_from_front))
	elif relative_position == RelativePosition.BACK:
		door_node.rotate_y(deg_to_rad(open_rotation_opened_from_back))
	else:
		door_node.rotate_y(deg_to_rad(open_rotation_opened_from_front))
	
	is_door_open = true
	
func open(interactor_entity):
	if is_moving == true:
		return
	
	print("Opening door...")
	var relative_position = get_relative_position_of_interactor(interactor_entity)
	create_new_tween()
	
	if relative_position == RelativePosition.FRONT:

		tween.tween_property(door_node, "rotation", 
			Vector3(door_node.rotation.x, deg_to_rad(open_rotation_opened_from_front), door_node.rotation.z), time_to_open_s)
		#door_node.rotate_y(deg_to_rad(open_rotation_opened_from_front))
		#static_body_node.rotate_y(deg_to_rad(open_rotation_opened_from_front))
	elif relative_position == RelativePosition.BACK:
		tween.tween_property(door_node, "rotation", 
			Vector3(door_node.rotation.x, deg_to_rad(open_rotation_opened_from_back), door_node.rotation.z), time_to_open_s)
		#door_node.rotate_y(deg_to_rad(open_rotation_opened_from_back))
		#static_body_node.rotate_y(deg_to_rad(open_rotation_opened_from_back))
	else:
		tween.tween_property(door_node, "rotation", 
			Vector3(door_node.rotation.x, deg_to_rad(open_rotation_opened_from_front), door_node.rotation.z), time_to_open_s)
		#door_node.rotate_y(deg_to_rad(open_rotation_opened_from_front))
		#static_body_node.rotate_y(deg_to_rad(open_rotation_opened_from_front))
	
	tween.play()
	is_door_open = true	
	started_opening.emit()
	do_moving_state(time_to_open_s)

func close():
	if is_moving == true:
		return
	
	create_new_tween()
	tween.tween_property(door_node, "rotation", starting_rotation_door, time_to_open_s)
	tween.play()
	is_door_open = false
	started_closing.emit()
	do_moving_state(time_to_open_s)
	
	
func close_instant():
	print("Closing door...")
	# Close the door by resetting to the starting rotation
	door_node.rotation = starting_rotation_door
	is_door_open = false
	pass
	
func do_moving_state(time_s):
	started_moving.emit()
	is_moving = true
	
	await get_tree().create_timer(time_s).timeout
	ended_moving.emit()
	is_moving = false

func interact(interactor_entity):
	if interactor_entity == null:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Wanted to interact with door but the entity interacting with it is null?"])
		return
		
	if is_moving == true:
		return
		
	print("Initial door rotation: ", door_node.global_rotation)
	
	print("Door default rotation, as set in ready(): ", starting_rotation_door)
	
	if is_door_open:
		close()
	else:
		open(interactor_entity)
		
	# After applying rotations
	print("Updated door rotation: ", door_node.global_rotation)
	print("---")
