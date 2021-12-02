extends Node

onready var platform_scene = preload("res://src/gameplay/objects/platforms/Platform.tscn")

var gap_len_limits = [30, 40] # Platform vars
var platform_len_limits = [100,250]
var platform_height_limits = [55.247, 90.2]
var ratio_gap_len = []
var ratio_platform_len = []

var desired_chunk_len=500 # Chunk vars

var create_gap_at_chunk_start = false
var generate_unique_platforms = false # Супер большие, платформы кусочками маленькими

var total # Memory vars
var taken
var left
var node

const U_BLOCK_SIZE = 16



func generate_chunk(offset=0):
	var chunk = []
	alloc_mem()
	adjust_gap_len_limits_to_player_speed()

	var max_platform_len = int(max(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE
	var _max_gap_len = max(gap_len_limits[0], gap_len_limits[1])
	
	var platform_len
	var platform_height
	var gap_len
	
	while true:
		platform_len = int(rand_range(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE # Setup platform and gap
		gap_len = rand_range(gap_len_limits[0],gap_len_limits[1])
		platform_height = Utils.get_prob_s([platform_height_limits[0], platform_height_limits[1]], [[platform_height_limits[1]-3, platform_height_limits[1], 200],[platform_height_limits[0]+3,platform_height_limits[0],200]])
		
		if create_gap_at_chunk_start and taken==0: pass
		elif platform_len<=left: # Instance platform
			chunk.append(platform_scene.instance().build(offset+taken, platform_height, platform_len))
			use_mem(platform_len)
			add_child(chunk.back())
		else: break
		
		if gap_len+max_platform_len<=left: use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
		else: break
			
	return [chunk, taken+offset]

func use_mem(mem):
	taken += mem
	left = total - taken
	
func alloc_mem():
	total = desired_chunk_len
	taken = 0
	left = desired_chunk_len - taken
	
func adjust_gap_len_limits_to_player_speed():
	var scene_speed = get_parent().get_parent().scene_speed
	if ratio_gap_len.empty():
		#создаем зависимости max-min длины от скорости
		ratio_gap_len = [gap_len_limits[0], gap_len_limits[1]]
		ratio_platform_len = [platform_len_limits[0], platform_len_limits[1]]

	
	gap_len_limits = [scene_speed*ratio_gap_len[0], scene_speed*ratio_gap_len[1]]
	platform_len_limits = [scene_speed*ratio_platform_len[0], scene_speed*ratio_platform_len[1]]
	
	
