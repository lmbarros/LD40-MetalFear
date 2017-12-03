extends Area2D

func playerEntered(body):
	if body == Player:
		State.enterMetalDetector()

func playerExited(body):
	if body == Player:
		State.exitMetalDetector()
		
func _ready():
	$animation.play("glow")
