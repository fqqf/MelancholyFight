extends Node2D

class_name Zone

var game

var enabled = false setget set_enabled, is_enabled

func set_enabled(state): 
	enabled = state
	if enabled:
		set_process(true)
		set_physics_process(true)
		set_process_input(true)
		visible = true

		game = Singleton.game
	else:
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		visible = false
	
	_set_zone_active(state)
	
func is_enabled(): return enabled

func _set_zone_active(_state):
	pass
	
func rebuild_platforms(zone_type):
	Singleton.platform_tilemap_id = zone_type
	for chunk in game.chunks:
		for platform in chunk[0]:
			platform.build()
	
