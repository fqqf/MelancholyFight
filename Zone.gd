extends Node2D 

# B - Block
# U - Unit

const U_BLOCK_SIZE = 16

export var SIZE_LIMITS = [7,28] # Пусть если сейчас нижний, то с большей вероятностью выпадет такого же уровня, или выше
export var HEIGHT_LIMITS = [55.247, 90.2]#[56.247, 92.3] # TODO: РАСПРЕДЕЛИТЬ ВЕРОЯТНОСТИ (ВСЕГО) 
export var GAP_LIMITS = [70,170]
export var BORDER_SIZE = 5*U_BLOCK_SIZE

const platformScene = preload("res://core/gameplay/Platform.tscn")

const CREATION_LENGTH = 300

onready var Dynamic = $Dynamic

var _length
var _length_taken = 0

func _ready():
	init(10000)

func init(length = 100, tag = 0):
	_length = length
	fill_terrain_array()
	print(terrain_array)
	create_platforms()
	
var terrain_array = []

func create_platforms():
	var platform_instance
	for platform in terrain_array:
		platform_instance = platformScene.instance()
		platform_instance.build(platform)
		Dynamic.add_child(platform_instance)

func fill_terrain_array():
	var alloc_len = 0
	var height = 0
	while true:
		if _length_taken <= _length-BORDER_SIZE:
			alloc_len = min(round(rand_range(SIZE_LIMITS[0], SIZE_LIMITS[1]))*U_BLOCK_SIZE,_length-_length_taken)
			height = rand_range(HEIGHT_LIMITS[0],HEIGHT_LIMITS[1])
			
			if _length_taken+alloc_len == _length:
				print("ENDING")
				alloc_len += BORDER_SIZE
			
			terrain_array.append(Vector3(_length_taken, height, alloc_len/U_BLOCK_SIZE)) # x, y (height), width
			_length_taken+=alloc_len+rand_range(GAP_LIMITS[0], GAP_LIMITS[1])
		else:
			break
