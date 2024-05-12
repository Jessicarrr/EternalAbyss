extends Node

enum EquipmentType { 
	HELMET = 0,
	AMULET = 1,
	BACK = 2,
	TORSO = 3,
	OFF_HAND = 4,
	LEGS = 5,
	BELT = 6,
	FEET = 7,
	NONE = 8,
	MAIN_HAND = 9
}

enum ContainerStates { 
	FULL,
	EMPTY,
	ITEM_ADDED,
	FAILED 
}

enum ActorStates {
	DEAD,
	IDLE,
	STAGGERED,
	ATK_WINDUP,
	ATK_SWING,
	ATK_RECOVERY,
	ATK_CANCEL,
	ATK_RECOIL,
	FOLLOW_PLAYER,
	BLOCK_START,
	BLOCKING,
	BLOCK_END,
	BLOCK_STAGGER,
	EATING,
	DRINKING,
	DORMANT,
	REANIMATING,
	GHOST_COMBAT_FOLLOW,
	GHOST_TEMPORARY_APPEARANCE
}

enum ItemUsages {
	NONE,
	EAT,
	DRINK,
	BLOCK
}

enum Materials {
	NONE,
	WOOD,
	IRON,
	SILVER
}

enum Effects { 
	NONE,
	HEALTH_REGEN
}

enum ControllerTypes {
	GAMEPAD,
	KEYBOARD
}

enum SoundDescriptions {
	NONE,
	AMBIENCE,
	ACTION,
	COMBAT
}

enum SoundVolumes {
	SILENT = 0,
	QUIET = 50, # sneaking footstep sound, door opening
	AVERAGE = 100, #normal footstep sound, door closing
	SEMI_LOUD = 135, #running footstep?
	LOUD = 180, # 
	VERY_LOUD = 280, #gun shots or something?
	DEAFENING = 400 # explosions?
}

func is_material_metallic(material):
	match self.Materials:
		Materials.IRON, Materials.SILVER:
			return true
		_:
			return false
