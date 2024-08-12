extends Node
class_name TimedFunctionExecutor

@onready var decision_timer : Timer = Timer.new()
@export var wait_time = 0.5
@export var function_to_call : Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_method("timed_execute") == false:
		push_error(self.get_path(), " requires parent node to have a function called 'timed_execute()'")
		return
	
	add_child(decision_timer)
	decision_timer.wait_time = wait_time  # Time in seconds between decisions
	decision_timer.timeout.connect(get_parent().timed_execute)
	decision_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
