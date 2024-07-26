extends Node

@export var door_node : NodePath = ""
@export var connection_points_node : NodePath = ""
var door_instance = null
var connection_points_instance = null

var connection_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if not door_node:
		print("not door node")
		return
		
	if not connection_points_node:
		print("Not connection points node")
		return
		
	door_instance = get_node(door_node)
	connection_points_instance = get_node(connection_points_node)
	connection_points = get_connection_points()
	connect_to_signal(connection_points)
	pass # Replace with function body.

func on_tree_exited(thing):
	door_instance.duplicate()
	door_instance.position = thing.position
	door_instance.rotation.y = thing.rotation.y + deg_to_rad(90)
	door_instance.visible = true
	door_instance.set_process(true)

func connect_to_signal(points):
	for point in points:
		point.tree_exiting.connect(on_tree_exited.bind(point))

func get_connection_points():
	var gathered_points = []
	
	for child in connection_points_instance.get_children():
		if child == self:
			continue
			
		if child.has_meta("PercentChanceOfDoor") == false:
			continue
			
		gathered_points.append(child)
		
	return gathered_points
