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


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func use_item():
	super.use_item()
	pass
	
func stop_using_item():
	super.stop_using_item()
	pass
	
func apply_item_effect():
	pass
	
func stop_item_effect():
	pass


func _on_player_weapon_hitbox_area_entered(area):
	pass # Replace with function body.
