extends HBoxContainer

var player_stats = ResourceLoader.player_stats

onready var label = $Label

func _ready():
	player_stats.connect("player_missiles_amount_changed", self, "_on_player_missiles_amount_changed")
	label.text = str(player_stats.missiles)
	player_stats.connect("player_missiles_unlocked",self, "_on_player_missiles_unlocked")
	
func _on_player_missiles_amount_changed(amount):
	label.text = str(amount)
	

func _on_player_missiles_unlocked(value):
	visible = value
