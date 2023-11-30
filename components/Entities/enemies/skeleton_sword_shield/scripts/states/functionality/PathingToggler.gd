# Toggle the type of pathing towards a target depending if the target can be seen
extends Node

@onready var parent = get_parent()

@onready var last_check = Time.get_ticks_msec()
var check_threshold = 2000

@onready var npc = get_node(get_meta("NPCPath"))
@onready var raycast : RayCast3D = get_node(get_meta("RayCastPhysical"))
@onready var nav_agent : NavigationAgent3D = get_node(get_meta("NavigationAgent3D"))

func maybe_change_path_type_to_target():
	if parent.entity == null:
		return
	
	var space_state = npc.get_world_3d().direct_space_state
	var origin_position = raycast.global_transform.origin
	var target_position = parent.entity.global_transform.origin
	
	var query = PhysicsRayQueryParameters3D.create(origin_position, target_position)
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		nav_agent.path_postprocessing = NavigationPathQueryParameters3D.PATH_POSTPROCESSING_EDGECENTERED
		Debug.msg(Debug.NPC_STATES, ["Cant see anything. path type: ", nav_agent.path_postprocessing])
		return
	
	var collider = result["collider"]
	var collider_parent = collider.get_parent()
	
	if collider_parent == parent.entity or collider == parent.entity:
		nav_agent.path_postprocessing = NavigationPathQueryParameters3D.PATH_POSTPROCESSING_CORRIDORFUNNEL
		Debug.msg(Debug.NPC_STATES, ["Target is in sight. path type: ", nav_agent.path_postprocessing])
	else:
		nav_agent.path_postprocessing = NavigationPathQueryParameters3D.PATH_POSTPROCESSING_EDGECENTERED
		Debug.msg(Debug.NPC_STATES, [collider_parent.get_name(), " is blocking vision of the target. path type: ", nav_agent.path_postprocessing])
	
func _physics_process(_delta):
	if parent.active == false:
		return
		
	var current_time = Time.get_ticks_msec()
	var time_passed = current_time - last_check
	
	if time_passed < check_threshold:
		return
		
	maybe_change_path_type_to_target()
	last_check = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
