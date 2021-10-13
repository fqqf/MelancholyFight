extends Powerup

func _pickup():
	PlayerStats.missiles_unlocked = false
	print("КОНФЛИКТ!!!")