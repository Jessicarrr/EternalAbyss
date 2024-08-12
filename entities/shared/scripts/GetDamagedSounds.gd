extends RandomStreamPlayer

@export var thing_to_track : CharacterBody3D

func _ready():
	super._ready()
	thing_to_track.on_hit.connect(_on_hit)
	
func _on_hit(_entity, _dmg):
	play_random()
	pass
