extends Node3D
@onready var splash_player = %SplashPlayer

func splash():
	splash_player.play("splash")
