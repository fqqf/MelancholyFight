extends Node2D 

# B - Block
# U - Unit

const U_BLOCK_SIZE = 16

export var SIZE_LIMITS = [3,20]
export var HEIGHT_LIMITS = [56.247, 92.3]
export var GAP_LIMITS = [40,100]
export var BORDER_SIZE = 5*U_BLOCK_SIZE

const platformScene = preload("res://core/gameplay/Platform.tscn")


const CREATION_LENGTH = 2000

onready var Dynamic = $Dynamic
onready var Souly = $Souly


var _length_taken = 0
var terrain_array = []
var count=0

func _process(delta):
	if count == 0:
		fill_terrain_array(1,CREATION_LENGTH) #формируем платформы для игрока на уровень смещения
		create_platforms()
	else:
		#привязка к движению + смещение
		if Dynamic.position.x - CREATION_LENGTH < -_length_taken:
			fill_terrain_array()
			create_platforms()




func create_platforms():
	var platform_instance
	var platform
	while count != terrain_array.size():
		platform = terrain_array[count]
		platform_instance = platformScene.instance()
		platform_instance.build(platform)
		Dynamic.add_child(platform_instance)
		count+=1
	
func fill_terrain_array(quantity=1, _length = 0):
	var alloc_len = 0
	var height = 0
	if _length == 0: #если длинна платформ не задана 
		while quantity:
			#1 длинна платформы, 2 - высота, 3 записываем в массив, 4 получаем следующую точку начала платформы 
			alloc_len = round(rand_range(SIZE_LIMITS[0], SIZE_LIMITS[1]))*U_BLOCK_SIZE
			height = rand_range(HEIGHT_LIMITS[0],HEIGHT_LIMITS[1])
			terrain_array.append(Vector3(_length_taken, height, alloc_len/U_BLOCK_SIZE))
			_length_taken+=alloc_len+rand_range(GAP_LIMITS[0], GAP_LIMITS[1])
			quantity-=1
			
	else:
		while _length_taken <= _length-BORDER_SIZE:
			alloc_len = min(round(rand_range(SIZE_LIMITS[0], SIZE_LIMITS[1]))*U_BLOCK_SIZE,_length-_length_taken)
			height = rand_range(HEIGHT_LIMITS[0],HEIGHT_LIMITS[1])
			if _length_taken+alloc_len == _length:
				print("ENDING")
				alloc_len += BORDER_SIZE
			terrain_array.append(Vector3(_length_taken, height, alloc_len/U_BLOCK_SIZE)) # x, y (height), width
			_length_taken+=alloc_len+rand_range(GAP_LIMITS[0], GAP_LIMITS[1])
		
