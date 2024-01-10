extends Npc
class_name GhostSpiritNpc

@export var visibility_range = 8.0

signal on_hit

#@onready var health = $Skills/Health

func hit(entity, weapon, damage):
	
	health.damage(damage)
	on_hit.emit(entity, weapon, damage)

# Called when the node enters the scene tree for the first time.
func _ready():	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
