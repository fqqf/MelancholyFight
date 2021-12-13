extends Node

class_name Game

onready var platform_builder = $Position/PlatformBuilder
onready var item_builder = $Position/ItemBuilder
onready var line = $Position/Line2D
onready var souly = $Souly
onready var position = $Position

var evangelion_zone_scene = preload("res://src/gameplay/zones/EvangelionZone.tscn")
var french_rose_zone_scene = preload("res://src/gameplay/zones/FrenchRoseZone.tscn")
var heavenly_yard_zone_scene = preload("res://src/gameplay/zones/HeavenlyYardZone.tscn")
var chunks = []
var entities = []

var start_time = 0
var time_passed = 0
var time

var current_zone
var zones = [] 

const ZONE_LIFETIME_SEC = 5
var zone_change_time = 0

func _ready():
	Singleton.game = self
	VisualServer.set_default_clear_color(Color(0.65098, 0.396078, 0.709804))
	setup_initial_chunk()
	start_time = OS.get_unix_time()
	create_zones()
	
	zone_change_time = time_passed+ZONE_LIFETIME_SEC	

func create_zones():
	
	zones = {
		"evangelion": evangelion_zone_scene.instance(),
		"french_rose": french_rose_zone_scene.instance(),
		"heavenly_yard": heavenly_yard_zone_scene.instance()
	}
	
	#current_zone = zones.values()[randi() % zones.size()]
	current_zone = zones["heavenly_yard"]
	current_zone.enabled = true	
	add_child(current_zone)

func setup_initial_chunk():
	platform_builder.desired_chunk_len=10000
	var chunk = platform_builder.generate_chunk()
	var entity = []
	chunks.append(chunk)
	Logger.log("Created start chunk")
	platform_builder.create_gap_at_chunk_start = true
	
	entity = entity_generator.create_entities(chunk)
	entities.append(entity)

func _physics_process(delta):
	time = OS.get_unix_time()
	time_passed = time-start_time
	
	if time_passed>zone_change_time:
		zone_change_time = time_passed+ZONE_LIFETIME_SEC
		var previous_zone = current_zone
		while(current_zone==previous_zone): current_zone = zones.values()[randi() % zones.size()]
		remove_child(previous_zone)
		previous_zone.enabled = false
		add_child(current_zone)
		current_zone.enabled = true
	
	move_scene(delta)
	
	create_and_delete_chunks()
	
const MAX_SCENE_SPEED = 10
const START_SCENE_SPEED = 4
var scene_acceleration = 0.005
var scene_speed = START_SCENE_SPEED

func move_scene(delta):
	scene_speed = min(scene_speed + scene_acceleration*delta, MAX_SCENE_SPEED)
	
	position.position.x -= scene_speed*0.6 if souly.ray_cast2d.is_colliding() else scene_speed
	
	limit_scene_acceleration()
	
func limit_scene_acceleration():
	if time_passed>100:
		scene_acceleration = 0.005
	elif time_passed>70:
		scene_acceleration = 0.015
	elif time_passed>60:
		scene_acceleration = 0.065

func create_and_delete_chunks():
	for chunk in chunks:
		if chunk.size()==2 and position.position.x < -chunk[1]+450: 
			chunks.append(platform_builder.generate_chunk(chunk[1]))
			Logger.log("Created chunk [" +str(chunk[1])+":"+str(chunks.back()[1])+"]")
			entities.push_front(item_builder.create_collectables(chunks.back(), chunk[1]))
			chunk.append("DELETE") # TODO: const
			#line.position.x = chunk[1] НЕ УБИРАТЬ ЭТОТ КОММЕНТАРИЙ, НУЖЕН ДЛЯ ДЕБАГА

		elif position.position.x < -chunk[1]-300 and chunk.size()==3:
			Logger.log("Deleted chunk ["+str(chunk[1])+":"+str(chunks.back()[1])+"], cur. pos is: "+str(-position.position.x))
			for platform in chunk[0]:
				platform.queue_free()
			chunks.erase(chunk)
			for et in entities[1]:
				if is_instance_valid(et):et.queue_free()	
			entities.remove(1)

func _on_souly_pickup_collectable(collectable):
	collectable.free()
	
func end_game():
	Logger.log("Game over")

