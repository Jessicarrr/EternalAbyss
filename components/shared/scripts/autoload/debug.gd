extends Node

const COMBAT = 0
const GENERAL_STATES = 1
const PLAYER_STATES = 2 
const NPC_STATES = 3
const OBJECT_STATES = 4
const GENERATION = 5
const GENERATION_COLLISION = 7
const ANIMATION = 6
const NPC_GENERATION = 8
const AUDIO = 9
const COLLISIONS = 10

const SHOW_HITBOXES = false

var print_flags = {
	COMBAT: false,
	GENERAL_STATES: false,
	PLAYER_STATES: false,
	PLAYER_STATE_MACHINE: false,
	NPC_STATES: false,
	NPC_STATE_MACHINE: false,
	OBJECT_STATES: false,
	GENERATION: false,
	GENERATION_COLLISION: false,
	ANIMATION: false,
	NPC_GENERATION: false,
	AUDIO: false,
	COLLISIONS: false,
	WELDER_GEN: false
}

func msg(type, args = []):
	if print_flags.get(type, false):
		var message = ""
		
		message += "["
		message += str(Time.get_ticks_msec())
		message += " ticks]: "
		for arg in args:
			message += str(arg)
		print(message)
