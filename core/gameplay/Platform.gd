extends TileMap

export var BLOCK_HEIGHT = 3

func _ready():
	pass

func build(x, height, width_PX):
	
	var width = unit2block(width_PX)
	
	position = Vector2(x, height)
	
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
