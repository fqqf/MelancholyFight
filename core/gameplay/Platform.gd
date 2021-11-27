extends TileMap

export var BLOCK_HEIGHT = 3

var width_PX
var height_PX

func _ready():
	pass

func build(x, height_PX_, width_PX_):
	height_PX = height_PX_
	width_PX = width_PX_
	var width = unit2block(width_PX)
	
	position = Vector2(x, height_PX)
	
	for x in width:
		for y in BLOCK_HEIGHT:
			set_cell(x,y,0)
	update_bitmask_region(Vector2(0,0),Vector2(width, BLOCK_HEIGHT))
	return self

const U_BLOCK_SIZE = 16

func unit2block(unit):
	assert(int(unit)%int(U_BLOCK_SIZE)==0,unit)
	return unit/U_BLOCK_SIZE
	
func block2unit(block):
	assert(str(block)==str(int(block)),"Wrong block! "+str(block)+"::"+str(int(block)) )
	return block*U_BLOCK_SIZE
