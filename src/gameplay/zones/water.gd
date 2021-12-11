tool
extends Sprite

func _ready():
	get_tree().get_root().connect("size_changed", self, "_zoom")
	_zoom()

func _zoom():
	if is_physics_processing():
		material.set_shader_param("zoom_y", get_viewport_transform().get_scale().y)
