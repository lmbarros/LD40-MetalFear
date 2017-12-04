extends Area2D

func gotTrophy(body):
	if body == Player:
		State.winGame()
