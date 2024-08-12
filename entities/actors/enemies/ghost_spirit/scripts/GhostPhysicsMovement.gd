extends Node

@export var nav_agent_path : NodePath = ""
var nav_agent

@onready var npc : CharacterBody3D = get_parent()

var move_speed_mult = 1.0

var dead = false

var friction_amount = 2.0

var ground_level_at_spawn = 0.0

#@export var raycast_node_path : NodePath = ""
#var raycast

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_agent = Helpers.try_load_node(self, nav_agent_path)
	#raycast = Helpers.try_load_node(self, raycast_node_path)
	
	
	npc.on_hit.connect(_on_hit)
	ground_level_at_spawn = npc.global_transform.origin.y
	

func move_towards_ground(delta):
	var threshold = 0.05  # Only move if the distance is greater than this threshold
	var flat_speed = friction_amount * 1.5  # Define a flat speed to move towards the ground
	
	var current_distance_to_ground = npc.global_position.y - ground_level_at_spawn
	
	if abs(current_distance_to_ground) > threshold:
		# Determine the direction the ghost needs to move to approach the ground
		var direction = sign(current_distance_to_ground)

		# Calculate the potential new position
		var potential_move = flat_speed * delta * direction

		# Check if the move exceeds the distance to the ground
		if abs(potential_move) > abs(current_distance_to_ground):
			# If it does, adjust to just close the gap
			npc.velocity.y = -current_distance_to_ground / delta
		else:
			# Otherwise, apply the flat speed in the correct direction
			npc.velocity.y -= potential_move




func apply_friction(delta):
	# Calculate the friction to apply this frame
	var friction_this_frame = friction_amount * delta

	# Apply friction to the x-axis
	if abs(npc.velocity.x) > 0:
		if abs(npc.velocity.x) < friction_this_frame:
			npc.velocity.x = 0
		else:
			npc.velocity.x -= friction_this_frame * sign(npc.velocity.x)
	
	# Apply friction to the y-axis
	if abs(npc.velocity.y) > 0:
		if abs(npc.velocity.y) < friction_this_frame:
			npc.velocity.y = 0
		else:
			npc.velocity.y -= friction_this_frame * sign(npc.velocity.y)
	
	# Apply friction to the z-axis
	if abs(npc.velocity.z) > 0:
		if abs(npc.velocity.z) < friction_this_frame:
			npc.velocity.z = 0
		else:
			npc.velocity.z -= friction_this_frame * sign(npc.velocity.z)

func _physics_process(delta):
	if dead == true:
		return
		
	apply_friction(delta)

	# Regular movement logic
	if (nav_agent != null) and not nav_agent.is_navigation_finished():
		var current_agent_position: Vector3 = npc.global_position
		var next_path_position: Vector3 = nav_agent.get_next_path_position()
		var direction: Vector3 = (next_path_position - current_agent_position).normalized()
		npc.velocity.x = direction.x * npc.walk_speed * move_speed_mult
		npc.velocity.z = direction.z * npc.walk_speed * move_speed_mult
		npc.velocity.y = direction.y * npc.walk_speed * move_speed_mult
	else:
		move_towards_ground(delta)

	# Move the NPC
	npc.move_and_slide()

	
func _on_state_machine_state_changed(state, data):
	if npc == null:
		return
		
		
	match(state):
		Enums.ActorStates.IDLE:
			move_speed_mult = npc.idle_mult
		Enums.ActorStates.FOLLOW_PLAYER:
			move_speed_mult = 1.0
		Enums.ActorStates.BLOCK_START:
			move_speed_mult = npc.block_start_mult
		Enums.ActorStates.BLOCKING:
			move_speed_mult = npc.block_mult
		Enums.ActorStates.BLOCK_END:
			move_speed_mult = npc.block_end_mult
		Enums.ActorStates.ATK_WINDUP:
			move_speed_mult = npc.windup_mult
		Enums.ActorStates.ATK_SWING:
			move_speed_mult = npc.swing_mult
		Enums.ActorStates.ATK_RECOVERY:
			move_speed_mult = npc.recovery_mult
		Enums.ActorStates.STAGGERED:
			move_speed_mult = npc.stagger_mult
		Enums.ActorStates.DEAD:
			dead = true
			move_speed_mult = 0.0
		Enums.ActorStates.BLOCK_STAGGER:
			move_speed_mult = 0.0
		_:
			move_speed_mult = 1.0
			
func _on_hit(entity, weapon, damage):
	# Calculate the direction vector from the parent to the entity
	var direction = (npc.global_transform.origin - entity.global_transform.origin).normalized()

	# Modify the upward force for a more natural arc
	var upward_force = Vector3(0, 1, 0) 
	var knockback_upward_strength = 1.1 # Reduced for a more natural arc

	# Combine the backward and upward directions
	var knockback_direction = direction + upward_force * knockback_upward_strength
	knockback_direction = knockback_direction.normalized()

	# Define the knockback strength
	var knockback_strength = 2.0

	# Apply the knockback as an initial impulse
	npc.velocity += knockback_direction * knockback_strength
