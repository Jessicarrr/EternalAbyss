extends Item
class_name Weapon
#@onready var attacks := $FirstPersonControl/Sprite2D/AttackAnims
#@onready var hitbox := $PlayerCombatHitbox
#@onready var hitbox_anim := $PlayerCombatHitbox/SwordSlashAnim

@export_category("Weapon Data")
@export var damage_min = 1
@export var damage_max = 2
@export var material : Enums.Materials = Enums.Materials.NONE
@export var range = 1.0

@export_category("Nodes")
@export var attacks_path : NodePath = ""
@export var attack_hitbox_path : NodePath = ""
@export var attack_hitbox_anim_path : NodePath = ""
@export var block_hitbox_path : NodePath = ""

var attacks
var attack_hitbox
var attack_hitbox_anim
var block_hitbox

func get_random_damage():
	return randi_range(damage_min, damage_max)

func setup():
	if block_hitbox_path:
		block_hitbox = get_node(block_hitbox_path)
	if attacks_path:
		attacks = get_node(attacks_path)
	if attack_hitbox_path:
		attack_hitbox = get_node(attack_hitbox_path)
	if attack_hitbox_anim_path:
		attack_hitbox_anim = get_node(attack_hitbox_anim_path)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
		
	setup()
	
	pass # Replace with function body.

func has_block_hitbox():
	if block_hitbox == null or not block_hitbox_path:
		return false
		
	return true
	
func get_block_hitbox():
	return block_hitbox

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func use_item():
	super.use_item()
