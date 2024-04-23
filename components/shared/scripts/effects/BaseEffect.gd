extends Node
class_name BaseEffect

@export var duration_s = 10.0
var start_time = 0
@export var magnitude = 10.0
@onready var duration_ms = duration_s * 1000
@export var effect_interval_s = 1.0
@onready var effect_interval_ms = effect_interval_s * 1000
@export var last_effect_application = 0
@export var effect_type : Enums.Effects = Enums.Effects.NONE
var node_to_apply
var started = false

func apply_and_start_effect(effect_manager_node, apply_to_node):
	var dupe = self.duplicate()
	dupe.start_time = Time.get_ticks_msec()
	dupe.started = true
	effect_manager_node.add_child(dupe)
	node_to_apply = apply_to_node
	
func has_effect_interval_elapsed():
	if Helpers.has_enough_time_passed(effect_interval_ms, last_effect_application) == false:
		return false
		
	return true
	
func do_effect():
	if started == false:
		push_error("Called do_effect() on ", self.get_name(), " but started == false")
		return
	
	if node_to_apply == null:
		push_error(self.get_path(), " tried to call do_effect() but node_to_apply == null")
		return
		
	last_effect_application = Time.get_ticks_msec()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started == false:
		return
		
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - start_time
	
	if elapsed_time > duration_ms:
		self.queue_free()
