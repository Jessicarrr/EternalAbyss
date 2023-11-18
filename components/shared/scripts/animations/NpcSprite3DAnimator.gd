extends Node

@export var npc_node_path : NodePath = ""
var npc : CharacterBody3D = null
@onready var sprite : AnimatedSprite3D = get_parent()
var current_state = Enums.ActorStates.IDLE
var current_data = {}
var tick_time_ms = 100
var last_tick = 0
var npc_prev_position = Vector3.ZERO

var walking_states = [
	Enums.ActorStates.FOLLOW_PLAYER
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if not npc_node_path:
		push_error(self, " no npc node path set. This node requires a npc node path")
		return
		
	npc = get_node(npc_node_path)
	npc_prev_position = npc.global_position



func play(name):
	if sprite.animation != name:
		sprite.play(name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_time = Time.get_ticks_msec()
	var elapsed_time = current_time - last_tick
	
	if elapsed_time < tick_time_ms:
		return
		
	last_tick = Time.get_ticks_msec()
		
	match current_state:
		Enums.ActorStates.IDLE:
			play("idle")
			
		Enums.ActorStates.FOLLOW_PLAYER:
			if npc.has_moved() == true:
				play("walk")
			else:
				play("idle")
		Enums.ActorStates.STAGGERED:
			var frames = sprite.sprite_frames
			var num_frames_in_stagger = frames.get_frame_count("staggered") # int frames in anim
			var stagger_time = current_data["StaggerTime"] # stagger time in seconds
			
			# do math
			var fps = floor(num_frames_in_stagger / stagger_time)
			
			#set anim speed
			frames.set_animation_speed("staggered", fps)
			play("staggered")
		Enums.ActorStates.DEAD:
			play("death")
		Enums.ActorStates.BLOCK_START:
			var frames = sprite.sprite_frames
			var num_frames_in_stagger = frames.get_frame_count("block_start") # int frames in anim
			var stagger_time = npc.block_transition_time
			
			# do math
			var fps = floor(num_frames_in_stagger / stagger_time)
			
			#set anim speed
			frames.set_animation_speed("block_start", fps)
			play("block_start")
		Enums.ActorStates.BLOCK_END:
			var frames = sprite.sprite_frames
			var num_frames_in_stagger = frames.get_frame_count("block_end") # int frames in anim
			var stagger_time = npc.block_transition_time
			
			# do math
			var fps = floor(num_frames_in_stagger / stagger_time)
			
			#set anim speed
			frames.set_animation_speed("block_end", fps)
			play("block_end")
		Enums.ActorStates.BLOCKING:
			play("block")
		Enums.ActorStates.BLOCK_STAGGER:
			var frames = sprite.sprite_frames
			var num_frames_in_stagger = frames.get_frame_count("block_stagger") # int frames in anim
			var stagger_time = current_data["StaggerTime"] # stagger time in seconds
			
			# do math
			var fps = floor(num_frames_in_stagger / stagger_time)
			
			#set anim speed
			frames.set_animation_speed("block_stagger", fps)
			play("block_stagger")
		_:
			play("idle")


func _on_skeleton_state_machine_state_changed(state, data):
	current_state = state
	current_data = data
