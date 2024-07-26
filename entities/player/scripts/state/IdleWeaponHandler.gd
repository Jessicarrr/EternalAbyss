extends Node

var hotbar_item = null

func is_hotbar_item_a_weapon():
	if hotbar_item == null:
		return false
	
	if hotbar_item.is_in_group('weapons'):
		return true
		
	return false
	
func is_hotbar_item_food():
	if hotbar_item == null:
		return false
		
	if hotbar_item.is_in_group("food"):
		return true
		
	return false

func _on_hotbar_item_changed(item): #picks up signal for when the hotbar item changes
	hotbar_item = item
