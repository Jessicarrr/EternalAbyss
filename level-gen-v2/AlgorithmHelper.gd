extends Node

# These are utility functions that are not tightly coupled with the main algorithm.

func are_objs_adjacent(obj1, obj2):
	var pos1 = obj1.global_transform.origin
	var pos2 = obj2.global_transform.origin
	
	var tolerance = 0.01  # A small number to account for floating-point errors
	
	if abs(pos1.x - pos2.x) < tolerance and abs(pos1.y - pos2.y) < tolerance and abs(pos1.z - pos2.z) < tolerance:
		return true
	return false

# New function to check if the orientation of two walls is the same
func have_same_orientation(wall1, wall2):
	# Get the rotation of each wall
	var rot1 = wall1.rotation_degrees
	var rot2 = wall2.rotation_degrees
	
	# Compare the rotations
	return rot1 == rot2

func has_overlapping_areas(new_room):
	var area3d = new_room.get_node_or_null("Bounds")
	
	if area3d == null:
		Debug.msg(Debug.GENERATION_COLLISION, ["Tried to check overlapping areas with a room but there was no Bounds node found."])
		push_error("Tried to check overlapping areas with a room but there was no Bounds node found.")
		return false
	
	var overlapping_areas = area3d.get_overlapping_areas()
	
	for area in overlapping_areas:
		# Skip if the overlapping area is a child of new_room
		if new_room.is_ancestor_of(area):
			continue
			
		if area.name != "Bounds":
			continue
		
		# If we reach this point, we've found an overlapping area that is not a child of new_room
		Debug.msg(Debug.GENERATION_COLLISION, ["Collision detection found overlapping area called ", area.name, ", when placing room ", new_room.get_path()])
		Debug.msg(Debug.GENERATION_COLLISION, ["New room bounds pos: ", area3d.global_position, ", and existing overlapping bounds position: ", area.global_position])
		return true
	
	return false


func is_close_to_another_room(minimum_distance, new_room, placed_rooms):
	var new_room_center = new_room.get_node("Bounds").global_transform.origin
	var new_room_extents = new_room.get_node("Bounds/CollisionShape3D").shape.extents
	var new_room_type = new_room.get_meta("RoomType")

	for room_dict in placed_rooms:
		var room = room_dict["Instance"]
		var compared_room_type = room_dict["RoomType"]
		var compared_room_center = room.get_node("Bounds").global_transform.origin
		var compared_room_extents = room.get_node("Bounds/CollisionShape3D").shape.extents

		# Set extra padding based on room type
		var extra_padding = 0 if compared_room_type == "Hallway" or new_room_type == "Hallway" else minimum_distance

		var distance_between_rooms = new_room_center.distance_to(compared_room_center)
		
		# Calculate the "acceptable distance" based on the dimensions of both rooms along each axis
		var acceptable_distance_x = new_room_extents.x + compared_room_extents.x + extra_padding
		var acceptable_distance_y = new_room_extents.y + compared_room_extents.y + extra_padding
		var acceptable_distance_z = new_room_extents.z + compared_room_extents.z + extra_padding

		var delta = new_room_center - compared_room_center
		var delta_abs = delta.abs()

		if delta_abs.x < acceptable_distance_x and delta_abs.y < acceptable_distance_y and delta_abs.z < acceptable_distance_z:
			if new_room_type == "PrisonCell":
				print_collision_debug_info(new_room_type, compared_room_type, new_room_center, new_room_extents, compared_room_center, compared_room_extents, acceptable_distance_x, acceptable_distance_y, acceptable_distance_z, distance_between_rooms, extra_padding)
			return true  # Collision detected

	print("No collision detected with ", new_room_type)
	return false  # No collision

func print_collision_debug_info(new_room_type, compared_room_type, new_room_center, new_room_extents, compared_room_center, compared_room_extents, acceptable_distance_x, acceptable_distance_y, acceptable_distance_z, distance_between_rooms, extra_padding):
	Debug.msg(Debug.GENERATION_COLLISION, ["Checking collision between ", new_room_type, " and ", compared_room_type])
	Debug.msg(Debug.GENERATION_COLLISION, [new_room_type, ": center position: ", new_room_center, ", extents: ", new_room_extents])
	Debug.msg(Debug.GENERATION_COLLISION, [compared_room_type, ": center position: ", compared_room_center, ", extents: ", compared_room_extents])
	Debug.msg(Debug.GENERATION_COLLISION, ["Acceptable distances - X: ", acceptable_distance_x, ", Y: ", acceptable_distance_y, ", Z: ", acceptable_distance_z])
	Debug.msg(Debug.GENERATION_COLLISION, ["Actual distance: ", distance_between_rooms, ", extra padding: ", extra_padding])

