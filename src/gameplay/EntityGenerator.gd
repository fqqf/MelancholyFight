extends Node

var game

onready var numus_scene = preload("res://src/gameplay/objects/collectables/Numus.tscn")

##
onready var collectables_map = preload("res://res/collectables/CollectablesMap.gd")
var numus_structures
const U_BLOCK_SIZE = 0.1


##


func _ready():
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
	for platform_ in chunk[0]: # Проверить память на платформе, кинуть кубик, если влезает - instance_numus()
		self.platform = platform_
		platform_memory = platform.memory
		##
		var found_gap = []
		var size_
		found_gap = search_gap(platform_memory)
		for count in found_gap:
			if  count[1]-count[0]+1 <5 and count[1]-count[0]+1 >= 3:
				var variant=round(rand_range(14,15))
				numus_struct = numus_structures[str(variant)]
				#print("numus_struct",numus_struct)
				size_ = return_size_numus_struct(numus_struct)
				var x = float(((count[1]-count[0])+1-size_)/2)#-numus_size/2
				var y = 1
				var _occupy = return_number_occupy(x,size_)
				instance_numus_struct(x,y, numus_struct)
				var start = _occupy[0]#+1
				var end = _occupy[1]
				while start < end:
					#print("start", start)
					platform_memory[start] = 1
					start+=1
				#print("[t_latform_mem]", platform_memory)
				
			elif	count[1]-count[0]+1 >= 5:
				var variant=round(rand_range(0,14))
				numus_struct = numus_structures[str(variant)]
				#print("numus_struct",numus_struct)
				size_ = return_size_numus_struct(numus_struct)
				if size_ > count[1]-count[0]+1:
					break
				var x = float(((count[1]-count[0])+1-size_)/2)#-numus_size/2
				var y = 1
				var _occupy = return_number_occupy(x,size_)
				instance_numus_struct(x,y, numus_struct)
				var start = _occupy[0]#+1
				var end = _occupy[1]
				while start < end:
					#print("start", start)
					platform_memory[start] = 1
					start+=1
				#print("[t_latform_mem]", platform_memory)
			pass
			#platform_memory[round_to_smaller(count)] = numus_struct
		
		##
		
		#instance_numus_struct(0,0, numus_struct) # Вычислить x и y для numus_struct через старый код
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
