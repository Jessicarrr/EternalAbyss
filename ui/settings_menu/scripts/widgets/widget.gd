extends HBoxContainer
class_name Widget

@export var option_node : Node
@export var label : Node

signal widget_value_changed

func _ready():
	if label == null:
		label = get_node("Label")

func get_value():
	pass


func set_value(the_value):
	if self.is_node_ready() == false:
		await self.ready