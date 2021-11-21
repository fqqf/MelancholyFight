extends Node2D

export(bool) var STOP_RENDER = false
export(bool) var FREE_AT_END = false
export(bool) var STOP_PROCESS = false
export(bool) var STOP_INPUT = false
export(bool) var STOP_COLLIDE = false

export(int) var DISTANCE = 1000

var node
var dynamic
var properties_active

func _ready():
	node = get_parent()
	dynamic = get_parent().get_parent()
	disable_properties()
	
func disable_properties():
	if STOP_RENDER: node.set_visible(false)
	if STOP_PROCESS: node.set_process(false)
	if STOP_INPUT: node.set_process_input(false)
	if STOP_COLLIDE: node.get_node("CollisionShape2D").disabled = true
	properties_active = false

func enable_properties():
	if STOP_RENDER: node.set_visible(true)
	if STOP_PROCESS: node.set_process(true)
	if STOP_INPUT: node.set_process_input(true)
	if STOP_COLLIDE: node.get_node("CollisionShape2D").disabled = false
	properties_active = true

func _physics_process(_delta):
	if dynamic.position.x + node.position.x < DISTANCE && not properties_active:
		enable_properties()
		
	if dynamic.position.x + node.position.x  < -DISTANCE/2:
		end()

func end():
	if FREE_AT_END:
		node.queue_free()
