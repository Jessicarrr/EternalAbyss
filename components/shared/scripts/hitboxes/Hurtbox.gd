extends "res://components/shared/scripts/hitboxes/CombatHitbox.gd"
class_name Hurtbox

@export var health_node_path : NodePath = ""
var health_node = null

@export var hurtbox_trigger_limit_ms = 250
var last_trigger = 0

var last_overlapping_areas_check = 0
var overlapping_area_check_limit = 5 #ms

var current_state

var shield_hit_grace_period = 100
var latest_shield_hit_time = 0
var latest_shield_hit_area = null

signal on_hit
signal on_hit_by_player

var hotbar_item

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	if not health_node_path:
		push_error(self.get_path(), ", a hurtbox, requires a health node to be linked")
		return
	
	health_node = get_node(health_node_path)
	self.area_entered.connect(_on_area_entered)
	self.body_entered.connect(_on_area_entered)
	connect_hotbar_if_player()

func connect_hotbar_if_player():
#	if parent_entity != PlayerDataExtra.player_instance:
#		Debug.msg(Debug.COLLISIONS, [self, " Did not set hotbar item listener because parent entity isnt a player"])
#		return
	
	if not "hotbar" in parent_entity:
		Debug.msg(Debug.COLLISIONS, [self, " Parent entity was player but couldnt find hotbar"])
		return
		
	await parent_entity.ready
	Debug.msg(Debug.COLLISIONS, [self, " Hotbar successfully connected"])
	parent_entity.hotbar.hotbar_item_changed.connect(_on_hotbar_item_changed)
	
func _on_hotbar_item_changed(item):
	if hotbar_item != null:
		var block_hitbox = get_block_hitbox_from_item()
		
		if block_hitbox != null:
			block_hitbox.area_entered.disconnect(_on_shield_hit)
	
	hotbar_item = item
	connect_hotbar_item_if_has_blocking()
	
func _should_ignore_hit_because_blocked(area):
	if latest_shield_hit_area == null:
		Debug.msg(Debug.COLLISIONS, [self, " Should not ignore latest hit because latest_shield_hit_area == null"])
		return
		
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - latest_shield_hit_time
	
	if elapsed_time > shield_hit_grace_period:
		Debug.msg(Debug.COLLISIONS, [self, " Should not ignore latest shield hit because ", elapsed_time, " > ", shield_hit_grace_period])
		return false
		
	if area == latest_shield_hit_area:
		return true
		
	Debug.msg(Debug.COLLISIONS, [self, " Should not ignore latest shield hit area didn't equal other area."])
	return false
	
func get_block_hitbox_from_item():
	if hotbar_item == null:
		Debug.msg(Debug.COLLISIONS, [self, " hotbar item was null so can't get block hitbox"])
		return null
		
	if hotbar_item.has_method("has_block_hitbox") == false:
		Debug.msg(Debug.COLLISIONS, [self, " hotbar item doesn't have has_block_hitbox()"])
		return null
		
	if hotbar_item.has_block_hitbox() == false:
		Debug.msg(Debug.COLLISIONS, [self, " hotbar item has_block_hitbox() == false"])
		return null
		
	var block_hitbox = hotbar_item.get_block_hitbox()
	Debug.msg(Debug.COLLISIONS, [self, " block hitbox successfully found."])
	return block_hitbox

func connect_hotbar_item_if_has_blocking():
	var block_hitbox = get_block_hitbox_from_item()
	
	if block_hitbox == null:
		return
		
	block_hitbox.area_entered.connect(_on_shield_hit)
	Debug.msg(Debug.COLLISIONS, [self, " on_shield_Hit successfully connected.."])
	pass

func _on_shield_hit(area):
	latest_shield_hit_area = area
	latest_shield_hit_time = Time.get_ticks_msec()
	return

func attacked_by_player(area, player, weapon):
	var rando_damage = randi_range(weapon.damage_min, weapon.damage_max)
	
	on_hit.emit(rando_damage)
	on_hit_by_player.emit(rando_damage, player, weapon)
	health_node.damage(rando_damage)
	pass
	
func attacked_by_npc(area, npc):
	if npc.has_method("get_random_damage") == false:
		push_error(self, " - ", npc.get_path(), " does not have a 'get_random_damage' function")
		return
		
	if _should_ignore_hit_because_blocked(area) == true:
		Debug.msg(Debug.COLLISIONS, [self, " Ignored a hurtbox hit because it was blocked by a shield"])
		return
		
	var rando_damage = npc.get_random_damage()
	on_hit.emit(rando_damage)
	health_node.damage(rando_damage)

func _on_area_entered(area : Area3D):
	Debug.msg(Debug.COLLISIONS, [self.get_path(), " - hurtbox entered by ", area, area.get_parent()])
	
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
