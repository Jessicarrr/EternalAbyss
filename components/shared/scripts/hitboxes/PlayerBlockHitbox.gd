extends "res://components/shared/scripts/hitboxes/CombatHitbox.gd"
class_name PlayerBlockHitbox

@onready var camera = PlayerDataExtra.player_camera
var distance_in_front = 0.17
@export var parent_item_path : NodePath = ""
var parent_item

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_entity = PlayerDataExtra.player_instance
	
	if not parent_item_path:
		push_error(self, " needs a parent item path set")
		return
		
	parent_item = get_node(parent_item_path)
	
	pass # Replace with function body.

func place_hitbox_in_front_of_player():
	self.global_position = camera.global_position
	self.global_rotation = camera.global_rotation
	var forward_dir = camera.global_transform.basis.z.normalized() * -1
	var new_pos = self.global_position + forward_dir * distance_in_front
	self.global_position = new_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent_entity == null:
		return
		
	if parent_item == null:
		return
	
	if parent_item.is_equipped() == false:
		return	
	
	place_hitbox_in_front_of_player()
