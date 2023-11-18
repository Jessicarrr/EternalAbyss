extends Node

@onready var state = get_node(get_meta("StatesPath"))
@onready var hotbar_checker = $HotbarItemChecker

func _on_input_handler_attack_held():
	pass # Replace with function body.

func _on_input_handler_attack_pressed():
	Debug.msg(Debug.COMBAT, ["Player tried to attack. Let's see whats in their hand."])
	
	if hotbar_checker.is_holding_weapon() == false:
		return
		
	var item = hotbar_checker.held_item
	
	if state.set_state(Enums.ActorStates.ATK_WINDUP) == false:
		return

	Debug.msg(Debug.COMBAT, ["calling attack on the weapon."])
	var attack = item.attacks.get_next_attack()
	Debug.msg(Debug.COMBAT, ["Trying to attack with the attack ", attack])
	await attack.windup()
	
	if state.set_state(Enums.ActorStates.ATK_SWING) == false:
		#attack.cancel()
		return
	
	await attack.swing()
	
	if state.set_state(Enums.ActorStates.ATK_RECOVERY) == false:
		#attack.cancel()
		return
	
	await attack.recover()
	
	state.set_state(Enums.ActorStates.IDLE)
	
	Debug.msg(Debug.COMBAT, ["Attack completely done."])
