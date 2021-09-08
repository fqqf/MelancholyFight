extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	zoom.x = 0.5
	zoom.y = 0.5
	pass # Replace with function body.

func _process(delta):
	var inpx_r = (int(Input.is_action_pressed("ui_right")))
	var inpx_l =  (int(Input.is_action_pressed("ui_left")))
	
	var inpx = inpx_r - inpx_l
	
	var inpy = (int(Input.is_action_pressed("ui_down"))) - (int(Input.is_action_pressed("ui_up")))
	
	print("inpx: "+inpx)
	
	print("inpy: "+inpy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
