extends Node

@onready var player = get_parent()
@onready var gear = player.get_node("Gear")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		var entity_seen = player.get_thing_im_looking_at()
		
		if entity_seen == null:
			return
		
		if entity_seen.is_in_group("items"):
			entity_seen.prepare_for_pickup()
			gear.add_item_to_inventory(entity_seen)
			player.item_picked_up.emit(entity_seen)
			return
