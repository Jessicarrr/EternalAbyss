extends "res://entities/shared/scripts/BaseStateMachine.gd"
class_name GhostStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	states_to_nodes = {
		Enums.ActorStates.IDLE : $Idle
		#Enums.ActorStates.FOLLOW_PLAYER : $FollowPlayer,
		#Enums.ActorStates.STAGGERED : $Staggered,
		#Enums.ActorStates.BLOCK_START : $StartBlocking,
		#Enums.ActorStates.BLOCK_END : $FinishBlocking,
		#Enums.ActorStates.BLOCKING : $Blocking,
		#Enums.ActorStates.BLOCK_STAGGER : $BlockStagger,
		#Enums.ActorStates.ATK_WINDUP : $AttackWindup,
		#Enums.ActorStates.ATK_SWING : $AttackSwing,
		#Enums.ActorStates.ATK_RECOVERY : $AttackRecovery
		
	}
	
	super._ready()
	default_state = Enums.ActorStates.IDLE
	transition_to_default_state()
	self.state_changed.connect(_on_state_change)
	
func _on_state_change(state, data):
	Debug.msg(Debug.NPC_STATE_MACHINE, ["NPC: ", get_parent().get_name()])
	Debug.msg(Debug.NPC_STATE_MACHINE, ["State: ", Helpers.state_name(state)])
	Debug.msg(Debug.NPC_STATE_MACHINE, ["Data: ", data])
	Debug.msg(Debug.NPC_STATE_MACHINE, ["----\n"])
