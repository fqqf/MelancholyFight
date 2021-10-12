extends Node2D

const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta
	


# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
	


func _on_HitBox_body_entered(body):
	Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()


func _on_HitBox_area_entered(_area):
	Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()
