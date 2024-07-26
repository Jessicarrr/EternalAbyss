extends Node

@onready var entity = get_parent().get_parent()

func _input(_event):
	if Input.is_action_just_pressed("crouch"):
		entity.crouching = !entity.crouching
