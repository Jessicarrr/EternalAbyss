extends EnemyRaycast3D
class_name GhostRaycast3D

signal communicate_distance_to_ground

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

func raycast_upwards_to_find_ground(ray_length, space_state):
	var target_position = self.global_transform.origin + Vector3(0, ray_length, 0)
	
	var query = PhysicsRayQueryParameters3D.create(self.global_transform.origin, target_position)
	return space_state.intersect_ray(query)
	
func raycast_downwards_to_find_ground(ray_length, space_state):
	var target_position = self.global_transform.origin - Vector3(0, ray_length, 0)
	
	var query = PhysicsRayQueryParameters3D.create(self.global_transform.origin, target_position)
	return space_state.intersect_ray(query)

func distance_to_ground():
	if player == null:
		return 0.0
	
	var ray_length = 10
	var space_state = player.get_world_3d().direct_space_state
	
	var result = raycast_downwards_to_find_ground(ray_length, space_state)
	
	if result.is_empty():
		result = raycast_upwards_to_find_ground(ray_length, space_state)
		
		if result.is_empty() == false:
			#we found something upwards
			var name = result.collider.get_name()
			var tix = 1
		
	if result.is_empty():
		# we found nothing
		return npc.global_position.y
		
	#something was found in general
	var name = result.collider.get_name()
	var tox = 2
		
	var hit_position = result.position
	var distance = npc.global_position.y - hit_position.y  # This is the actual distance from the NPC to the ground
	
	return distance
	
func emit_distance_to_ground():
	var distance = distance_to_ground()
	communicate_distance_to_ground.emit(distance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	emit_distance_to_ground()
		
	
	
