extends Node


export(bool) var DO_HIDE = false
export(bool) var DO_FREE = true
export(bool) var STOP_PROCESS = false
export(bool) var STOP_INPUT = false
export(bool) var PAUSE = true 
export(bool) var BECOME_INVISIBLE = false
export(bool) var DISABLE_COLLISION = true
export var DISTANCE = 1000


# get_parent().get_node("Dynamic").position.x
#get_tree().get_root().get_node("Init/Main/Zone/Dynamic").position.x
	



func _ready():
	
	hide(DO_HIDE)
	set_process(STOP_PROCESS)
	set_process_input(STOP_INPUT)
	pause(PAUSE)
	visible(BECOME_INVISIBLE)
	collision(DISABLE_COLLISION)
	
	# get_parent().get_node("Dynamic").position.x
	# get_tree().get_root().get_node("Init/Main/Zone/Dynamic").position.x
	

func _physics_process(delta):
	if get_parent().get_node("Dynamic").position.x + self.position.x < DISTANCE:
		_ready()
		
	if get_parent().get_node("Dynamic").position.x + self.position.x  < -DISTANCE/2:
		complete_distance(DO_FREE)


func hide(delta):
	if delta:
		get_parent().hide()
	
func set_process(delta):
	if delta:
		get_parent().set_process(delta)
	
func set_process_input(delta):
	if delta:
		get_parent().set_process_input(delta)
	
func pause(delta):
	if delta:
		get_parent().pause()
	
func visible(delta):
	if delta:
		get_parent().visible()
	
func collision(delta):
	if delta:
		
		get_node("CollisionShape2D").disabled = true # disable : DISABLE_COLLISION
	
func complete_distance(delta):
	if DO_FREE:
		queue_free()
	
