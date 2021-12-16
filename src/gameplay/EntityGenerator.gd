extends Node

var game

onready var numus_scene = preload("res://src/gameplay/objects/collectables/Numus.tscn")

##
onready var collectables_map = preload("res://res/collectables/CollectablesMap.gd")
var numus_structures
const U_BLOCK_SIZE = 0.1


##


func _ready():
	randomize()
	game = Singleton.game
	numus_structures = collectables_map.numus

var entities
var platform_memory

var numus_struct_x
var numus_struct_y

var numus_size = 0.05
var numus_gap = 0
var platform

func create_entities(chunk):
	entities = []
	var x
	var y
	var start_platform_flag
	for platform_ in chunk[0]:
		var scene_speed = get_parent().scene_speed
		self.platform = platform_
		platform_memory = platform.memory
		##
		var found_gap = []
		var size_numus_structur
		found_gap = search_gap(platform_memory)
		if platform_memory[0]==0: start_platform_flag = true
		for count_gap in found_gap:
			
			if  count_gap[1]-count_gap[0]+1 <5 and count_gap[1]-count_gap[0]+1 >= 3:
				var variant=round(rand_range(14,15))
				numus_struct = numus_structures[str(variant)]
				size_numus_structur = return_size_numus_struct(numus_struct)
				x = float(((count_gap[1]-count_gap[0])+1-size_numus_structur)/2)#-numus_size/2
				y = 1
				var _occupy = return_number_occupy(x,size_numus_structur)
				instance_numus_struct(x,y, numus_struct)
				var start = _occupy[0]
				var end = _occupy[1]
				while start < end:
					platform_memory[start] = 1
					start+=1
								
			elif count_gap[1]-count_gap[0]+1 >= 5:
				while count_gap[0] <= count_gap[1] - 3:#минимальный параметр
					var lucky = round(rand_range(0,9))
					if lucky >3:
						count_gap[0]+= scene_speed*5 #делаем пропуск если не повезло
						pass
					else:
						var variant=round(rand_range(0,14))
						numus_struct = numus_structures[str(variant)]
						size_numus_structur = return_size_numus_struct(numus_struct)
						if start_platform_flag == true:
							count_gap[0]+=3
							start_platform_flag = false
						if size_numus_structur > count_gap[1]-count_gap[0]+1:
							break
						x = count_gap[0]
						if len(numus_struct) >7:
							y =-1 
						else: 
							y = rand_range(0.5,1.5)
						var _occupy = return_number_occupy(x,size_numus_structur)
						x= float((_occupy[1]-size_numus_structur)/2)
						instance_numus_struct(x,y, numus_struct)
						var start = _occupy[0]#+1
						var end = _occupy[1]
						while start < end:
							platform_memory[start] = 1
							start+=1
							count_gap[0] +=1
						count_gap[0] += scene_speed*5
	return entities



####
func return_number_occupy(x,size_):
	var array = []
	var start
	var count_blocks
	start = round_to_smaller(x)
	array.append(start)
	count_blocks = round_to_large(x+size_)#-start
	array.append(count_blocks)
	return array
	pass


func return_size_numus_struct(numus_struct_):
	var size_ = numus_struct_[0].size()
	size_= float(((size_*(numus_size+numus_gap))-numus_gap)/U_BLOCK_SIZE)
	return size_


#
func round_to_large(x_):
	if round(x_) >= x_:
		x_= round(x_)
		pass
	elif round(x_) < x_:
		x_= round(x_)+1
		pass
	return x_

func round_to_smaller(x_):
	if round(x_) <= x_:
		x_= round(x_)
		pass
	elif round(x_) > x_:
		x_= round(x_)-1
		pass
	return x_


#
func search_gap(platform_memory_):
	var end_gap = false
	var start_gap = false
	var start
	var end
	var array_gap = []
	var size_ = platform_memory_.size()-1
	for count in platform_memory_.size():
		var temp_array = []
		if platform_memory_[count] == 0:
			if start_gap == false:
				start=count
				start_gap = true
			elif start_gap == true:
				if count == size_:
					end = count
					temp_array.append(start)
					temp_array.append(end)
					array_gap.append(temp_array)
		elif platform_memory_[count] != 0:
			if start_gap:
				end = count - 1
				start_gap = false
				temp_array.append(start)
				temp_array.append(end)
				array_gap.append(temp_array)
			else: pass
	return array_gap
##########
var numus_struct

func instance_numus_struct(numus_struct_x, numus_struct_y, numus_struct):
	var i = 0
	var j = 0
	for y_ in numus_struct: # Создать саму структуру
		for x_ in y_:
			if x_ == 1:
				var numus = numus_scene.instance()

				numus.position.x = numus_struct_x+i*numus_size*10+numus_gap*i
				numus.position.y = numus_struct_y+j*numus_size*10-numus_gap*j 
				numus.scale.x = numus_size
				numus.scale.y = numus_size

				platform.add_entity(numus, false)
				entities.append(numus)
			i+=1
		i=0
		j+=1
		
#	for count in numus_struct[0].size(): # Записать в память ссылки на структуру
#		#print("count jopp", count, numus_struct)		
#		#platform_memory[round_to_smaller(count)] = numus_struct
#		pass
