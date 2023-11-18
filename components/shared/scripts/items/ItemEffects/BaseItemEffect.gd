extends Node

var sprite : Sprite2D
var camera = null

func can_animate():
	if sprite == null:
		push_warning("Could not animate FakePhysics because sprite was not set (is null)")
		return false
	
	if sprite.has_meta("ShouldAnimate") == false:
		push_warning("Could not animate FakePhysics because control has no animating metadata")
		return false
	
	if sprite.get_meta("ShouldAnimate") == false:
		return false
		
	#print("Camera in can_animate for ", self, " is: ", camera)	
	
	if camera == null:
		push_warning("Could not animate FakePhysics because camera was not set (is null)")
		return false
		
	return true

func try_set_sprite():
	if self.get_parent() is Sprite2D:
		print("Successfully set up sprite in ", self)
		sprite = self.get_parent()
	else:
		push_error("Couldn't find sprite2d in ", self,\
		 ", tried looking at parent which is a ", self.get_parent())

func try_set_camera():
	if PlayerDataExtra.player_camera != null:
		print("Camera set in ", self, " to ", PlayerDataExtra.player_camera, " from autoloaded script")
		camera = PlayerDataExtra.player_camera
		return
	
	print("Couldn't get camera in ", self, " from autoloaded script. Setting up signal connect instead.")
	PlayerDataExtra.camera_set.connect(on_camera_ready)

# Called when the node enters the scene tree for the first time.
func _ready():
	try_set_sprite()
	try_set_camera()
	#self.set_process(false)
	
	pass # Replace with function body.
	
func _process(_delta):
	#print("Processing on ", self)
	pass

func on_camera_ready(new_camera):
	print("Camera set from signal in ", self, " to ", new_camera)
	camera = new_camera
