extends Node

var current_state_node = null
var default_state = Enums.ActorStates.IDLE

var states_to_nodes = {}

var state_changing = false

var dead = false

signal state_changed

func get_node_for_next_state(state):
	if states_to_nodes.has(state):
		return get_node(states_to_nodes[state].get_path())
	
	Debug.msg(Debug.GENERAL_STATES, [self.get_path(), " tried to find state ",\
	 Helpers.state_name(state), " but could not find it in its dictionary."])
	push_error(self.get_path(), " tried to find state ", Helpers.state_name(state),\
	 " but could not find it in its dictionary.")
	return null
	
func transition_to_state(state, data = {}):
	if state_changing == true:
		Debug.msg(Debug.GENERAL_STATES, [self, " tried to go to new state but the state\
		is already in the process of changing. This must have been a race condition."])
		return
		
	state_changing = true
	Debug.msg(Debug.GENERAL_STATES, [self, " changing to state ", Helpers.state_name(state)])
	
	state_changed.emit(state, data)
	
	if current_state_node != null:
		current_state_node.active = false
		current_state_node.end()
		
	current_state_node = get_node_for_next_state(state)
	current_state_node.active = true
	current_state_node.begin(data)
	state_changing = false
	
	
	
func transition_to_default_state():
	transition_to_state(default_state)

func state_node_exists(value):
	for v in states_to_nodes.values():
		if v == value:
			return true
	return false

func _add_death_state_if_missing():
	var has_death_state = false
	
	for child in get_children():
		if child is DeadState:
			has_death_state = true
			return
			
	var death_state = DeadState.new()
	add_child(death_state)
	
	if states_to_nodes.has(Enums.ActorStates.DEAD) == false:
		states_to_nodes[Enums.ActorStates.DEAD] = death_state


func _on_request_state_change(state_node, state = null, data = {}):
	if dead == true:
		return
	
	if state_node != current_state_node:
		Debug.msg(Debug.GENERAL_STATES, [self, " rejected request to go to state ", Helpers.state_name(state),\
		". Request sent by ", state_node, ", request rejected because it is not the currently active state."])
		return
	
	if state == null:
		Debug.msg(Debug.GENERAL_STATES, [self, " rejected request to go to state because the sent state was null."])
		return
		
	if state_node_exists(state_node) == false:
		Debug.msg(Debug.GENERAL_STATES, [self, " has a missing state node in states_to_nodes"])
		push_error(self, " has a missing state node in states_to_nodes")
		#breakpoint
		
	transition_to_state(state, data)

func _on_death():
	transition_to_state(Enums.ActorStates.DEAD)
	dead = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_death_state_if_missing()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
