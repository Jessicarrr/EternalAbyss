extends "res://components/shared/scripts/actors/BaseStateMachine.gd"
class_name NpcStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	states_to_nodes = {
		Enums.ActorStates.IDLE : $Idle,
		Enums.ActorStates.FOLLOW_PLAYER : $CombatFollow,
		Enums.ActorStates.STAGGERED : $Staggered,
		Enums.ActorStates.BLOCK_START : $StartBlocking,
		Enums.ActorStates.BLOCK_END : $FinishBlocking,
		Enums.ActorStates.BLOCKING : $Blocking,
		Enums.ActorStates.BLOCK_STAGGER : $BlockStagger
	}
	
	super._ready()
	default_state = Enums.ActorStates.IDLE
	transition_to_default_state()
