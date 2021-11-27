extends Node

onready var zone_scene = preload("res://core/gameplay/Zone.tscn")

onready var platform_builder = $Position/PlatformBuilder
onready var item_builder = $Position/ItemBuilder
onready var position = $Position


var chunks = []
var items = {}

func _ready():
	VisualServer.set_default_clear_color(Color(0.65098, 0.396078, 0.709804))
	
	platform_builder.desired_chunk_len=10000
	var chunk = platform_builder.generate_chunk()
	
	chunks.append(chunk)
	platform_builder.create_gap_at_chunk_start = true
	
	items[chunk] = item_builder.create_collectables(chunk)

func _physics_process(delta):
	position.position.x -= delta * 70
	
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


	
func _process(delta):
	pass

func _on_souly_pickup_collectable(collectable):
	collectable.free()

