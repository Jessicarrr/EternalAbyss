extends Node

@export var nav_agent_path : NodePath = ""
var nav_agent

@onready var npc : CharacterBody3D = get_parent()
@onready var collision : CollisionShape3D = npc.get_node("CollisionShape3D")

var gravity = -9.8  # Strength of gravity
var current_gravity = gravity

var move_speed_mult = 1.0

var knockback_velocity = Vector3.ZERO
var knockback_duration = 0.3 # Duration of the knockback in seconds
var knockback_timer = 0.0

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_agent = Helpers.try_load_node(self, nav_agent_path)

func _physics_process(delta):
	if collision.disabled == true:
		return
		
	# Apply gravity
	if not npc.is_on_floor() or knockback_timer > 0:
		npc.velocity.y += gravity * delta

	# Handle knockback effect
	if knockback_timer > 0:
		# Interpolate the horizontal velocity towards zero
		var horizontal_velocity = knockback_velocity * knockback_timer / knockback_duration
		horizontal_velocity.y = 0  # Ignore vertical component for this calculation

		# Add the knockback's vertical velocity only once at the beginning
		if knockback_timer == knockback_duration:
			npc.velocity.y = knockback_velocity.y

		# Combine horizontal and vertical velocities
		npc.velocity.x = horizontal_velocity.x
		npc.velocity.z = horizontal_velocity.z

		knockback_timer -= delta
		npc.move_and_slide()
		return


	# Regular movement logic
	if npc.is_on_floor() and (nav_agent != null) and not nav_agent.is_navigation_finished():
		var current_agent_position: Vector3 = npc.global_position
		var next_path_position: Vector3 = nav_agent.get_next_path_position()
		var direction: Vector3 = (next_path_position - current_agent_position).normalized()
		npc.velocity.x = direction.x * npc.walk_speed * move_speed_mult
		npc.velocity.z = direction.z * npc.walk_speed * move_speed_mult
	else:
		npc.velocity.x = 0
		npc.velocity.z = 0

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
		Enums.ActorStates.DORMANT:
			move_speed_mult = npc.dormant_mult
		Enums.ActorStates.BLOCK_STAGGER:
			move_speed_mult = 0.0
		_:
			move_speed_mult = 1.0
			
func _on_hit(entity, weapon, damage):
	# Calculate the direction vector from the parent to the entity
	var direction = (npc.global_transform.origin - entity.global_transform.origin).normalized()

	# Modify the upward force for a more natural arc
	var upward_force = Vector3(0, 1, 0) 
	var knockback_upward_strength = 0.6 # Reduced for a more natural arc

	# Combine the backward and upward directions
	var knockback_direction = direction + upward_force * knockback_upward_strength
	knockback_direction = knockback_direction.normalized()

	# Define the knockback strength
	var knockback_strength = 5.0

	# Apply the knockback as an initial impulse
	knockback_velocity = knockback_direction * knockback_strength

	# Reset the knockback timer
	knockback_timer = knockback_duration

func _on_blocked_hit(entity, weapon, damage):
	# Calculate the direction vector from the parent to the entity
	var direction = (npc.global_transform.origin - entity.global_transform.origin).normalized()

	# Modify the upward force for a more natural arc
	var upward_force = Vector3(0, 1, 0) 
	var knockback_upward_strength = 0.0 # Reduced for a more natural arc

	# Combine the backward and upward directions
	var knockback_direction = direction + upward_force * knockback_upward_strength
	knockback_direction = knockback_direction.normalized()

	# Define the knockback strength
	var knockback_strength = 3.0

	# Apply the knockback as an initial impulse
	knockback_velocity = knockback_direction * knockback_strength

	# Reset the knockback timer
	knockback_timer = knockback_duration
