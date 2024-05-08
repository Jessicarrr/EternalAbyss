extends Node
class_name ListenForPlayerFootsteps

@onready var parent = get_parent()
var player
var npc
@export var npc_path :NodePath = ""

signal alerted

func wait_for_world_events_ready():
	while WorldData.events == null:
		await get_tree().create_timer(0.5).timeout
		
	WorldData.events.sound_event.connect(_on_sound_played)

func _on_sound_played(source, volume, sound_global_position, description):
	if parent.active == false:
		return
	
	if source != PlayerDataExtra.player_instance:
		return
		
	var distance_to_thing_heard = npc.global_position.distance_to(sound_global_position)
	var effective_volume = calculate_effective_volume(volume, distance_to_thing_heard)
	
	if distance_to_thing_heard < 4:
		Debug.msg(Debug.NPC_HEARING, ["Detected sound at volume ", effective_volume, ", will notice  stuff at: ", npc.minimum_hearing_volume, ". Distance to thing: ", distance_to_thing_heard])
		
	if effective_volume >= npc.minimum_hearing_volume:
		Debug.msg(Debug.NPC_HEARING, ["Heard player"])
		alerted.emit()
		return
		
	if distance_to_thing_heard <= npc.touching_detection_distance:
		Debug.msg(Debug.NPC_HEARING, ["Touched player"])
		alerted.emit()
		return

func calculate_effective_volume(emitted_volume, distance):
	# Adjust how quickly the sound diminishes with distance (sound attenuation).
	var falloff = parent.npc.hearing_distance_falloff
	var effective_volume = emitted_volume / (falloff * distance + 1)
	return effective_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	npc = Helpers.try_load_node(self, npc_path)
	await wait_for_world_events_ready()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
