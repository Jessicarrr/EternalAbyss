extends Node
class_name ListenForPlayerFootsteps

@onready var parent = get_parent()
var player
var npc
@export var npc_path :NodePath = ""

signal alerted

@export var alert_categories : Array[Enums.SoundSources] = [
	Enums.SoundSources.PLAYER_FOOTSTEP,
	Enums.SoundSources.NON_PLAYER_FOOTSTEP
]

func wait_for_world_events_ready():
	while WorldData.events == null:
		await get_tree().create_timer(0.5).timeout
		
	WorldData.events.sound_event.connect(_on_sound_played)

func _on_sound_played(source, volume, sound_global_position):
	if parent.active == false:
		return
		
	if source not in alert_categories:
		return
		
	var distance_to_player = npc.global_position.distance_to(sound_global_position)
	var effective_volume = calculate_effective_volume(volume, distance_to_player)
	
	if distance_to_player < 4:
		Debug.msg(Debug.NPC_HEARING, ["Hearing player at volume ", effective_volume, ", will hear player at: ", npc.minimum_hearing_volume, ". Distance to player: ", distance_to_player])
		
	if effective_volume >= npc.minimum_hearing_volume:
		Debug.msg(Debug.NPC_HEARING, ["Heard player"])
		alerted.emit()
		return
		
	if distance_to_player <= npc.touching_detection_distance:
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
