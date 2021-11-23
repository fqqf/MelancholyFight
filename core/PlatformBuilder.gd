extends Node

onready var platform_scene = preload("res://core/gameplay/Platform.tscn")

var gap_len_limits = [30, 70] # Platform vars
var platform_len_limits = [100,200]
var platform_height_limits = [55.247, 90.2]

var desired_chunk_len=10000 # Chunk vars
var generate_gap_at_chunk_start = false
var generate_unique_platforms = false # Супер большие, платформы кусочками маленькими

var total # Memory vars
var taken
var left

const U_BLOCK_SIZE = 16

func generate_chunk():
	var chunk = []
	alloc_mem()
	
	var max_platform_len = int(max(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE
	var max_gap_len = max(gap_len_limits[0], gap_len_limits[1])
	
	var platform_len
	var platform_height
	var gap_len
	
	while true:
		platform_len = int(rand_range(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE # Setup platform and gap

		gap_len = rand_range(gap_len_limits[0],gap_len_limits[1])
		platform_height = rand_range(platform_height_limits[0], platform_height_limits[1])
		
		if generate_gap_at_chunk_start: pass
		elif platform_len<=left: # Instance platform
			chunk.append(platform_scene.instance().build(taken, platform_height, platform_len))
			print(platform_len)
			use_mem(platform_len)
			add_child(chunk.back())
		else: break
		
		if gap_len+max_platform_len<=left: use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
		else: break
			
	return [chunk, taken]

func use_mem(mem):
	taken += mem
	left = total - taken
	
func alloc_mem():
	total = desired_chunk_len
	taken = 0
	left = desired_chunk_len - taken
	
