extends Area2D

class_name Powerup

var PlayerStats = ResourceLoader.PlayerStats

func _pickup():
	
	SoundFx.play("Powerup", rand_range(0.8, 1.1), -30)
	
