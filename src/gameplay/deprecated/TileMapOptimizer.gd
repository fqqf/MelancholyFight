extends "res://src/gameplay/deprecated/GameObjectsOptimizer.gd"

func stop_collide(state):
	if STOP_COLLIDE: node.collision_use_parent = state
