extends Node2D

onready var background = $ParallaxBackground/Background
onready var moon = $ParallaxBackground2/Moon
onready var moon_part = $ParallaxBackground2/Moon/AnimatedSprite/MoonPart

onready var deco1 = $ParallaxBackground2/Moon/deco1
onready var deco2 = $ParallaxBackground2/Moon/deco2
onready var deco3 = $ParallaxBackground2/Moon/deco3

onready var cloud1 = $ParallaxBackground3/Clouds/Cloud1
onready var cloud2 = $ParallaxBackground3/Clouds/Cloud2
onready var cloud3 = $ParallaxBackground3/Clouds/Cloud3


onready var light = $ParallaxBackground2/Moon/light

onready var layer0 = $ParallaxBackground3/Layer0
onready var layer1 = $ParallaxBackground3/Layer1
onready var layer2 = $ParallaxBackground4/Layer2


onready var stars = $ParallaxBackground/Stars

onready var star_scene = preload("res://src/gameplay/zones/Star.tscn")

var offset_x = 0
var cool_offset = 0 

func _ready():
	var star
	var rand
	var anim_player
	
	for i in 100:
		star = star_scene.instance()
		star.get_node("Light").self_modulate = (Color(0.15,0.84,1,0.8))
		star.position = Vector2(rand_range(-1000,1000),rand_range(-300,300))
		rand = rand_range(0.05,0.4)
		star.scale = Vector2(rand, rand)
		anim_player = star.get_node("Light").get_node("AnimationPlayer")
		anim_player.play("Idle")
		anim_player.seek(rand_range(0,4), true)
		anim_player.set_speed_scale(rand_range(0.5,2.5))
		stars.add_child(star)
		
	deco1.position = Vector2(rand_range(0,1328),rand_range(230,360))
	deco2.position = Vector2(rand_range(0,1328),rand_range(230,360))
	deco3.position = Vector2(rand_range(0,1328),rand_range(230,360))
	
	cloud1.position = Vector2(rand_range(-726,830), rand_range(-108,110))
	cloud2.position = Vector2(rand_range(-726,830), rand_range(-108,110))
	cloud3.position = Vector2(rand_range(-726,830), rand_range(-108,110))
	
	var _sign = ceil(rand_range(-1,1))
	cloud_1_speed = rand_range(_sign*0, _sign*0.9)
	cloud_2_speed = rand_range(_sign*0, _sign*0.9)
	cloud_3_speed = rand_range(_sign*0, _sign*0.9)
	
	light.set_modulate(Color(1.3,1.3,1.3,0.9))

var cloud_1_speed
var cloud_2_speed
var cloud_3_speed

func _process(_delta):
	stars.set_motion_offset(Vector2(-offset_x/2.5,0))
	#stars.set_motion_offset(Vector2(-offset_x,0))
	background.set_motion_offset(Vector2(cool_offset*2,0))
	moon.set_motion_offset(Vector2(-cool_offset,0))
	layer0.set_motion_offset(Vector2(offset_x,0))
	layer1.set_motion_offset(Vector2(offset_x/3,0))
	layer2.set_motion_offset(Vector2(-offset_x/6,0))
	
	cloud1.position.x += cloud_1_speed
	cloud2.position.x += cloud_2_speed
	cloud3.position.x += cloud_3_speed
	
	#layer4.set_motion_offset(Vector2(-offset_x/6,0))
	#moon_part.position = Vector2(moon_part.position.x+rand_range(-1,1), moon_part.position.y+rand_range(-1,1))
	offset_x += 6
	cool_offset +=0.1
	pass
