extends Node

enum EquipmentType { 
	OFF_HAND = 0,
 	MAIN_HAND = 1,
	TORSO = 2 
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
	CONSUME,
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
