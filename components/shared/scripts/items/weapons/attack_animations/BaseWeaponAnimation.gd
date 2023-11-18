extends "res://components/shared/scripts/animations/Base2dAnimation.gd"

signal windup_started
signal swing_started
signal recovery_started
	
func windup():
	pass
	
func swing():
	pass
	
func recover():
	pass
	
func swing_recoil():
	if tween != null:
		if tween.is_running():
			tween.stop()

