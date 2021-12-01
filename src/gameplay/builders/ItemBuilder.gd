extends Node2D

onready var collectables_map = preload("res://res/collectables/CollectablesMap.gd")

onready var numus_scene = preload("res://src/gameplay/objects/collectables/Numus.tscn")

var numus_structures
var numus_structure_min_width

var numus_size = 7
var numus_gap = 1

var chunk
var offset
var items

func _ready():
	numus_structures = collectables_map.numus
	
func create_collectables(chunk_, offset_=0):
	items = []
	chunk = chunk_
	offset = offset_
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
		
		while width > 60:
			#пока платформа не меньше 60 кидаем кубик на каждое место gjrf 50%
			var lacky = round(rand_range(0,1))
			
			if lacky == 1:
				var struct_range = round(rand_range(0,numus_structures.size()-1))
				struct = numus_structures[str(struct_range)]
				
				#пока остаток платформы меньше чем выбранная структура
				while struct[0].size()*(numus_size+2) > width:
					struct_range = round(rand_range(0,6))
					struct = numus_structures[str(struct_range)]

				var width2 = 0
				width2 = width
				width -=10+numus_gap+(struct[0].size()*(numus_size+numus_gap))
				
				if width < 60: #если остаток платформы меньше 60 - ставим структуру на весь остаток
					var c = (width2-struct[0].size()*(numus_size+numus_gap))/2
					instance_numus_struct(x+c,platform.position.y-11, struct)
					x += (c*2)+struct[0].size()*(numus_size+numus_gap)
				else:
					instance_numus_struct(12+x,platform.position.y-11, struct)
					x += 10+numus_gap+struct[0].size()*(numus_size+numus_gap)
			else:# если кубик не выкинул структуру на место - оставляем пустым на 112 пикселей
				width-= (10+numus_gap+100)
				x += (10+numus_gap+100)


func instance_numus_struct(var x, var y, var struct):
	var i = 0
	var j = 0
	# Logger.log("Creating collectables with offset: " + str(offset))
	for y_ in struct:
		for x_ in y_:
			if x_ == 1:
				
				#Logger.log("Created collectable: ("+str(offset+x+x_)+"::"+str(offset+y+y_)+")")
				items.append(numus_scene.instance().build(x+i*numus_size+numus_gap*i, y-j*numus_size-numus_gap*j))
				add_child(items.back())
			i+=1
		i=0
		j+=1			
