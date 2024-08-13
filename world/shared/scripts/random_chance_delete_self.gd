extends Node3D
class_name SelfDeletingNode3D

@export var chance_of_deletion = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var double_chance : float = float(chance_of_deletion) / 10

	if Helpers.should_chance_succeed(double_chance):
		self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
