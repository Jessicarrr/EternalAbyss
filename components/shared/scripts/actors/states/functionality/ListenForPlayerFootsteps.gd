extends Node
class_name ListenForPlayerFootsteps

@onready var parent = get_parent()
var player
var npc

func wait_for_player_ready():
	while PlayerDataExtra.player_instance == null:
		await get_tree().create_timer(0.2).timeout
		continue
		
	player = PlayerDataExtra.player_instance
	
	if player.is_node_ready() == false:
		await player.ready
		
	player.footstep_sound_made.connect(_on_player_footstep)

func _on_player_footstep(volume):
	if parent.active == false:
		return
		
	var distance_to_player = npc.global_position.distance_to(player.global_position)
	var effective_volume = calculate_effective_volume(volume, distance_to_player)
	
	if distance_to_player < 4:
		Debug.msg(Debug.NPC_HEARING, ["Hearing player at volume ", effective_volume, " with hearing threshold at ", npc.minimum_hearing_volume])
		
	if effective_volume >= npc.minimum_hearing_volume:
		Debug.msg(Debug.NPC_HEARING, ["Heard player"])

func calculate_effective_volume(emitted_volume, distance):
	# Adjust how quickly the sound diminishes with distance (sound attenuation).
	var falloff = parent.npc.hearing_distance_falloff
	var effective_volume = emitted_volume / (falloff * distance + 1)
	return effective_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	await wait_for_player_ready()
	npc = parent.npc
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
