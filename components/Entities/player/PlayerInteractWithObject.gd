extends Node

func _input(event):
	if Input.is_action_just_released("interact"):
		try_interact()

func try_interact():
	var player = PlayerDataExtra.player_instance
	
	if player == null:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Couldn't interact with object because player was null"])
		return
	
	var entity_seen = player.get_thing_im_looking_at()
	
	if entity_seen == null:
		return
	
	if entity_seen is InteractableObject == false:
		if entity_seen.get_parent() is InteractableObject == false:
			Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Not an interactable object!"])
			return

		entity_seen = entity_seen.get_parent()
		
	if entity_seen.has_method("interact") == false:
		Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Is an interactable object, but 'interact' method not found?"])
		return
		
	Debug.msg(Debug.INTERACT_WITH_OBJECTS, ["Attempt interaction with ", entity_seen.get_name()])
	entity_seen.interact(player)
	
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
