extends Node

@export var nav_agent_path : NodePath = ""
var nav_agent

@onready var parent = get_parent()
@onready var last_target_position_refresh_time = Time.get_ticks_msec()
var target_refresh_time_threshold = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_agent = Helpers.try_load_node(self, nav_agent_path)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if parent.active == false:
		return
		
	var current_time = Time.get_ticks_msec()
	var time_passed = current_time - last_target_position_refresh_time
	
	if time_passed >= target_refresh_time_threshold:
		nav_agent.set_target_position(PlayerDataExtra.player_instance.global_position)
		return
