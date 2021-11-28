extends Node

onready var platform_builder = $Position/PlatformBuilder
onready var item_builder = $Position/ItemBuilder
onready var souly = $Souly
onready var position = $Position


var chunks = []
var items = {}

var start_time
var time_passed

func _ready():
	VisualServer.set_default_clear_color(Color(0.65098, 0.396078, 0.709804))
	
	platform_builder.desired_chunk_len=2000
	var chunk = platform_builder.generate_chunk()
	
	chunks.append(chunk)
	platform_builder.create_gap_at_chunk_start = true
	
	items[chunk] = item_builder.create_collectables(chunk)
	
	start_time = OS.get_unix_time()

func _physics_process(delta):
	time_passed = OS.get_unix_time()-start_time
	move_scene(delta)

	for chunk in chunks:
		if chunk.size()==2 and position.position.x < -chunk[1]+450: # TODO: CHANGE TO CONST
			chunks.append(platform_builder.generate_chunk(chunk[1]))
			items[chunk] = item_builder.create_collectables(chunk, chunk[1])
			chunk.append("DELETE") # TODO: const
			Logger.log("Created chunk from " +str(chunk[1])+" to "+str(chunks.back()[1]))
		elif position.position.x < -chunk[1]-300 and chunk.size()==3:
			Logger.log("Deleted chunk with end: "+str(chunk[1])+", cur. pos is: "+str(position.position.x))
			for platform in chunk[0]:
				platform.queue_free()
			#for item in items[str(chunk)]: # TODO: QUEUE
			#	item.queue_free()
			#items.erase(chunk)
			chunks.erase(chunk)

const MAX_SCENE_SPEED = 4.5
const START_SCENE_SPEED = 3.5

var scene_acceleration = 0.005
var scene_speed = START_SCENE_SPEED

func move_scene(delta):
	scene_speed += min(scene_acceleration*delta, START_SCENE_SPEED)
	
	

	position.position.x -= scene_speed*0.6 if souly.ray_cast2d.is_colliding() else scene_speed
	
	if time_passed>100:
		scene_acceleration = 0.005
	elif time_passed>70:
		scene_acceleration = 0.015
	elif time_passed>60:
		scene_acceleration = 0.065
	
	

func _on_souly_pickup_collectable(collectable):
	collectable.free()

