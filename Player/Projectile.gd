extends Node2D

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta
	


# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
	


func _on_HitBox_body_entered(body):
	queue_free()


func _on_HitBox_area_entered(area):
	queue_free()
