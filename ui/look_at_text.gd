extends VBoxContainer

var raycast_check_delay = 50 #ms
var last_ray_check = Time.get_ticks_msec()

@onready var label = $Text
var player = PlayerDataExtra.player_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if Helpers.has_enough_time_passed(raycast_check_delay, last_ray_check) == false:
		return
		
	last_ray_check = Time.get_ticks_msec()

	if player == null:
		if PlayerDataExtra.player_instance == null:
			label.text = ""
			return
			
		player = PlayerDataExtra.player_instance
	
	var entity_seen = player.get_thing_im_looking_at()
	
	if entity_seen == null:
		label.text = ""
		return
		
	var entity_parent = entity_seen.get_parent()
	
	
	
#	if entity_seen.global_position.distance_to(player.global_position) > player.interaction_distance:
#		print(entity_seen.global_position.distance_to(player.global_position))
#		label.text = ""
#		return
		
	var interaction_button_string = InputDescriptor.get_button_string_for_action("interact")
		
	if entity_seen is Item == true:
		label.text = interaction_button_string + ": Pick Up\n" +Helpers.generate_item_text(entity_seen, false)
		return
		
	if entity_seen is InteractableObject == true\
	or entity_parent is InteractableObject == true:
		if entity_seen.has_method("get_lookat_text"):
			label.text = interaction_button_string + ": " + entity_seen.get_lookat_text()
			return
			
		if entity_parent.has_method("get_lookat_text"):
			label.text = interaction_button_string + ": " + entity_parent.get_lookat_text()
			return
		
	label.text = ""
	#label.text = entity_parent.get_name() + "/" + entity_seen.get_name()
