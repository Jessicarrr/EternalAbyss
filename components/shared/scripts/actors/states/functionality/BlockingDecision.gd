extends Node
class_name BlockingDecision

@onready var parent = get_parent()
var entity = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func alter_connections():
	if parent.entity == self.entity:
		return
		
	if self.entity == null:
		self.entity = parent.entity
		try_connect_state_machine()
		return

	if parent.entity == null:
		try_disconnect_state_machine()
		self.entity = null
		return

func timed_execute():
	alter_connections()

func _on_entity_state_changed(state, data):
	if parent.active == false:
		return
		
	#print("Thingy im chasing changed state to ", state)
	
	if state == Enums.ActorStates.ATK_WINDUP:
		parent.request_state_change.emit(parent, Enums.ActorStates.BLOCK_START, parent.data)

func try_connect_state_machine():
	if not "state_machine" in entity:
		return
	
	entity.state_machine.state_changed.connect(_on_entity_state_changed)

func try_disconnect_state_machine():
	if not "state_machine" in entity:
		return
	
	entity.state_machine.state_changed.disconnect(_on_entity_state_changed)
