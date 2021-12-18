extends TileMap

tool

onready var coordinate_system = $Transform
onready var line_x = $Transform/LineX
onready var cube = $Transform/Cube
onready var draw = $Transform/Control

export var BLOCK_HEIGHT = 3

var width_PX = 0
var height_PX = 0
var x = 0

var width

var tilemap_id = 1

func get_tilemap_id(): return tilemap_id


		
func instance_debug_entity(debug_figure, pos_x):
	var entity = debug_figure.duplicate()
	entity.visible = true
	entity.position.x = pos_x
	add_entity(entity, false)
	
var memory = []

func recolor():
#	width = Utils.unit2block(width_PX)
	tilemap_id = Singleton.platform_tilemap_id
	for _x in width:
		for y in BLOCK_HEIGHT:
			set_cell(_x,y,tilemap_id)
	update_bitmask_region(Vector2(0,0),Vector2(width, BLOCK_HEIGHT))	

func build(x_=x, height_PX_=height_PX, width_PX_=width_PX):
	height_PX = height_PX_
	width_PX = width_PX_
	x = x_
	width = Utils.unit2block(width_PX)
	
	for i in range (0,width):
		memory.append(0)
	
	recolor()
	position = Vector2(x, height_PX)	
	return self

func draw_debug_for_numus():
	for i in range(width):
		instance_debug_entity(line_x, i)
		if memory[i]!=0: instance_debug_entity(cube, i)	

func add_entity(entity, adjust_scale=true):
	if adjust_scale:
		entity.scale.x *= 0.01
		entity.scale.y *= -0.01
	coordinate_system.add_child(entity)

