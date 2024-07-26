extends Node

var held_item = null

func is_holding_weapon():
	if held_item == null:
		return false
		
	if held_item.is_in_group("weapons") == false:
		return false
		
	return true

func _on_hotbar_hotbar_item_changed(item):
	held_item = item
	pass # Replace with function body.
