extends Node

onready var zone_scene = preload("res://core/gameplay/Zone.tscn")

onready var platform_builder = $Position/PlatformBuilder
onready var item_builder = $Position/ItemBuilder

func _ready():
	VisualServer.set_default_clear_color(Color(0.65098, 0.396078, 0.709804))
	var build = platform_builder.generate_chunk()
	print(build[0])
