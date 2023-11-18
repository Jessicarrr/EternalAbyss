extends Node
#
#var current_animator_node = null
#@onready var hitbox = get_node(get_meta("HitboxPath"))
#@onready var hitbox_animator = get_node(get_meta("HitboxAnimationPath"))
#
#func _on_weapon_slash_anim(animator_node, anim_data):
#	current_animator_node = animator_node
#
#func _on_hitbox_body_collide(body):
#	var body_parent = body.get_parent()
#	if body == PlayerDataExtra.player_instance or body_parent == PlayerDataExtra.player_instance:
#		return
#
#	Debug.msg(Debug.COLLISIONS, ["Hitbox collided with ", body, " which its parent is ", body_parent])
#
#	if body.get_collision_layer_value(1) == true:
#		hitbox_animator.cancel()
#		current_animator_node.cancel()
#	pass
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
