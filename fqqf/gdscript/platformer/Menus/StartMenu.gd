extends Control

func _ready():
	VisualServer.set_default_clear_color(Color(0.05,0.05,0.05))

func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_Load_pressed():
	SaverAndLoader.is_loading = true
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")


func _on_Quit_pressed():
	get_tree().quit()
