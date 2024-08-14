extends Node3D
class_name DependentNode3D

@export var dependencies : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for dependency in dependencies:
		dependency.tree_exited.connect(_on_dependency_tree_exited)

func _on_dependency_tree_exited():
	self.queue_free()
