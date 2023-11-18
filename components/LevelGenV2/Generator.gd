extends Node

@export_category("Generator Options")
@export var algorithm : Node
@export var algorithm_helper : Node
@export var maximum_allowed_fails : int

@export_category("Requirements")
@export var player_scene : PackedScene

@onready var debug = get_node("GenDebug")

@onready var layout_node = get_node(self.get_meta("LayoutPath"))
@onready var root_node = get_node(self.get_meta("RootPath"))
@onready var actors_node = get_node(self.get_meta("ActorsPath"))
@onready var current_level_data = LevelData.get_current_level()

var generation_fails_in_a_row = 0

signal generation_finished

func place_environment():
	var environment_resource = load(current_level_data["Environment"])
	var environment = environment_resource.instantiate()
	
	root_node.add_child.call_deferred(environment)

func place_player():
	var player = player_scene.instantiate()
	actors_node.add_child.call_deferred(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	await algorithm.ready
	algorithm.add_data(current_level_data["Rooms"])
	algorithm.set_path(layout_node)
	
	var result

	while true:  # Infinite loop, but we'll break out manually
		result = await algorithm.generate_next()
		
		if result == GenerationConstants.finished_step:
			continue  # Go to the next iteration
		
		elif result == GenerationConstants.failed_step:
			generation_fails_in_a_row += 1
			if generation_fails_in_a_row >= maximum_allowed_fails:
				print("Generation failed.")
				break  # Exit the loop
		
		elif result == GenerationConstants.finished_generation:
			print("Generation signal finished")
			break  # Exit the loop

	print("Generation loop broken")
	generation_finished.emit(current_level_data)
	place_environment()
	place_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
