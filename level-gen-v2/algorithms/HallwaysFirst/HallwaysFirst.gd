extends "res://level-gen-v2/AlgorithmHelper.gd"

var is_generating = false

@onready var rng = RandomNumberGenerator.new()

var scene_data = {}
var hallway_data = {}

var placed_rooms = []
var hallway_direction : Vector3 = Vector3(1, 0, 0)
var previous_hallway_coords : Vector3 = Vector3(0, 0, 0)

var placements_without_turning = 0

var removed_overlapping_hallways = false

@export_category("Generation Settings")
@export var min_hallways_before_turn = 5
@export var percent_chance_of_hallway_turning = 10
@export var total_hallways_to_create = 30
@export var min_distance_between_rooms = 0.1

var layout_path = self

#Logical steps:
# Place first hallway
# Count hallways placed before turn += 1
# If hallways in a row before turn > 5, low chance of changing direction
# Place hallway in the next direction
# Find north facing wall of old hallway
# Find south facing wall of new hallway
# Delete both
# Append 'Hallway' to placed_rooms
# Check scene_data for how many hallways are needed
# Check placed_rooms for how many hallways there are
# If less hallways, go to step 3
# If more or equal hallways, continue
# Loop thru and check scene_data[x] to see what room comes up (exclude hallways)
# Check how many rooms of that type already exist
# If less, try to place that room
# Check collisions of that room, if it sucks, remove it. Emit failure signal
# If all done, emit signal taht we're done

func add_data(data):
	scene_data = data
	hallway_data = data["Hallway"]
	
func set_path(node):
	layout_path = node

func get_next_hallway_direction():
	var direction_map = {
		Vector3(1, 0, 0): Vector3(0, 0, rng.randf_range(-1, 1)),  # Forward
		Vector3(-1, 0, 0): Vector3(0, 0, rng.randf_range(-1, 1)),  # Backward
		Vector3(0, 0, 1): Vector3(rng.randf_range(-1, 1), 0, 0),  # Right
		Vector3(0, 0, -1): Vector3(rng.randf_range(-1, 1), 0, 0)  # Left
	}
	
	hallway_direction = direction_map.get(hallway_direction, Vector3.ZERO).normalized()

func get_next_hallway_position():
	return previous_hallway_coords + (hallway_direction * 2)

func build_hallway():
	var instanced_hallway = load(hallway_data["Path"]).instantiate()
	layout_path.add_child(instanced_hallway)
	await get_tree().process_frame
	
	if placed_rooms.size() > 0:
		var next_hallway_position = get_next_hallway_position()
		instanced_hallway.global_transform.origin = next_hallway_position
		previous_hallway_coords = next_hallway_position
	
	return instanced_hallway

func append_placed_room(room_type: String, room_instance):
	placed_rooms.append({
		"RoomType" : room_type,
		"Instance" : room_instance
	})
	
func get_num_hallways():
	return get_instances_of_room_type("Hallway").size()

func remove_walls_between_halls_and_rooms():
	var hallways = filter_array_by_key_value(placed_rooms, "RoomType", "Hallway")
	var rooms = filter_array_by_key_value(placed_rooms, "RoomType", "Hallway", true)
	
	for hallway in hallways:
		var hall_instance = hallway["Instance"]
		var walls1 = hall_instance.get_node("ConnectionPoints").get_children()
		
		for room in rooms:
			var instance2 = room["Instance"]
			var walls2 = instance2.get_node("ConnectionPoints").get_children()
			
			for wall1 in walls1:
				for wall2 in walls2:
					# Check if walls are adjacent and have the same orientation
					if are_objs_adjacent(wall1, wall2):
						# Remove or hide the walls
						wall1.queue_free()
						wall2.queue_free()
	
func remove_walls_between_hallways():
	for i in range(len(placed_rooms)):
		var hallway1 = placed_rooms[i]
		if hallway1["RoomType"] != "Hallway":
			continue

		var walls1 = hallway1["Instance"].get_node("ConnectionPoints").get_children()

		for j in range(i + 1, len(placed_rooms)):
			var hallway2 = placed_rooms[j]
			if hallway2["RoomType"] != "Hallway":
				continue

			var walls2 = hallway2["Instance"].get_node("ConnectionPoints").get_children()

			for wall1 in walls1:
				for wall2 in walls2:
					# Check if walls are adjacent and have the same orientation
					if are_objs_adjacent(wall1, wall2) and !have_same_orientation(wall1, wall2):
						# Remove or hide the walls
						wall1.queue_free()
						wall2.queue_free()

func get_dictionary_instances_of_room_type(room_type: String) -> Array:
	var result = []
	for room in placed_rooms:
		if room["RoomType"] == room_type:
			result.append(room)
	return result


func get_instances_of_room_type(type):
	var rooms = []
	
	for room in placed_rooms:
		if room["RoomType"] == type:
			rooms.append(room["Instance"])
			
	return rooms

func get_insufficiently_placed_room():
	for scene in scene_data.keys():
		var scene_val = scene_data[scene]
		
		if scene == "Hallway":
			continue
			
		var num_required = scene_val["NumRequired"]
		var num_existing = get_instances_of_room_type(scene).size()
		
		print("For ", scene, ", num needed: ", str(num_required), " and num existing ", str(num_existing))
		
		if num_required > num_existing:
			return scene

	return null

func get_random_connection_point(hallway_instance):
	var connection_points_node = hallway_instance.get_node("ConnectionPoints")
	var num_points = connection_points_node.get_child_count()
	
	if num_points == 0:
		return null  # No connection points available
	
	var random_index = randi() % num_points
	return connection_points_node.get_child(random_index)

