extends Node

signal failed_placement
signal successful_placement
signal finished_generation

@onready var hallway_gen = $HallwayGen

var scene_data = {}
var hallway_data = {}

var placed_rooms = []


@export_category("Generation Settings")
@export var min_hallways_before_turn = 5
@export var percent_chance_of_hallway_turning = 10
@export var total_hallways_to_create = 30

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
# If more or equal, start placing other stuff, maybe in order of size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_data(data):
	scene_data = data
	hallway_data = data["Hallway"]
	hallway_gen.add_data(hallway_data)

func append_placed_room(room_type: String, room_instance):
	placed_rooms.append({
		"RoomType" : room_type,
		"Instance" : room_instance
	})
	
func get_num_hallways():
	var count = 0
	
	for room in placed_rooms:
		if room["RoomType"] == "Hallway":
			count += 1
			
	return count
	
func are_walls_adjacent(wall1, wall2):
	var pos1 = wall1.global_transform.origin
	var pos2 = wall2.global_transform.origin
	
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

	
func remove_walls_between_hallways():
	for i in range(len(placed_rooms)):
		var hallway1 = placed_rooms[i]
		if hallway1["RoomType"] != "Hallway":
			continue
		
		var instance1 = hallway1["Instance"]
		var walls1 = instance1.get_node("ConnectionPoints").get_children()
		
		for j in range(i + 1, len(placed_rooms)):
			var hallway2 = placed_rooms[j]
			if hallway2["RoomType"] != "Hallway":
				continue
			
			var instance2 = hallway2["Instance"]
			var walls2 = instance2.get_node("ConnectionPoints").get_children()
			
			for wall1 in walls1:
				for wall2 in walls2:
					# Check if walls are adjacent and have the same orientation
					if are_walls_adjacent(wall1, wall2) and !have_same_orientation(wall1, wall2):
						# Remove or hide the walls
						wall1.queue_free()
						wall2.queue_free()

func generate_next():
	if get_num_hallways() < total_hallways_to_create:
		await hallway_gen.generate_next(placed_rooms)
	else:
		print("Total hallways placed: " + str(get_num_hallways()))
		remove_walls_between_hallways()
		finished_generation.emit()


func _on_hallway_gen_placed_hallway(hallway_instance):
	append_placed_room("Hallway", hallway_instance)
	successful_placement.emit()
