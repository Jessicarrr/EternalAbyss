extends SimpleEnemy
class_name ghost_spirit

@export_category("Ghost Stuff")
@export var flashing_visibility_time = 0.4
@export var flashing_invisibility_time = 0.7
@export var flashing_randomness_range = 0.1
@export var always_tangible = false

#@onready var health = $Skills/Health

func hit(entity, weapon, damage):
	
	health.damage(damage)
	on_hit.emit(entity, weapon, damage)

# Called when the node enters the scene tree for the first time.
func _ready():	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
