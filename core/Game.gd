extends Node

onready var zone_scene = preload("res://core/gameplay/Zone.tscn")

onready var platform_builder = $Position/PlatformBuilder
onready var item_builder = $Position/ItemBuilder
onready var position = $Position


var chunks = []

func _ready():
	VisualServer.set_default_clear_color(Color(0.65098, 0.396078, 0.709804))
	
	platform_builder.desired_chunk_len=10000
	chunks.append(platform_builder.generate_chunk())
	platform_builder.create_gap_at_chunk_start = true
	
	# pass chunk_info to item_builder

func _physics_process(delta):
	position.position.x -= delta * 200
	
	for chunk in chunks:
		if chunk.size()==2 and position.position.x < -chunk[1]+450: # TODO: CHANGE TO CONST
			chunks.append(platform_builder.generate_chunk(chunk[1]))
			chunk.append("DELETE") # TODO: const
			Logger.log("Created chunk from " +str(chunk[1])+" to "+str(chunks.back()[1]))
		elif position.position.x < -chunk[1]-300 and chunk.size()==3:
			Logger.log("Deleted chunk with end: "+str(chunk[1])+", cur. pos is: "+str(position.position.x))
			for platform in chunk[0]:
				platform.queue_free()
			chunks.erase(chunk)


	
func _process(delta):
	pass


