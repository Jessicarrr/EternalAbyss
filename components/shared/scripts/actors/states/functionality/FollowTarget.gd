extends Node

@onready var parent = get_parent()
@onready var last_target_position_refresh_time = Time.get_ticks_msec()
var target_refresh_time_threshold = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if parent.active == false:
		return
		
	if parent.entity == null:
		return
		
	var current_time = Time.get_ticks_msec()
	var time_passed = current_time - last_target_position_refresh_time
	
	if time_passed >= target_refresh_time_threshold:
		last_target_position_refresh_time = Time.get_ticks_msec()
		parent.move_npc.emit(parent.entity.global_position)
		#Debug.msg(Debug.NPC_STATES, [self, " pathing to position ", entity.global_position])
