extends Node3D

@export var camera : Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.global_position = camera.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.rotation = camera.rotation
	
	pass
