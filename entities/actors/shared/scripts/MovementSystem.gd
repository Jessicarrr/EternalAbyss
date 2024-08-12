extends Node

@export var npc_path : NodePath = ""

var npc
@onready var nav_agent : NavigationAgent3D = get_parent()
var movement_speed

var current_movement_target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	npc = Helpers.try_load_node(self, npc_path)
	movement_speed = npc.walk_speed
	
	nav_agent.navigation_finished.connect(_on_navigation_finished)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Calling the move_and_slide function (inherited from CharacterBody3D) to move the character.
	npc.move_and_slide()
	
func set_movement_target(target_position):
	current_movement_target = target_position
	nav_agent.set_target_position(current_movement_target)

func _on_set_movement_target(target : Vector3):
	set_movement_target(target)
	
func clear_movement_target():
	current_movement_target = null
	
func _on_navigation_finished():
	current_movement_target = null
