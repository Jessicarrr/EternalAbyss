extends Node

@onready var last_regeneration_process_time = Time.get_ticks_msec()
var regeneration_tick_time_ms = 100
var regeneration_sources = []

func _remove_expired_regeneration_buffs():
	var expired_regens = []
	
	for source in regeneration_sources:
		if source["TicksLeft"] < 1:
			expired_regens.append(source)
			
	for expired_regen in expired_regens:
		regeneration_sources.erase(expired_regen)

func _should_process_regeneration():
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - last_regeneration_process_time
	
	if elapsed_time >= regeneration_tick_time_ms:
		return true
		
	return false

func _process_regeneration():
	var largest_regen = 0
	
	for source in regeneration_sources:
		var regen_percentage = source["Amount"]
		largest_regen = max(regen_percentage, largest_regen)
		source["TicksLeft"] -= 1
	
	#_heal(largest_regen)
	
	last_regeneration_process_time = Time.get_ticks_msec()

func regenerate(amount_per_second, duration_seconds):
	var duration_ms = duration_seconds * 1000
	var ticks = ceil(duration_ms / regeneration_tick_time_ms)
	
	regeneration_sources.append(
		{
			"Amount" : amount_per_second,
			"TotalTicks" : ticks,
			"TicksLeft" : ticks
		}
	)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
