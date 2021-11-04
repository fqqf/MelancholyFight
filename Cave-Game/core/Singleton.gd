extends Node

onready var player = null setget setPlayer
onready var screen


signal setPlayer
signal setScreen

func setPlayer(_player):
	player = _player
	Logger.info("Set player")
	emit_signal("setPlayer")

func _ready():
	pass
