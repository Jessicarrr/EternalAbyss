extends Node

signal attack_cancelled

func _ready():
	# Ensure this node is processing input
	set_process_input(true)

func _input(_event):
	# Check for the "attack" action
	if Input.is_action_pressed("attack_cancel"):
		attack_cancelled.emit()
