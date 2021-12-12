extends TileMap

export var BLOCK_HEIGHT = 3

var width_PX = 0
var height_PX = 0
var x = 0


var tilemap_id = 1

func get_tilemap_id(): return tilemap_id

func _ready():
	pass

var array

func recolor():
	tilemap_id = Singleton.platform_tilemap_id
	var width = Utils.unit2block(width_PX)
	for _x in width:
		for y in BLOCK_HEIGHT:
			set_cell(_x,y,tilemap_id)
	update_bitmask_region(Vector2(0,0),Vector2(width, BLOCK_HEIGHT))	

func build(x_=x, height_PX_=height_PX, width_PX_=width_PX):
	height_PX = height_PX_
	width_PX = width_PX_
	x = x_
	
	recolor()
	
	position = Vector2(x, height_PX)
	
	return self


