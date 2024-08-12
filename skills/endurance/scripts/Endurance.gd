extends "res://skills/shared/scripts/BaseSkill.gd"
class_name Endurance

@export var stamina_per_level = 5

@onready var max_stamina = level * stamina_per_level
@onready var current_stamina = max_stamina

@export var default_regen_per_second = 0.25

var last_stamina_usage = 0
var stamina_regen_delay_after_usage = 2000

var can_instant_heal = true
var can_regenerate = true

signal reached_zero_stamina
signal stamina_changed

func lower_stamina(number):
	current_stamina -= number
	
	if current_stamina <= 0:
		reached_zero_stamina.emit()
		current_stamina = 0
		
	stamina_changed.emit(current_stamina, max_stamina)
	last_stamina_usage = Time.get_ticks_msec()
	
func get_stamina_percentage():
	return current_stamina / max_stamina

func regenerate_stamina(delta):
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - last_stamina_usage
	
	if elapsed_time < stamina_regen_delay_after_usage:
		return
	
	var stamina_to_add = delta * default_regen_per_second * max_stamina
	var new_stamina = min(current_stamina + stamina_to_add, max_stamina)
	
	if current_stamina != new_stamina:
		current_stamina = new_stamina
		stamina_changed.emit(current_stamina, max_stamina)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	regenerate_stamina(delta)
