extends CenterContainer

func _on_Quit_pressed():
	get_tree().quit()


func _on_Load_pressed():
	SoundFX.play("Click", -1, -10)
	SaverAndLoader.is_loading = true
	Music.list_stop()
	get_tree().change_scene("res://src/World.tscn")
