extends "res://components/shared/scripts/animations/Base2dAnimation.gd"

func _ready():
	super._ready()

func starting_anim(time):
	if tween != null:
		if tween.is_running():
			tween.stop()
	
func ending_anim(time):
	if tween != null:
		if tween.is_running():
			tween.stop()
