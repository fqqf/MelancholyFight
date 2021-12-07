extends Zone
onready var background = $ParallaxBackground/Background
onready var layer1 = $ParallaxBackground/Layer1
onready var layer2 = $ParallaxBackground/Layer2
onready var layer3 = $ParallaxBackground/Layer3
onready var layer4 = $ParallaxBackground2/Layer4
onready var stars = $ParallaxBackground/Stars

var star_scene = preload("res://src/gameplay/zones/Star.tscn")

var offset_x = 0

func _change_properties(state):
	#._change_properties(state)
	var platform_script = load("res://src/gameplay/objects/platforms/Platform.gd")
	platform_script.set_meta("tilemap_id",0)
	for chunk in game.chunks:
		for platform in chunk[0]:
			platform.tilemap_id = 0

func _ready():
	var star
	var rand
	var anim_player
	
	for i in 300:
		star = star_scene.instance()
		star.position = Vector2(rand_range(-1000,1000),rand_range(-300,300))
		rand = rand_range(0.05,0.4)
		star.scale = Vector2(rand, rand)
		anim_player = star.get_node("Light").get_node("AnimationPlayer")
		anim_player.play("Idle")
		anim_player.seek(rand_range(0,4), true)
		anim_player.set_speed_scale(rand_range(0.5,2.5))
	
		stars.add_child(star)
func _process(_delta):
	stars.set_motion_offset(Vector2(-offset_x,0))
	background.set_motion_offset(Vector2(offset_x,0))
	layer1.set_motion_offset(Vector2(offset_x/2,0))
	layer2.set_motion_offset(Vector2(offset_x/3,0))
	layer3.set_motion_offset(Vector2(offset_x/4,0))
	layer4.set_motion_offset(Vector2(-offset_x/6,0))
	offset_x += 6
	pass
