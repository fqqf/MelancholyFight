extends RigidBody2D

const HitEffect = preload("res://HitEffect.tscn")

onready var laserSound = $LaserSound

# Called when the node enters the scene tree for the first time.
func _ready():
	laserSound.play()

#func _exit_tree():
	#create_hit_effect()
func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

#func _process(delta):
#	pass
