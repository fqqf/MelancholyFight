extends ParallaxBackground

onready var layer1 = $ParallaxLayer
onready var layer2 = $ParallaxLayer2
onready var layer3 = $ParallaxLayer3
onready var layer4 = $ParallaxLayer4

var offset_x = 0

func _process(delta):
	layer1.set_motion_offset(Vector2(offset_x,0))
	layer2.set_motion_offset(Vector2(offset_x/2,0))
	layer3.set_motion_offset(Vector2(offset_x/4,0))
	layer4.set_motion_offset(Vector2(offset_x/6,0))
	offset_x += 1
	pass
