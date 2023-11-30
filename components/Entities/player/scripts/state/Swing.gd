extends "res://components/shared/scripts/actors/BaseState.gd"

var weapon
@export var endurance_node_path : NodePath = ""
var endurance

func _ready():
	#super._ready()
	
	if not endurance_node_path:
		print("!! not endurance_node_path gosh")
		return
		
	endurance = Helpers.try_load_node(self, endurance_node_path)

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.PLAYER_STATES, ["Player is in swing state w data: ", data])
	
	weapon = _data["Weapon"]
	weapon.sprite.swing()
	
	if "stamina_cost" in weapon:
		if endurance != null:
			var stam_cost = weapon.stamina_cost
			endurance.lower_stamina(stam_cost)
	
	#weapon.attack_hitbox.area_entered.connect(_on_attack_collide)
	
	await get_tree().create_timer(weapon.swing_time).timeout
	go_to_recovery_state()
	
func end():
	super.end()
	Debug.msg(Debug.PLAYER_STATES, ["Player swing state ended."])
	#weapon.attack_hitbox.area_entered.disconnect(_on_attack_collide)
	weapon = null
	
func go_to_recovery_state():
	Debug.msg(Debug.PLAYER_STATES, ["Player swing state requesting to go to recovery state."])
	request_state_change.emit(self, Enums.ActorStates.ATK_RECOVERY, self.data)
