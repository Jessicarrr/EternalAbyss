extends Weapon
class_name Sword3D

@export var windup_time = 0.6
@export var swing_time = 0.2
@export var recovery_time = 0.2

@export var stamina_cost = 15

var swing_sounds = [
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 01_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 02_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 03_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 04_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 05_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 06_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 07_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 08_DDUMAIS_NONE.wav",
	"res://items/equippable/weapons/swords/shared/sounds/SWSH_Swing 2 Normal 09_DDUMAIS_NONE.wav",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
