extends Node2D

onready var collectables_map = preload("res://res/collectables/CollectablesMap.gd")

onready var numus_scene = preload("res://src/gameplay/objects/collectables/Numus.tscn")

var numus_structures
var numus_structure_min_width

var numus_size = 10
var numus_gap = 2

var chunk
var offset
var items

func _ready():
	numus_structures = collectables_map.numus
	
func create_collectables(chunk_, offset_=0):
	items = []
	chunk = chunk_
	offset = offset_
	#Logger.log("Creating collectables")
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
		var struct_range = round(rand_range(0,numus_structures.size()-1))
		struct = numus_structures[str(struct_range)]
		instance_numus_struct(x,platform.position.y-20, struct)
		
		


func instance_numus_struct(var x, var y, var struct):
	var i = 0
	var j = 0
	print("Creating collectables with offset" + str(offset))
	print("platform pos: "+ str(chunk[0][0].position))
	for y_ in struct:
		for x_ in y_:
			if x_ == 1:
				
				#Logger.log("Created collectable: ("+str(offset+x+x_)+"::"+str(offset+y+y_)+")")
				items.append(numus_scene.instance().build(x+i*numus_size+numus_gap*i, y-j*numus_size-numus_gap*j))
				add_child(items.back())
			i+=1
		i=0
		j+=1			
