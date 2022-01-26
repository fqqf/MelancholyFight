extends Control

func _ready():
	VisualServer.set_default_clear_color(Color(0.05,0.05,0.05))

func _on_Start_pressed():
	SoundFX.play("Click", -1, -10)
	get_tree().change_scene("res://src/World.tscn")


func _on_Load_pressed():
	SoundFX.play("Click", -1, -10)
	SaverAndLoader.is_loading = true
	get_tree().change_scene("res://src/World.tscn")


func _on_Quit_pressed():
	SoundFX.play("Click", -1, -30)
	get_tree().quit()
