extends Zone

onready var background = $Back/Background

onready var layer0 = $Back/Layer0
onready var layer1 = $Front/Layer1

onready var plat1 = $Between/Platform1
onready var plat2 = $Between/Platform2
onready var plat3 = $Between/Platform3
onready var plat4 = $Between/Platform4
onready var plat5 = $Between/Platform5
onready var plat6 = $Between/Platform6
onready var plat7 = $Between/Platform7
onready var plat8 = $Between/Platform8

onready var cloud1 = $Between/Cloud1
onready var cloud2 = $Between/Cloud2
onready var cloud3 = $Between/Cloud3
onready var cloud4 = $Between/Cloud3

onready var creeper = $Between/Creeper

var objects

var ready = false

func _set_zone_active(active):
	game = Singleton.game
	
	if active:
		rebuild_platforms(Singleton.ZoneType.HEAVENLY_YARD)
		
	if ready:
		for object in objects:
			object.set_meta("speed", Utils.get_prob_ps([-0.7,0.5],[[0,30,60],[31,59,20],[70,100,60]]))
			object.motion_offset.x += rand_range(0,1000)


func _ready():
	
	ready = true
	
	objects = [plat1, plat2, plat3, plat4, plat5, plat6, plat7, plat8, creeper]

	for object in objects:
		object.set_meta("speed", Utils.get_prob_ps([-0.7,0.5],[[0,30,60],[31,59,20],[70,100,60]]))
		object.motion_offset.x += rand_range(0,1000)

var offset_x = float(0)

func _process(_delta):
	for object in objects:
		object.motion_offset.x += object.get_meta("speed") #+ offset_x
		
	background.motion_offset.x = offset_x
	layer0.motion_offset.x = -offset_x/2
	layer1.motion_offset.x = -offset_x*2
	offset_x += 1
	cloud1.motion_offset.x = offset_x/4
	cloud2.motion_offset.x = offset_x/3
	cloud3.motion_offset.x = offset_x*0.12
	cloud4.motion_offset.x = offset_x/5
	pass
