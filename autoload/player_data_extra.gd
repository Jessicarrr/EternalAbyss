extends Node

var player_camera : Camera3D
var player_instance : CharacterBody3D

signal camera_set

func set_camera(cam):
	if player_camera == null:
		player_camera = cam
		camera_set.emit(cam)
		
func set_player(player):
	if player_instance == null:
		player_instance = player
