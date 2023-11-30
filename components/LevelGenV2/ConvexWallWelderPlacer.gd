extends Node

@export var layout_node_path : NodePath = ""
var layout

@export var welder_path := "res://models/scenes/structure/welder.tscn"
var welder_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	layout = Helpers.try_load_node(self, layout_node_path)
	welder_scene = load(welder_path)
	Debug.msg(Debug.WELDER_GEN, ["Welder Scene Loaded ", welder_scene])
	Debug.msg(Debug.WELDER_GEN, ["Layout node Loaded ", layout])

func find_walls_in_group(node, group_name, walls):
	if node.is_in_group(group_name):
		walls.append(node)
		Debug.msg(Debug.WELDER_GEN, ["Adding wall to process: ", node.name])

	for child in node.get_children():
		find_walls_in_group(child, group_name, walls)

func _on_generator_generation_finished(_data):
	pass
#	var walls = []
#	Debug.msg(Debug.WELDER_GEN, ["Total objects in layout: ", layout.get_children().size()])
#
#	# Start the recursive search for walls
#	find_walls_in_group(layout, "WeldedWall", walls)
#	Debug.msg(Debug.WELDER_GEN, ["Total walls to process: ", walls.size()])
#
#	# Find corners and place welders
#	find_and_place_welders(walls)

func find_and_place_welders(walls):
	for i in range(walls.size()):
		for j in range(i+1, walls.size()):
			# Get the endpoints of the walls
			var endpoint1_wall1 = walls[i].global_position + Vector3.FORWARD.rotated(Vector3.UP, walls[i].global_rotation.y) * 1 
			var endpoint2_wall1 = walls[i].global_position - Vector3.FORWARD.rotated(Vector3.UP, walls[i].global_rotation.y) * 1
			var endpoint1_wall2 = walls[j].global_position + Vector3.FORWARD.rotated(Vector3.UP, walls[j].global_rotation.y) * 1
			var endpoint2_wall2 = walls[j].global_position - Vector3.FORWARD.rotated(Vector3.UP, walls[j].global_rotation.y) * 1

			var corner_points = [endpoint1_wall1, endpoint2_wall1, endpoint1_wall2, endpoint2_wall2]
			# find the closest two points among these four points
			var min_dist = INF
			var corner1
			var corner2

			for k in range(corner_points.size()):
				for l in range(k+1, corner_points.size()):
					var dist = corner_points[k].distance_to(corner_points[l])
	
					if dist < min_dist:
						min_dist = dist
						corner1 = corner_points[k]
						corner2 = corner_points[l]

			# If the closest points are not from the same wall and are close enough,
			# and the y rotations are not similar, we've found a corner!
			if corner1 != corner2 and min_dist < 1.95 and not rotations_are_similar(walls[i].global_rotation.y, walls[j].global_rotation.y):
				Debug.msg(Debug.WELDER_GEN, ["Corner found ", corner1, corner2])

				var welder = welder_scene.instantiate()
				layout.add_child(welder)
				welder.global_position = walls[i].global_position
				
				welder = welder_scene.instantiate()
				layout.add_child(welder)
				welder.global_position = walls[j].global_position
				
				
				
func fmod(a, b):
	return a - b * floor(a / b)

func rotations_are_similar(rotation1, rotation2, epsilon = 0.1):
	var diff = min(
		abs(fmod(rotation1 - rotation2 + 2 * PI, 2 * PI)),
		abs(fmod(rotation2 - rotation1 + 2 * PI, 2 * PI))
	)
	return diff < epsilon
