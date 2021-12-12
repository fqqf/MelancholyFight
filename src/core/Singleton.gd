extends Node

# Screw godot for not having static vars. I can't share one variable between multiple instances without using Singleton.

onready var player
onready var main
onready var game

enum CollectableType {
	NONE = -1,
	NUMUS = 0
}

enum ZoneType {
	FRENCH_ROSE = 0,
	EVANGELION = 1,
	HEAVENLY_YARD = 2
}

var platform_tilemap_id = ZoneType.FRENCH_ROSE
