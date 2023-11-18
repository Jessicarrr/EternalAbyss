extends "res://components/shared/scripts/hitboxes/CombatHitbox.gd"
class_name Hurtbox

@export var health_node_path : NodePath = ""
var health_node = null

@export var hurtbox_trigger_limit_ms = 250
var last_trigger = 0

var last_overlapping_areas_check = 0
var overlapping_area_check_limit = 5 #ms

var current_state

signal on_hit
signal on_hit_by_player

# Called when the node enters the scene tree for the first time.
func _ready():
	if not health_node_path:
		push_error(self, ", a hurtbox, requires a health node to be linked")
		return
	
	health_node = get_node(health_node_path)
	self.area_entered.connect(_on_area_entered)
	self.body_entered.connect(_on_area_entered)

func attacked_by_player(area, player, weapon):
	var rando_damage = randi_range(weapon.damage_min, weapon.damage_max)
	
	on_hit.emit(rando_damage)
	on_hit_by_player.emit(rando_damage, player, weapon)
	health_node.damage(rando_damage)
	pass
	
func attacked_by_npc(area, npc):
	pass

func _on_area_entered(area : Area3D):
	Debug.msg(Debug.COLLISIONS, [self, " - hurtbox entered by ", area, area.get_parent()])
	
	if health_node == null:
		return
	
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - last_trigger

	if elapsed_time < hurtbox_trigger_limit_ms:
		return
	
	if area.has_method("is_disabled"):
		if area.is_disabled() == true:
			print("Ignored disabled hitbox")
			return
	
	if current_state == Enums.ActorStates.BLOCKING or current_state == Enums.ActorStates.BLOCK_STAGGER:
		return
	
	last_trigger = Time.get_ticks_msec()
	
	if area.parent_entity == PlayerDataExtra.player_instance:
		var player = PlayerDataExtra.player_instance
		var weapon = area.parent_item
		attacked_by_player(area, player, weapon)
		return
	
	attacked_by_npc(area, area.parent_entity)

func _on_state_changed(state, data):
	current_state = state
