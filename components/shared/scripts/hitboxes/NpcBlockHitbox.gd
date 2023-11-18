extends CombatHitbox
class_name NpcBlockHitbox

signal on_hit

func is_disabled():
	return collision_shape.disabled

func enable():
	if collision_shape == null:
		return
		
	collision_shape.set_deferred("disabled", false)
	enable_mesh()	

func disable():
	if collision_shape == null:
		return
		
	collision_shape.set_deferred("disabled", true)
	disable_mesh()	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.area_entered.connect(_on_area_entered)
	#self.body_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attacked_by_player(area, player, weapon):
	var rando_damage = randi_range(weapon.damage_min, weapon.damage_max)
	
	on_hit.emit(rando_damage)

func _on_area_entered(area):
	print("blah blah blah")
	if area.parent_entity == PlayerDataExtra.player_instance:
		var player = PlayerDataExtra.player_instance
		var weapon = area.parent_item
		attacked_by_player(area, player, weapon)
		return
	
	#attacked_by_npc(area, area.parent_entity)

func _on_state_changed(state, data):
	#if state == Enums.ActorStates.BLOCK_STAGGER:
	#	return
		
	if state == Enums.ActorStates.BLOCKING:
		if is_disabled() == true:
			enable()
			
		return
	
	disable()
