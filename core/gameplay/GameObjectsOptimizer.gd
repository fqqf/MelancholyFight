extends Node

export(bool) var STOP_RENDER = false
export(bool) var FREE_AT_END = false
export(bool) var STOP_PROCESS = false
export(bool) var STOP_INPUT = false
export(bool) var STOP_COLLIDE = false

export(int) var ENABLE_DISTANCE = 1000
export(int) var END_DISTANCE = -1000

var node
var dynamic
var properties_active

func _ready():
	node = get_parent()
	dynamic = get_parent().get_parent()
	stop_properties(true)
	
func stop_render(state):
	if STOP_RENDER: node.set_visible(!state)

func stop_process(state):
	if STOP_PROCESS: node.set_process(!state)

func stop_input(state):
	if STOP_INPUT: node.set_process_input(!state)

func stop_collide(state):
	if STOP_COLLIDE: node.get_node("CollisionShape2D").disabled = state

func stop_properties(state):
		stop_render(state)
		stop_process(state)
		stop_input(state)
		stop_collide(state)
		properties_active = !state

func _physics_process(_delta):
	if dynamic.position.x + node.position.x < ENABLE_DISTANCE and not properties_active:
		stop_properties(false)
		
	if dynamic.position.x + node.position.x  < END_DISTANCE:
		end()

func end():
	if FREE_AT_END:
		node.queue_free()
