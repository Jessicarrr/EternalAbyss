extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerDataExtra.set_camera(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
