extends "res://Enemies/Enemy.gd"

export(int) var ACCELERATION = 100

var main_instances = ResourceLoader.main_instances

onready var animation_player = $AnimationPlayer

onready var sprite = $Sprite

func _ready():
	MAX_SPEED = rand_range(30,50)
	animation_player.seek(rand_range(0,0.6),true)

func _physics_process(delta):
	var player = main_instances.Player
	if player != null:
		chase_player(player, delta)
	
func chase_player(player, delta):
	var direction = (player.global_position - global_position).normalized() 
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(MAX_SPEED)
	sprite.flip_h = global_position < player.global_position
	motion = move_and_slide(motion)
