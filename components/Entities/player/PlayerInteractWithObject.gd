extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_released("interact"):
		try_interact()

func try_interact_with_object(player, entity_seen) -> bool:
	if entity_seen is InteractableObject == false:
		if entity_seen.get_parent() is InteractableObject == false:
			Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Not an interactable object!"])
			return false

		entity_seen = entity_seen.get_parent()
		
	if entity_seen.has_method("interact") == false:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Is an interactable object, but 'interact' method not found?"])
		return false
		
	Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Attempt interaction with ", entity_seen.get_name()])
	entity_seen.interact(player)
	return false
	
func try_interact_with_item(player, entity_seen) -> bool:
	if entity_seen is Item == false:
		if entity_seen.get_parent() is Item == false:
			return false
			
		entity_seen = entity_seen.get_parent()
		
	if player.is_node_ready() == false or player.gear.is_node_ready() == false:
		push_warning("Tried to pick up an item, yet the gear node or the player node is not ready?")
		return false
		
	player.gear.add_item_to_inventory(entity_seen)
	
	return true

func try_interact():
	var player = PlayerDataExtra.player_instance
	
	if player == null:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Couldn't interact with object because player was null"])
		return
	
	var entity_seen = player.get_thing_im_looking_at()
	
	if entity_seen == null:
		return
	
	var success = try_interact_with_object(player, entity_seen)
	
	if success: return true
	
	success = try_interact_with_item(player, entity_seen)
	
	if success: return true
	
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
