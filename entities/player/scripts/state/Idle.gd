extends "res://entities/shared/scripts/BaseState.gd"

@onready var item_handler = $ItemHandler
@onready var use_item_input = $UseItemInput
@export var endurance_node_path : NodePath = ""
var endurance

# Called when the node enters the scene tree for the first time.
func _ready():
	endurance = Helpers.try_load_node(self, endurance_node_path)
	use_item_input.use_button_pressed.connect(_on_item_used)
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in idle state"])
	
func end():
	Debug.msg(Debug.PLAYER_STATES, ["Player idle state ended."])
	super.end()

func try_go_to_windup_state():
	if active == false:
		return
		
	if item_handler.is_hotbar_item_a_weapon() == false:
		return
		
	var item = item_handler.hotbar_item
	
	if "stamina_cost" in item:
		var required_stamina = item.stamina_cost
		if endurance.current_stamina < item.stamina_cost:
			return
	
	Debug.msg(Debug.PLAYER_STATES, ["Idle state requesting to go to windup state"])
	request_state_change.emit(self, Enums.ActorStates.ATK_WINDUP,\
	{
		"Weapon" : item,
	})

func _on_block():
	if active == false:
		return
		
	var item = item_handler.hotbar_item
	
	Debug.msg(Debug.PLAYER_STATES, ["Idle state requesting to go to block start state"])
	request_state_change.emit(self, Enums.ActorStates.BLOCK_START,\
	{
		"Weapon" : item,
	})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func _on_item_used():
	var item = item_handler.hotbar_item
	
	#if item.can_use_item() == false:
		#Debug.msg(Debug.PLAYER_STATES, ["Idle state tried to use an item but it can't be used due to missing var assignments"])
		#return
	#
	#if item.usage_type == Enums.ItemUsages.BLOCK:
		#_on_block()
		#return
		#
	#if item_handler.is_hotbar_item_food() == true:
		#request_state_change.emit(self, Enums.ActorStates.EATING, {
			#"item" : item_handler.hotbar_item
		#})
		#return

func _on_attack_input_attack_clicked():
	Debug.msg(Debug.PLAYER_STATES, ["Trying to go to windup state?"])
	try_go_to_windup_state()


func _on_attack_input_attack_held():
	pass # Replace with function body.
