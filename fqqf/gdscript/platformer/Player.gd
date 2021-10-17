extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const dust_effect_scene = preload("res://Effects/DustEffect.tscn")
const jump_effect_scene = preload("res://Effects/JumpEffect.tscn")
const player_bullet_scene = preload("res://Player/PlayerBullet.tscn")
const wall_dust_effect_scene = preload("res://Effects/WallDustEffect.tscn")
const player_missile_scene = preload("res://assets/Player/PlayerMissile.tscn")

var player_stats = ResourceLoader.player_stats
var main_instances = ResourceLoader.main_instances

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var MAX_WALL_SLIDE_SPEED = 12
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46
export (int) var BULLET_SPEED = 250
export (int) var WALL_SLIDE_SPEED = 48
export (int) var MISSILE_BULLET_SPEED = 150

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var coyote_timer = $CoyoteJumpTimer
onready var blink_animator = $BlinkAnimator
onready var fire_bullet_timer = $FireBulletTimer
onready var gun = $Sprite/PlayerGun
onready var muzzle = $Sprite/PlayerGun/Sprite/Muzzle
onready var powerup_detector = $PowerupDetector
onready var camera_follow = $CameraFollow

# warning-ignore:unused_signal
signal hit_door(door)

enum {
	MOVE,
	WALL_SLIDE
}

var state = MOVE
var invincibility = false setget set_invincibility
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var has_jumped = false
var double_jump = true

func set_invincibility(value):
	invincibility = value
	
func _ready():
	player_stats.connect("player_died",self,"_on_died")
	main_instances.Player = self
	call_deferred("assign_world_camera")

func _exit_tree():
	main_instances.Player = null

func assign_world_camera():
	camera_follow.remote_path = main_instances.WorldCamera.get_path()

func _physics_process(delta):
	has_jumped = false

	match state:
		MOVE:
			var input_vector = get_input_vector()
	
			apply_horizontal_force(input_vector, delta)
			apply_friction(input_vector)
			update_snap_vector()
			jump_check()
			if Input.is_action_pressed("Fire") and fire_bullet_timer.time_left == 0:
				fire_bullet()
			elif Input.is_action_just_pressed("fire_missile") and fire_bullet_timer.time_left == 0:
				if player_stats.missiles > 0 and player_stats.missiles_unlocked:
					fire_missile()
			
			apply_gravity(delta)
			update_animations(input_vector)
			move()
			
			wall_slide_check()
			
		WALL_SLIDE:
			animation_player.play("Wall Slide")
			var wall_axis = get_wall_axis()
			if wall_axis != 0:
				sprite.scale.x = wall_axis
				
			wall_slide_jump_check(wall_axis)
			wall_slide_drop(delta)
			move()
			wall_detach(delta,wall_axis)
	if Input.is_action_just_pressed("save"):
		SaverAndLoader.save_game()
	if Input.is_action_just_pressed("load"):
		SaverAndLoader.load_game()

		
func apply_horizontal_force(input_vector: Vector2, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func update_animations(input_vector):
	var facing = sign(get_local_mouse_position().x)
	if facing!=0:
		sprite.scale.x = facing
	
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

func fire_bullet():
	var bullet = Utils.instance_scene_on_main(player_bullet_scene, muzzle.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()
	fire_bullet_timer.start()

func fire_missile():
	var missile = Utils.instance_scene_on_main(player_missile_scene, Vector2(muzzle.global_position.x, muzzle.global_position.y))
	missile.velocity = Vector2.RIGHT.rotated(gun.rotation) * MISSILE_BULLET_SPEED
	missile.velocity.x *= sprite.scale.x
	motion -= missile.velocity * 0.8
	snap_vector = Vector2.ZERO
	has_jumped = true
	missile.rotation = missile.velocity.angle()
	fire_bullet_timer.start()
	player_stats.missiles -= 1

func create_dust_effect():
	Utils.instance_scene_on_main(jump_effect_scene, global_position)
	var dust_position = global_position
	dust_position.x += rand_range(-4,4)
	Utils.instance_scene_on_main(dust_effect_scene, dust_position)

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
			jump(JUMP_FORCE)
			has_jumped = true
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2: # Doesnt let you to get more force, if you have more than JUMP_FORCE/2
			motion.y = -JUMP_FORCE/2 # You need to remember that going down is actually -y
		
		if Input.is_action_just_pressed("ui_up") and double_jump:
			jump(JUMP_FORCE* .75)
			double_jump = false
			
func jump(force):
	Utils.instance_scene_on_main(jump_effect_scene, global_position)
	motion.y = -force
	snap_vector = Vector2.ZERO
		
func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func move():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_motion = motion
	var last_position = position
	
	motion = move_and_slide_with_snap(motion, snap_vector*4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	# Landing
	if was_in_air and is_on_floor():
		motion.x = last_motion.x
		Utils.instance_scene_on_main(jump_effect_scene, global_position)
		double_jump = true
	
	# Just left ground
	if was_on_floor and not is_on_floor() and not has_jumped:
		motion.y = 0
		position.y = last_position.y
		coyote_timer.start()
	
	# Prevent Sliding (hack)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position.x = last_position.x


func _on_Hurtbox_hit(damage):
	if not invincibility:
		player_stats.health -= damage
		blink_animator.play("Blink")

func _on_died():
	queue_free()

func wall_slide_check():
	if not is_on_floor() and is_on_wall():
		state = WALL_SLIDE
		double_jump = true
		create_dust_effect()
		
func get_wall_axis():
	var is_right_wall = test_move(transform, Vector2.RIGHT)
	var is_left_wall = test_move(transform, Vector2.LEFT)
	return int(is_left_wall) - int(is_right_wall)


func wall_slide_jump_check(wall_axis):
	if Input.is_action_just_pressed("ui_up"):
		motion.x = wall_axis*MAX_SPEED
		motion.y = -JUMP_FORCE/1.25
		state = MOVE
		var dust_position = global_position + Vector2(wall_axis*4, -2 )
		var dust = Utils.instance_scene_on_main(wall_dust_effect_scene, dust_position)
		dust.scale.x = wall_axis
		
func wall_slide_drop(delta):
	var max_slide_speed = WALL_SLIDE_SPEED
	if Input.is_action_pressed("ui_down"):
		max_slide_speed = MAX_WALL_SLIDE_SPEED
	motion.y = min(motion.y + GRAVITY * delta, max_slide_speed)

func wall_detach(delta, wall_axis):
	if Input.is_action_just_pressed("ui_right"): 
		motion.x = ACCELERATION * delta
		state = MOVE
		
	if Input.is_action_just_pressed("ui_left"):
		motion.x = -ACCELERATION * delta
		state = MOVE
	if wall_axis == 0 or is_on_floor():
		state = MOVE


func _on_PowerupDetector_area_entered(area):
	if area is Powerup:
		area._pickup()
		
func save():
	var save_dictionary = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"position_x" : position.x,
		"position_y" : position.y
	}
	return save_dictionary
