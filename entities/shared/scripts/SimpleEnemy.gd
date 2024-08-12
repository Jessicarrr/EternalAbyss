extends CharacterBody3D
class_name SimpleEnemy

@onready var health = $Skills/Health
@onready var state_machine = $StateMachine

@export_category("States")
@export var chance_dormant_on_spawn = 1.0
@export var touching_detection_distance = 0.7

@export_category("Attacks")
@export var windup_time = 0.5
@export var swing_time = 0.2
@export var recovery_time = 0.5

@export var attack_chance = 0.3
@export var attack_chance_interval = 100
@export var attack_min_distance = 1.3
@export var attack_range = 1.1
@export var min_time_between_attacks = 1.0

@export var damage_min = 12
@export var damage_max = 15

@export_category("Blocking")
@export var block_chance = 0.7
@export var block_transition_time = 0.5
@export var block_duration_base = 1.5

@export var visibility_range = 7

@onready var prev_pos = global_position

@export var base_stagger_time_s = 0.5
@export var extra_time_per_damage = 0.01

@export_category("Movement Speed")
@export var walk_speed = 1.4
@export var block_mult = 0.3
@export var block_stagger_mult = 0.0
@export var block_start_mult = 0.3
@export var block_end_mult = 0.3
@export var stagger_mult = 0.0
@export var idle_mult = 0.0
@export var windup_mult = 0.3
@export var swing_mult = 0.0
@export var recovery_mult = 0.3
@export var dormant_mult = 0.0

@export_category("Other Timings")
@export var reanimation_time = 2.0

@export_category("Hearing")
@export var hearing_distance_falloff = 1
@export var minimum_hearing_volume = 18

var process_update_time = 5000
@onready var last_process = Time.get_ticks_msec()

#@export_category("Physics")
#@export var knockback_strength = 2.0

signal on_hit
signal on_blocked_hit

func has_moved():
	var cur_pos = self.global_position
	var moved = false
	
	if cur_pos.x != prev_pos.x or cur_pos.z != prev_pos.z:
		moved = true
		
	prev_pos = cur_pos
	return moved
	
func hit(entity, weapon, damage):
	if state_machine.current_state == Enums.ActorStates.BLOCKING:
		on_blocked_hit.emit(entity, weapon, damage)
		return
	
	health.damage(damage)
	on_hit.emit(entity, weapon, damage)
	
func calculate_stagger_time(damage):
	var damage_time_modifier_s = damage * extra_time_per_damage
	var total_stagger_time = base_stagger_time_s + damage_time_modifier_s
	return total_stagger_time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Helpers.has_enough_time_passed(process_update_time, last_process) == false:
		return
	
	last_process = Time.get_ticks_msec()
		
	if self.global_position.y < -15:
		push_warning(self.get_path(), " is at a weird height, which is ", self.global_position.y, " with relative position at " , self.position.y)
	pass

