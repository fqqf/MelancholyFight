extends KinematicBody2D

export (int) var GRAVITY = 210
export (int) var JUMP_FORCE = 125

onready var coyote_timer = $CoyoteJumpTimer

var motion = Vector2.ZERO

var has_jumped = false
var jump_released = false
var early_released = false

func _ready():
	pass

func move():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_motion = motion
	var last_position = position
	
	motion = move_and_slide(motion, Vector2.UP) 
	
	if was_on_floor and not is_on_floor() and not has_jumped:
		motion.y = 0
		position.y = last_position.y
		coyote_timer.start()
		Logger.info("Coyote timer has started")
		
	if was_in_air and is_on_floor():
		motion.x = last_motion.x

func _physics_process(delta):
	has_jumped = false
	apply_gravity(delta)
	jump_check()
	move()
	




	
func jump_check():
	if is_on_floor() or coyote_timer.time_left > 0 : # Works only, if there is a force that constantly pushes you down
		jump_released = false
		if Input.is_action_just_pressed("jump"):	
			jump(JUMP_FORCE)
			has_jumped = true
	else:
		if Input.is_action_just_released("jump"): # Doesnt let you to get more force, if you have more than JUMP_FORCE/2
			if motion.y < -JUMP_FORCE/2:
				motion.y = -JUMP_FORCE/2 # You need to remember that going down is actually -y
				early_released = true
				Logger.log("Added force for releasing jump early")
			jump_released = true
func jump(force):
	motion.y = -force

func apply_gravity(delta):
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)
		
		if jump_released:
			motion.y += (GRAVITY if early_released else GRAVITY*2)*delta


func _on_CoyoteJumpTimer_timeout():
	Logger.info("Coyote timer has ended")
