extends Resource
class_name PlayerStats

var max_health = 4
var health = max_health setget set_health
var max_missiles = 7
var missiles = max_missiles setget set_missiles_amount
var missiles_unlocked = false setget set_missiles_available

signal player_health_changed(value)
signal player_missiles_amount_changed(value)
signal player_missiles_unlocked(value)
signal player_died 

func set_health(value):
	if value < health:
		Events.emit_signal("add_screenshake",0.25,0.5)
	health = clamp(value,0,max_health)
	emit_signal("player_health_changed", health)
	if health == 0:
		emit_signal("player_died")

func set_missiles_amount(value):
	missiles = clamp(value,0,max_missiles)
	emit_signal("player_missiles_amount_changed", missiles)
	
func set_missiles_available(value):
	missiles_unlocked = value
	SaverAndLoader.custom_data.missiles_unlocked = value
	emit_signal("player_missiles_unlocked", value)

func refill_stats():
	health = max_health
	missiles = max_missiles
	emit_signal("player_health_changed", health)
	emit_signal("player_missiles_amount_changed", missiles)
