extends "res://components/shared/scripts/actors/BaseState.gd"
class_name NpcBlocking

@export var npc_path : NodePath = ""
var npc = null
var block_timer = null  # Variable to store the reference to the Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#super._ready()
	if not npc_path:
		push_error(self,  " requires an npc path set in its attributes")
		return
	
	npc = get_node(npc_path)

func begin(_data = {}):
	super.begin(_data)
	
	if _data.has("GoToState"):
		Debug.msg(Debug.NPC_STATES, ["Blockin state going straight to block end because there's a GoToState"])
		request_state_change.emit(self, Enums.ActorStates.BLOCK_END, _data)
		return
	
	Debug.msg(Debug.NPC_STATES, ["Npc is in Blocking state"])
	block_timer = Timer.new()  # Create a new Timer
	block_timer.wait_time = npc.block_duration_base
	block_timer.one_shot = true
	block_timer.timeout.connect(_on_block_timer_timeout)
	add_child(block_timer)  # Add the Timer as a child of the current node
	block_timer.start()
	
func _on_block_timer_timeout():
	Debug.msg(Debug.NPC_STATES, ["Npc Blocking ending. Going to BlockEnd..."])
	request_state_change.emit(self, Enums.ActorStates.BLOCK_END, data)
	block_timer.queue_free()  # Free the Timer after use
	block_timer = null

func end():
	if block_timer and not block_timer.is_stopped():  # Check if the Timer exists and is not stopped
		block_timer.stop()
		block_timer.queue_free()
		block_timer = null
	
	super.end()
	Debug.msg(Debug.NPC_STATES, ["Npc Blocking state ended."])

func _on_hit(entity, weapon, damage):
	#Debug.msg(Debug.NPC_STATES, ["blah."])
	if active == false:
		return
	
	Debug.msg(Debug.NPC_STATES, ["Npc Blocking state going to block stagger state."])
	var stagger_time = npc.calculate_stagger_time(damage)
	var merged_data = data.duplicate()  # Duplicate to avoid modifying the original
	merged_data.merge({"StaggerTime": stagger_time})
	request_state_change.emit(self, Enums.ActorStates.BLOCK_STAGGER, merged_data)

func _on_blocked_hit(entity, weapon, damage):
	#Debug.msg(Debug.NPC_STATES, ["blah."])
	if active == false:
		return
	
	Debug.msg(Debug.NPC_STATES, ["Npc Blocking state going to block stagger state."])
	var stagger_time = npc.calculate_stagger_time(damage)
	var merged_data = data.duplicate()  # Duplicate to avoid modifying the original
	merged_data.merge({"StaggerTime": stagger_time})
	request_state_change.emit(self, Enums.ActorStates.BLOCK_STAGGER, merged_data)
