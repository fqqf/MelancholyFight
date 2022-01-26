extends Node

var is_loading = false

var custom_data = {
	missiles_unlocked = false,
	boss_defeated = false
}

func save_game():
	var savefile = File.new()
	savefile.open("user://game_.save", File.WRITE)
	
	savefile.store_line(to_json(custom_data))
	
	var persisitng_nodes = get_tree().get_nodes_in_group("Persists")
	for node in persisitng_nodes:
		var node_data = node.save()
		savefile.store_line(to_json(node_data))
	savefile.close()
	
func load_game():
	var savefile = File.new()
	if not savefile.file_exists("user://game_.save"):
		return
		
	var persisting_nodes = get_tree().get_nodes_in_group("Persists")
	for node in persisting_nodes:
		node.queue_free() # Убиваем существующие ноды, требующие загрузки параметров
	
	savefile.open("user://game_.save",File.READ)
	
	if not savefile.eof_reached():
		custom_data = parse_json(savefile.get_line())
	
	while not savefile.eof_reached():
		var current_line = parse_json(savefile.get_line())
		if current_line != null:
			var new_node  = load(current_line["filename"]).instance()
			print(current_line)
			get_node(current_line["parent"]).add_child(new_node,true)
			new_node.position = Vector2(current_line["position_x"], current_line["position_y"])
			
			for property in current_line.keys():
				if (property == "filename"
				or property == "parent"
				or property == "position_x"
				or property == "position_y"):
					continue
				new_node.set(property, current_line[property])
	savefile.close()
