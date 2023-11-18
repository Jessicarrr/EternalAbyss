extends Node3D

@export var maybe_flip: bool = true
@export var vary_scale: bool = true
@export var max_scale_variance = 0.005

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		if child is Sprite3D:
			var rng = RandomNumberGenerator.new()
	
			if vary_scale == true:
				var scale_variation = rng.randf_range(-max_scale_variance, max_scale_variance)
				child.pixel_size += scale_variation
				
			if maybe_flip == true:
				var chance = rng.randi_range(0, 100)
				if chance <= 50:
					child.flip_h = true
