extends ColorRect

var is_paused = false setget pause

func pause(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused:
		SoundFX.play("Pause",1,-10)
	else:
		SoundFX.play("Unpause",1,-10)
func _process(_delta):
	var Player_is_alive = get_tree().get_nodes_in_group("Player").size() > 0
	if Input.is_action_just_pressed("pause") and Player_is_alive:
		self.is_paused = !is_paused

func _on_ResumeButton_pressed():
	SoundFX.play("Click", 1, -10)
	self.is_paused = false

func _on_QuitButton_pressed():
	get_tree().quit()
