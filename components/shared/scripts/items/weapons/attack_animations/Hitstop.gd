extends Node

@export var hitstop_time = 0.075
var latest_animation_node = null

func _on_swing_started(node, new_anim_data):
	Debug.msg(Debug.COLLISIONS, ["Latest animation node updated to ", node])
	latest_animation_node = node

func _on_actor_hit():
	if latest_animation_node == null:
		Debug.msg(Debug.COLLISIONS, ["latest animation node was null"])
		return

	Debug.msg(Debug.COLLISIONS, [latest_animation_node, ": weapon collided so pausing this animation node"])
	latest_animation_node.tween.pause()
	await get_tree().create_timer(hitstop_time).timeout
	latest_animation_node.tween.play()

func _on_area_entered(area):
	if area.get_collision_layer_value(4) == true:
		_on_actor_hit()
