extends Camera2D

var main_instances = ResourceLoader.main_instances

var shake = 0

onready var timer = $Timer

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("add_screenshake", self, "_on_Events_add_screenshake")
	main_instances.WorldCamera = self

func queue_free():
	main_instances.WorldCamera = null
	.queue_free()
	
func _process(_delta):
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)
	
func screenshake(amount, duration):
	shake = amount
	timer.wait_time = duration
	timer.start( )


func _on_Timer_timeout():
	shake = 0

func _on_Events_add_screenshake(amount, duration):
	screenshake(amount, duration)
