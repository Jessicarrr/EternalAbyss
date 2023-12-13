extends VBoxContainer

var raycast_check_delay = 50 #ms
var last_ray_check = Time.get_ticks_msec()

@onready var label = $Text

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
		
	if entity_seen.is_in_group("items") == true:
		label.text = Helpers.generate_item_text(entity_seen, false)
		return
		
	label.text = ""
