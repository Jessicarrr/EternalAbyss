extends ColorRect

@export var damaged_opacity = 1.0
@export var min_opacity = 0.0
@export var current_opacity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.material.set_shader_parameter("vignette_opacity", current_opacity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_opacity >= min_opacity:
		current_opacity -= 0.01
		self.material.set_shader_parameter("vignette_opacity", current_opacity)


func _on_hit(entity, damage):
	current_opacity = damaged_opacity
	self.material.set_shader_parameter("vignette_opacity", current_opacity)
