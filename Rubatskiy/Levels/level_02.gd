extends "res://Levels/level.gd"

const PLAYER_BIT = 0


#onready var bossEnemy = $BossEnemy
onready var blockDoor = $BlockDoor

func set_block_door(active):
	blockDoor.visible = active
	blockDoor.set_collision_mask_bit(PLAYER_BIT, active)
	

func _on_Trigger_area_triggerd():
	if not SaverAndLoader.custom_data.boss_defeated:
		set_block_door(true)

func _on_BossEnemy_died():
	set_block_door(false)
