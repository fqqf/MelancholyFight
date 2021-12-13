extends Area2D

export var type = Singleton.CollectableType.NONE


func build(x,y):
	position.x = x
	position.y = y
	return self
