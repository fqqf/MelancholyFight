extends Node

var MainInstances = ResourceLoader.main_instances

onready var currentLevel = $Level_00

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color(0.05,0.05,0.05))
	MainInstances.Player.connect("hit_door",self,"_on_Player_hit_door")

func change_levels(door):
	var offset = currentLevel.position
	print(currentLevel.position)
	currentLevel.queue_free()
	var Exit_level = load(door.new_level_path)
	var exit_level = Exit_level.instance()
	add_child(exit_level)
	var exit_door = get_door_with_connection(door, door.connection)
	print(exit_door.position)
	var exit_position = exit_door.position - offset
	exit_level.position = door.position - exit_position
	print(door.position)
	print(exit_level.position)
	
	
func get_door_with_connection(entered_door, connection): # entered_door - Дверь, которую нужно игнорировать. 
	# В doors Ведь входят все двери, и та, через которую мы вошли
	var doors = get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != entered_door:
			return door
	return null

func _on_Player_hit_door(door):
	call_deferred("change_levels", door)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
