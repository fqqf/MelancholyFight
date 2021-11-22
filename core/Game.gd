extends Node

onready var zoneScene = preload("res://core/gameplay/Zone.tscn")

var current_zone

var dynamic

const MAX_SPEED = 400

func _ready():
	VisualServer.set_default_clear_color(Color(0.65098, 0.396078, 0.709804))
	current_zone = zoneScene.instance()
	add_child(current_zone)
	current_zone.init(10_000,0,[50,70])
	
	dynamic = current_zone.get_node("Dynamic")
	time_started = OS.get_unix_time()

var time_started
var time_passed

var speed = 40
var acceleration = 0.01

func _physics_process(delta):
	assert(current_zone,"Current zone is null!")
	
	time_passed = OS.get_unix_time() - time_started
	
	if time_passed > 90:
		acceleration = 0.02
	elif time_passed > 60:
		acceleration = 0.03
	elif time_passed > 30:
		acceleration = 0.04
	elif time_passed > 15:
		acceleration = 0.01
	
	speed = min(speed+acceleration, MAX_SPEED)
	dynamic.position.x -=  speed*delta
