extends Area2D

func playerEntered(body):
	if body == Player:
		State.enterMetalDetector()
		print("METAL")

func playerExited(body):
	if body == Player:
		State.exitMetalDetector()
		print("SAFE")
		
func _ready():
	$animation.play("glow")
