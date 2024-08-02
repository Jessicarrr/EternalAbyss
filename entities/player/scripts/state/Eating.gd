extends "res://entities/shared/scripts/BaseState.gd"

var item
@onready var use_item_input = $UseItemInput

# Called when the node enters the scene tree for the first time.
func _ready():
	use_item_input.use_button_released.connect(_on_use_item_released)
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in eating state"])
	
	back_to_idle_if_no_input()
	
	item = _data["item"]
	item.use_item()
	await get_tree().create_timer(item.use_item_time).timeout
	
	if active == false:
		return
	
	request_state_change.emit(self, Enums.ActorStates.IDLE, {})
	
func end():
	item.stop_using_item()
	item = null
	
	Debug.msg(Debug.PLAYER_STATES, ["Player eating state ended."])
	super.end()
	
func back_to_idle_if_no_input():
	if use_item_input.is_pressing_use_button() == false:
		request_state_change.emit(self, Enums.ActorStates.IDLE, {})
		return

func _on_use_item_released():
	if active == false: return
	
	request_state_change.emit(self, Enums.ActorStates.IDLE, {})
	return
