extends "res://components/shared/scripts/actors/BaseStateMachine.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	states_to_nodes = {
		Enums.ActorStates.IDLE : $Idle,
		Enums.ActorStates.ATK_WINDUP : $AttackWindup,
		Enums.ActorStates.ATK_SWING : $AttackSwing,
		Enums.ActorStates.ATK_RECOVERY : $AttackRecovery,
		Enums.ActorStates.ATK_CANCEL : $AttackCancel,
		Enums.ActorStates.ATK_RECOIL : $AttackRecoil,
		Enums.ActorStates.BLOCK_START : $BlockStart,
		Enums.ActorStates.BLOCKING : $Blocking,
		Enums.ActorStates.BLOCK_END : $BlockEnding
	}
	
	super._ready()
	default_state = Enums.ActorStates.IDLE
	transition_to_default_state()
