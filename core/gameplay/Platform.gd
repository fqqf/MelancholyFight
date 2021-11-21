extends TileMap

export var BLOCK_HEIGHT = 3

func _ready():
	pass
	
func build(vec3):
	position = Vector2(vec3.x, vec3.y)
	
	for x in vec3.z:
		for y in BLOCK_HEIGHT:
			set_cell(x,y,0)
	update_bitmask_region(Vector2(0,0),Vector2(vec3.z, BLOCK_HEIGHT))	
