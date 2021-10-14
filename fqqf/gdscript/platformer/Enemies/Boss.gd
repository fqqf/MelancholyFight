extends "res://Enemies/Enemy.gd"

var main_instances = ResourceLoader.main_instances

const bullet_scene = preload("res://Player/EnemyBullet.tscn")

export (int) var ACCELERATION = 70

onready var rightWallCheck = $RightWallCheck
onready var leftWallCheck = $LeftWallCheck

signal died

func _process(delta):
	chase_player(delta)
	
func chase_player(delta):
	var player = main_instances.Player
	if player != null:
		var direction_to_move = sign(player.global_position.x - global_position.x)
		motion.x += ACCELERATION * delta * direction_to_move
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		global_position.x += motion.x * delta
		rotation_degrees = lerp(rotation_degrees, (motion.x / MAX_SPEED) * 10, 0.3)
		
		if ((rightWallCheck.is_colliding() and motion.x > 0) or 
		(leftWallCheck.is_colliding() and motion.x < 0)):
			motion.x *= -0.5
			
func fire_bullet() -> void:
	var bullet = Utils.instance_scene_on_main(bullet_scene, global_position)
	var velocity = Vector2.DOWN * 50
	velocity = velocity.rotated(deg2rad(rand_range(-30,30)))
	bullet.velocity = velocity
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	fire_bullet()