extends CollisionShape3D

@onready var player = get_parent()

@onready var default_height = self.shape.height
@onready var default_position = self.transform.origin

var crouched_position = Vector3(0, 0.0, 0)
var crouched_height = 0.95

func _on_crouch_start():
	self.transform.origin = crouched_position
	self.shape.height = crouched_height
	pass
	
func _on_crouch_ended():
	self.transform.origin = default_position
	self.shape.height = default_height
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	player.crouch_started.connect(_on_crouch_start)
	player.crouch_ended.connect(_on_crouch_ended)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
