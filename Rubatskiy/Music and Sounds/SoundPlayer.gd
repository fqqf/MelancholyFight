extends Node

export(String) var sound_string = ""


func _ready():
	if sound_string != "":
		SoundFx.play(sound_string)
