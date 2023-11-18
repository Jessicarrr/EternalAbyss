extends Node

var active = false
var data = {}

signal began
signal ended

signal request_state_change

func begin(_data = {}):
	if active == false:
		return
		
	self.data = _data
	began.emit()
	
func end():
	if active == false:
		return
		
	ended.emit()
	self.data = {}
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active == false:
		return
