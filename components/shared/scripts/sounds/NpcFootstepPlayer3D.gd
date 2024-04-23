extends RandomStreamPlayer3D
class_name NpcFootstepPlayer3D

@export var animation_name = ""
@export var animation_frames = [1, 2]

@export var animated_sprite_path : NodePath = ""
var sprite : AnimatedSprite3D

var current_animation = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	sprite = Helpers.try_load_node(self, animated_sprite_path)
	
	sprite.animation_changed.connect(_animation_changed)
	sprite.frame_changed.connect(_frame_changed)
	
	self.bus = "ReverbBus"
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _animation_changed():
	if sprite == null:
		return
		
	current_animation = sprite.animation
	
func _frame_changed():
	if current_animation != animation_name:
		return
		
	if sprite.frame in animation_frames:
		play_random()
