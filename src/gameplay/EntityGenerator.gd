extends Node

var game

onready var numus_scene = preload("res://src/gameplay/objects/collectables/Numus.tscn")


func _ready():
	game = Singleton.game

var entities = []
var platform_memory

var numus_struct_x
var numus_struct_y

var numus_size = 9
var numus_gap = 0

var platform

func create_entities(chunk):	
	for platform_ in chunk[0]: # Проверить память на платформе, кинуть кубик, если влезает - instance_numus()
		self.platform = platform_
		platform_memory = platform.memory
		
		numus_struct = [[0,0,0,0,0],[1,1,1,1,1],[0,0,0,0,1]]
		instance_numus_struct(523542,42342342, numus_struct) # Вычислить x и y для numus_struct через старый код
	return entities

var numus_struct

func instance_numus_struct(numus_struct_x, numus_struct_y, numus_struct):
	var i = 0
	var j = 0
	for y_ in numus_struct: # Создать саму структуру
		for x_ in y_:
			if x_ == 1:
				
				var numus = numus_scene.instance()	
				
				numus.x = numus_struct_x+i*numus_size+numus_gap*i
				numus.y = numus_struct_y-j*numus_size-numus_gap*j
			
				platform.add_entity(numus)
				entities.add(numus)
			i+=1
		i=0
		j+=1
		
	for h in numus_struct[0].size(): # Записать в память ссылки на структуры
		platform_memory[round(h)] = numus_struct

