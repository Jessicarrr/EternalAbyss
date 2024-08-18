extends CharacterBody3D
class_name Player

# Functions
@onready var health = $Skills/Health
@onready var stealth = $Skills/Stealth

@onready var state_machine = $PlayerStateMachine
@onready var hotbar = $Gear/Hotbar

@onready var raycast : RayCast3D = $Head/Camera/RayCast

@onready var movement_sounds = $MovementSystem/MovementSounds

@onready var gear = $Gear

@export var crouch_transition_time = 0.3
@export var base_noise_level = 50.0
@export var not_crouching_noise_modifier = 50.0
@export var interaction_distance = 2.0
@export var footstep_interval_walking = 0.7
@export var footstep_interval_sprinting = 0.4
@export var footstep_interval_crouching_mult = 0.6

var crouching = false:
	set(val):
		if val == false:
			crouch_ended.emit()
			crouch_toggled.emit(val)
	
		elif val == true:
			crouch_started.emit()
			crouch_toggled.emit(val)
			
		crouching = val
	get:
		return crouching

signal on_hit
signal on_blocked_hit

signal crouch_started
signal crouch_ended
signal crouch_toggled

func _ready():
	PlayerDataExtra.set_player(self)
	Game.player = self
	
	movement_sounds.sound_made.connect(_process_footstep_sound)
	raycast.target_position = Vector3(0, 0, -interaction_distance)
	
func _process(_delta):
	pass
	
func _process_sound(source):
	pass
	
func _process_footstep_sound():
	var stealth_level = stealth.level
	var stealth_reduction_per_level = stealth.percent_reduction_per_level
	var percent_volume_reduction = stealth_level * stealth_reduction_per_level
		
	#Final_Volume=Volume_Base×(1−(Sneak_Skill_Level×Reduction_Per_Level))
	
	var final_volume = base_noise_level * (1 - (percent_volume_reduction))
	
	if crouching == false:
		final_volume += not_crouching_noise_modifier
		
	# Ensure final volume is not negative
	final_volume = max(final_volume, 0)
	
	#footstep_sound_made.emit(final_volume)
	WorldData.events.do_sound_event(self, final_volume, self.global_position, Enums.SoundDescriptions.ACTION)
	
func get_equipped_weapon():
	var item = hotbar.get_selected_hotbar_item()
	
	if item.is_in_group("weapons"):
		return item
		
	return null

func get_thing_im_looking_at():
	if raycast.is_colliding() == false:
		return null
		
	var collided_object = raycast.get_collider()
	return collided_object
	
# getting hit by an enemy.
# - entity: the enemy
# - damage: how much damage to apply to the player
func hit(entity, damage):
	if state_machine.current_state == Enums.ActorStates.BLOCKING:
		var thing = get_thing_im_looking_at()
		if thing == entity or thing.get_parent() == entity:
			on_blocked_hit.emit(entity, damage)
			return
			
	health.damage(damage)
	on_hit.emit(entity, damage)
