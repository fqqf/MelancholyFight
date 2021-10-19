extends Node2D

func _ready():
	SoundFX.play("EnemyDie")
	


func _on_EnemyDeathEffect_tree_exited():
	queue_free()