func check_room_parts_collide(new_room):
	return _check_collision_recursive(new_room, new_room)

func _check_collision_recursive(root, current_node):
	# Loop through each child of the current_node
	for child in current_node.get_children():
		# Skip if the child has the meta "ConnectionPointUsed" set to true
		if child.has_meta("ConnectionPointUsed") == true:
			#Debug.msg(Debug.GENERATION_COLLISION, ["Skipping child with ConnectionPointUsed: ", child.name])
			continue

		# Check if the child has a StaticBody3D as a direct child
		var static_body = child.get_node_or_null("StaticBody3D")
		if static_body != null:
			# Get the CollisionShape3D node
			var collision_shape = static_body.get_node_or_null("CollisionShape3D")
			if collision_shape != null:
				#Debug.msg(Debug.GENERATION_COLLISION, ["Checking collision for: ", child.name])
				# Check for collisions
				var overlapping_bodies = static_body.get_overlapping_bodies()
				for body in overlapping_bodies:
					# Skip if the colliding body is part of the root (new_room)
					if root.is_a_parent_of(body):
						#Debug.msg(Debug.GENERATION_COLLISION, ["Ignoring collision with part of new_room: ", body.name])
						continue

					# If we reach this point, we've found a collision with something outside of new_room
					Debug.msg(Debug.GENERATION_COLLISION, ["Collision detected between ", child.name, " and ", body.name])
					return true

		# Recursive call to check children of the current child
		if _check_collision_recursive(root, child):
			return true

	# If we reach this point, no collisions were found
	Debug.msg(Debug.GENERATION_COLLISION, ["No collision detected for: ", current_node])
	return false




func room_hitboxes_collide(new_room, placed_rooms):
	var new_room_bounds = new_room.get_node("Bounds").global_transform.origin
	var new_room_extents = new_room.get_node("Bounds/CollisionShape3D").shape.extents
	var isNewRoomAdmin = new_room.name == "Administration"
	var room_type
	var distance_between_rooms
	var extra_padding = 2.0  # Extra meters for padding
	var dynamic_distance_threshold

	for room_dictionary in placed_rooms:
		var room = room_dictionary["Instance"]
		room_type = room_dictionary["RoomType"]

		var room_bounds = room.get_node("Bounds").global_transform.origin
		var room_extents = room.get_node("Bounds/CollisionShape3D").shape.extents

		distance_between_rooms = new_room_bounds.distance_to(room_bounds)
		dynamic_distance_threshold = new_room_extents.length() + room_extents.length() + extra_padding

		# Debugging for Administration type and within dynamic distance
		if (room_type == "Administration" or isNewRoomAdmin) and distance_between_rooms < dynamic_distance_threshold:
			print("Debugging for Administration room:")
			print("New room bounds: ", new_room_bounds)
			print("New room extents: ", new_room_extents)
			
			print("Compared room bounds: ", room_bounds)
			print("Compared room extents: ", room_extents)

			if (abs(new_room_bounds.x - room_bounds.x) < (new_room_extents.x + room_extents.x)) and \
			   (abs(new_room_bounds.y - room_bounds.y) < (new_room_extents.y + room_extents.y)) and \
			   (abs(new_room_bounds.z - room_bounds.z) < (new_room_extents.z + room_extents.z)):
				if (room_type == "Administration" or isNewRoomAdmin) and distance_between_rooms < dynamic_distance_threshold:
					print("Collision detected with Administration room.")
				return true  # Collision detected

	# This part will execute after the for loop has finished
	if (room_type == "Administration" or isNewRoomAdmin) and distance_between_rooms < dynamic_distance_threshold:
		print("No collision detected with Administration room.")
	return false  # No collision




