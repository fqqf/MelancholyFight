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

func create_entities(chunk):	
	for platform in chunk[0]:
		platform_memory = platform.memory
		# Проверить память на платформе, кинуть кубик, если влезает - instance_numus()
		numus_struct = [[0,0,0,0,0],[1,1,1,1,1],[0,0,0,0,1]]
		numus_struct_x = 4234
		numus_struct_y = 4525
		
		instance_numus(platform, numus_struct)
	return entities

var numus_struct

func instance_numus(platform, numus_struct):
	
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

