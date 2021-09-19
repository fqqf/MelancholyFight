extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const dust_effect_scene = preload("res://Effects/DustEffect.tscn")

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var coyote_timer = $CoyoteJumpTimer

var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var has_jumped = false

func _physics_process(delta):
	has_jumped = false
	var input_vector = get_input_vector()
	
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	update_snap_vector()
	jump_check()
	apply_gravity(delta)
	update_animations(input_vector)
	move()
		
func apply_horizontal_force(input_vector: Vector2, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func update_animations(input_vector):
	sprite.scale.x = sign(get_local_mouse_position().x)
	if input_vector.x != 0:
		animation_player.play("Run")
		animation_player.playback_speed = input_vector.x * sprite.scale.x
	else:
		animation_player.playback_speed = 1
		animation_player.play("Idle")
	if not is_on_floor():
		animation_player.play("Jump")

func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION) # Interpolates

func create_dust_effect():
	var dust_position = global_position
	dust_position.x += rand_range(-4,4)
	var dust_effect = dust_effect_scene.instance()
	get_tree().current_scene.add_child(dust_effect)
	dust_effect.global_position = dust_position	

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector
	
func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN

func jump_check():
	if is_on_floor() or coyote_timer.time_left > 0 : # Works only, if there is a force that constantly pushes you down
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			has_jumped = true
			snap_vector = Vector2.ZERO
	elif Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2: # Doesnt let you to get more force, if you have more than JUMP_FORCE/2
		motion.y = -JUMP_FORCE/2 # You need to remember that going down is actually -y
			
func apply_gravity(delta):
	#if not is_on_floor(): # Now that matters
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE) # Minimum value

func move():
	var is_flying = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_position = position
	var last_motion = motion
	
	motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP,true,4,deg2rad(MAX_SLOPE_ANGLE))
	
	# Landing
	if is_flying and is_on_floor():
		motion.x = last_motion.x
		create_dust_effect()
		
	# Just left the ground
	if was_on_floor and not is_on_floor() and not has_jumped:
		motion.y = 0
		position.y = last_position.y
		coyote_timer.start()

	# Prevent sliding (If our motion is tiny, stops)
	if is_on_floor() and abs(motion.x) < 3:
		position.x = last_position.x
