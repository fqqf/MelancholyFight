extends KinematicBody2D

export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO


func _on_HurtBox_hit(damage):
	queue_free()
