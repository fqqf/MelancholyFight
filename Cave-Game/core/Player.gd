class_name BasePlayerSideScroll
extends KinematicBody2D

const UP_DIRECTION = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_VECTOR_LENGTH = 32.0
const MAX_SLIDES = 4
const MAX_SLOPE_ANGLE = deg2rad(46)

export var speed = 600.0
export var jump_strength = 1400.0
export var gravity = 4500.0 # Being applied every frame

export var do_stop_on_slope = false
export var has_infinite_inertia = true

var _velocity = Vector2.ZERO
var _snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH
var _horizontal_direction = 0.0

onready var _pivot: Node2D = $PlayerSideSkin
onready var _anim_player: AnimationPlayer = $PlayerSideSkin/AnimationPlayer
onready var _start_scale := _pivot.scale

func _ready() -> void:
	do_stop_on_slope = false

func apply_base_movement(delta: float) -> void:
	
	_horizontal_direction = (Input.get_action_strength("move_right") -
	Input.get_action_strength("move_left"))
	
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta
	
	if is_jumping():
		_velocity.y = -jump_strength
		_snap_vector = Vector2.ZERO
	elif is_jump_cancelled():
		_velocity.y = 0.0
	elif is_landing():
		_snap_vector = SNAP_DIRECTION * SNAP_VECTOR_LENGTH
		
	_velocity = move_and_slide_with_snap(
		_velocity,
		_snap_vector,
		UP_DIRECTION,
		do_stop_on_slope,
		MAX_SLIDES,
		MAX_SLOPE_ANGLE,
		has_infinite_inertia
	)
	
func update_animation() -> void:
	if is_jumping():
		_anim_player.play("jump")
	elif is_running():
		_anim_player.play("run")
	elif is_falling():
		_anim_player.play("fall")
	else:
		_anim_player.play("idle")

func update_look_direction() -> void:
	if not is_zero_approx(_horizontal_direction):
		_pivot.scale.x = sign(_horizontal_direction) * _start_scale.x

func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump") and is_on_floor()

func is_jump_cancelled() -> bool:
	return Input.is_action_just_released("jump") and _velocity.y < 0.0

func is_landing() -> bool:
	return _snap_vector == Vector2.ZERO and is_on_floor()

func is_falling() -> bool:
	return _velocity.y > 0.0 and not is_on_floor()

func is_running() -> bool:
	return is_on_floor() and not is_zero_approx(_horizontal_direction) and not is_on_wall()
