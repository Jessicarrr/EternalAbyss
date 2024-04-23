extends Weapon
class_name Sword

var swing_sounds = [
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 01_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 02_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 03_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 04_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 05_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 06_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 07_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 08_DDUMAIS_NONE.wav",
	"res://sounds/weapons/sword/SWSH_Swing 2 Normal 09_DDUMAIS_NONE.wav",
]
var recoil_sounds = [
	"res://sounds/weapons/general/METLImpt_Impact Metal Small 30_DDUMAIS_NONE.wav",
	"res://sounds/weapons/general/METLImpt_Impact Metal Small 31_DDUMAIS_NONE.wav",
	"res://sounds/weapons/general/METLImpt_Impact Metal Small 32_DDUMAIS_NONE.wav",
	"res://sounds/weapons/general/METLImpt_Impact Metal Small 33_DDUMAIS_NONE.wav"
]

var impact_sounds = [
	
]

var block_hit_anim_playing = false
var block_hit_anim_time = 0.1
	
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func use_item():
	#if can_use_item() == false:
	#	return
		
	if currently_using_item == true:
		return
		
	currently_using_item = true
	await usage_anim_node.starting_anim(self.use_item_time)
	use_item_started.emit(self)
	apply_item_effect()
	
	if destroy_on_use:  # Check if the item should be destroyed after use
		_destroy_item()
		
func stop_using_item():
	#if can_use_item() == false:
	#	return
		
	if currently_using_item == false:
		return
	
	use_item_ending.emit(self)
	
	#await usage_anim_node.ending_anim(self.use_item_time) # can introduce a bug?
	
	if block_hit_anim_playing == true:
		await get_tree().create_timer(block_hit_anim_time).timeout
	
	usage_anim_node.ending_anim(self.use_item_time)
	await get_tree().create_timer(self.use_item_time).timeout
	use_item_ended.emit(self)
	
	stop_item_effect()
	currently_using_item = false
	
	if destroy_on_use:  # Check if the item should be destroyed after use
		_destroy_item()
	
func apply_item_effect():
	pass
	
func stop_item_effect():
	pass


func _on_player_weapon_hitbox_area_entered(area):
	pass # Replace with function body.


func _on_block_hit_anim_ended(anim_time):
	block_hit_anim_playing = false
	block_hit_anim_time = anim_time
	pass # Replace with function body.

func _on_block_hit_anim_started(anim_time):
	block_hit_anim_playing = true
	block_hit_anim_time = anim_time
	pass # Replace with function body.
