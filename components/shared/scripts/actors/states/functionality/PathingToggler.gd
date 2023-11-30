extends Node

@export var nav_agent_path : NodePath = ""
var nav_agent : NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_agent = Helpers.try_load_node(self, nav_agent_path)
	pass # Replace with function body


func _on_enemy_ray_cast_3d_gained_player_visibility():
	if nav_agent == null:
		return
		
	nav_agent.path_postprocessing = NavigationPathQueryParameters3D.PATH_POSTPROCESSING_CORRIDORFUNNEL


func _on_enemy_ray_cast_3d_lost_player_visibility():
	if nav_agent == null:
		return
		
	nav_agent.path_postprocessing = NavigationPathQueryParameters3D.PATH_POSTPROCESSING_EDGECENTERED
