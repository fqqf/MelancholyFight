extends Node2D

class_name Zone

var game

var enabled = false setget set_enabled, is_enabled

func set_enabled(state): 
	enabled = state
	if enabled:
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		visible = false
	else:
		set_process(true)
		set_physics_process(true)
		set_process_input(true)
		visible = true
	
	_change_properties(state)
	
func is_enabled(): return enabled

func _change_properties(_state):
	pass

func init(_game):
	self.game = _game
	return self
