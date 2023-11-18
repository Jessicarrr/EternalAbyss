extends "res://components/shared/scripts/actors/BaseState.gd"

@onready var detection_sphere : Area3D = get_node(get_meta("DetectionSphere"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func begin(_data = {}):
	super.begin(_data)
	Debug.msg(Debug.NPC_STATES, ["Npc is in idle state"])
	
	var overlapping_areas = detection_sphere.get_overlapping_areas()
	
	for ov_area in overlapping_areas:
		if ov_area.is_in_group("PlayerDetection"):
			var player = ov_area.get_parent()
			Debug.msg(Debug.NPC_STATES, [player, " is already in the detection radius of an enemy"])
			await get_tree().create_timer(0.1).timeout
			request_state_change.emit(self, Enums.ActorStates.FOLLOW_PLAYER, {
				"Entity" : player
			})
	
	detection_sphere.area_entered.connect(detection_sphere_entered)
	
	
func end():
	Debug.msg(Debug.NPC_STATES, ["Npc idle state ended."])
	if detection_sphere.area_entered.is_connected(detection_sphere_entered):
		detection_sphere.area_entered.disconnect(detection_sphere_entered)
	super.end()

func detection_sphere_entered(area):
	if active == false:
		return
		
	if area.is_in_group("PlayerDetection"):
		var player = area.get_parent()
		Debug.msg(Debug.NPC_STATES, [player, " entered detection radius of an enemy"])
		request_state_change.emit(self, Enums.ActorStates.FOLLOW_PLAYER, {
			"Entity" : player
		})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
