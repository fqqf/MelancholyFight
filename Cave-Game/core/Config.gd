extends Node

const logging_string = "[{TIME}][{MOD}][{LVL}] :: {MSG}"
const DEFAULT_ASPECT_RATIO = 500/500

func _ready():
	Logger.output_format = logging_string
