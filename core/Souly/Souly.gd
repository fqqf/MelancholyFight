extends KinematicBody2D

export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128

var motion = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):

	if Input.is_action_just_pressed("jump"):
		jump(JUMP_FORCE)
	
	motion = move_and_slide(motion, Vector2.UP) 
	print(position.y)
	apply_gravity(delta)
	print(is_on_floor())
	
func jump(force):
	motion.y = -force

func apply_gravity(delta):
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)
