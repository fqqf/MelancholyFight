extends Node

var viewport
onready var cameraViewport = $CameraViewport
onready var camera = $CameraViewport/Camera

var last_pos 
var cur_pos

func _ready():
	Singleton.main = self
	viewport = get_viewport()
	viewport.connect("size_changed", self, "_root_viewport_size_changed")
	last_pos = cameraViewport.position.x
	cur_pos = cameraViewport.position.x
	_root_viewport_size_changed()

func _root_viewport_size_changed():
	var cur_ratio = viewport.size.x/viewport.size.y
	var default_ratio = Config.DEFAULT_ASPECT_RATIO
	var _diff = cur_ratio/(default_ratio/cur_ratio)
	cameraViewport.position.x = (cur_ratio/default_ratio)*(Config.DEFAULT_WIDTH/2)-Config.DEFAULT_WIDTH/2
