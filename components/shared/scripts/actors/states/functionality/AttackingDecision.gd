extends Node
class_name MeleeAttackingDecision

@onready var parent = get_parent()

@onready var last_check = Time.get_ticks_msec()
@onready var last_attack = Time.get_ticks_msec()

@export var npc_path : NodePath = ""
var npc

#@export var attack_chance = 0.2
#@export var attack_chance_interval = 500
#@export var attack_min_distance = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	npc = Helpers.try_load_node(self, npc_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent.active == false:
		return
	
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - last_check
	
	if elapsed_time < npc.attack_chance_interval:
		return
		
	last_check = Time.get_ticks_msec()
	
	if npc.global_position.distance_to(PlayerDataExtra.player_instance.global_position) > npc.attack_min_distance:
		return
		
	var elapsed_time_since_last_attack = current_time - last_attack
	
	if elapsed_time_since_last_attack/1000 < npc.min_time_between_attacks:
		return
	
	if Helpers.should_chance_succeed(npc.attack_chance) == false:
		return
		
	last_attack = Time.get_ticks_msec()
	parent.request_state_change.emit(parent, Enums.ActorStates.ATK_WINDUP, parent.data)
		
	
