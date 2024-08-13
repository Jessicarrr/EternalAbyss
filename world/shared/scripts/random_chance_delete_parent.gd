extends Node
class_name RandomChanceDeleteParent

@export var chance_of_deletion = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var double_chance : float = float(chance_of_deletion) / 10

	if Helpers.should_chance_succeed(double_chance):
		get_parent().queue_free()

