extends AnimatedSprite


func _physics_process(delta):
	if frame == 49:
		play("default", true)
	elif frame == 0:
		play("default")
