extends CharacterBody3D
class_name Npc

@onready var health = $Skills/Health

@onready var prev_pos = global_position

@export_category("Damage")
@export var damage_min = 2
@export var damage_max = 4

@export_category("Stagger")
@export var base_stagger_time_s = 0.2
@export var extra_time_per_damage = 0.01

@export_category("Blocking")
@export var block_transition_time = 0.2
@export var block_duration_base = 1.0

@export_category("Attacks")
@export var windup_time = 0.4
@export var swing_time = 0.2
@export var recovery_time = 0.2

@export_category("Behaviour Chances")
@export var chance_attack_after_block_stagger = 0.2
	
func get_random_damage():
	return randi_range(damage_min, damage_max)
	
func has_moved():
	var cur_pos = self.global_position
	var moved = false
	
	if cur_pos.x != prev_pos.x or cur_pos.z != prev_pos.z:
		moved = true
		
	prev_pos = cur_pos
	return moved

func calculate_stagger_time(damage):
	var damage_time_modifier_s = damage * extra_time_per_damage
	var total_stagger_time = base_stagger_time_s + damage_time_modifier_s
	return total_stagger_time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
