extends Node

const logging_string = "[{TIME}][{MOD}][{LVL}] :: {MSG}"

func _ready():
	Logger.output_format = logging_string
