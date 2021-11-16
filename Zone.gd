extends Node2D 

# B - Block
# U - Unit

const U_BLOCK_SIZE = 16

export var WIDTH_LIMITS = [7,58] # Пусть если сейчас нижний, то с большей вероятностью выпадет такого же уровня, или выше
export var HEIGHT_LIMITS = [55.247, 90.2]#[56.247, 92.3] # TODO: РАСПРЕДЕЛИТЬ ВЕРОЯТНОСТИ (ВСЕГО) 

export var GAP_LIMITS = [70,170]
export var BORDER_GAP_LIMITS = [30,50]
export var BORDER_SIZE = 5*U_BLOCK_SIZE

const platformScene = preload("res://core/gameplay/Platform.tscn")
const CREATION_LENGTH = 300

const DEFAULT_PLATFORM_WIDTH = 10
var DEFAULT_PLATFORM_HEIGHT = HEIGHT_LIMITS[0]
const DEFAULT_GAP_SIZE = 50

onready var Dynamic = $Dynamic

var _length = 0
var _length_taken = 0
var terrain_array = []

func _ready():
	init(10000)

func init(length = 100, tag = 0):
	Logger.log("Zone init")
	_length = length
	total = _length
	fill_terrain_array_()
	Logger.log("Generated terrain: "+str(terrain_array) )
	build_platforms()



func build_platforms():
	var platform_instance
	for platform in terrain_array:
		platform_instance = platformScene.instance()
		platform_instance.build(platform)
		Dynamic.add_child(platform_instance)

var allocate = 0
var used = 0
var total = 0
var left = 0

func fill_terrain_array_():

	var maximum_size = block2unit(WIDTH_LIMITS[1])+GAP_LIMITS[1]
	left = total - used
		
	create_platform(0,DEFAULT_PLATFORM_HEIGHT,block2unit(DEFAULT_PLATFORM_WIDTH))
	alloc(DEFAULT_GAP_SIZE)
	
	while used != total:
		assert(not used > total, "Memory problem!")
		var height = rand_range(HEIGHT_LIMITS[0],HEIGHT_LIMITS[1])
		var width = block2unit(round(rand_range(WIDTH_LIMITS[0], WIDTH_LIMITS[1])))
		
		if left <= maximum_size:
			var last_platform = ( ceil((left - DEFAULT_GAP_SIZE)/U_BLOCK_SIZE) * U_BLOCK_SIZE) 
			create_platform(used,height, last_platform)
			alloc(left)
		else:
			create_platform(used,height,width)
			alloc(rand_range(GAP_LIMITS[0],GAP_LIMITS[1]))


func create_platform(x,height,width,create_gap=false): # Accept units only
	Logger.log("Creating platform: x: "+str(x)+", height: "+str(height)+", width: "+str(width))
	assert(width <= left,"No size left for platform "+str(allocate)+">"+str(left))
	terrain_array.append(Vector3(x,height,unit2block(width)))
	alloc(width)

func alloc(mem):
	used += mem
	left = total - used

func unit2block(unit):
	assert(int(unit)%int(U_BLOCK_SIZE)==0,unit)
	return unit/U_BLOCK_SIZE
	
func block2unit(block):
	assert(str(block)==str(int(block)),"Wrong block! "+str(block)+"::"+str(int(block)) )
	return block*U_BLOCK_SIZE

