extends KinematicBody2D

const enemy_death_effect_scene = preload("res://Effects/EnemyDeathEffect.tscn")

export (int) var MAX_SPEED = 15
var motion = Vector2.ZERO

onready var stats = $EnemyStats

func _on_Hurtbox_hit(damage):
	stats.health -= damage


func _on_EnemyStats_enemy_died():
	Utils.instance_scene_on_main(enemy_death_effect_scene, global_position)
	queue_free()
