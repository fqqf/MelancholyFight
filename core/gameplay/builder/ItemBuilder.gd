extends Node2D

onready var collectables_map = preload("res://assets/collectables/CollectablesMap.gd")

onready var numus_scene = preload("res://core/gameplay/collectables/Numus.tscn")

var numus_structures
var numus_structure_min_width

var numus_size = 10

var chunk
var offset
var items

func _ready():
	numus_structures = collectables_map.numus
	
func create_collectables(chunk, offset_=0):
	items = []
	offset = offset_
	Logger.log("Creating collectables")
	create_numus(chunk)
	return items
	
func create_numus(chunk):
	var width
	var numus_amount
	var struct
	var x
	
	for platform in chunk[0]:
		width = platform.width_PX
		x = platform.position.x
		if width < 300 and width > 150:
			numus_amount = round(rand_range(0.4,0.8))
			if numus_amount == 1:
				struct = numus_structures["long"]
				instance_numus_struct(rand_range(x,x+width-struct[0].size()*numus_size),platform.position.y-20, struct)
		elif width < 500:
			numus_amount = floor(rand_range(0.3,2.3))
		else:
			numus_amount = floor(rand_range(0.99,4))
			

func instance_numus_struct(var x, var y, var struct):
	var numus_instance
	var i = 0
	var j = 0
	
	for y_ in struct:
		for x_ in y_:
			if x_ == 1:
				#print("created")
				#Logger.log("Created collectable: ("+str(offset+x+x_)+"::"+str(offset+y+y_)+")")
				items.append(numus_scene.instance().build(offset+x+i*numus_size+2*i, y-j*numus_size-2*j))
				add_child(items.back())
			i+=1
		i=0
		j+=1			
