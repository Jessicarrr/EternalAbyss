extends Node3D

@export var possible_items_names : Array[String] = []
@onready var editor_display = $EditorDisplayBox
@export var percent_chance_spawn_item = 100

func check_integrity_of_items():
	for item_name in possible_items_names:
		var item = Helpers.find_item_by_name(item_name)
		
		if item == null:
			push_error("ItemSpawner ", name, " could not find an item with the name ", item_name)

func spawn_random_item():
	print("ItemSpawner ", get_path(), " spawning item at ", str(self.global_position))
	
	var chance_float = float(percent_chance_spawn_item) / 100
	if Helpers.should_chance_succeed(chance_float) == false:
		return
	
	var random_item_name = possible_items_names.pick_random()
	var item = Helpers.find_item_by_name(random_item_name)
	
	if item == null:
		push_warning(get_path(), " tried to spawn item ", random_item_name, " but item could not be found.")
		return

	var duplicated = item.duplicate()
		
	#if duplicate.is_node_ready() == false:
	#	await duplicate.ready
	
	duplicated.put_in_3d_world()
	#await get_tree().create_timer(0.5).timeout
	#duplicate.velocity = Vector3.ZERO
	duplicated.global_position = self.global_position
	
	#await get_tree().create_timer(5).timeout
	#var pos = duplicate.global_position
	#print(str(pos))
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	editor_display.queue_free()
	WorldData.events.world_gen_complete.connect(_on_world_gen_complete)
	pass # Replace with function body.

func _on_world_gen_complete():
	spawn_random_item()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
