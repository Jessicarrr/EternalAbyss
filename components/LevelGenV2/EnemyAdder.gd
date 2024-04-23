extends Node

@onready var layout_node = get_node(get_meta("LayoutsNodePath"))
@onready var actors_node = get_node(get_meta("ActorsNodePath"))

func add_enemies(enemy_data, spawn_points):
	var spawn_points_used_up = false
	
	for enemy in enemy_data:
		var enemy_amount = enemy["NumRequired"]
		var enemy_path = enemy["Path"]
		
		if spawn_points_used_up == true:
			Debug.msg(Debug.NPC_GENERATION, ["Could not add more enemies coz we ran out of spawn points"])
			push_warning("Could not add more enemies coz we ran out of spawn points")
			break
		
		var enemy_scene = load(enemy_path)
		
		for i in range(0, enemy_amount):
			if spawn_points.size() <= 0:
				spawn_points_used_up = true
				break
			
			var enemy_instance = enemy_scene.instantiate()
			var random_spawn_point = spawn_points[randi() % spawn_points.size()]
			enemy_instance.position = random_spawn_point.global_position
			actors_node.add_child(enemy_instance)
			spawn_points.erase(random_spawn_point)

func get_spawn_points():
	var spawn_points = []
	
	if layout_node == null:
		await get_tree().process_frame
		
	for child in layout_node.get_children():
		for grandchild in child.get_children():
			
			if grandchild.is_in_group("EnemySpawnPoint"):
				Debug.msg(Debug.NPC_GENERATION, ["Found an enemy spawn point, ", grandchild])
				spawn_points.append(grandchild)
	
	return spawn_points

func _on_generator_generation_finished(scene_resources):
	var spawn_points = await get_spawn_points()
	
	if spawn_points.size() <= 0:
		Debug.msg(Debug.NPC_GENERATION, ["Could not add any enemies coz there was no enemy spawn points"])
		return
	
	var enemy_data = scene_resources["Enemies"]
	add_enemies(enemy_data, spawn_points)
	pass # Replace with function body.
