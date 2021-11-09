extends TileMap


export (int) var WIDTH = 5
export (int) var HEIGHT = 3
 
func _ready():
	for x in WIDTH:
		for y in HEIGHT:
			set_cell(x,y,0)
	update_bitmask_region(Vector2(0,0),Vector2(WIDTH, HEIGHT))
	
