extends "res://src/Level.gd"

const PLAYER_BIT = 0
const WORLD_BIT = 1

onready var boss = $Boss
onready var blockDoor = $BlockDoor

func set_block_door(active):
	blockDoor.visible = active
	blockDoor.set_collision_mask_bit(PLAYER_BIT, active)
	blockDoor.set_collision_mask_bit(WORLD_BIT, not active)

func _on_Trigger_area_triggered():
	if not SaverAndLoader.custom_data.boss_defeated:
		set_block_door(true)


func _on_Boss_died():
	set_block_door(false)
