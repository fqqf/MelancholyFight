extends StaticBody2D

onready var animationPlayer = $AnimationPlayer

var player_stats = ResourceLoader.player_stats


func _on_SaveArea_body_entered(_body):
	SoundFX.play("Powerup", 0.6, -10)
	animationPlayer.play("Save")
	SaverAndLoader.save_game()
	player_stats.refill_stats()
