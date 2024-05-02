extends VBoxContainer

var raycast_check_delay = 50 #ms
var last_ray_check = Time.get_ticks_msec()

@onready var label = $Text
@export var minimum_distance = 0.6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if Helpers.has_enough_time_passed(raycast_check_delay, last_ray_check) == false:
		return
		
	last_ray_check = Time.get_ticks_msec()
	
	if PlayerDataExtra.player_instance == null:
		return
	
	var entity_seen = PlayerDataExtra.player_instance.get_thing_im_looking_at()
	
	if entity_seen == null:
		return
		
	var entity_parent = entity_seen.get_parent()
	
	if entity_seen.global_position.distance_to(PlayerDataExtra.player_instance.global_position) > minimum_distance:
		label.text = ""
		return
		
	if entity_seen.is_in_group("items") == true:
		label.text = Helpers.generate_item_text(entity_seen, false)
		return
		
	if entity_seen is InteractableObject == true\
	or entity_parent is InteractableObject == true:
		var interaction_button_string = InputDescriptor.get_button_string_for_action("interact")
		
		if entity_seen.has_method("get_lookat_text"):
			label.text = "[ " + interaction_button_string + " ] " + entity_seen.get_lookat_text()
			return
			
		if entity_parent.has_method("get_lookat_text"):
			label.text = "[ " + interaction_button_string + " ] " + entity_parent.get_lookat_text()
			return
		
	label.text = ""
