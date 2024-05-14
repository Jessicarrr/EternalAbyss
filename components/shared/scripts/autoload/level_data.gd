extends Node

var _game_levels = [
	{
		"Name" : "Prison",
		"Rooms" : {
			"Administration" : {
				"NumRequired" : 1,
				"Path" : "res://components/levels/Prison/Administration.tscn",
				"Weight" : 1
			},
			"Hallway" : {
				"IsHallway" : true,
				"NumRequired" : 20,
				"Path" : "res://components/levels/Prison/Hallway.tscn",
				"Weight" : 10
			},
			"PrisonCell" : {
				"NumRequired" : 10,
				"Path" : "res://components/levels/Prison/PrisonCell.tscn",
				"Weight" : 4
			},
			"Storage" : {
				"NumRequired" : 3,
				"Path" : "res://components/levels/prison/Storage.tscn",
				"Weight" : 4
			}
		},
		"Environment" : "res://components/levels/prison/EnvironmentalSettings.tscn",
		"Enemies" : [
			{
				"Path" : "res://components/Entities/enemies/skeleton_sword_shield_simple/skeleton_sword_shield_simple.tscn",
				"NumRequired" : 0,
				"SpawnPoints" : [
					"EnemySpawnPoint"
				]
			},
			{
				"Path" : "res://components/Entities/enemies/ghost_spirit/ghost_spirit.tscn",
				"NumRequired" : 0,
				"SpawnPoints" : [
					"GhostSpawnPoint"
				]
			}
		],
		"AmbientSounds" : [
			"res://sounds/ambience/random/rocks/singular_stone_01.wav",
			"res://sounds/ambience/random/rocks/singular_stone_02.wav",
			"res://sounds/ambience/random/rocks/singular_stone_03.wav",
			"res://sounds/ambience/random/rocks/stones-falling.wav",
			"res://sounds/ambience/random/rocks/stones_falling_02.wav",
			"res://sounds/ambience/random/ghosts/581090__magnuswaker__cavernous-moan.wav",
			#"res://sounds/ambience/random/ghosts/ghost_distance_01.wav",
			"res://sounds/ambience/random/ghosts/ghost_distance_02.wav",
			#"res://sounds/ambience/random/ghosts/groan_01.wav",
			"res://sounds/ambience/random/footsteps/random_singular_step.wav",
			"res://sounds/ambience/impacts/381602__dorianmastin__snd_impactnormalwood05.wav"
		]
	}
]

var _current_level_index = 0

signal level_changed

func get_current_level():
	return _game_levels[_current_level_index]
