extends Node

onready var platform_scene = preload("res://src/gameplay/objects/platforms/Platform.tscn")
onready var platforms_zone = preload("res://res/collectables/platforms_zone.gd")

var gap_len_limits = [30, 40] # Platform vars

var platform_len_limits = [100,250]
var platform_height_limits = [55.247, 90.2]
var ratio_gap_len = []
var ratio_platform_len = []
var platform_structures

var desired_chunk_len=500 # Chunk vars

var create_gap_at_chunk_start = false
var generate_unique_platforms = false # Супер большие, платформы кусочками маленькими

var total # Memory vars
var taken
var left
var node

const U_BLOCK_SIZE = 16

var platform_height = platform_height_limits[0]
func _ready():
	platform_structures = platforms_zone.platforms
	
func generate_chunk(offset=0):
	var chunk = []
	alloc_mem()
	adjust_gap_len_limits_to_player_speed()

	var max_platform_len = int(max(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE
	var _max_gap_len = max(gap_len_limits[0], gap_len_limits[1])
	
	var platform_len
	
	var platform_height_diff = platform_height_limits[1]-platform_height_limits[0]
	var gap_len
	var lacky 
	while _max_gap_len+max_platform_len<=left:
		lacky = round(rand_range(0,5))
		if lacky == 1 and  taken!=0:
			chunk = create_pl(offset,chunk)
		platform_len = int(rand_range(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE # Setup platform and gap
		
		gap_len = Utils.get_prob_ps([gap_len_limits[0], gap_len_limits[1]], [[100,100,100000]])
		print("PLAT HEIGHT")
		print(platform_height_limits[0])
		if platform_height <= platform_height_limits[0]+platform_height_diff*0.4: # TALL
			print(str(platform_height)+" <=0.4 == "+str(platform_height_limits[0]+platform_height_diff*0.4))
			print(platform_height)
			platform_height = Utils.get_prob_ps([platform_height_limits[0], platform_height_limits[1]],[[0,20,250], [21, 60, 40],[61, 79, 50],[80,100, 30]])
			print(platform_height)
		elif platform_height >= platform_height_limits[0]+platform_height_diff*0.7: # SMALL	
			print(str(platform_height)+" >=0.65 == "+str(platform_height_limits[0]+platform_height_diff*0.65))
			print(platform_height)
			platform_height = Utils.get_prob_ps([platform_height_limits[0], platform_height_limits[1]],[[0,20,40],[21, 60, 40],[61, 79, 50],[80,100, 250]])
			print(platform_height)
		else:
			print("medium")
			print(platform_height)
			platform_height = Utils.get_prob_ps([platform_height_limits[0], platform_height_limits[1]],[[0,20,35],[21, 60, 50],[61, 79, 300],[80,100, 35]])	
			print(platform_height)
		#if create_gap_at_chunk_start and taken==0: pass
		if _max_gap_len+max_platform_len<=left: # Instance platform
			chunk.append(platform_scene.instance().build(offset+taken, platform_height, platform_len))
			use_mem(platform_len)
			add_child(chunk.back())
		
			use_mem(gap_len)
			  # Generate gap only if there will be space for platform after gap
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

	if scene_speed ==0:
		gap_len_limits = [ratio_gap_len[0], ratio_gap_len[1]]
		platform_len_limits = [ratio_platform_len[0], ratio_platform_len[1]]
	elif scene_speed < 1:
		gap_len_limits = [scene_speed*ratio_gap_len[0], scene_speed*ratio_gap_len[1]]
	else:	
		gap_len_limits = [scene_speed*ratio_gap_len[0], scene_speed*ratio_gap_len[1]]
		platform_len_limits = [scene_speed*ratio_platform_len[0], scene_speed*ratio_platform_len[1]]

func create_pl(offset,chunk):
	var scene_speed = get_parent().get_parent().scene_speed

	var max_platform_len = int(max(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE
	var _max_gap_len = max(gap_len_limits[0], gap_len_limits[1])
	
	var platform_len
	var platform_height
	var gap_len
	var gap_fl =1
	
	
	var lacky =1# round(rand_range(0,1))
	if lacky == 1 :
		var platform_range = round(rand_range(0,platform_structures.size()-1))
		gap_len = platform_structures[str(platform_range)][2][1]
		
		if gap_len == 0: 
			gap_fl = 0
		platform_len = max(U_BLOCK_SIZE*3, int((scene_speed*platform_structures[str(platform_range)][2][0])/U_BLOCK_SIZE)*U_BLOCK_SIZE)
		var pl_fl
		if platform_structures[str(platform_range)][2][0] ==0: pl_fl=0
		var count=0
		var platform_height_change = (35.0/platform_structures[str(platform_range)][0][0])
		while _max_gap_len+max_platform_len<=left:
			if count == platform_structures[str(platform_range)][1].size():
				break
			if pl_fl ==0:
				platform_len = int(rand_range(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE # Setup platform and gap
			#if create_gap_at_chunk_start and taken==0: pass
			
			platform_height = 55.0 + platform_structures[str(platform_range)][1][count]*platform_height_change
			chunk.append(platform_scene.instance().build(offset+taken, platform_height, platform_len))
			use_mem(platform_len)
			add_child(chunk.back())
		
			if gap_fl == 0:
				gap_len = rand_range(gap_len_limits[0],gap_len_limits[1])
			use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
			count += 1
		pass
	
	return chunk	
