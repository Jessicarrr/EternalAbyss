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
	BLOCK_STAGGER
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

func is_material_metallic(material):
	match self.Materials:
		Materials.IRON, Materials.SILVER:
			return true
		_:
			return false