func place_room(type):
	var room_data = scene_data[type]
	print("Trying to place room " + type)
	var loaded_room = load(room_data["Path"])
	var instanced_room = loaded_room.instantiate()
	
	layout_path.add_child(instanced_room)
	await get_tree().process_frame
	
	var all_hallways = get_instances_of_room_type("Hallway")
	
	var rando_hallway = all_hallways[randi() % all_hallways.size()]
	
	var rando_hall_wall = get_random_connection_point(rando_hallway)
	var rando_room_wall = get_random_connection_point(instanced_room)
	
	if rando_hall_wall == null or rando_room_wall == null:
		print("ERROR: Could not find a connection point anymore.")
		print("Hall connection : " + str(rando_hall_wall) +\
		 ", room connection " + str(rando_room_wall))
		instanced_room.queue_free()
		return false
		
	
	align_rotationally(instanced_room,\
	 rando_room_wall, rando_hall_wall)
	align_transform(instanced_room,\
	 rando_room_wall, rando_hall_wall)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	if has_overlapping_areas(instanced_room):
		instanced_room.queue_free()
		print("Failed at placing room " + type + " because it collided.")
		return false
	
	print("Succeeded at placing rando room " + type)
	append_placed_room(type, instanced_room)
	return true

func maybe_turn_hallway():
	if placements_without_turning >= min_hallways_before_turn and rng.randf_range(0.0, 100.0) < percent_chance_of_hallway_turning:
		get_next_hallway_direction()
		placements_without_turning = 0

func place_hallway():
	maybe_turn_hallway()
	var hallway = await build_hallway()
	append_placed_room("Hallway", hallway)
	placements_without_turning += 1
	return GenerationConstants.finished_step

func finalize_generation():
	print("Finished placing all rooms")
	remove_walls_between_halls_and_rooms()

func place_misc_room():
	var next_misc_room = get_insufficiently_placed_room()
	if next_misc_room == null:
		finalize_generation()
	else:
		print("Not enough rooms placed yet. we still gotta place a " + next_misc_room)
		var result = await place_room(next_misc_room)
		
		if result == true:
			return GenerationConstants.finished_step
		else:
			return GenerationConstants.failed_step

func is_room_instance_gone(room_instance):
	if room_instance == null or room_instance.is_inside_tree() == false:
		return true
		
	return false

func remove_freed_rooms_from_array():
	var rooms_to_remove = []
	
	# Iterate over placed_rooms to identify freed hallways
	for hallway_dict in placed_rooms:
		var instance = hallway_dict["Instance"]
		
		if is_room_instance_gone(instance):
			rooms_to_remove.append(hallway_dict)
			
	# Remove the identified hallways from placed_rooms
	for room_dict in rooms_to_remove:
		placed_rooms.erase(room_dict)


func remove_overlapping_hallways():
	var should_keep_removing = true
	var starting_num_hallways = get_instances_of_room_type("Hallway").size()
	var iteration_count = 0  # Counter for the number of iterations
	var max_iterations = starting_num_hallways  # Maximum allowed iterations, for safety

	Debug.msg(Debug.GENERATION_COLLISION, ["Checking ", starting_num_hallways, " hallways for overlaps and removing overlapping hallways..."])
	
	while should_keep_removing and iteration_count < max_iterations:
		var all_hallways = get_dictionary_instances_of_room_type("Hallway")
		var found_overlaps = false  # Reset for each iteration

		for hallway_dict in all_hallways:
			var hallway = hallway_dict["Instance"]
			
			if is_room_instance_gone(hallway):
				continue
			
			var area_3d = hallway.get_node_or_null("Bounds")
			
			if area_3d == null:
				push_error("Found a hallway with no bounds node?? called ", hallway)
				return
				
			var overlapping_areas = area_3d.get_overlapping_areas()
			
			if overlapping_areas.size() > 0:
				#Debug.msg(Debug.GENERATION_COLLISION, ["Found overlap with hallway: ", hallway])
				found_overlaps = true
				
				for overlapping_area in overlapping_areas:
					var hallway_root = overlapping_area.get_parent()

					# Check if the overlapping hallway is the same as the current hallway
					if hallway_root == hallway:
						Debug.msg(Debug.GENERATION_COLLISION, ["Didn't remove overlapping hallway because it belongs to the hallway in question."])
						continue  # Skip to the next iteration

					hallway_root.free()
					# Uncomment the await lines if necessary
					# await get_tree().process_frame
					# await get_tree().process_frame

		# After checking all hallways for overlaps
		remove_freed_rooms_from_array()

		# If no overlaps were found in the entire iteration
		if not found_overlaps:
			should_keep_removing = false

		iteration_count += 1

	if iteration_count >= max_iterations:
		Debug.msg(Debug.GENERATION_COLLISION, ["Reached maximum iterations. Potential infinite loop detected."])

	var ending_num_hallways = get_instances_of_room_type("Hallway").size()
	Debug.msg(Debug.GENERATION_COLLISION, ["Finished removing overlapping hallways. We removed ", starting_num_hallways - ending_num_hallways, " hallways."])



func generate_next():
	if get_num_hallways() < total_hallways_to_create:
		return await place_hallway()  # Await and return the constant
		
	if removed_overlapping_hallways == false:
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await remove_overlapping_hallways()
		removed_overlapping_hallways = true
		return GenerationConstants.finished_step
		
	if get_insufficiently_placed_room() != null:
		remove_walls_between_hallways()
		return await place_misc_room()  # Await and return the constant
	
	finalize_generation()
	return GenerationConstants.finished_generation  # Return the constant directly

	

		
		
