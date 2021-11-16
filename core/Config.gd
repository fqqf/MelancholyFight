extends Node

# const logging_string = "[{TIME}][{MOD}][{LVL}] :: {MSG}"
const logging_string = "[{TIME}][{MOD}] :: {MSG} \n"
var DEFAULT_ASPECT_RATIO = float(ProjectSettings.get_setting("display/window/size/width"))/float(ProjectSettings.get_setting("display/window/size/height"))
var DEFAULT_WIDTH = ProjectSettings.get_setting("display/window/size/width")+0.0
var DEFAULT_HEIGHT = ProjectSettings.get_setting("display/window/size/height")+0.0

func _ready():
	Logger.output_format = logging_string
	Logger.log("PROJECT WIDTH : "+str(DEFAULT_WIDTH)+", PROJECT HEIGHT : "+str(DEFAULT_HEIGHT)+", ASPECT : "+str(DEFAULT_ASPECT_RATIO))
