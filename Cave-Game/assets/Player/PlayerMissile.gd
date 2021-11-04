extends "res://Player/Projectile.gd"

const BRICK_LAYER_BIT = 4
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _ready():
	SoundFX.play("Explosion")

func _on_Hitbox_body_entered(body):
	if body.get_collision_layer_bit(BRICK_LAYER_BIT):
		body.queue_free()
		Utils.instance_scene_on_main(EnemyDeathEffect, body.global_position)
	._on_Hitbox_area_entered(body)
	
