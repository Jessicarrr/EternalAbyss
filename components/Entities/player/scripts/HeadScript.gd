extends Node3D

@onready var player = get_parent()
@onready var default_position = self.position
var crouched_position = Vector3(0, 0.23, 0)
var crouched = false
var tween

func create_new_tween(parallel, tween_type):
	if tween != null:
		if tween.is_running():
			tween.stop()
			
	tween = get_tree().create_tween()
	tween.set_parallel(parallel)
	tween.set_ease(tween_type)

func _on_crouch_started():
	create_new_tween(true, Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", crouched_position, player.crouch_transition_time)
	crouched = true
	
func _on_crouch_ended():
	create_new_tween(true, Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", default_position, player.crouch_transition_time)
	crouched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.crouch_started.connect(_on_crouch_started)
	player.crouch_ended.connect(_on_crouch_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
