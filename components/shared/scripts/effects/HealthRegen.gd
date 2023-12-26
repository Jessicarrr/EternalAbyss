extends BaseEffect
class_name HealthRegen

func do_effect():
	super.do_effect()
	
	var hp_to_regen = self.magnitude
	var health_node = self.node_to_apply
	
	health_node.regenerate(hp_to_regen)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
