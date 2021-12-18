extends Node2D

onready var collectables_map = preload("res://res/collectables/CollectablesMap.gd")

onready var numus_scene = preload("res://src/gameplay/objects/collectables/Numus.tscn")

var numus_structures
var numus_structure_min_width

var numus_size = 9
var numus_gap = 0


var chunk
var offset
var items

func _ready():
	randomize()
	numus_structures = collectables_map.numus
	
func create_collectables(chunk_, offset_=0):
	items = []
	chunk = chunk_
	offset = offset_
	create_numus()
	return items
	
func create_numus():
	var width
	var height

	var struct
	var x
	
	
	for platform in chunk[0]:
		width = platform.width_PX
		height = (platform.height_PX-56)/4 + 20
		x = platform.position.x
		var scene_speed = get_parent().get_parent().scene_speed

		var not_together = false
		if width <= max(60, scene_speed*40):
			var variant=round(rand_range(14,15))
			struct = numus_structures[str(variant)]
			var c = numus_size/2+ float((width-(struct[0].size()*(numus_size+numus_gap))+numus_gap))/2
			instance_numus_struct(x+c,platform.position.y-10, struct)
			x += (c*2)+struct[0].size()*(numus_size+numus_gap)
		while width > max(60, scene_speed*40):
			#пока платформа не меньше 60 кидаем кубик на каждое место gjrf 50%
			var lacky = round(rand_range(1,3))
			if lacky == 1 and not_together == false:
				not_together = true
				var struct_range = round(rand_range(0,numus_structures.size()-3))

				struct = numus_structures[str(struct_range)]
				
				#пока остаток платформы меньше чем выбранная структура
				while struct[0].size()*(numus_size+2) > width:
					struct_range = round(rand_range(0,6))
					struct = numus_structures[str(struct_range)]

				# var width2 = 0
				# width2 = width
				width -=10+numus_gap+(struct[0].size()*(numus_size+numus_gap))

				if width < max(40, scene_speed*40):
					#var c = (width2-struct[0].size()*(numus_size+numus_gap))/2
					#instance_numus_struct(x+c,platform.position.y-20, struct)
					#x += (c*2)+struct[0].size()*(numus_size+numus_gap)
					width = 0
				else:

					height = rand_range(numus_size/2+3, 29)
					if struct.size() > 4 or scene_speed>4: height = numus_size/2+3

					instance_numus_struct(12+x,platform.position.y-height, struct)
					x += 10+numus_gap+struct[0].size()*(numus_size+numus_gap)
			else:# если кубик не выкинул структуру на место - оставляем пустым на 112 пикселей
				not_together = false
				var gap_between_structur =100# max(100, scene_speed*15)
				width-= (10+numus_gap+gap_between_structur)
				x += (10+numus_gap+gap_between_structur)


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
