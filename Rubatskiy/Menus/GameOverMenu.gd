extends CenterContainer



func _on_QuiutButton_pressed():
	SoundFx.play("Click", 1, -30 )
	get_tree().quit()


func _on_LoadButton_pressed():
	SoundFx.play("Click", 1, -30 )
	SaverAndLoader.is_loading = true
	Music.list_stop()
	get_tree().change_scene("res://World.tscn")