func collides_with_another_room_nodebug(new_room, placed_rooms):
	var new_room_bounds = new_room.get_node("Bounds").global_transform.origin
	var new_room_extents = new_room.get_node("Bounds/CollisionShape3D").shape.extents

	for room_dictionary in placed_rooms:
		var room = room_dictionary["Instance"]
		#Invalid get index '{ "RoomType": "Hallway", "Instance": Hallway:<Node3D#33671873781> }' (on base: 'Array').
		var room_bounds = room.get_node("Bounds").global_transform.origin
		var room_extents = room.get_node("Bounds/CollisionShape3D").shape.extents

		if (abs(new_room_bounds.x - room_bounds.x) < (new_room_extents.x + room_extents.x)) and \
		   (abs(new_room_bounds.y - room_bounds.y) < (new_room_extents.y + room_extents.y)) and \
		   (abs(new_room_bounds.z - room_bounds.z) < (new_room_extents.z + room_extents.z)):
			return true  # Collision detected

	return false  # No collision

func align_transform(new_room, connection_new, connection_old):
	print("Aligning transform...")
	
	var new_connection_global_position = connection_new.global_transform.origin
	var old_connection_global_position = connection_old.global_transform.origin
	
	#print("Initial new connection global position: " + str(new_connection_global_position))
	#print("Initial old connection global position: " + str(old_connection_global_position))
	
	var translation_vector = old_connection_global_position - new_connection_global_position
	#print("Calculated translation vector: " + str(translation_vector))
	
	new_room.global_transform.origin += translation_vector
	
	new_connection_global_position = connection_new.global_transform.origin
	old_connection_global_position = connection_old.global_transform.origin
	
	#print("Updated new connection global position: " + str(new_connection_global_position))
	#print("Updated old connection global position: " + str(old_connection_global_position))
	
func align_rotationally(new_room, connection_new, connection_old):
	# Get the global rotations of the connection points
	var new_rotation = connection_new.global_transform.basis.get_euler()
	var old_rotation = connection_old.global_transform.basis.get_euler()
	
	#print("Initial new connection global rotation: " + str(new_rotation))
	#print("Initial old connection global rotation: " + str(old_rotation))
	
	# Calculate the rotation difference for the Y-axis
	var rotation_difference_y = old_rotation.y - new_rotation.y
	
	# Convert the rotation difference to degrees
	rotation_difference_y = rad_to_deg(rotation_difference_y)
	
	#print("Rotation difference (degrees) on Y-axis: " + str(rotation_difference_y))
	
	# Get the current global transform of the new room
	var gt = new_room.global_transform
	
	# Create a new Transform object with the desired rotation
	var new_rotation_transform = Transform3D.IDENTITY.rotated(Vector3(0, 1, 0), deg_to_rad(rotation_difference_y))
	
	# Apply the new rotation to the global transform
	new_room.global_transform = new_rotation_transform * gt
	
	# Rotate the new room by 180 degrees to make the walls face each other
	new_rotation_transform = Transform3D.IDENTITY.rotated(Vector3(0, 1, 0), deg_to_rad(180))
	new_room.global_transform = new_rotation_transform * new_room.global_transform
	
	# Fetch the updated global rotations for debugging
	new_rotation = connection_new.global_transform.basis.get_euler()
	old_rotation = connection_old.global_transform.basis.get_euler()
	
	#print("Updated new connection global rotation: " + str(new_rotation))
	#print("Updated old connection global rotation: " + str(old_rotation))
	
func remove_overlapping_welders():
	var welders = []
	
	var root_of_current_scene = self
	while root_of_current_scene.get_parent() != null:
		root_of_current_scene = root_of_current_scene.get_parent()
	
	_find_welders(root_of_current_scene, welders)
	
	for i in range(welders.size()):
		var welder1 = welders[i]
		for j in range(i + 1, welders.size()):
			var welder2 = welders[j]
			if are_objs_adjacent(welder1, welder2):
				welder2.queue_free()
				welders.erase(j)
				j -= 1  # Adjust the index after removal

func _find_welders(node, welders):
	if "welder" in node.name.to_lower():
		welders.append(node)
	for child in node.get_children():
		_find_welders(child, welders)

func filter_array_by_key_value(arr: Array, key: String, value, inverse: bool = false) -> Array:
	var filtered_array = []
	for item in arr:
		if (item[key] == value) == !inverse:
			filtered_array.append(item)
	return filtered_array

