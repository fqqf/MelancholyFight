extends Node2D

export var STATIC_SPEED = -100

func _physics_process(_delta):
	position.x +=  (_delta*STATIC_SPEED)
