extends Camera2D

onready var remoteTransform2D = $RemoteTransform2D

func _ready():
	if Singleton.player:
		remoteTransform2D.remote_path = Singleton.player.get_path()
	Singleton.connect("setPlayer",self,"_onPlayerSet")
	
func _onPlayerSet():
	remoteTransform2D.remote_path = Singleton.player
	
