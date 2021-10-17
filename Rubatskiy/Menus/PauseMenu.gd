extends ColorRect

var paused = false setget set_paused

func set_paused(value):
	paused = value
	get_tree().paused = paused
	visible = paused
	if paused:
		
		SoundFx.play("Pause", 1, -30)
	else:
		SoundFx.play("Unpause", 1, -30)
	

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		self.paused = !paused
		

func _on_ResumeButton_pressed():
	SoundFx.play("Click", 1, -30)
	self.paused = false


func _on_QuitButton_pressed():
	SoundFx.play("Unpause", 1, -30)
	get_tree().quit()
