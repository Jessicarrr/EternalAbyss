extends RayCast3D
class_name EnemyRaycast3D

var time_between_checks = 300
@onready var last_check_time = Time.get_ticks_msec()

@onready var player = PlayerDataExtra.player_instance

var minimum_distance_to_raycast = 8

var could_previously_see_player = false

signal gained_player_visibility
signal lost_player_visibility

@export var npc_path : NodePath = ""
var npc

# Called when the node enters the scene tree for the first time.
func _ready():
	npc = Helpers.try_load_node(self, npc_path)
	
	if npc != null:
		minimum_distance_to_raycast = npc.visibility_range

func can_see_player():
	if player == null:
		return false
		
	var space_state = player.get_world_3d().direct_space_state
	var origin_position = self.global_transform.origin
	var target_position = player.global_transform.origin
	
	var query = PhysicsRayQueryParameters3D.create(origin_position, target_position)
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		return false
	
	var collider = result["collider"]
	var collider_parent = collider.get_parent()
	
	if collider_parent == player or collider == player:
		return true
	else:
		Debug.msg(Debug.NPC_STATES, ["Can't see player but can see ", collider, collider_parent])
		return false

func emit_whether_i_can_see_player():
	if player == null:
		player = PlayerDataExtra.player_instance
		print("player was null")
		return
	
	var distance = player.global_position.distance_to(self.global_position)
	#Debug.msg(Debug.NPC_STATES, ["Distance between npc and player is ", distance])
	
	if distance > minimum_distance_to_raycast:
		#print("player too far away")
		#Debug.msg(Debug.NPC_STATES, ["Player too far away."])
		return
	
	var player_visible = can_see_player()
	
	#Debug.msg(Debug.NPC_STATES, ["player visible? ", player_visible])
	
	if player_visible == true and could_previously_see_player == false:
		gained_player_visibility.emit()
		Debug.msg(Debug.NPC_STATES, ["Saw the player."])
		could_previously_see_player = true
		return
		
	if player_visible == false and could_previously_see_player == true:
		lost_player_visibility.emit()
		could_previously_see_player = false
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Helpers.has_enough_time_passed(time_between_checks, last_check_time) == false:
		return
		
	last_check_time = Time.get_ticks_msec()
	
	emit_whether_i_can_see_player()
		
	
	
