extends Node

onready var platform_scene = preload("res://src/gameplay/objects/platforms/Platform.tscn")
onready var platforms_zone = preload("res://res/collectables/platforms_zone.gd")

var gap_len_limits = [30, 38] # Platform vars
var platform_len_limits = [100,250]
var platform_height_limits = [55.247, 90.3]
var ratio_gap_len = []
var ratio_platform_len = []

var desired_chunk_len=500 # Chunk vars

var create_gap_at_chunk_start = false
var generate_unique_platforms = false # Супер большие, платформы кусочками маленькими

var total # Memory vars
var taken
var left
var node
var platform_structures

const U_BLOCK_SIZE = 16

func _ready():
	platform_structures = platforms_zone.platforms

func generate_chunk(offset=0):
	var chunk = []
	alloc_mem()
	var scene_speed
	scene_speed = adjust_gap_len_limits_to_player_speed()

	var max_platform_len = int(max(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE
	var _max_gap_len = max(gap_len_limits[0], gap_len_limits[1])
	
	var platform_len
	var platform_height
	var gap_len
	var j =0
	
	while max_platform_len<=left:
		var lacky =1# round(rand_range(0,1))
		if lacky == 1 and _max_gap_len+max_platform_len<=left:
			var platform_range = round(rand_range(0,platform_structures.size()-1))
			print("platform_range",platform_structures[str(platform_range)])
			gap_len = platform_structures[str(platform_range)][2][1]
			var gap_fl
			if gap_len == 0: 
				print("gap == 0")
				gap_fl = 0
			platform_len = int((scene_speed*platform_structures[str(platform_range)][2][0])/U_BLOCK_SIZE)*U_BLOCK_SIZE
			var pl_fl
			if platform_structures[str(platform_range)][2][0] ==0: pl_fl=0
			var count=0
			print("platform_structures[str(platform_range)][0]", platform_structures[str(platform_range)][0][0])
			var platform_height_change = (35.0/platform_structures[str(platform_range)][0][0])
			while _max_gap_len+max_platform_len<=left:
				print ("_max_gap_len+max_platform_len while =", _max_gap_len+max_platform_len, " left= ", left)
				if count == platform_structures[str(platform_range)][1].size():
					break
				if pl_fl ==0:
					platform_len =  int(rand_range(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE # Setup platform and gap
				if create_gap_at_chunk_start and taken==0: pass
				else:
					platform_height = 55.0 + platform_structures[str(platform_range)][1][count]*platform_height_change
					print("platform_height", platform_height)
					chunk.append(platform_scene.instance().build(offset+taken, platform_height, platform_len))
					use_mem(platform_len)
					print("use mem platform=  ", platform_len)
					add_child(chunk.back())
				if _max_gap_len+max_platform_len<=left:
					print ("_max_gap_len+max_platform_len gap = ", _max_gap_len+max_platform_len, " left= ", left)
					if gap_fl == 0:
						gap_len = rand_range(gap_len_limits[0],gap_len_limits[1])
					print("use mem gap=  ", gap_len) 
					
					use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
				else: break
				count += 1
			pass
		else:break	
		print("запуск while")
	
	
	
	return [chunk, taken+offset]
	
	#platform_height = 55.5
	
#	while true:
#		print("запуск while")
#		platform_len =  int(rand_range(platform_len_limits[0], platform_len_limits[1])/U_BLOCK_SIZE)*U_BLOCK_SIZE # Setup platform and gap
#		gap_len = 1#rand_range(gap_len_limits[0],gap_len_limits[1])
#		platform_height = Utils.get_prob_s([platform_height_limits[0], platform_height_limits[1]], [[platform_height_limits[1]-3, platform_height_limits[1], 200],[platform_height_limits[0]+3,platform_height_limits[0],200]])
#		var platform_mass = {}
#		var pl_mass = []
#		var lacky =1# round(rand_range(0,1))
#		if lacky == 1 and gap_len+max_platform_len<=left:
#			var platform_range = round(rand_range(0,platform_structures.size()-1))
#			print("platform_range",platform_structures[str(platform_range)])
#			#var j1=0
#			for j1 in platform_structures[str(platform_range)][0].size():
#				var j2 =0
#				for count in platform_structures[str(platform_range)]:
#					#print("while", platform_structures[str(platform_range)][0].size())
#					if count[j1] ==1 and platform_len<=left :
#						print("count j1 = 1! ", count, " ", j1, "j2= ", j2)
#						platform_height = 55.0+ j2*(40/platform_structures[str(platform_range)][0].size()-1)
#						chunk.append(platform_scene.instance().build(offset+taken, platform_height, platform_len))
#						use_mem(platform_len)
#						add_child(chunk.back())
#
#						if gap_len+max_platform_len<=left: use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
#						else: break
#					else:break
#					j2+=1	
#		elif platform_len<=left: # Instance platform
#			print ("elif")
#			chunk.append(platform_scene.instance().build(offset+taken, platform_height, platform_len))
#			use_mem(platform_len)
#			add_child(chunk.back())
#			if gap_len+max_platform_len<=left:
#				use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
#			else: break
#
#
#		else: break
#
#
#		#if gap_len+max_platform_len<=left: use_mem(gap_len)  # Generate gap only if there will be space for platform after gap
#		#else: break
#
#	return [chunk, taken+offset]

func use_mem(mem):
	taken += mem
	print("zero mem=", mem)
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
	return scene_speed
	
