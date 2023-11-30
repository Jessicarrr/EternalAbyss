extends Node
class_name StaggerDetector

@onready var parent = get_parent()
@export var npc_path : NodePath = ""
var npc = null

func _on_hit(entity, weapon, damage):
	if parent.active == false:
		return
	
	if npc == null:
		return
		
	var stagger_time = npc.calculate_stagger_time(damage)
	
	parent.request_state_change.emit(parent, Enums.ActorStates.STAGGERED, {
		"Damage" : damage,
		"StaggerTime" : stagger_time,
	})

func _ready():
	if not npc_path:
		push_error(self, " requires an npc to be set.")
		return
		
	npc = get_node_or_null(npc_path)
