extends Node

@onready var npc = get_node(get_meta("NpcNode"))
@onready var nav_agent : NavigationAgent3D = get_node(get_meta("NavigationAgent"))
@onready var movement_speed = npc.get_meta("WalkSpeed")

var current_movement_target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_agent.navigation_finished.connect(_on_navigation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if nav_agent.is_navigation_finished():
		return
		
	if current_movement_target == null:
		return
		
	var current_agent_position: Vector3 = npc.global_position
	
	# Getting the next position along the path that the agent should move to.
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	
	# Calculating the direction vector towards the next path position.
	var new_velocity: Vector3 = next_path_position - current_agent_position
	
	# Normalizing the vector to get a unit vector, which gives us the direction.
	new_velocity = new_velocity.normalized()
	# Multiplying the normalized vector by the movement speed to get the velocity vector.
	new_velocity = new_velocity * movement_speed
	
	# Setting the velocity property (inherited from CharacterBody3D) with the newly calculated velocity.
	npc.velocity = new_velocity
	# Calling the move_and_slide function (inherited from CharacterBody3D) to move the character.
	npc.move_and_slide()
	
func set_movement_target(target_position):
	current_movement_target = target_position
	nav_agent.set_target_position(current_movement_target)

func _on_set_movement_target(target : Vector3):
	set_movement_target(target)
	
func _on_navigation_finished():
	current_movement_target = null
