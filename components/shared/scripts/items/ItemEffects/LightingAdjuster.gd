extends "res://components/shared/scripts/items/ItemEffects/BaseItemEffect.gd"
class_name LightingAdjustments

@export_category("Adjustments")
@export var min_modulation = 40
@export var max_modulation = 80
@export var modulation_mult = 0.5

var prev_player_rotation = Vector3()
var current_modulation_value = 50  # This starts at 50, but should change!

var going_up = false
var lighting_direction_change_chance = 2

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if camera == null:
		return
		
	prev_player_rotation = camera.global_rotation_degrees
	
	if can_animate() == false:
		return
	
	sprite.modulate = Color(current_modulation_value/255.0, current_modulation_value/255.0, current_modulation_value/255.0, 1.0)

func maybe_change_light_direction():
	var chance = rng.randf_range(0.0, 100.0)
	
	if chance < lighting_direction_change_chance:
		going_up = !going_up

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if can_animate() == false:
		return
		
	if prev_player_rotation == null:
		prev_player_rotation = camera.global_rotation_degrees
		
	maybe_change_light_direction()
	var rotation_difference = camera.global_rotation_degrees - prev_player_rotation
	var modulation_change = abs(rotation_difference.y * modulation_mult)
	
	if going_up == true:
		current_modulation_value += modulation_change
	else:
		current_modulation_value -= modulation_change
	
	current_modulation_value = clamp(current_modulation_value, min_modulation, max_modulation)  # Adjust min/max as needed
	sprite.modulate = Color(current_modulation_value/255.0, current_modulation_value/255.0, current_modulation_value/255.0, 1.0)
	
	#print("Modulation change: ", modulation_change, ", rotation difference: ", rotation_difference)
	
	# Update the previous rotation value for the next frame
	prev_player_rotation = camera.global_rotation_degrees
