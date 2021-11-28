extends Node2D

onready var light = $Light

func _ready():
	var anim_player = get_node("Light/AnimationPlayer")
	anim_player.seek(rand_range(0,4), true)
	var rand = rand_range(0.9,1.7)
	scale = Vector2(rand, rand)
	light.self_modulate.a = rand_range(0.5,0.8)
