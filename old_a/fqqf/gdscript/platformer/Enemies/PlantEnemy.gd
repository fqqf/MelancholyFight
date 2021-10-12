extends "res://Enemies/Enemy.gd"

const enemy_bullet_scene = preload("res://Player/EnemyBullet.tscn")

export(int) var BULLET_SPEED = 30
export(float) var SPREAD = 30

onready var fireDirection = $FireDirection
onready var bulletSpawnPoint = $BulletSpawnPoint

func fire_bullet():
	var bullet = Utils.instance_scene_on_main(enemy_bullet_scene, bulletSpawnPoint.global_position)
	var velocity = (fireDirection.global_position - global_position).normalized() * BULLET_SPEED
	velocity = velocity.rotated(deg2rad(rand_range(-SPREAD/2, SPREAD)))
	bullet.velocity = velocity
