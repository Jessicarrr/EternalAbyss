extends "res://components/shared/scripts/actors/BaseState.gd"

#@onready var weapon_handler = $WeaponHandler
var swinging_again = false
var atk_data
var weapon
var recoiled = false

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in swing state w data: ", data])
	
	weapon = _data["Weapon"]
	weapon.attack_hitbox.hitbox_disabled_by_collision.connect(_on_attack_collide)
	
	atk_data = _data["Attack"]
	atk_data.swing()
	
	#weapon.attack_hitbox.area_entered.connect(_on_attack_collide)
	
	await atk_data.tween.finished
	#await get_tree().create_timer(atk_data.swing_time + 0.05).timeout
	
	if recoiled == true:
		return
		
	if swinging_again == false:
		go_to_recovery_state()
		return
		

	await get_tree().create_timer(atk_data.windup_time + 0.1).timeout
	swing_again()
	
func end():
	super.end()
	Debug.msg(Debug.PLAYER_STATES, ["Player swing state ended."])
	weapon.attack_hitbox.hitbox_disabled_by_collision.disconnect(_on_attack_collide)
	#weapon.attack_hitbox.area_entered.disconnect(_on_attack_collide)
	atk_data = null
	weapon = null
	swinging_again = false
	recoiled = false
	
#func go_to_idle_state():
#	Debug.msg(Debug.PLAYER_STATES, ["Player windup state requesting to go to idle state."])
#	request_state_change.emit(self, Enums.ActorStates.IDLE)
	
func go_to_recovery_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player swing state requesting to go to recovery state."])
	request_state_change.emit(self, Enums.ActorStates.ATK_RECOVERY, self.data)

func swing_again():
	swinging_again = true
	var item = data["Weapon"]
	var next_attack = item.attacks.get_next_attack()
	
	Debug.msg(Debug.PLAYER_STATES, ["Swing state requesting to go to another swing state"])
	request_state_change.emit(self, Enums.ActorStates.ATK_SWING,\
	{
		"Weapon" : item,
		"Attack" : next_attack
	})
	swinging_again = false

func go_to_recoil_state(body):
	await get_tree().create_timer(0.01).timeout
	Debug.msg(Debug.PLAYER_STATES, ["Swing state recoiled. Now attempting to go to recoil state..."])
	recoiled = true
	weapon.attack_hitbox_anim.cancel()
	request_state_change.emit(self, Enums.ActorStates.ATK_RECOIL,\
	{
		"Weapon" : weapon,
		"Attack" : atk_data,
		"Object" : body
	})

func _on_attack_collide(body):
	if active == false:
		return
	
	Debug.msg(Debug.PLAYER_STATES, ["Player swing state detected collision with ", body])
	go_to_recoil_state(body)
	
#	var body_parent = body.get_parent()
#	var player = PlayerDataExtra.player_instance
#
#	if body == player or body_parent == player:
#		return
	
#	if body.get_collision_layer_value(1) or body.get_collision_layer_value(5) == true:
	

func _on_attack_clicked():
	if active == false:
		return
		
	swinging_again = true
	pass # Replace with function body.


func _on_attack_held():
	pass # Replace with function body.
