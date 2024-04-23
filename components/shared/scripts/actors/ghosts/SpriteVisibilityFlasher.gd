extends Node

@export var ghost_npc_parent: NodePath
var ghost_npc
var ghost_sprite
var timer
var is_flashing_visibility = false
var current_state = Enums.ActorStates.IDLE

var flashing_states = [
	Enums.ActorStates.IDLE,
	Enums.ActorStates.ATK_SWING,
	Enums.ActorStates.ATK_CANCEL,
	Enums.ActorStates.ATK_RECOIL,
	Enums.ActorStates.ATK_RECOVERY,
	Enums.ActorStates.ATK_SWING,
	Enums.ActorStates.ATK_WINDUP,
	Enums.ActorStates.BLOCKING,
	Enums.ActorStates.BLOCK_START,
	Enums.ActorStates.BLOCK_END,
	Enums.ActorStates.BLOCK_STAGGER,
	Enums.ActorStates.GHOST_COMBAT_FOLLOW,
	Enums.ActorStates.GHOST_TEMPORARY_APPEARANCE
]

# Called when the node enters the scene tree for the first time.
func _ready():
	ghost_npc = Helpers.try_load_node(self, ghost_npc_parent)
	ghost_sprite = get_parent()

	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.one_shot = true


	if ghost_npc.always_tangible == true:
		ghost_sprite.visible = true
		return
		
	if current_state != null and current_state in flashing_states:
		begin_toggling_visibility()

func _toggle_visibility():
	# Inverse the visibility if we are flashing.
	if current_state in flashing_states:
		ghost_sprite.visible = !ghost_sprite.visible
	else:
		# Ensure the ghost is invisible if it's not in a flashing state.
		ghost_sprite.visible = false
		return

	# Set the timer to the appropriate wait time.
	
	var extra_time = randf_range(-ghost_npc.flashing_randomness_range, ghost_npc.flashing_randomness_range)
	var wait_time = ghost_npc.flashing_visibility_time if ghost_sprite.visible else ghost_npc.flashing_invisibility_time
	wait_time = wait_time + extra_time
	timer.start(wait_time)

func _on_timer_timeout():
	_toggle_visibility()

func begin_toggling_visibility():
	if ghost_npc == null or current_state == null:
		return
	
	if ghost_npc.always_tangible:
		ghost_sprite.visible = true
		timer.stop()  # Ensure the timer is stopped if the ghost is always tangible.
	else:
		if current_state in flashing_states:
			# If already visible, we start with the invisibility duration.
			ghost_sprite.visible = !ghost_sprite.visible  # Toggle visibility immediately
			var extra_time = randf_range(-ghost_npc.flashing_randomness_range, ghost_npc.flashing_randomness_range)
			var wait_time = ghost_npc.flashing_visibility_time if ghost_sprite.visible else ghost_npc.flashing_invisibility_time
			wait_time = wait_time + extra_time
			timer.start(wait_time)  # Start timer with the new wait time
		else:
			# If the state is not a flashing state, ensure the sprite is invisible and stop any running timer.
			ghost_sprite.visible = false
			timer.stop()

func change_visibility_according_to_state(state, data):
	current_state = state
	
	if ghost_npc == null:
		return
	
	begin_toggling_visibility()


func _on_ghost_state_machine_state_changed(state, data):
	change_visibility_according_to_state(state, data)
	pass # Replace with function body.
