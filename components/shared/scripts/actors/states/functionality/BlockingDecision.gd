extends Node
class_name BlockingDecision

@onready var parent = get_parent()
@export var npc_path : NodePath = ""
var npc
var connected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	npc = Helpers.try_load_node(self, npc_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_player_attacking():
	if parent.active == false:
		return false
	
	if PlayerDataExtra.player_instance == null:
		return false
		
	if not "state_machine" in PlayerDataExtra.player_instance:
		return false
		
	if PlayerDataExtra.player_instance.state_machine.current_state == Enums.ActorStates.ATK_WINDUP\
	 or PlayerDataExtra.player_instance.state_machine.current_state == Enums.ActorStates.ATK_SWING:
		return true
		
	return false

func try_go_to_block():
	var should_block = Helpers.should_chance_succeed(npc.block_chance)
	
	if should_block == false:
		return
	
	parent.request_state_change.emit(parent, Enums.ActorStates.BLOCK_START, parent.data)

func _on_player_state_changed(state, data):
	if parent.active == false:
		return
		
	#print("Thingy im chasing changed state to ", state)
	
	if state == Enums.ActorStates.ATK_WINDUP or state == Enums.ActorStates.ATK_SWING:
		try_go_to_block()

func try_connect_state_machine():
	if not "state_machine" in PlayerDataExtra.player_instance:
		return
	
	PlayerDataExtra.player_instance.state_machine.state_changed.connect(_on_player_state_changed)

func _on_combat_follow_began():
	#if parent.active == false:
	#	return
	#Debug.msg(Debug.NPC_STATES, ["Follow player combat began, now trying to connect state machine"])
	if PlayerDataExtra.player_instance == null:
		return
		
	if connected == false:
		try_connect_state_machine()
		connected = true
		
	if is_player_attacking():
		try_go_to_block()
