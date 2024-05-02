extends InteractableObject
class_name Door

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_lookat_text():
	if self.has_meta("lookat_text") == true:
		return self.get_meta("lookat_text")
	return "Door"

func interact():
	pass
