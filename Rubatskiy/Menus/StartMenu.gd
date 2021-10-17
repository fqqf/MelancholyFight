extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	


func _on_StartButton_pressed():
	SoundFx.play("Click", 1, -30 )
	get_tree().change_scene("res://World.tscn")


func _on_LoadButton_pressed():
	SoundFx.play("Click", 1, -30 )
	SaverAndLoader.is_loading = true
	get_tree().change_scene("res://World.tscn")


func _on_QuitButton_pressed():
	SoundFx.play("Click", 1, -30 )
	get_tree().quit()
