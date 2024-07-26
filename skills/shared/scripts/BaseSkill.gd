extends Node

@export var level = 1
@export var skill_name = "Skill"
@export var description = "A skill"

var max_level = 99
var min_level = 1

var current_offset = 0

@export var offset_correction_time_ms = 10000 #ms
@onready var last_offset_correction = Time.get_ticks_msec()

@export var offset_limit = 5

func get_absolute_level():
	return level
	
func get_effective_level():
	return level + current_offset
	
func get_skill_name():
	return skill_name
	
func get_description():
	return description

func level_up():
	if level < max_level:
		level += 1

func apply_offset(offset):
	var potential_new_offset = current_offset + offset
	if potential_new_offset > offset_limit:
		current_offset = offset_limit
	elif potential_new_offset < -offset_limit:
		current_offset = -offset_limit
	else:
		current_offset = potential_new_offset
	
func should_correct_offset():
	var current_time = Time.get_ticks_msec()
	var time_passed = current_time - last_offset_correction
	
	if current_offset == 0:
		return
	
	if time_passed > offset_correction_time_ms:
		return true
		
	return false
	
func correct_offset():
	if current_offset < 0:
		current_offset += 1
	if current_offset > 0:
		current_offset -= 1
		
func _ready():
	pass
	
func _process(_delta):
	if should_correct_offset():
		last_offset_correction = Time.get_ticks_msec()  # Update the timestamp before correcting
		correct_offset()

