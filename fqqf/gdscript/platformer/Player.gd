extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

var motion = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_input_vector()
	
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	move()
		
func apply_horizontal_force(input_vector: Vector2, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION) # Interpolates

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector

func jump_check():
	if is_on_floor(): # Works only, if there is a force that constantly pushes you down
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	elif Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2: # Doesnt let you to get more force, if you have more than JUMP_FORCE/2
		motion.y = -JUMP_FORCE/2 # You need to remember that going down is actually -y
			
func apply_gravity(delta):
#	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE) # Minimum value

func move():
	motion = move_and_slide(motion, Vector2.UP)
	
