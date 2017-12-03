extends Node

func _ready():
	State.stopGame()
	Sound.playTheme()

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		get_tree().change_scene("res://scenes/sectors/a1.tscn")
		Sound.playTense()
		State.startGame()
