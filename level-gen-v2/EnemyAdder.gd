extends Node

@onready var layout_node = get_node(get_meta("LayoutsNodePath"))
@onready var actors_node = get_node(get_meta("ActorsNodePath"))

func add_enemies(enemy_data):
	for enemy in enemy_data:
		var enemy_amount = enemy["NumRequired"]
		var enemy_path = enemy["Path"]
		var enemy_spawn_points = enemy["SpawnPoints"]
		
		# Pre-load the enemy scene
		var enemy_scene = load(enemy_path)
		
		for spawn_group in enemy_spawn_points:
			# Find all nodes in the specified spawn group

			for i in range(0, enemy_amount):
				var spawn_nodes = get_tree().get_nodes_in_group(spawn_group)
				
				if spawn_nodes.size() <= 0:
					push_warning("Could not add more enemies coz we ran out of spawn points")
					break  # Break out if there are no available spawn points

				var enemy_instance = enemy_scene.instantiate()
				var random_spawn_point = spawn_nodes.pick_random()
				actors_node.add_child(enemy_instance)
				enemy_instance.global_position = random_spawn_point.global_position
				var gposition = enemy_instance.global_position
				var thing = ""
				
				

				# Mark this spawn point as used
				random_spawn_point.free()

				if spawn_nodes.size() <= 0:
					push_warning("Ran out of spawn points for this enemy type.")
					break  # Break out if there are no more spawn points for this enemy type

	#if used_spawn_points.size() == 0:
	#	push_warning("Could not add enemies because there were no valid spawn points.")

func _on_generator_generation_finished(scene_resources):
	var enemy_data = scene_resources["Enemies"]
	add_enemies(enemy_data)
	pass # Replace with function body.
