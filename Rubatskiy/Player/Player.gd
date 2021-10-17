extends KinematicBody2D

const DustEffect = preload("res://Effects/DustEffect.tscn")
const PlayerBullet = preload("res://Player/PlayerBullet.tscn")
const JumpEffect = preload("res://Effects/JumpEffect.tscn")
const WallDustEffect = preload("res://Effects/WallDustEffect.tscn")
const PlayerMissile = preload("res://Player/PlayerMissile.tscn")

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var WALL_SLIDE_SPEED = 42
export (int) var MAX_WALL_SLIDE_SPEED = 128
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46
export (int) var BULLET_SPEED = 250
export (int) var MISSILE_BULLET_SPEED = 150
enum {
	MOVE,
	WALL_SLIDE
}

var state = MOVE
var invincible = false setget set_invincible
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var double_jump = true


onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator
onready var blinkAnimator = $BlinkAnimator
onready var coyoteJumpTimer = $CoyoteJumpTimer
onready var fireBulletTimer = $FireBulletTimer
onready var gun = $Sprite/PlayerGun
onready var muzzle = $Sprite/PlayerGun/Sprite/Muzzle
#onready var powerupDetector = $PowerupDetectror
onready var cameraFollow = $CameraFollow

# warning-ignore:unused_signal
signal hit_door(door)

func set_invincible(value):
	invincible = value
	
func _ready():
	PlayerStats.connect("player_died", self, "_on_died")
	PlayerStats.missiles_unlocked = SaverAndLoader.custom_data.missiles_unlocked
	MainInstances.Player = self
	call_deferred("assign_world_camera")
	
func queue_free():
	MainInstances.Player = null
	.queue_free()


#func _exit_tree():
#	MainInstances.Player = null


func _physics_process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		queue_free()
#
	var input_vector = get_input_vector()
	just_jumped = false
	
	match state:
		MOVE:
			apply_horizontal_force(input_vector, delta)
			apply_friction(input_vector)
			update_snap_vector()
			jump_check()	
			apply_gravity(delta)
			update_animations(input_vector)
			move()
			wall_slide_check()
			
		WALL_SLIDE:
			spriteAnimator.play("Wall Slide")
			
			var wall_axis = get_wall_axis()
			if wall_axis != 0:
				sprite.scale.x = wall_axis
			wall_slide_jump_check(wall_axis)
			wall_slide_drop(delta)

			move()
			wall_detach(delta, wall_axis)
			
	if Input.is_action_pressed("Fire") and fireBulletTimer.time_left == 0:
		fire_bullet()
	if 	Input.is_action_pressed("fire_missile") and fireBulletTimer.time_left == 0:
		if PlayerStats.missiles > 0 and PlayerStats.missiles_unlocked:
			fire_missile()
			PlayerStats.missiles -= 1
			
			
	if Input.is_action_just_pressed("save"):
		SaverAndLoader.save_game()
		
	if Input.is_action_just_pressed("load"):
		SaverAndLoader.load_game()

func assign_world_camera():
	cameraFollow.remote_path = MainInstances.WorldCamera.get_path()

	
		
func save():
	print("save mat ego")
	var save_dictionary = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"position_x" : position.x,
		"position_y" : position.y
	}
	return save_dictionary
	

	
func fire_bullet():
	var bullet = Utils.instance_scene_on_main(PlayerBullet, muzzle.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()
	fireBulletTimer.start()

func fire_missile():
	var missile = Utils.instance_scene_on_main(PlayerMissile, muzzle.global_position)
	missile.velocity = Vector2.RIGHT.rotated(gun.rotation) * MISSILE_BULLET_SPEED
	missile.velocity.x *= sprite.scale.x
	motion -= missile.velocity *0.25
	missile.rotation = missile.velocity.angle()
	fireBulletTimer.start() 
	
	
func 	create_dust_effect():
	SoundFx.play("Step", rand_range(0.8, 1.1), -30)
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	Utils.instance_scene_on_main(DustEffect, dust_position)
#	var dustEffect = DustEffect.instance()
#	get_tree().current_scene.add_child(dustEffect)
#	dustEffect.global_position = dust_position
			 
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")	
	return input_vector
	
func apply_horizontal_force(input_vector, delta):
	if 	input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	
func apply_friction(input_vector):
	if input_vector.x ==0 and is_on_floor():
		motion.x = lerp(motion.x , 0, FRICTION)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN
		

		
func jump_check():
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			jump(JUMP_FORCE)
			
			just_jumped = true
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2;
		if Input.is_action_just_pressed("ui_up") and double_jump == true:
			jump(JUMP_FORCE * .75)
			double_jump = false
			
		
func jump(force):
	SoundFx.play("Jump", rand_range(0.8, 1.1), -30)
	Utils.instance_scene_on_main(JumpEffect, global_position)
	motion.y = -force
	snap_vector = Vector2.ZERO	
	
			
func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)
	
			
func update_animations(input_vector):
	var facing = sign(get_local_mouse_position().x)
	if facing != 0:
		sprite.scale.x = facing
	
	if input_vector.x != 0:
		#sprite.scale.x = sign(input_vector.x)
		spriteAnimator.play("Run")
		spriteAnimator.playback_speed = input_vector.x * sprite.scale.x
	else:
		spriteAnimator.playback_speed = 1
		spriteAnimator.play("Idle")	
	if not is_on_floor():
		spriteAnimator.play("Jump")
		
func move():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_position = position
	var last_motion = motion
	motion = move_and_slide_with_snap(motion,snap_vector*4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))	
	#Landing
	if was_in_air and is_on_floor():
		motion.x = last_motion.x
		#create_dust_effect()
		SoundFx.play("Step", rand_range(0.8, 1.1), -30)
		Utils.instance_scene_on_main(JumpEffect, global_position)
		double_jump = true
		
	
	#Just left groung
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyoteJumpTimer.start()
	# Prevent Sliding (hack)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position.x = last_position.x
		
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
		SoundFx.play("Jump", rand_range(0.8, 1.1), -30)
		motion.x = wall_axis * MAX_SPEED
		motion.y = -JUMP_FORCE/1.25
		state = MOVE
		var dust_position = global_position + Vector2(4* wall_axis, -2)
		var dust = Utils.instance_scene_on_main(WallDustEffect, dust_position)
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

func _on_HurtBox_hit(damage):
	if not invincible:
		SoundFx.play("Hurt", rand_range(0.8, 1.1), -30)
		PlayerStats.health -= damage
		blinkAnimator.play("Blink")

func _on_died():
	queue_free()
	
	


func _on_PowerupDetectror_area_entered(area):
	if area is Powerup:
		area._pickup()
