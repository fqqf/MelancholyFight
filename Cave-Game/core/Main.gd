extends Node2D

var viewport
onready var camera = $Camera

var lastPos 
var curPos

func _ready():
	Singleton.main = self
	viewport = get_viewport()
	viewport.connect("size_changed", self, "_root_viewport_size_changed")
	lastPos = camera.position.x
	curPos = camera.position.x
	_root_viewport_size_changed()

func _root_viewport_size_changed():
	var cur_width = viewport.size.x/viewport.size.y
	var default_width = Config.DEFAULT_ASPECT_RATIO
	var diff = cur_width/(default_width/cur_width)
	print(camera.position.x)
	_adjustPos()
	camera.position.x = (cur_width/default_width)*curPos
	lastPos=camera.position.x
	
func _process(delta):
	_adjustPos()
	

func _adjustPos():
	if lastPos!=camera.position.x:
		curPos += lastPos-camera.position.x
		lastPos=camera.position.x
