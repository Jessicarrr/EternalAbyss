extends "res://components/shared/scripts/skills/BaseSkill.gd"
class_name Health

@export var hp_per_level = 5

@onready var max_hitpoints = level * hp_per_level
@onready var current_hitpoints = max_hitpoints

@export var default_regeneration_rate = 0.0

var can_instant_heal = true
var can_regenerate = true

signal reached_zero_hp
signal health_changed

func is_dead():
	if current_hitpoints <= 0:
		return true
		
	return false

func damage(number):
	if current_hitpoints <= 0:
		return
	
	current_hitpoints -= number
	
	Debug.msg(Debug.COMBAT, ["Took ", number, " damage and is now ", current_hitpoints, " hp."])
	if is_dead():
		current_hitpoints = 0
		can_instant_heal = false
		can_regenerate = false
		reached_zero_hp.emit()
		Debug.msg(Debug.COMBAT, ["Thingy is now dead."])
		
	health_changed.emit(current_hitpoints, max_hitpoints)
	
		
func _heal(heal_amount):
	if current_hitpoints + heal_amount > max_hitpoints:
		current_hitpoints = max_hitpoints
		return
		
	current_hitpoints = current_hitpoints + heal_amount

func instant_heal(heal_amount):
	if can_instant_heal == false:
		return
		
	_heal(heal_amount)
	health_changed.emit(current_hitpoints, max_hitpoints)

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
